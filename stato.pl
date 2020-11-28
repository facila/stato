#!/usr/bin/perl

# version  : 2.10 - November 2020
# author   : Thierry Le Gall
# contact  : facila@gmx.fr
# web site : https://github.com/facila/stato

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# execution des requetes snmp
sub state {
    my $field;
    %add_id = %id_nb = ();

    foreach (@field) { next if /id/ ; %$_ = () }
    # etat en utilisant state_mib , permet d'ajouter des champs au format standard ($$field{$1} = $2) sans modifier les scripts
    $x = 0;
    foreach (@state_mib) {
       $field = $field[$x];
       $x ++;

       next if $field eq 'id';

       # pour address , l'ordre est secondaires puis primaire , %address contient donc uniquement les adresses primaires
       foreach (`snmpwalk -Oeq $options $host_add $_ 2> /dev/null`) {
          if    ($field eq 'address' && /\.(\d+\.\d+\.\d+\.\d+) (.*)/) { $$field{$2} = $1 ; $add_id{$1} = $2 ; $id_nb{$2} ++ }
          elsif ($field eq 'mask'    && /\.(\d+\.\d+\.\d+\.\d+) (.*)/) { $$field{$1} = $2 }
          elsif (                       /\.(\d+) (.*)/               ) { $$field{$1} = $2 } } }

    foreach (keys %interface) {
       # erreurs sur adminstatus et operstatus
       $adminstatus{$_} = 0 if ! $adminstatus{$_};
       $operstatus {$_} = 0 if ! $operstatus {$_};
       # création des tableaux add_sort et mask_sort au format address triable directement
       $add_sort{$_} = $mask_sort{$_} = 0;
       if ( $address{$_} ) {
          $add_sort{$_}  = sprintf "%03d%03d%03d%03d" , split /\./ , $address{$_};
          $mask_sort{$_} = sprintf "%03d%03d%03d%03d" , split /\./ , $mask{$address{$_}} } }

    &result }

sub my_sort {
    my $s = $sort;
    if    ($s eq 'address') { $s = 'add_sort'  }
    elsif ($s eq 'mask'   ) { $s = 'mask_sort' }

    if ($sense == 1) {
       if    ($s eq 'id'          ) {     $a  <=> $b      }
       elsif ($s eq 'interface'   ) { $$s{$a} cmp $$s{$b} }
       elsif ($s =~ /speed|_sort/ ) { $$s{$a} <=> $$s{$b} || $interface{$a} cmp $interface{$b} }
       else                         { $$s{$a} cmp $$s{$b} || $interface{$a} cmp $interface{$b} } }
    else {
       if    ($s eq 'id'          ) {     $b  <=> $a      }
       elsif ($s eq 'interface'   ) { $$s{$b} cmp $$s{$a} }
       elsif ($s =~ /speed|_sort/ ) { $$s{$b} <=> $$s{$a} || $interface{$b} cmp $interface{$a} }
       else                         { $$s{$b} cmp $$s{$a} || $interface{$b} cmp $interface{$a} } } }

