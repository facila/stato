#!/bin/bash

# version 1.00 Mai 2021
# se positionner dans le répertoire contenant install.sh et le fichier tar.gz
# exécuter la commande : sudo sh install.sh APPLI VERSION

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

APPLI=$1
VERSION=$2
FILE=$APPLI.$VERSION.tar.gz

DIR=/usr/local/facila
LG=fr_FR.UTF-8

[ "`whoami`" != 'root' ] && { echo vous devez exécuter : sudo sh install.sh APPLI VERSION ; exit ; }
[ ! -s $FILE           ] && { echo fichier $FILE absent ; exit ; }

# vérification des dépendances
proc_appli
proc_perl

# installation
echo installation de facila $FILE
tar -xzf $FILE -C /

# copie du répertoire d'origine $LG dans la langue de votre machine $LANG
# vous pouvez-ensuite traduire les fichiers ( menu , aide , ... )
[ "$LANG" != "$LG" ] && cp -R $DIR/var/$LG $DIR/var/$LANG
