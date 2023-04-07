# facila stato : Etat SNMP
### Installation de facila stato
```
vous devez avoir installé au préalable :
- perl et perl-tk ( Tk.pm )

téléchargez stato à partir de github :
- cliquez sur : Code
- cliquez sur : Download ZIP

l'installation se fait dans le répertoire de l'utilisateur
tapez les commandes suivantes :
  MAIN=stao-main
  TAR=stato.v2.16.tar.gz
  DIR="nom du répertoire où se trouve le fichier téléchargé : $MAIN.zip"
  cd
  mv $DIR/$MAIN.zip .
  unzip $MAIN.zip
  sh $MAIN/install.sh $TAR

si la variable globale $FACILA n'existe pas
- elle est créée dans ~/.bashrc : "export FACILA=~/facila"


si il y a une ancienne version de stato
- les répertoires et fichiers de install_stato sont copiés dans $FACILA/share/save/old

$MAIN.zip est déplacé dans $FACILA/share/save/install
$TAR      est déplacé dans $FACILA/share/save/version

```
### Utilisation de facila stato
```
$FACILA/stato/prg/stato
```
### L'utilisateur peut créer un alias dans .bashrc
```
alias stato='$FACILA/stato/prg/stato'
```
### La commande devient alors
```
stato
```
### Application partagée sur un serveur
```
stato est accessible à tous les utilisateurs ayant un compte sur le serveur
avec les droits r-x ou r-- pour tous
les utilisateurs doivent se connecter au serveur avec la commande : ssh -X SERVEUR
```