# fonction appelée aussi directement par la commande sort
sub result {
    $ligne=$groupe=0;
    $id_old='';

    # tableau contenant tous les resultats
    # utilisé par la suite pour calculer la largeur des colonnes et pour la creation du resultat final
    @result=();

    my $field;

    foreach $id (sort my_sort keys %interface) {
       foreach $field (@field) {
          next if $field eq 'id';
          $$field='';

          next if $field =~ /address|mask/;
          if ($$field{$id} ne '') { $$field=$$field{$id} } }

       # filtrer les lignes
       $filtrer = $field = $value = 0;
       foreach (@filtrer) { ($field,$value) = split /\s+/; $filtrer = 1 if $$field =~ /$value/ }
       next if $filtrer;

       # formater les lignes , prise en compte de $id_nb
       if    (! $id_nb{$id}   ) { &format('0') }
       elsif ($id_nb{$id} == 1) { $address=$address{$id}; $mask=$mask{$address}; &format('0') }
       elsif ($id_nb{$id}  > 1) {
          $add_autre = 0;
          foreach $address (sort { $a cmp $b } keys %add_id) {
             if ($add_id{$address} eq $id) {
                $mask=$mask{$address};
                &format($add_autre);
                $add_autre ++ } } } }

    # creation et affichage de l'entete
    &heading;

    # creation du resultat final
    $text='';
    $x=0;
    foreach (@result) {
       $text .= sprintf " %$pos[$x]$lg[$x]s" , $_;
       $x++;
       $lg = $lg + $lg[$x] + 1 if $lg[$x];
       if ($x == @field) {
          my $s=0 ; $s="%$espace"."s" if $espace > 0;
          $text .= sprintf $s , '' if $s;
          $text .= "\n";
          $x=0 } } }

