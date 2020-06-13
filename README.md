# Projet 2 NA17 

IDRISSI KAITOUNI Maria

## Sujet 32 : 

# Entreprise de vente
Une petite entreprise de vente de matériel technologique et électroménager souhaite changer son image de marque et se doter d'une nouvelle base de données permettant de tracer précisément tous les achats effectués par les clients, afin d'améliorer tout son service après-vente.

# Hypothèses
L'entreprise vend des produits de différentes marques ;

- Chaque action donne lieu à une facturation, que ce soit une vente, une réparation ou une reprise d'un objet ;

- Chaque intervention du SAV se solde de trois manières différentes : le produit est irréparable et rendu au client (aucun frais) ou alors une offre de reprise peut-être faite, ou alors si c'est réparable l'entreprise peut effectuer la réparation ;

- différents services sont présents : le service vente, le service réparation et le service achat ;

- Les clients peuvent être des particuliers ou des professionnels ;

- Chaque produit vendu peut être un appareil, mais aussi une pièce détaché (le SAV se sert d'ailleurs des pièces détachés pour effectuer les réparations) ;

- Pour chaque produit (appareil, accessoire, pièce détachée, etc.), il faut établir des relations de compatibilités avec les autres.

# Besoins
- Chaque produit doit posséder une référence (souvent celle proposée par la marque), une description, un prix de référence (proposée par la marque), et parfois une consommation ; et il est classé dans une catégorie et une sous-catégorie de produits ;

- Pour chaque produit, il faut spécifier s'il peut donner lieu à une extension de garantie (qui passe alors de 2 à 5 ans) ;

- Chaque occurrence de produit possède un propre numéro de série et un prix affiché ;

- Un fournisseur propose un ensemble de produits (ainsi plusieurs fournisseurs peuvent proposer le même produit), mais chaque occurrence du produit ne provient évidemment que d'un seul fournisseur ;

- La facturation est toujours réalisée par un membre du service vente ;

- Le SAV est géré par un membre du service SAV : il crée le ticket de prise en charge et note la date (pour contrôler la garantie du produit) ;

- Le SAV choisi ensuite de prendre en charge ou non la réparation, ou si c'est irréparable, de rendre le produit au client ou de proposer une remise sur un achat suite à la reprise du produit défectueux ;

- Pour une réparation, nous avons besoin de connaître le temps passé ainsi que le matériel utilisé, ce qui servira a établir la facture (si nécessaire) ;

- Lors d'une vente, il faut préciser si l'installation doit être effectué par un spécialiste (auquel cas un supplément sera à régler) ;

- Le service vente peut émettre un bon de commande pour demander un achat de produits et réapprovisionner les stocks ;

- Dans ce cas, c'est le service achat qui se charge de la négociation (qui ne concerne pas notre BDD), et valide au final un achat avec une quantité de produits et le prix unitaire final ;

- Sur chaque facture, il peut y avoir des remises différentes appliquées sur chaque produit acheté ;

- Nous avons besoin de pouvoir retrouver différentes statistiques, comme par exemple les produits les plus vendus, ceux qui ont le plus de pannes, le panier moyen, le total des remises effectuées par un vendeur, etc.

### Dates des livrables

Livrable 1 : NDC, MCD ─ dimanche 24 mai 23h59

Livrable 2 : NDC, MCD, MLD, SQL CREATE et INSERT ─ dimanche 31 mai 23h59

Livrable 3 : NDC, MCD, MLD, SQL CREATE et INSERT, SQL SELECT, Complément : PostgreSQL/JSON ─ dimanche 07 juin 23h59

Livrable 4 : Révision complète du projet (v2) ─ Application CLI Python (On considère que c'est un admin qui execute le fichier menu.py)- dimanche 14 juin 23h59

Livrable 5 : Révision complète du projet (v3) ─ dimanche 21 juin 23h59
