#!/bin/bash

# se positionner dans le répertoire contenant stato_install.sh et le fichier tar.gz
# exécuter la commande : sudo sh stato_install.sh 

APPLI=stato
VERSION=2.13

DIR=/usr/local/facila
LG=fr_FR.UTF-8

[ "`whoami`" != 'root' ] && { echo vous devez exécuter : sudo sh stato_install.sh ; exit ; }

# vérification des dépendances
perl -e ''       2>/dev/null ; [ $? != "0" ] && { echo "vous devez d'abbord installer : perl"    ; exit ; }
perl -e 'use Tk' 2>/dev/null ; [ $? != "0" ] && { echo "vous devez d'abbord installer : perl-tk" ; exit ; }

FILE=$APPLI.$VERSION.tar.gz
echo installation de facila $FILE
tar -xzf $FILE -C /

# copie du répertoire d'origine $LG dans la langue de votre machine $LANG
# vous pouvez-ensuite traduire les fichiers ( menu , aide , ... )
[ "$LANG" != "$LG" ] && cp -R $DIR/var/$LG $DIR/var/$LANG
