DROP TABLE IF EXISTS
Produit, ProduitCompatibleProduit, Marque, Categorie, SousCategorie,
OccurenceProduit, Facture, FactureOccurenceProduit,Fournisseur, Client, 
PersonnelAchat, PersonnelVente, PersonnelSAV,PersonnelReparation, 
TicketPriseEnCharge, BonDeCommande, Reparation, Reprise, Vente
CASCADE
;

CREATE TABLE Marque(
 nom VARCHAR PRIMARY KEY
);

CREATE TABLE Categorie(
 nom VARCHAR PRIMARY KEY
);

CREATE TABLE SousCategorie(
 nom VARCHAR PRIMARY KEY,
 sousCategorie VARCHAR, 
 FOREIGN KEY(sousCategorie) REFERENCES Categorie(nom)
);

CREATE TABLE Produit(
  reference VARCHAR PRIMARY KEY,
  prixReference FLOAT,
  description VARCHAR,
  extensionGarantie BOOLEAN NOT NULL,
  consommation INTEGER, 
  marque VARCHAR REFERENCES Marque(nom) NOT NULL,
  sousCategorie VARCHAR REFERENCES SousCategorie(nom) NOT NULL,
  CHECK (prixReference >0)
);


CREATE TABLE ProduitCompatibleProduit(
 produit1 VARCHAR,
 produit2 VARCHAR, 
 FOREIGN KEY (produit1) REFERENCES Produit(reference),
 FOREIGN KEY (produit1) REFERENCES Produit(reference)
);

CREATE TABLE Fournisseur(
 nom VARCHAR PRIMARY KEY
);

CREATE TABLE OccurenceProduit(
 numeroDeSerie INTEGER PRIMARY KEY,
 prixAffiche FLOAT, 
 sousCategorie VARCHAR, 
 referenceProduit VARCHAR REFERENCES Produit(reference) NOT NULL,
 fournisseur VARCHAR REFERENCES Fournisseur(nom) NOT NULL,
 CHECK (prixAffiche >0)
);

CREATE TABLE PersonnelAchat(
 idPersonnel INTEGER PRIMARY KEY,
 nom VARCHAR,
 prenom VARCHAR
);

CREATE TABLE PersonnelVente(
 idPersonnel INTEGER PRIMARY KEY,
 nom VARCHAR,
 prenom VARCHAR
);

CREATE TABLE PersonnelSAV(
 idPersonnel INTEGER PRIMARY KEY,
 nom VARCHAR,
 prenom VARCHAR
);

CREATE TABLE PersonnelReparation(
 idPersonnel INTEGER PRIMARY KEY,
 nom VARCHAR,
 prenom VARCHAR
);

CREATE TABLE TicketPriseEnCharge(
 numeroTicket INTEGER PRIMARY KEY,
 date VARCHAR NOT NULL,
 ticketTraité BOOLEAN,
 produit INTEGER REFERENCES OccurenceProduit(numeroDeSerie) NOT NULL,
 personnel INTEGER REFERENCES PersonnelSAV(idPersonnel) NOT NULL
);

CREATE TABLE Client(
 nom VARCHAR UNIQUE,
 prenom VARCHAR UNIQUE,
 dateNaissance VARCHAR UNIQUE,
 adresseMail VARCHAR,
 typeClient VARCHAR, 
 PRIMARY KEY (nom, prenom, dateNaissance)
);

CREATE TABLE Facture(
 numeroFacture INTEGER PRIMARY KEY,
 totalsansRemise FLOAT NOT NULL, 
 remise FLOAT, 
 supplement FLOAT, 
 totalFinal FLOAT NOT NULL, 
 client VARCHAR REFERENCES Client(nom) NOT NULL,
 personnel INTEGER REFERENCES PersonnelVente(idPersonnel) NOT NULL
);

CREATE TABLE Reparation(
 numeroReparation INTEGER PRIMARY KEY,
 tempsPassé FLOAT NOT NULL,
 materielUtilisé VARCHAR,
 ticketPriseEnCharge INTEGER REFERENCES TicketPriseEnCharge(numeroTicket) NOT NULL,
 facture INTEGER REFERENCES Facture(numeroFacture) NOT NULL
);

CREATE TABLE Reprise(
 numeroReprise INTEGER PRIMARY KEY,
 contrePartie VARCHAR,
 ticketPriseEnCharge INTEGER REFERENCES TicketPriseEnCharge(numeroTicket) NOT NULL,
 facture INTEGER REFERENCES Facture(numeroFacture) NOT NULL
);

CREATE TABLE Vente(
 numeroVente INTEGER PRIMARY KEY,
 installationRequise BOOLEAN,
 facture INTEGER REFERENCES Facture(numeroFacture) NOT NULL
);

CREATE TABLE FactureOccurenceProduit(
 facture INTEGER,
 produit INTEGER,
 FOREIGN KEY (facture) REFERENCES Facture(numeroFacture),
 FOREIGN KEY (produit) REFERENCES OccurenceProduit(numeroDeSerie)
);


CREATE TABLE BonDeCommande(
 numeroBonDeCommande INTEGER PRIMARY KEY,
 date VARCHAR NOT NULL,
 quantite INTEGER NOT NULL,
 prixUnitaire FLOAT NOT NULL,
 bonTraité BOOLEAN, 
 produit VARCHAR REFERENCES Produit(reference) NOT NULL,
 personnelQuiCree INTEGER REFERENCES PersonnelVente(idPersonnel) NOT NULL,
 personnelQuiValide INTEGER REFERENCES PersonnelAchat(idPersonnel) NOT NULL
 CHECK (prixUnitaire>0),
 CHECK (quantite>0)
);




Intersection(Restriction(Facture, reparation NULL), Restriction(Facture, reprise NULL), Restriction(Facture, vente NULL))={}
ET ((reparation NULL AND vente NULL) OR (reparation NULL AND reprise NULL) OR (vente NULL AND reprise NULL)) 


PROJECTION(FactureOccurenceProduit, facture) = PROJECTION(Facture, numeroFacture)

PROJECTION(Client, nom) = PROJECTION(Facture,client)

vPersonnel=Union(Projection(PersonnelAchat,idPersonnel,nom, prenom),Projection(PersonnelVente,idPersonnel,nom, prenom),Projection(PersonnelSAV,idPersonnel,nom, prenom), Projection(PersonnelReparation,idPersonnel,nom, prenom))

Intersection(Restriction(TicketPriseEnCharge, reparation not NULL), Restriction(TicketPriseEnCharge, reprise not NULL))={}
ET Intersection(Restriction(TicketPriseEnCharge, reparation NULL), Restriction(TicketPriseEnCharge, reprise NULL))={}

 CHECK (typeClient = Particulier OR typeClient = Professionnel)
 
 Verifier les cardinalites pour ticketPriseEnCharge et Facture