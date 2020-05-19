# Note de Clarification du projet Entreprise de vente (Sujet 32)

## Description du projet

L'objectif de ce projet est de créer une nouvelle base de données pour une petite entreprise de vente de matériel technologique et électroménager, pour lui permettre de repertorier tous les achats effectués par les clients, les reparations, les factures, afin d'améliorer tout son service après-vente.


## Liste des objets nécessaires à la modélisation

**Produit**

**Fournisseur**

**Action**

**Facture**

**Reéparation**

**Vente**

**Reprise d'objet**

**Client**

**SAV**

**Ticket de prise en charge**

**Bon de commande**

**Achat**

## Liste des propriétés associées à chaque objet

**Produit**
- possède une référence
- possède une description
- possède un prix de référence 
- peut possèder une consommation  
- classé une catégorie 
- classé dans une sous-catégorie 
- possède un propre numéro de série 
- un prix affiché
- possède un fournisseur
- peut avoir une extension de garantie 

**Fournisseur**
- propose un ensemble de produits (ainsi plusieurs fournisseurs peuvent proposer le même produit), 

**Action**
-donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet

**Facture**
- réalisée par un membre du service vente
- total (hypotèse)
- nom du client (hypotèse)
- numero de facture (hypotèse)

**Ticket de prise en charge**
- date
- numero de serie du produit

**Bon de commande**
- reference produit 
- quantite

**Achat**
- quantité 
- prix unitaire


**Reéparation** 
- le temps passé  
- le matériel utilisé


**Vente**
- peut necessiter une Installation avec un professionnel

**Reprise d'objet**

**Client**

**SAV**

## Liste des contraintes associées à ces objets et propriétés

- Le prix de référence est proposé par la marque
- Chaque produit est classé dans une catégorie et une sous-catégorie de produits 
- Pour chaque produit, il faut spécifier s'il peut donner lieu à une extension de garantie (qui passe alors de 2 à 5 ans)
- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet
- Chaque occurrence du produit ne provient évidemment que d'un seul fournisseur
- Plusieurs fournisseurs peuvent proposer le même produit
- Pour une réparation, nous avons besoin de connaître le temps passé ainsi que le matériel utilisé, ce qui servira a établir la facture (si nécessaire) 
- La facturation est toujours réalisée par un membre du service vente
- Lors d'une vente, il faut préciser si l'installation doit être effectué par un spécialiste (auquel cas un supplément sera à régler)
- Sur chaque facture, il peut y avoir des remises différentes appliquées sur chaque produit acheté
- Le SAV choisi de prendre en charge ou non la réparation, ou si c'est irréparable, de rendre le produit au client ou de proposer une remise sur un achat suite à la reprise du produit défectueux ;


## Liste des utilisateurs (rôles) appelés à modifier et consulter les données

-Membre du SAV 
-Membre du service vente

## Liste des fonctions que ces utilisateurs pourront effectuer
- C'est le service vente qui réalise les factures
- C'est le service  vente qui emmet les bons de commandes
- C'est le service achat qui valide un achat suite au bon de commande avec une quantité de produits et le prix unitaire final
- Pouvoir retrouver différentes statistiques, comme par exemple les produits les plus vendus, ceux qui ont le plus de pannes, le panier moyen, le total des remises effectuées par un vendeur, etc

## Hypothèses faites pour la modélisation
- L'entreprise vend des produits de différentes marques ;
- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet ;
- Chaque intervention du SAV se solde de trois manières différentes : le produit est irréparable et rendu au client (aucun frais) ou alors une offre de reprise peut-être faite, ou alors si c'est réparable l'entreprise peut effectuer la réparation ;
- Différents services sont présents : le service vente, le service réparation et le service achat ;
- Les clients peuvent être des particuliers ou des professionnels ;
- Chaque produit vendu peut être un appareil, mais aussi une pièce détaché (le SAV se sert d'ailleurs des pièces détachés pour effectuer les réparations) ;
- Pour chaque produit (appareil, accessoire, pièce détachée, etc.), il faut établir des relations de compatibilités avec les autres
