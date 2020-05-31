DROP TABLE IF EXISTS
Produit, ProduitCompatibleProduit, Marque, Categorie, SousCategorie,
OccurenceProduit, Facture, FactureOccurenceProduit,Fournisseur, Client, 
PersonnelAchat, PersonnelVente, PersonnelSAV,PersonnelReparation, 
TicketPriseEnCharge, BonDeCommande, Reparation, Reprise, Vente
CASCADE
;

-- Creation table

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
 date DATE NOT NULL,
 ticketTraité BOOLEAN,
 produit INTEGER REFERENCES OccurenceProduit(numeroDeSerie) NOT NULL,
 personnel INTEGER REFERENCES PersonnelSAV(idPersonnel) NOT NULL
);

CREATE TABLE Client(
 numeroCarteIdentite INTEGER PRIMARY KEY,
 nom VARCHAR NOT NULL,
 prenom VARCHAR NOT NULL,
 dateNaissance DATE NOT NULL,
 adresseMail VARCHAR,
 typeClient VARCHAR NOT NULL, 
 CHECK (typeClient = 'Particulier' OR typeClient = 'Professionnel')
);

CREATE TABLE Facture(
 numeroFacture INTEGER PRIMARY KEY,
 totalSansRemise FLOAT NOT NULL, 
 remise FLOAT NOT NULL DEFAULT 0, 
 supplement FLOAT NOT NULL DEFAULT 0,  
 client INTEGER REFERENCES Client(numeroCarteIdentite) NOT NULL,
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
 date DATE NOT NULL,
 quantite INTEGER NOT NULL,
 prixUnitaire FLOAT NOT NULL,
 bonTraité BOOLEAN, 
 produit VARCHAR REFERENCES Produit(reference) NOT NULL,
 personnelQuiCree INTEGER REFERENCES PersonnelVente(idPersonnel) NOT NULL,
 personnelQuiValide INTEGER REFERENCES PersonnelAchat(idPersonnel) NOT NULL
 CHECK (prixUnitaire>0),
 CHECK (quantite>0)
);

-- Views 

CREATE VIEW vueticketPriseEncharge(nbTicket) AS
SELECT COUNT(*)
FROM Reparation, Reprise
WHERE Reparation.ticketPriseEnCharge=Reprise.ticketPriseEnCharge;

CREATE VIEW vueFacture(nbFacture) AS
SELECT COUNT(*)
FROM Reparation, Reprise, Vente
WHERE (Reparation.facture=Reprise.facture OR Reprise.facture=Vente.facture OR Reparation.facture=Vente.facture);

CREATE VIEW vueFactureOccurenceProduit(nbFactureAvecProduit, nbFactureTotal) AS
SELECT COUNT(DISTINCT FactureOccurenceProduit.facture), COUNT(DISTINCT Facture.numeroFacture)
FROM FactureOccurenceProduit, Facture;

CREATE VIEW vueFactureClient(nbClient, nbFactureAvecClient) AS
SELECT COUNT (DISTINCT C.numeroCarteIdentite), COUNT(DISTINCT F.client)
FROM Client C, Facture F;

CREATE VIEW vuePersonnel(idPersonnel, nom, prenom) AS 
SELECT idPersonnel, nom, prenom 
FROM PersonnelAchat 
UNION 
SELECT * FROM PersonnelVente 
UNION 
SELECT * FROM PersonnelSAV 
UNION 
SELECT * FROM PersonnelReparation;

CREATE VIEW vueTotalFinal(numeroFacture, total) AS 
SELECT Facture.numeroFacture, Facture.totalSansRemise + Facture.remise + Facture.supplement
FROM Facture;

-- Insertions

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
('Gros Electromenager', 'Cuisine'),
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
('Plaque induction PUJ631BB1E', 500, '4 plaques inductions', 'false', 9, 'Bosch', 'Cuisson'),
('Television 27 DH YT', 290, 'Ecran plat Full HD 4K', 'true', 4, 'LG', 'Cuisson'),
('Frigo AJ 64 87', 900, 'Frigo avec compartiment congélateur', 'true', 13, 'Bosch', 'Gros Electromenager');

INSERT INTO ProduitCompatibleProduit VALUES
('Four encastrable pyrolyse HB675G0S1F iQ700','Plaque induction PUJ631BB1E');

