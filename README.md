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

l'installation crée une variable globale "export FACILA=$DIR/facila" dans ~/.bashrc
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