sub format {
    if ($format) {
       # application des régles du fichier format : f = field , v = value
       my($f1,$f2,$v1,$v2); 
       foreach (@filter ) { ($f1,$v1    ) = split /\s+/; if ($v1 && $$f1 =~ /$v1/         ) { return                } }
       foreach (@empty  ) { ($f1,$v1    ) = split /\s+/; if ($v1 && $$f1 =~ /$v1/         ) { $$f1 = ''             } }
       foreach (@cut    ) { ($f1,$v1    ) = split /\s+/; if ($v1 && $$f1 =~ /(.*?)$v1/    ) { $$f1 = $1             } }
       foreach (@remove ) { ($f1,$v1    ) = split /\s+/; if ($v1 && $$f1 =~ /$v1/         ) { $$f1 =~ s/$v1//g      } }
       foreach (@replace) { ($f1,$v1,$v2) = split /\s+/; if ($v2 && $$f1 =~ /$v1/         ) { $$f1 =~ s/$v1/$v2/g   } }
       foreach (@split  ) { ($f1,$v1,$f2) = split /\s+/; if ($f2 && $$f1 =~ /(.*?)$v1(.*)/) { $$f1 = $1 ; $$f2 = $2 } }
       }

    # ajout dans le tableau @result des valeurs des champs pour une ligne
    foreach (@field) {
       $result = $$_;
       $result = '' if $_[0] && $_ !~ /address|mask/; # cas des add_autre
       push @result , $result }

    &color if ! $term }

sub heading {
    # calcul de la largeur des colonnes
    @lg = ();
    $x = 0;
    foreach (@field) {
       $lg[$x] = length($text_field[$x]); # largeur des entetes des fields
       $x ++ }

    $x = 0;
    foreach (@result) {
       $lg = length($_);
       $lg[$x] = $lg if $lg > $lg[$x]; # largeur des valeurs des champs
       $x ++;
       $x = 0 if $x == @field }

    # creation de la ligne d'entete
    $text = '';
    $x = 0;
    foreach (@field) {
       $text .= sprintf " %$pos[$x]$lg[$x]s" , $text_field[$x];
       $x ++ }

    if ( $term ) { print "$text\n" } else { &heading_tk } }

# execution des requetes snmp de la liste mib à partir du fichier mib 
# creation du résultat $text
sub mib {
    $text = '';
    if ( $alone{$list} ) { &mib_exec($list); return } 
    foreach ( keys %all ) { &mib_exec($_) }
    if ( $list ) { return if $all{$list}; &mib_exec($list) } }

sub mib_exec {
    my $mib_exec = $_[0];
    $text .= "$mib_exec :\n\n";
    my $i = 1;
    open(FILE,"<$mode",'mib');
    while(<FILE>) {
       next if $_ !~ /^$mib_exec /;
       @mib = split /\s+/;
       my $j = 2; # pour mib multiple

       foreach (`snmpwalk -On $options $host_add $mib[1] 2> /dev/null`) {
          if    ($mib_exec =~ /table/ ) { s/.$mib[1]// ; s/(.*?= ).*: (.*?)$/$1 $2/ ; $text .= $_    }
          elsif (/.*?= .*: (.*?)$/    ) { $text .= sprintf $mib_format , $i ++ , $mib[$j++] , "$1\n" }
          elsif (/.*?= (.*?)$/        ) { $text .= sprintf $mib_format , $i ++ , $mib[$j++] , "$1\n" }
          else                          { $text .= sprintf $mib_format , ""    , ""         , $_     } } }
    close(FILE);
    $text .= "\n" }

# test si $host_add repond à snmp , puis au ping
sub test {
    $text = '';
    $snmp = 1 if `$share/net_snmp.sh $options $host_add`;

    $ligne = 0;
    if (! $snmp) {
       $ligne ++;
       $text .= " $host_all $msg_error_snmp"; $tag_fg{$ligne} = $color_test_ko;

       $ligne++;
       chomp ($ping = `$share/net_ping.sh $host_add`);
       if (! $ping) { $text .= "\n $host_all $msg_error_ping"; $tag_fg{$ligne} = $color_test_ko }
       else         { $text .= "\n $host_all $msg_ok_ping"   ; $tag_fg{$ligne} = $color_test_ok } }
     
    print "$text\n" if $text && $term }

sub term {
    &test;
    if ( $snmp ) {  
       if ( $list ) { &mib } else { &state }
       print $text }
    exit }

########################## programme principal ############################

$facila = '/usr/local/facila' ;
$share  = "$facila/share/prg";
$prg    = "$facila/stato/prg";
$var    = "$facila/stato/var/$ENV{LANG}";

exit if ! -d $var;
chdir $var;

$term = 0;
$term = 1 if $ARGV[0] =~ /term|help/;

$mode = '';
$mode = ':encoding(UTF-8)' if $ENV{LANG} =~ /UTF-8/ && ! $term;

open(FILE,"<$mode",'help'); while(<FILE>) { $file_help .= $_ }; close(FILE);

if    ( $ARGV[0] eq 'help' ) { print $file_help ; exit }
elsif ( $ARGV[0] eq 'term' ) { shift }

( $host , $host_add , $options , $list ) = @ARGV;
exit if ! $options;

$x = 0;
# initialisation des variables à partir des fichiers
foreach $file ('format','init','state','mib') { 
   open(FILE,"<$mode",$file);
   while(<FILE>) {
      next if /^#|^\s+$|^$/ ; # lignes ignorées

      if (/^(.*?)#/   ) {$_=$1} # suppression à partir de #....
      if (/^\s+(.*?)$/) {$_=$1} # suppression des espaces du début
      if (/^(.*?)\s+$/) {$_=$1} # suppression des espaces de la fin

      if    ($file eq 'format') { if (/^(.*?)\s+(.*)$/) { push @$1 , $2 } }
      elsif ($file eq 'init'  ) { if (/^(.*?)\s+(.*)$/) { $x2 = $2 ; $x2 =~ tr/\"//d; $$1 = $x2 } }
      elsif ($file eq 'state' ) {
         ($field[$x] , $text_field[$x] , $pos[$x] , $state_mib[$x]) = split /\s+/ ;
         $pos[$x] = '' if $pos[$x] eq '+';
         $x++ }
      elsif ($file eq 'mib' ) {
         ( $x1 , $x2 ) = (split/\s+/)[0,1] ;
         if    ( $x1 eq 'alone' ) { $alone{$x2} = 1 }
         elsif ( $x1 eq 'all'   ) { $all{$x2}   = 1 }
         else                     { push @list , $x1 if ! $list{$x1} ; $list{$x1} = 1 } } }
   close(FILE) }

# variables pour le tri
$sense    = 1;
$host_all = "$host $host_add";
$mib_format = " %2s %-15s : %s";

if ( $term ) { &term }
else { require "$prg/stato.tk" ; &stato_tk }
