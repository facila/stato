#!/bin/bash

# version 2.00 octobre 2022
# sh install.sh FICHIER

proc_exit ()
{
perl -e "$1" 2>/dev/null
[ $? != "0" ] && { echo "  vous devez d'abbord installer : $2" ; exit ; }
}

proc_appli ()
{
case $APPLI in
kalkulo) proc_exit 'use Net::Kalk' facila/Net-Kalk ;;
esac
}

proc_perl ()
{
proc_exit ''       perl
proc_exit 'use Tk' perl-tk
}

proc_facila ()
{
OK_FACILA=1
[ "$FACILA" = "" ] && { OK_FACILA=0 ; FACILA=$PWD/facila ; }
          
SAVE=$FACILA/share/save
          
if [ $OK_FACILA = 0 ]
then echo "  ajout de FACILA dans .bashrc"
     printf "\n# FACILA\nexport FACILA=$FACILA\n" >> ~/.bashrc
     if [ ! -d $FACILA ]
     then echo "  création des répertoires de facila"
          mkdir -p $SAVE
          cd $SAVE 
          mkdir install old archive version
     fi
fi
}

proc_old ()
{
[ "$INSTALL" = "" ] && return

OK_OLD=0
for F in $(cat $INSTALL)
do if [ -d $F -o -f $F ]
   then OK_OLD=1
        mkdir -p $SAVE/old/$F # création des répertoires contenus dans $F
        rmdir    $SAVE/old/$F # suppression du dernier repertoire de $F
        mv $F    $SAVE/old/$F.`date +%y%m%d_%H%M` 2> /dev/null
   fi
done
[ $OK_OLD = 1 ] && echo "  sauvegarde de l'ancienne version dans $SAVE/old"
}

proc_lang ()
{
[ "$LG" = "$LANG" ] && return

echo "copie du répertoire d'origine $LG dans la langue de la machine $LANG"
cp -R $APPLI/var/$LG $APPLI/var/$LANG
echo "  votre langue est $LANG"
echo "  vous pouvez traduire les fichiers ( menu , aide , ... )"
}

proc_end ()
{
cd ..
mv $APPLI-main.zip $SAVE/install
mv $FILE           $SAVE/version
rm -rf $APPLI-main

if [ $OK_FACILA = 1 ]
then echo "  vous pouvez exécuter $APPLI"
else echo "  fermer et relancer le shell pour exécuter $APPLI"
fi
echo "  commande : $FACILA/$APPLI/prg/$APPLI"
}

#################################################################################

 FILE=$1
APPLI=`echo $FILE | cut -f1 -d.`
  EXT=`echo $FILE | cut -f4-5 -d.`
  DIR=$PWD/$APPLI-main  
   LG=fr_FR.UTF-8

FILE=$DIR/$FILE
[ "$EXT" != "tar.gz" ] && { echo "le fichier $FILE doit être un tar.gz" ; exit ; }
[ ! -s "$FILE"       ] && { echo "fichier $FILE absent" ; exit ; }
[ -f "$DIR/install_$APPLI" ] && INSTALL=$DIR/install_$APPLI

echo "vérification des dépendances"
proc_perl
proc_appli

echo "verification de facila"
proc_facila

echo "installation de $FILE"
cd $FACILA
proc_old
tar -xzf $FILE
proc_lang
proc_end
