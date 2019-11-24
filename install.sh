#!/bin/bash

# version 2.00
# l'installation se fait en root
# se positionner dans le répertoire contenant install.sh et le fichier à installer
# passer la commande : ./install.sh FICHIER

[ "`whoami`" != 'root' ] && { echo vous devez être root pour exécuter install.sh ; exit ; }
FILE=$1 ; [ ! -f $FILE ] && { echo "le fichier $FILE n'existe pas" ; exit ; }

FACILA=/usr/local/facila
 DROIT=$FACILA/share/prg/sys_droit.sh
if [ ! -d $FACILA ]
then mkdir $FACILA $FACILA/share $FACILA/share/prg
     tail -17 install.sh > $DROIT
     chmod 744 $DROIT
fi

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
cp $FILE /$FILE
cd /
tar -xzf $FILE
rm $FILE

echo configuration des droits de facila
$DROIT

exit

# facila/share/prg/sys_droit.sh créé à la première installation par la commande tail de install.sh

#!/bin/bash

cd /usr/local
chown -R root:root facila
chmod -R 755       facila

cd facila
chmod 744 share/prg/sys_droit.sh

find . -type d -name var -exec chmod -R 644 {} \;
find . -type d -name var -exec chmod -R u+X,g+X,o+X {} \;

find . -type d -name tmp -exec chmod -R 666 {} \;
find . -type d -name tmp -exec chmod -R u+X,g+X,o+X {} \;

find . -type d -name data -exec chmod -R 666 {} \;
find . -type d -name data -exec chmod -R u+X,g+X,o+X {} \;
