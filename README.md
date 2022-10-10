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
- DIR_SOURCE="nom du répertoire où se trouve le fichier téléchargé : stato-main.zip"
- cd
- mv $DIR_SOURCE/stato-main.zip .
- unzip stato-main.zip
- sh stato-main/install.sh stato.v2.15.tar.gz

si la variable globale $FACILA n'existe pas
- elle est créée dans ~/.bashrc : "export FACILA=~/facila"

si il y a une ancienne version de stato
- les répertoires et fichiers de install_stato sont copiés dans $FACILA/old

stato-main.zip est déplacé dans $FACILA/install
stato.v2.15.tar.gz est déplacé dans $FACILA/version
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
### Application partagée , commandes à faire en root
```
si vous souhaitez partager stato à un groupe d'utilisateurs vous devez :
- créer un groupe pour stato ou utiliser un groupe déjà existant
- mettre les répertoires et fichiers de stato dans ce groupe ( vérifier les droit r-x )
- créer les utilisateurs en les mettant dans ce groupe

les utilisateurs doivent se connecter au serveur avec la commande : ssh -X SERVEUR
```
