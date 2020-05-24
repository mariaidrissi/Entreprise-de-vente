# Note de Clarification du projet 

Entreprise de vente (Sujet 32)

## Description du projet

L'objectif de ce projet est de créer une nouvelle base de données pour une petite entreprise de vente de matériel technologique et électroménager, pour lui permettre de repertorier tous les achats effectués par les clients, les reparations, les factures, afin d'améliorer tout son service après-vente.


## Liste des objets nécessaires à la modélisation

* Produit
* Fournisseur
* Facture
* Client
* Ticket de prise en charge
* Reprise 
* Réparation
* Bon de commande
* Personnel
* Achat
* Vente

## Liste des propriétés associées à chaque objet

**Produit**
- possède une référence
- possède une description
- possède un prix de référence 
- peut possèder une consommation  
- classé dans une catégorie 
- classé dans une sous-catégorie 
- possède un propre numéro de série 
- un prix affiché
- possède un fournisseur
- peut avoir une extension de garantie 

**Fournisseur**
- posséde un nom

**Personnel**
- possède un identifiant
- appartient à un service : Vente, Réparation, Achat, Après vente

**Facture**
- réalisée par un membre du service vente
- posséde un total 
- posséde un numéro de facture

**Ticket de prise en charge**
- posséde une date, date à laquelle le produit a été pris en charge
- posséde numero de serie du produit
- possède un booléan pour savoir si le ticket a été traité ou pas

**Bon de commande**
- posséde une reference produit 
- posséde une quantité
- possède un booléan pour savoir si le bon de commande a été traité ou pas

**Achat**
- posséde une quantité 
- posséde un prix unitaire

**Réparation** 
- le temps passé  
- le matériel utilisé

**Vente**
- peut necessiter une Installation avec un professionnel

**Reprise d'objet**
- possède une contre partie 

**Client**
- possède un nom, prenom, et date de naissance 
- possède un prenom
- possède une date de naissance 
- possède une adresseMail
- typeClient (soit un particulier soit un professionel)

## Liste des contraintes associées à ces objets et propriétés

- Le prix de référence est proposé par la marque
- Chaque produit est classé dans une catégorie et une sous-catégorie de produits 
- Pour chaque produit, il faut spécifier s'il peut donner lieu à une extension de garantie (qui passe alors de 2 à 5 ans)
- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet
- Chaque occurrence du produit ne provient évidemment que d'un seul fournisseur
- Un fournisseur propose un ensemble de produits 
- Plusieurs fournisseurs peuvent proposer le même produit
- Pour une réparation, nous avons besoin de connaître le temps passé ainsi que le matériel utilisé, ce qui servira a établir la facture (si nécessaire) 
- La facturation est toujours réalisée par un membre du service vente
- Lors d'une vente, il faut préciser si l'installation doit être effectué par un spécialiste (auquel cas un supplément sera à régler)
- Sur chaque facture, il peut y avoir des remises différentes appliquées sur chaque produit acheté
- Le SAV est géré par un membre du service SAV : il crée le ticket de prise en charge et note la date (pour contrôler la garantie du produit)
- Le SAV choisi de prendre en charge ou non la réparation, ou si c'est irréparable, de rendre le produit au client ou de proposer une remise sur un achat suite à la reprise du produit défectueux 


## Liste des utilisateurs (rôles) appelés à modifier et consulter les données

- Membre du SAV 
- Membre du service vente
- Membre du service achat

## Liste des fonctions que ces utilisateurs pourront effectuer
- C'est le service vente qui réalise les factures
- C'est le service vente qui emmet les bons de commandes
- C'est le service achat qui valide un achat suite au bon de commande avec une quantité de produits et le prix unitaire final
- C'est le service après vente qui crée le ticket de prise en charge, et qui décide si un produit est réparable, ou si le produit sera repris en proposant une remise au client ou si le produit lui sera rendu
- Pouvoir retrouver différentes statistiques, comme par exemple les produits les plus vendus, ceux qui ont le plus de pannes, le panier moyen, le total des remises effectuées par un vendeur, etc

## Hypothèses faites pour la modélisation
- L'entreprise vend des produits de différentes marques 
- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet ;
- Si une reparation est payante, le SAV demande au service vente de réaliser la facture car la facturation est toujours réalisée par un membre du service vente
- Chaque intervention du SAV se solde de trois manières différentes : le produit est irréparable et rendu au client (aucun frais) ou alors une offre de reprise peut-être faite, ou alors si c'est réparable l'entreprise peut effectuer la réparation 
- Si le produit est irréparable, et qu'on décide de le rendre au client, on détruit le ticket de prise en charge associé, donc un ticket de prise en charge qui a été traité concerne soit une rêparation soit une reprise 
- Différents services sont présents : le service vente, le service réparation et le service achat 
- Les clients peuvent être des particuliers ou des professionnels 
- Chaque produit vendu peut être un appareil, mais aussi une pièce détaché (le SAV se sert d'ailleurs des pièces détachés pour effectuer les réparations) 
- Pour chaque produit (appareil, accessoire, pièce détachée, etc.), il faut établir des relations de compatibilités avec les autres
- Chaque achat est associé à un bon de commande
