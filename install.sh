#!/bin/bash

# version 1.01 Juin 2021
# se positionner dans le répertoire contenant install.sh et le FICHIER tar.gz à installer
# exécuter la commande : sudo sh install.sh FICHIER

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

proc_exit ()
{
perl -e "$1" 2>/dev/null
[ $? != "0" ] && { echo "vous devez d'abbord installer : $2" ; exit ; }
}

##########################################################################

FILE=$1
APPLI=`echo $FILE | cut -f1 -d.`
  EXT=`echo $FILE | cut -f4-5 -d.`

DIR=/usr/local/facila
LG=fr_FR.UTF-8

[ "`whoami`" != 'root'   ] && { echo vous devez exécuter : sudo sh install.sh FICHIER ; exit ; }
[ "$EXT"     != "tar.gz" ] && { echo le fichier $FILE doit être un tar.gz ; exit ; }
[ ! -s $FILE             ] && { echo fichier $FILE absent ; exit ; }

# vérification des dépendances
proc_appli
proc_perl

# installation
echo installation de facila $FILE
tar -xzf $FILE -C /

# copie du répertoire d'origine $LG dans la langue de votre machine $LANG
# vous pouvez-ensuite traduire les fichiers ( menu , aide , ... )
[ "$LANG" != "$LG" ] && cp -R $DIR/var/$LG $DIR/var/$LANG
