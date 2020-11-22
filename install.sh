#!/bin/bash

# se positionner dans le répertoire contenant install.sh et le fichier .tar.gz
# exécuter la commande : sudo sh install.sh

APPLI=stato
VERSION=2.02

[ "`whoami`" != 'root' ] && { echo vous devez exécuter : sudo sh install.sh ; exit ; }

# vérification des dépendances
perl -e ''       2>/dev/null ; [ $? != "0" ] && { echo "vous devez d'abbord installer : perl"    ; exit ; }
perl -e 'use Tk' 2>/dev/null ; [ $? != "0" ] && { echo "vous devez d'abbord installer : perl-tk" ; exit ; }

FILE=$APPLI.$VERSION.tar.gz
echo installation de facila $FILE
tar -xzf $FILE -C /
