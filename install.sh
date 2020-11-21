#!/bin/bash

# version 3.01
# l'installation se fait en root
# se positionner dans le répertoire contenant install.sh et le fichier à installer
# passer la commande : ./install.sh FICHIER

[ "`whoami`" != 'root' ] && { echo vous devez être root pour exécuter install.sh ; exit ; }

FILE=$1
[ "$FILE" = '' ] && { echo "vous devez préciser l'application à installer" ; exit ; }
[ ! -f $FILE   ] && { echo "le fichier $FILE n'existe pas" ; exit ; }

APPLI=`echo $FILE | cut -f1 -d'.'`

echo vérification des dépendances de $APPLI
ok_perl    () { [ "`perl -v`"                = '' ] && ERROR=$ERROR"perl   "    ; }
ok_perl_tk () { [ "`perl -e 'use Tk' 2>&1`" != '' ] && ERROR=$ERROR"perl-tk   " ; } 

ERROR=''
case $APPLI in
  stato) ok_perl ; ok_perl_tk ;;
kalkulo) ok_perl ; ok_perl_tk ;;
esac
[ "$ERROR" != '' ] && { echo "vous devez d'abbord installer : $ERROR" ; exit ; }

echo installation de facila $FILE
tar -xzf $FILE -C /
