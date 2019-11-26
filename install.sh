#!/bin/bash

# version 2.00
# l'installation se fait en root
# se positionner dans le répertoire contenant install.sh et le fichier à installer
# passer la commande : ./install.sh FICHIER

[ "`whoami`" != 'root' ] && { echo vous devez être root pour exécuter install.sh ; exit ; }
FILE=$1 ; [ ! -f $FILE ] && { echo "le fichier $FILE n'existe pas" ; exit ; }

APPLI=`echo $FILE | cut -f1 -d'.'`

echo vérification des dépendances de $APPLI
ok_perl     () { [ "`find /usr/bin   -name perl`"    = '' ] && ERROR=$ERROR"perl   "            ; }
ok_perl_tk  () { [ "`find /usr/lib   -name Tk.pm`"   = '' ] && ERROR=$ERROR"perl-tk   "         ; }
ok_net_kalk () { [ "`find /usr/share -name Kalk.pm`" = '' ] && ERROR=$ERROR"facila/Net-Kalk   " ; }

ERROR=''
case $APPLI in
Net-Kalk) ok_perl ;;
   stato) ok_perl ; ok_perl_tk ;;
 kalkulo) ok_perl ; ok_perl_tk ; ok_net_kalk ;;
esac
[ "$ERROR" != '' ] && { echo "vous devez d'abbord installer : $ERROR" ; exit ; }

echo installation de facila $FILE
cp $FILE /
cd /
tar -xzf $FILE
rm $FILE
