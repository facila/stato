#!/bin/bash

# l'installation se fait en root
# se positionner dans le répertoire contenant install.sh et le fichier .tar.gz
# passer la commande : sh install.sh

APPLI=stato
VERSION=2.02

[ "`whoami`" != 'root' ] && { echo vous devez être root pour exécuter install.sh ; exit ; }

# vérification des dépendances
ERROR=''
[ "`perl -v`"                       = '' ] && ERROR=$ERROR"perl   "
[ "`perl -e 'use Tk' 2>/dev/null`" != '' ] && ERROR=$ERROR"perl-tk   "
[ "$ERROR" != '' ] && { echo "vous devez d'abbord installer : $ERROR" ; exit ; }

FILE=$APPLI.$VERSION.tar.gz
echo installation de facila $FILE
tar -xzf $FILE -C /
