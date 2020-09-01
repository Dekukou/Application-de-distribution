# Exercice technique - Infomaniak (FullStack)

## Technologies utilisées

Pour cette exercice, j'ai décidé de partir sur une `API` en `Laravel` permettant l'ajout des colis et des livreurs ainsi que leur sélection pour la création du planning.

Il y a également un service base de données `PostgreSQL` qui tourne grâce à un docker. On y retrouve `3 tables` dont une relationnelle mais aussi une view permettant de retourner le format que l'on souhaite pour le planning.

En ce qui concerne la partie Front, j'ai décidé de partir sur 2 applications mobiles en `Flutter`. L'une servant au centre de livraison permettant de choisir les ressources de la journée et de lancer le script d'attribution des colis.
L'autre permet aux livreurs d'avoir une vision sur le colis à livrer.

## Explication du script planning

En admettant qu'un livreur habite à l'extrémité en bas à gauche de la map et qu'il doit livrer un colis se trouvant en haut à droite, pour qu'il puisse livrer son colis et rentrer chez lui en moins de 240km, on limite la map en `x(-56; 56)` et en `y(-56; 56)`.

Le point le plus complexe est de savoir comment attribuer le premier colis de la meilleure manière possible.

Avant d'expliquer la démarche utilisée, nous allons voir les différentes idées rencontrées avant le résultat final.

- La toute première idée était de diviser la map en plusieurs radians en fonction du nombre de livreur pour la journée.
`Problème rencontré:` Selon la disposition des colis, il est possible qu'un livreur ne soit associé à aucun colis.

- Ensuite, trier les colis en fonction du centre de livraison et attribuer les colis le plus proche en priorité.
`Problème rencontré:` Il y a de grandes chances que les colis se trouvant en bord de map ne soient jamais livrés.

- À l'inverse, trier les colis en fonction du centre de livraison et attribuer les colis le plus éloignés en priorité.
`Problème rencontré:` Il y a de grandes chances que les colis se trouvant proche du centre ne soient jamais livrés.

- Une attribution aléatoire du premier colis pour chaque livreur.
`Problème rencontré:` Cette attribution a peu de chances d'être efficace et il est également possible que les colis les plus éloignés ne soient jamais livrés.

- Trier les colis en fonction du domicile de chaque livreur et remplir le tableau dans le sens opposé (commencer par attribuer les colis livrés en dernier).
`Problème rencontré:` Méthode la plus optimisé, mais pas assez original.

Maintenant nous allons expliquer l'idée utilisée et détailler ses avantages comparés aux idées précédentes.

- Pour commencer nous trions les colis afin de les classer par ordre de proximité du centre de tri.
- Le premier livreur se chargera du colis le plus proche.
- Les autres livreurs (sans compter le dernier) s'occuperont des colis plus ou moins proche avec un espace de `Nb_colis / Nb_livreur + valeur précédente`.
- Le dernier livreur (si le nombre de livreur est supérieur à 1) livrera tout le temps le colis le plus éloigné.

Cette méthode permet de repartir de façon efficace les livreurs sur la map ainsi que de s'occuper des colis proches et éloignés.

Pour la suite, chaque livreur s'occupera du colis le plus proche du point où il se trouve s'il ne dépasse pas les 240km en comptant son retour au domicile.

## Fonctionnement des services

Chaque service contient un `README` qui lui est propre en ce qui concerne son installation et son fonctionnement.

Une collection `Postman` est disponible à la racine du projet pour voir les routes utilisées ainsi que leur retour.