INSERT INTO OccurenceProduit VALUES 
(8347836, 590, 'Lave linge WD 80 K 5 B 10', 'GeneralElectromenager'), 
(7785385, 590, 'Lave linge WD 80 K 5 B 10', 'GeneralElectromenager'),
(2723759, 590, 'Lave linge WD 80 K 5 B 10', 'Saphir'),
(3276433, 439, 'Four encastrable pyrolyse HB675G0S1F iQ700', 'GeneralElectromenager'), 
(3397448, 439, 'Four encastrable pyrolyse HB675G0S1F iQ700', 'Saphir'),
(7457484, 439, 'Four encastrable pyrolyse HB675G0S1F iQ700', 'GeneralElectromenager'), 
(1236537, 300, 'Television 27 DH YT', 'Telephonie'),
(7367483, 505, 'Plaque induction PUJ631BB1E', 'CuisinePourTous'),
(2425364, 910, 'Frigo AJ 64 87', 'CuisinePourTous');


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

INSERT INTO TicketPriseEnCharge VALUES
(736, '2020-02-09', 'true', 8347836, 2413),
(273, '2020-04-09', 'true', 8347836, 2413),
(372, '2020-06-09', 'true', 7785385, 1342),
(376, '2020-06-10', 'false', 3276433, 2134);

INSERT INTO Client VALUES
(372647289,'Idrissi', 'Rita', '1990-06-10', 'idrissi.rita@lilo.org', 'Particulier'),
(245367283,'Idrissi', 'Rayane', '2008-06-10', 'idrissi.rayane@lilo.org', 'Particulier'),
(456789938, 'Brasseur', 'Solene', '1995-06-10', 'brasseur.sln@lilo.org', 'Particulier'),
(456132584, 'Lafond', 'Colin', '1994-03-12', 'lfd.colin@lilo.org', 'Particulier'),
(753715738, 'Bond', 'James', '1998-06-10', 'bond.007@lilo.org', 'Professionnel'),
(537537683, 'Taylor', 'Vanessa', '1998-05-03', 'vanessa.taylor@lilo.org', 'Professionnel'),
(467846776, 'Bass', 'Chuck', '1991-05-03', 'chuck.bass@lilo.org', 'Professionnel');

INSERT INTO Facture(numeroFacture, totalsansRemise, remise, supplement, client, personnel)VALUES
(45678, 590, -10, 5, '372647289', 1334),
(63729, 439, -20, 30, '245367283', 1334),
(45254, 300, -10, 10, '456789938', 2337);

-- Test du 0 par default de remise

INSERT INTO Facture(numeroFacture, totalsansRemise, supplement, client, personnel)VALUES
(26724, 505, 50, '456132584', 1287),
(12354, 910, 40, '753715738', 2347), 
(19875, 590, 40, '537537683', 2347), 
(54324, 590, 0, '467846776', 2347);

-- Test du 0 par default de supplement

INSERT INTO Facture(numeroFacture, totalsansRemise, client, personnel)VALUES
(98479, 90, '537537683', 2231),
(65283, 89, '467846776', 2347),
(32415, 0, '245367283', 1287);

INSERT INTO Reparation(numeroReparation, tempsPassé, ticketPriseEnCharge, facture) VALUES
(53678, 0.4, 736, 98479),
(65421, 0.5, 372, 65283);

INSERT INTO Reprise VALUES
(67892, 'Remise de 50% à appliquer en caisse', 376, 32415);

INSERT INTO Vente VALUES
(456723, 'false', 45254),
(376277, 'true', 45678),
(942757, 'true', 63729),
(635267, 'false', 26724), 
(362736,'true', 12354),
(526726, 'true', 19875),
(153657, 'false', 54324);

INSERT INTO FactureOccurenceProduit VALUES
(45678, 8347836),
(63729, 3276433),
(45254, 1236537),
(26724, 7367483),
(98479, 7785385),
(19875, 7785385),
(54324, 2723759),
(65283, 2723759),
(12354, 2425364),
(32415, 2425364);

INSERT INTO BonDeCommande VALUES
(4567, '2020-02-09', 5, 500, 'true', 'Plaque induction PUJ631BB1E', 2337, 2637),
(3214, '2020-02-10', 8, 290, 'true', 'Television 27 DH YT', 2337, 2637); 


/* -- Pour tester la vueFacture en mettant le meme numero de facture

INSERT INTO Vente VALUES
(456723, 'false', 98479);

--Pour tester la vueTicketPriseEnCharge en mettant le meme numero de ticketPriseEnCharge 

INSERT INTO Reprise VALUES
(67892, 'Remise de 50% à appliquer en caisse', 736, 65283);

 */