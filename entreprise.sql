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
 categorie VARCHAR, 
 FOREIGN KEY(categorie) REFERENCES Categorie(nom)
);

CREATE TABLE Produit(
  reference VARCHAR PRIMARY KEY,
  prixReference FLOAT NOT NULL,
  description VARCHAR NOT NULL,
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
 prixAffiche FLOAT NOT NULL,  
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
 PRIMARY KEY (nom, prenom, dateNaissance), 
 CHECK (typeClient = 'Particulier' OR typeClient = 'Professionnel')
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
 ticketPriseEnCharge INTEGER REFERENCES TicketPriseEnCharge(numeroTicket)UNIQUE NOT NULL,
 facture INTEGER REFERENCES Facture(numeroFacture) UNIQUE NOT NULL
);

CREATE TABLE Reprise(
 numeroReprise INTEGER PRIMARY KEY,
 contrePartie VARCHAR,
 ticketPriseEnCharge INTEGER REFERENCES TicketPriseEnCharge(numeroTicket) UNIQUE NOT NULL,
 facture INTEGER REFERENCES Facture(numeroFacture) UNIQUE NOT NULL
);

CREATE TABLE Vente(
 numeroVente INTEGER PRIMARY KEY,
 installationRequise BOOLEAN,
 facture INTEGER REFERENCES Facture(numeroFacture) UNIQUE NOT NULL
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


CREATE VIEW vueticketPriseEncharge(nbTicket) AS
SELECT COUNT(DISTINCT Reparation.ticketPriseEnCharge)
FROM Reparation, Reprise
WHERE Reparation.ticketPriseEnCharge=Reprise.ticketPriseEnCharge;

CREATE VIEW vueFacture(nbFacture) AS
SELECT COUNT(DISTINCT Reparation.facture)
FROM Reparation, Reprise, Vente
WHERE Reparation.facture=Reprise.facture AND Reprise.facture=Vente.facture ;

CREATE VIEW vueFactureOccureneProduit(nbFactureTotal, nbFactureAvecProduit) AS
SELECT COUNT(FactureOccurenceProduit.facture), COUNT(Facture.numeroFacture)
FROM FactureOccurenceProduit, Facture;

CREATE VIEW vueFactureClient(nbFacture, nbFactureAvecClient) AS
SELECT COUNT(Facture), COUNT(Facture.client)
FROM Client, Facture
WHERE Client.nom=Facture.client;

CREATE VIEW vuePersonnel(idPersonnel, nom, prenom) AS 
SELECT idPersonnel, nom, prenom 
FROM PersonnelAchat 
UNION 
SELECT * FROM PersonnelVente 
UNION 
SELECT * FROM PersonnelSAV 
UNION 
SELECT * FROM PersonnelReparation;

INSERT INTO Marque VALUES
('Sonic'),
('LG'),
('Samsung'),
('Apple'),
('Bosch');

INSERT INTO Categorie VALUES
('Cuisine'),
('Chambre'),
('Jardin'),
('Informatique'),
('Electromenager');

INSERT INTO SousCategorie VALUES
('Petit Electromenager', 'Cuisine'),
('Ustensile', 'Cuisine'),
('Literie', 'Chambre'),
('Lampes', 'Chambre'),
('Bricolage', 'Jardin'),
('Jardinage', 'Jardin'),
('Ordinateur', 'Informatique'),
('Telephone', 'Informatique'),
('Cuisson', 'Electromenager'),
('Aspirateur et nettoyeur', 'Electromenager');

INSERT INTO Fournisseur VALUES
('GeneralElectromenager'),
('CuisinePourTous'),
('JardinProcheDeVous'),
('Telephonie'),
('Saphir');

INSERT INTO Produit VALUES 
('Lave linge WD 80 K 5 B 10', 600, 'Lave linge et secheur frontal', 'true', 8,	'Samsung', 'Aspirateur et nettoyeur'),
('Four encastrable pyrolyse HB675G0S1F iQ700', 400, 'Four haute intensité', 'true', 10, 'Bosch', 'Cuisson'),
('Plaque induction PUJ631BB1E', 500, '4 plaques inductions', 'false', 9, 'Bosch', 'Cuisson');

INSERT INTO ProduitCompatibleProduit VALUES
('Four encastrable pyrolyse HB675G0S1F iQ700','Plaque induction PUJ631BB1E');

INSERT INTO OccurenceProduit VALUES 
(8347836, 590, 'Lave linge WD 80 K 5 B 10', 'GeneralElectromenager'), 
(7785385, 590, 'Lave linge WD 80 K 5 B 10', 'GeneralElectromenager'),
(2723759, 590, 'Lave linge WD 80 K 5 B 10', 'Saphir'),
(3276433, 439, 'Four encastrable pyrolyse HB675G0S1F iQ700', 'GeneralElectromenager'), 
(3397448, 439, 'Lave linge WD 80 K 5 B 10', 'Saphir'),
(7457484, 439, 'Lave linge WD 80 K 5 B 10', 'GeneralElectromenager');


INSERT INTO PersonnelAchat VALUES
(2637, 'Idrissi', 'Maria'),
(1383, 'Dupont', 'Maria'),
(0173, 'Dupont', 'Christophe'),
(3726, 'Brasseur', 'Marine'),
(2938, 'Dehaas', 'Marguerite');

INSERT INTO PersonnelVente VALUES
(1334, 'Jolicoeur', 'Christine'),
(2337, 'Dufourg', 'Camille'),
(2231, 'Perez', 'Alice'),
(2347, 'Lopez', 'Alex'),
(1287, 'Attache', 'William');

INSERT INTO PersonnelSAV VALUES
(2413, 'Lopez', 'Emmy'),
(1342, 'Dupuis', 'Eddy'),
(2134, 'Leroux', 'Paula'),
(4453, 'Picard', 'Simon'),
(2314, 'Thomas', 'Will');

INSERT INTO PersonnelReparation VALUES
(2484, 'Lacroix', 'Marie'),
(5874, 'Fournier', 'Eric'),
(2947, 'Marrec', 'Florian'),
(4972, 'Perrier', 'Eloise'),
(4264, 'Galice', 'Maeva');