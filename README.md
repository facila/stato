# facila stato : Etat SNMP
### Installation de facila stato
```
vous devez avoir installé au préalable :
- perl et perl-tk ( Tk.pm )

téléchargez stato à partir de github :
- cliquez sur : Code
- cliquez sur : Download ZIP

positionnez vous dans le répertoire $DIR où vous souhaitez installer facila stato
copier le fichier téléchargé stato-main.zip dans ce répertoire

tapez les commandes suivantes :
- unzip stato-main.zip
- cd stato-main
- install.sh stato.2.15.tar.gz

si la variable globale $FACILA n'existe pas , elle est créée dans ~/.bashrc : "export FACILA=$DIR/facila"
si il y a une ancienne version de stato , les répertoires et fichiers de install_stato sont copiés dans $FACILA/old
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
