# Note de Clarification du projet 

Entreprise de vente (Sujet 32)

## Description du projet

L'objectif de ce projet est de créer une nouvelle base de données pour une petite entreprise de vente de matériel technologique et électroménager, pour lui permettre de repertorier tous les achats effectués par les clients, les reparations, les factures, afin d'améliorer tout son service après-vente.


## Liste des objets nécessaires à la modélisation

* Produit
* OccurenceProduit
* Categorie
* SousCategorie
* Marque
* Fournisseur
* Personnel
* PersonnelSAV
* PersonnelVente
* PersonnelRéparation
* PersonnelAchat
* Facture
* Ticket de prise en charge
* Bon de commande
* Réparation
* Vente
* Reprise 
* Client


## Liste des propriétés associées à chaque objet

**Produit**
- possède une référence
- possède une description
- possède un prix de référence 
- peut possèder une consommation  
- classé dans une sous-catégorie qui appartient à une catégorie
- est fabriqué par une marque
- peut avoir une extension de garantie qui passe de 2 ans à 5 ans (supplément ou gratuite)
- reference un autre produit si il est compatible avec

**OccurenceProduit**
- possède un numéro de série
- possède un prix affiché
- possède une garantie
- correspond à un produit 
- est fourni par un fournisseur

**Categorie**
- possède un nom

**SousCategorie**
- possède un nom
- appartient à une categorie (composition car cycle de vie lié)

**Marque**
- posséde un nom

**Fournisseur**
- posséde un nom

**Personnel**
- possède un identifiant
- possède un nom
- possède un prénom

**PersonnelSAV**
- hérite de la classe Personnel

**PersonnelVente**
- hérite de la classe Personnel

**PersonnelRéparation**
- hérite de la classe Personnel

**PersonnelAchat**
- hérite de la classe Personnel

**Facture**
- réalisée par un Personnel du service vente
- possède un total sans remise
- possède un numéro de facture
- peut possèder un supplément si l'installation nécessite un spécialiste, par default le supplement=0
- peut possèder une remise à appliquer sur le total sans remise, par default la remise=0
- possède une methode total final pour calculer le total avec remise et supplément si il y a 

**Ticket de prise en charge**
- possède une date, date à laquelle le produit a été pris en charge
- possède numero de serie du produit
- possède un booléan pour savoir si le ticket a été traité ou pas

**Bon de commande**
- possède une quantité
- possède un prix unitaire
- possède un booléan pour savoir si le bon de commande a été traité ou pas
- concerne un produit


**Réparation** 
- le temps passé  
- le matériel utilisé

**Vente**
- peut necessiter une Installation avec un professionnel

**Reprise d'objet**
- possède une contre partie 

**Client**
- possède un nom, prenom, et date de naissance (les trois constituent une clé)
- possède une adresseMail
- typeClient (soit un particulier soit un professionel)

## Liste des contraintes associées à ces objets et propriétés

- Le prix de référence est proposé par la marque
- Chaque produit est classé dans une sous catégorie qui appartient à une catégorie de produits 
- Pour chaque produit, il faut spécifier s'il peut donner lieu à une extension de garantie (qui passe alors de 2 à 5 ans)
- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet
- Chaque occurrence du produit ne provient évidemment que d'un seul fournisseur
- Un fournisseur propose un ensemble de produits 
- Plusieurs marques peuvent proposer le même produit
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
- Pouvoir retrouver différentes statistiques
- On peut connaitre le montant du panier moyen
- On peut connaitre le total des remises effectué par chaque personnel vente
- On peut connaitre les produits les plus vendus
- On peut connaitre les produits qui ont eu le plus de réparation
- On peut connaitre LE produit le plus vendu
- On peut connaitre LE produit qui a été le plus réparé
- On peut connaitre le nombre de facture par personnel
- On peut connaitre LE personnel qui a emis le plus de facture
- On peut consulter tous les cliens qui ont deja payés une facture
- On peut connaitre combien de facture a payé chaque client
- On peut connaitre le client le plus fidèle, c'est à dire celui qui a payé le plus de facture
- On peut consulter l'ensemble des personnels
- On peut consulter le total final pour chaque facture

## Hypothèses faites pour la modélisation
- L'entreprise vend des produits de différentes marques 
- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet ;
- Si une reparation est payante, le SAV demande au service vente de réaliser la facture car la facturation est toujours réalisée par un membre du service vente
- Chaque intervention du SAV se solde de trois manières différentes : le produit est irréparable et rendu au client (aucun frais) ou alors une offre de reprise peut-être faite, ou alors si c'est réparable l'entreprise peut effectuer la réparation 
- Si le produit est irréparable, et qu'on décide de le rendre au client, on détruit le ticket de prise en charge associé, donc un ticket de prise en charge qui a été traité concerne soit une rêparation soit une reprise 
- Si le produit est repris par l'entreprise, on donne une contrepartie au client, cette contrepartie peut etre une remise à appliquer sur un poduit
- Différents services sont présents : le service vente, le service réparation et le service achat 
- Les clients peuvent être des particuliers ou des professionnels 
- Un client professionnel n'est pas un fournisseur, ça peut etre une entreprise qui achète des produits en plus grande quantité  
- Chaque produit vendu peut être un appareil, mais aussi une pièce détaché (le SAV se sert d'ailleurs des pièces détachés pour effectuer les réparations) 
- Pour chaque produit (appareil, accessoire, pièce détachée, etc.), il faut établir des relations de compatibilités avec les autres
- Chaque achat est associé à un bon de commande
- Le supplément si jamais une installation est requise sera ajouté au total de la facture
- Le total final de la facture, sera obtenu à partir du total sans remise auquel on aura  rajouté un supplément et une remise si nécessaire
- L'extension de garantie peut être considéré comme un supplement dans la facture, sinon elle peut être proposé gratuitement pour certains produits
- On distingue marque et fournisseur, la marque fabrique le produit, et le fournisseur fournit le produit
- Un client paye au moins une facture sinon il serait pas client de l'entreprise. 
- Une occurence peut etre dans plusieurs factures, car cela peut etre une facture d'achat ou de reprise ou de reparation
- Une facture est soi une facture de vente, de reprise ou de reparation
- Deux sous categories peuvent avoir le même nom, tant qu'elles font pas partie de la même catégorie
- Le prix unitaire dans le bon de Commande ne depend pas du produit car il peut etre negocie par le service achat, donc le prix unitaire depend du bon de commande
