#!/bin/bash

# l'installation se fait en root
# se positionner dans le répertoire d'installation
# passer la commande : ./install.sh "APPLICATION" "VERSION"

ok_root     () { [ "`whoami`" != 'root'    ] && { printf "vous devez être root pour exécuter install.sh\n" ; exit ; } }
ok_facila   () { [ ! -d /facila            ] && mkdir /facila ; }
ok_share    () { [ ! -d /facila/share      ] && ERROR=$ERROR"facila/share   "    ; }
ok_net_kalk () { [ "`locate Kalk.pm`" = '' ] && ERROR=$ERROR"facila/Net-Kalk   " ; }
ok_perl     () { [ "`which perl`"     = '' ] && ERROR=$ERROR"perl   "            ; }
ok_perl_tk  () { [ "`locate /Tk.pm`"  = '' ] && ERROR=$ERROR"perl-tk   "         ; }
ok_install  () { [ "$ERROR" != ''          ] && { printf "vous devez d'abbord installer : $ERROR\n" ; exit ; } }

do_tar ()
{
TAR=$APP.$VER.tar.gz
cp $TAR /facila/$TAR
cd /facila
tar -xzf $TAR
rm $TAR
}

####################### applications à installer ########################

share ()
{
do_tar
}

Net-Kalk ()
{
ok_perl
ok_install
cp Kalk.pm Kalk.pod /usr/share/perl5/Net/
cp Net::Kalk.3pm.gz /usr/share/man/man3/
}

kalkulo ()
{
updatedb
ok_share
ok_net_kalk
ok_perl_tk
ok_install
do_tar
}

stato ()
{
updatedb
ok_share
ok_perl
ok_perl_tk
ok_install
do_tar
}

####################### programme principal ########################

ok_root
ok_facila

APP=$1
VER=$2
echo installation de facila $APP $VER
$APP
