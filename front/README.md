# Partie Front

## Explications

Étant donné que le choix des technologies est libre, j'ai choisi de partir sur du Flutter afin d'apprendre plus de choses sur ce langage et de réaliser mon premier projet en PWA.

/!\ Les applications peuvent se run sur un mobile ou un navigateur web.

J'ai choisi de partir sur la création 2 applications distinctes. L'utilité de ces applications est décrite ci-dessous.


### Application `center`

Cette application est destinée au centre des colis pour créer de nouveaux colis, mais également choisir les livreurs et les colis que l'on sélectionne pour la livraison de la journée.

La page `Accueil` permet de visualiser les tournées de chaque livreur.
La page `Profil` permet la modification de l'utilisateur et la création des livraisons pour la journée.

Utilisateur déjà dans la DB: `root@test.fr`, password: `groot1234`

### Application `deliverer`

Cette deuxième est destinée aux livreurs, ce qui leur permet de signaler la livraison d'un colis. Une fois la livraison effectuée, le livreur reçoit sa prochaine destination. Il a également une visualisation sur la distance parcourue et sur sa distance totale de la journée.

Utilisateur déjà dans la DB: `test3@test.fr`, password: `grootgroot`, uid; `mm-CcaS9dlVRhty2`

## Installation Flutter

https://flutter.dev/docs/get-started/install

## Lancer les projets

`cd deliverer` ou `cd center`

`flutter devices`

`flutter run -d <device-id>`
