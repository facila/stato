#!/bin/bash

# version 2.00 octobre 2022
# se positionner dans le répertoire contenant install.sh et le FICHIER tar.gz à installer
# exécuter la commande : install.sh FICHIER

proc_exit ()
{
perl -e "$1" 2>/dev/null
[ $? != "0" ] && { echo "vous devez d'abbord installer : $2" ; exit ; }
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
OK=1
if [ "$FACILA" = "" ]
then FACILA="$DIR/facila"
     printf "\n# FACILA\nexport FACILA=$FACILA\n" >> ~/.bashrc
     OK=0
fi

[ ! -d $FACILA ] && mkdir facila facila/old facila/archive facila/version
cd $FACILA
}

proc_old ()
{
[ ! -f "$DIR/install_$APPLI" ] && return
cat $DIR/install_$APPLI | while read OLD
do mkdir -p old/$OLD # création des répertoires contenus dans $OLD
   rmdir    old/$OLD # suppression du dernier repertoire de $OLD
   mv $FACILA/$OLD old/$OLD.`date +%y%m%d_%H%M` 2> /dev/null
done
}

proc_lang ()
{
# copie du répertoire d'origine $LG dans la langue de la machine $LANG
[ "$LG" = "$LANG" ] && return
cp -R $FACILA/$APPLI/var/$LG $FACILA/$APPLI/var/$LANG
echo "votre langue est $LANG"
echo "vous pouvez traduire les fichiers ( menu , aide , ... )"
}

proc_end ()
{
if [ "$OK" = "1" ]
then echo "vous pouvez exécuter $APPLI"
else echo "fermer et relancer le shell pour exécuter $APPLI"
fi
echo "commande : $FACILA/$APPLI/prg/$APPLI"
}

#################################################################################

 FILE=$1
APPLI=`echo $FILE | cut -f1 -d.`
  EXT=`echo $FILE | cut -f4-5 -d.`
  DIR=$PWD
   LG=fr_FR.UTF-8

[ "$EXT" != "tar.gz" ] && { echo le fichier $FILE doit être un tar.gz ; exit ; }
[ ! -s "$FILE"       ] && { echo fichier $FILE absent ; exit ; }

[ "`dirname $FILE`" = "." ] && FILE="$DIR/$FILE"

echo vérification des dépendances
proc_perl
proc_appli

echo installation de facila $FILE
proc_facila
proc_old
tar -xzf $FILE
proc_lang
proc_end
