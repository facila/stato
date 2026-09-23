# Facila Stato

### Etat SNMP
```
version : 2.16 Avril 2023
auteur  : Thierry Le Gall
contact : facila@gmx.fr
site    : https://github.com/facila/stato
```
### Installation de facila stato
```
vous devez avoir installé au préalable :
- perl et perl-tk ( Tk.pm )

voir facila/install README.md
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
