DROP TABLE IF EXISTS
Produit, ProduitCompatibleProduit, Marque,
OccurenceProduit, Facture, FactureOccurenceProduit,Fournisseur, 
PersonnelAchat, PersonnelVente, PersonnelSAV,PersonnelReparation, 
TicketPriseEnCharge, BonDeCommande, Reparation, Reprise, Vente
CASCADE
;

-- Creation table

CREATE TABLE Marque(
 nom VARCHAR PRIMARY KEY
);

CREATE TABLE Produit(
  reference VARCHAR PRIMARY KEY,
  prixReference FLOAT NOT NULL,
  description VARCHAR NOT NULL,
  extensionGarantie BOOLEAN NOT NULL,
  consommation INTEGER, 
  marque VARCHAR REFERENCES Marque(nom) NOT NULL,
  sousCategorie JSON NOT NULL, 
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


CREATE TABLE Facture(
 numeroFacture INTEGER PRIMARY KEY,
 totalSansRemise FLOAT NOT NULL, 
 remise FLOAT NOT NULL DEFAULT 0, 
 supplement FLOAT NOT NULL DEFAULT 0,  
 client JSON NOT NULL,
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


-- Creation View

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

CREATE VIEW vueTotalPanierMoyen(totalMoyenFacture) AS
SELECT avg(total) FROM vueTotalFinal;

CREATE VIEW vueTotalRemiseParVendeur(idPersonnel, nomPersonnel, Totalremise) AS
SELECT Facture.personnel, PersonnelVente.nom, sum(Facture.remise)
FROM Facture, PersonnelVente
WHERE Facture.personnel=PersonnelVente.idPersonnel
GROUP BY Facture.personnel, PersonnelVente.idPersonnel;

CREATE VIEW vueProduitLesPlusVendus(referenceProduit, nombreDeVente) AS
SELECT P.reference, COUNT(*) 
FROM Vente V, FactureOccurenceProduit FOP, OccurenceProduit OP, Produit P
WHERE V.facture=FOP.Facture AND FOP.Produit=OP.numeroDeSerie AND OP.referenceProduit=P.reference
GROUP BY P.reference;

CREATE VIEW vueBestSeller(referenceProduitLePlusVendu, nombreDeVente) AS
WITH vueProduitLesPlusVendus 
AS
(
SELECT *, RANK ( ) OVER (ORDER BY nombreDeVente DESC) AS RANG
FROM vueProduitLesPlusVendus
)
SELECT referenceProduit, nombreDeVente
FROM vueProduitLesPlusVendus 
WHERE RANG=1;

CREATE VIEW vueProduitsLesPlusRepares(referenceProduit, nombreDePanne) AS
SELECT P.reference, COUNT(*) 
FROM Reparation R, FactureOccurenceProduit FOP, OccurenceProduit OP, Produit P
WHERE R.facture=FOP.Facture AND FOP.Produit=OP.numeroDeSerie AND OP.referenceProduit=P.reference
GROUP BY P.reference;

CREATE VIEW vuePireProduit(referenceProduitLePlusRepare, nombreDeReparation) AS
WITH vueProduitsLesPlusRepares 
AS
(
SELECT *, RANK ( ) OVER (ORDER BY nombreDePanne DESC) AS RANG
FROM vueProduitsLesPlusRepares
)
SELECT referenceProduit, nombreDePanne
FROM vueProduitsLesPlusRepares 
WHERE RANG=1;

CREATE VIEW vueTOPPersonnelVente(idPersonnel, nomPersonnel, nombreDeFacture) AS
SELECT Facture.personnel, PersonnelVente.nom, COUNT(*)
FROM Facture, PersonnelVente
WHERE Facture.personnel=PersonnelVente.idPersonnel
GROUP BY Facture.personnel, PersonnelVente.idPersonnel;

CREATE VIEW vueMeilleurPersonnelVente(idPersonnel, nomPersonnel, nombreDeFacture) AS
WITH vueTOPPersonnelVente 
AS
(
SELECT *, RANK ( ) OVER (ORDER BY nombreDeFacture DESC) AS RANG
FROM vueTOPPersonnelVente
)
SELECT idPersonnel, nomPersonnel, nombreDeFacture
FROM vueTOPPersonnelVente 
WHERE RANG=1;


CREATE VIEW vueClient(numeroCarteIdentite, nom, prenom, dateNaissance, adresseMail, typeClient) AS
SELECT CAST(c->>'numeroCarteIdentite' AS INTEGER) AS numeroCarteIdentite, c->>'nom' AS nom, c->>'prenom' AS prenom, 
c->>'dateNaissance' AS dateNaissance, c->>'adresseMail' AS adresseMail, c->>'typeClient' AS typeClient
FROM Facture F, JSON_ARRAY_ELEMENTS(F.client) c;

CREATE VIEW vueClientFacture(nombreFacture, nomClient, prenomClient) AS
SELECT COUNT(*), nom, prenom
FROM vueClient
GROUP BY nom, prenom;

CREATE VIEW vueClientLePlusFidele(nomClient, prenomClient, nombreDeFacture) AS
WITH vueClientFacture 
AS
(
SELECT *, RANK ( ) OVER (ORDER BY nombreFacture DESC) AS RANG
FROM vueClientFacture
)
SELECT nomClient, prenomClient, nombreFacture 
FROM vueClientFacture 
WHERE RANG=1;

CREATE VIEW vueProduitsInvendus(referenceProduit)AS
SELECT DISTINCT P.reference 
FROM Vente V, FactureOccurenceProduit FOP, OccurenceProduit OP, Produit P
WHERE P.reference NOT IN (
SELECT P.reference 
FROM Vente V, FactureOccurenceProduit FOP, OccurenceProduit OP, Produit P
WHERE V.facture=FOP.Facture AND FOP.Produit=OP.numeroDeSerie AND OP.referenceProduit=P.reference);

/*
-- Create User

CREATE ROLE PersonnelAchat;
CREATE ROLE PersonnelVente;
CREATE ROLE PersonnelReparation;
CREATE ROLE PersonnelSAV;

-- Tout le monde peut accéder à l’ensemble des produits, et des marques

GRANT SELECT
ON Produit, Marque
TO PUBLIC;

-- Tous les personnels peuvent accéder à l’ensemble des données et statistiques de l’entreprise

GRANT SELECT
ON Produit, ProduitCompatibleProduit, Marque,
OccurenceProduit, Facture, FactureOccurenceProduit,Fournisseur, 
PersonnelAchat, PersonnelVente, PersonnelSAV,PersonnelReparation, 
TicketPriseEnCharge, BonDeCommande, Reparation, Reprise, Vente, vueticketPriseEncharge, vueFacture, vueFactureOccurenceProduit, vuePersonnel, vueTotalFinal, vueTotalPanierMoyen, vueTotalRemiseParVendeur, vueProduitLesPlusVendus, vueBestSeller, vueProduitsLesPlusRepares, vuePireProduit, vueTOPPersonnelVente, vueMeilleurPersonnelVente, vueClient, vueClientFacture, vueClientLePlusFidele, vueProduitsInvendus
TO PersonnelAchat, PersonnelVente, PersonnelReparation, PersonnelSAV;

-- Tous les personnels peuvent insérer et modifier les tables des personnels, des marques, des fournisseurs et des produits

GRANT INSERT, UPDATE
ON PersonnelAchat, PersonnelVente, PersonnelReparation, PersonnelSAV, Marque, Fournisseur, Produit
TO PersonnelAchat, PersonnelVente, PersonnelReparation, PersonnelSAV;

-- C’est le personnel vente qui crée les bons de commande et qui émet les factures

GRANT INSERT, UPDATE, DELETE ON BonDeCommande, Facture, FactureOccurenceProduit TO PersonnelVente;

-- C’est le personnel achat qui valide les bons de commande avec une quantité de produits et le prix unitaire final

GRANT UPDATE ON BonDeCommande TO PersonnelAchat;

-- C’est le personnel SAV qui émet les ticketsPriseEnCharge, et qui décide si le produit sera réparé, repris ou vendu

GRANT INSERT, UPDATE, DELETE
ON TicketPriseEnCharge, Reparation, Reprise
TO PersonnelSAV;

-- C’est le personnel Reparation qui effectue les reparations et qui les modifie

GRANT INSERT, UPDATE, DELETE
ON Reparation
TO PersonnelReparation;

*/


-- Insertions


INSERT INTO Marque VALUES
('Sonic'),
('LG'),
('Samsung'),
('Apple'),
('Bosch'), 
('Brico');


INSERT INTO Fournisseur VALUES
('GeneralElectromenager'),
('CuisinePourTous'),
('JardinProcheDeVous'),
('Telephonie'),
('Saphir');

INSERT INTO Produit 
VALUES 
(
'Lave linge WD 80 K 5 B 10',
600, 
'Lave linge et secheur frontal', 
'true', 
8,	
'Samsung', 
'{"categorie":"Electromenager","sousCategorie":"Aspirateur et nettoyeur"}'
);

INSERT INTO Produit 
VALUES 
(
'Four encastrable pyrolyse HB675G0S1F iQ700', 
400, 
'Four haute intensité', 
'true', 
10, 
'Bosch', 
'{"categorie":"Electromenager","sousCategorie" : "Cuisson"}'
);

INSERT INTO Produit 
VALUES 
(
'Plaque induction PUJ631BB1E', 
500, 
'4 plaques inductions', 
'false', 
9, 
'Bosch',  
'{"categorie":"Electromenager","sousCategorie" : "Cuisson"}'
);

INSERT INTO Produit 
VALUES 
(
'Television 27 DH YT', 
290, 
'Ecran plat Full HD 4K', 
'true', 
4, 
'LG',  
'{"categorie":"Informatique","sousCategorie" : "Television"}'
);

INSERT INTO Produit 
VALUES 
(
'Boite à outils 34 ER 78', 
150, 
'Tres pratique pour vous depanner en cas de soucis informatique', 
'true', 
0, 
'Brico',  
'{"categorie":"Informatique","sousCategorie" : "Bricolage"}'
);

INSERT INTO Produit 
VALUES 
(
'Secateur 56 HT 76', 
60, 
'Secateur indispensable pour votre bricolage dans votre jardin', 
'true', 
0, 
'Brico', 
'{"categorie": "Jardin", "sousCategorie" : "Bricolage"}'
);

INSERT INTO Produit 
VALUES 
(
'Tondeuse 74 HG TH', 
150, 
'Tondeuse simple à utiliser', 
'true', 
6, 
'Bosch', 
'{"categorie": "Jardin", "sousCategorie" : "Jardinage"}'
);

INSERT INTO Produit 
VALUES 
(
'Frigo AJ 64 87', 
900, 
'Frigo avec compartiment congélateur', 
'true', 
13, 
'Bosch', 
'{"categorie": "Cuisine", "sousCategorie" : "Gros Electromenager"}'
);


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

INSERT INTO Facture(numeroFacture, totalsansRemise, remise, supplement, client, personnel)
VALUES
(
45678, 
590, 
-10, 
5,  
'[{"numeroCarteIdentite" : "372647289","nom" : "Idrissi", "prenom" : "Rita",
"dateNaissance" : "1990-06-10", "adresseMail" : "idrissi.rita@lilo.org", "typeClient" : "Particulier"}]', 
1334
);

INSERT INTO Facture(numeroFacture, totalsansRemise, remise, supplement, client, personnel)
VALUES
(
63729, 
439, 
-20, 
30, 
'[{"numeroCarteIdentite" : "245367283", "nom" : "Idrissi", "prenom" : "Rayane",
"dateNaissance" : "2008-06-10", "adresseMail" : "idrissi.rayane@lilo.org",
"typeClient" : "Particulier"}]',
1334
);

INSERT INTO Facture(numeroFacture, totalsansRemise, remise, supplement, client, personnel)
VALUES
(
45254, 
300, 
-10, 
10, 
'[{"numeroCarteIdentite" : "456789938", "nom" : "Brasseur", "prenom" : "Solene",
"dateNaissance" : "1995-06-10", "adresseMail" : "brasseur.sln@lilo.org",
"typeClient" : "Particulier"}]',
2337
);

-- Test du 0 par default de remise

INSERT INTO Facture(numeroFacture, totalsansRemise, supplement, client, personnel)
VALUES
(
26724, 
505, 
50, 
'[{"numeroCarteIdentite" : "456132584", "nom" : "Lafond", "prenom" : "Colin",
"dateNaissance" : "1994-03-12", "adresseMail" : "lfd.colin@lilo.org",
"typeClient" : "Particulier"}]', 
1287
);

INSERT INTO Facture(numeroFacture, totalsansRemise, supplement, client, personnel)
VALUES
(
12354, 
910, 
40,  
'[{"numeroCarteIdentite" : "753715738", "nom" : "Bond", "prenom" : "James", "dateNaissance" : "1998-06-10", "adresseMail" : "bond.007@lilo.org", 
"typeClient" : "Professionnel"}]',
2347
); 
 
INSERT INTO Facture(numeroFacture, totalsansRemise, supplement, client, personnel)
VALUES
(19875, 
590, 
40, 
'[{"numeroCarteIdentite" : "537537683", "nom" : "Taylor", "prenom" : "Vanessa",
"dateNaissance" : "1998-05-03", "adresseMail" : "vanessa.taylor@lilo.org",
"typeClient" : "Professionnel"}]', 
2347
);

INSERT INTO Facture(numeroFacture, totalsansRemise, supplement, client, personnel)
VALUES
(
54324, 
590, 
0, 
'[{"numeroCarteIdentite" : "456789938", "nom" : "Brasseur", "prenom" : "Solene",
"dateNaissance" : "1995-06-10", "adresseMail" : "brasseur.sln@lilo.org", "typeClient" : "Particulier"}]', 
2347
);

-- Test du 0 par default de supplement

INSERT INTO Facture(numeroFacture, totalsansRemise, client, personnel)
VALUES
(
98479, 
90, 
'[{"numeroCarteIdentite" : "537537683", "nom" : "Taylor", "prenom" : "Vanessa",
"dateNaissance" : "1998-05-03", "adresseMail" : "vanessa.taylor@lilo.org",
"typeClient" : "Professionnel"}]',
 2231
);

INSERT INTO Facture(numeroFacture, totalsansRemise, client, personnel)
VALUES
(
65283, 
89, 
'[{"numeroCarteIdentite" : "467846776", "nom" : "Bass", "prenom" : "Chuck",
"dateNaissance" : "1991-05-03", "adresseMail" : "chuck.bass@lilo.org",
"typeClient" : "Professionnel"}]', 
2347
);

INSERT INTO Facture(numeroFacture, totalsansRemise, client, personnel)
VALUES
(
32415, 
0, 
'[{"numeroCarteIdentite" : "245367283", "nom" : "Idrissi", "prenom" : "Rayane",
"dateNaissance" : "2008-06-10", "adresseMail" : "idrissi.rayane@lilo.org",
"typeClient" : "Particulier"}]', 
1287
);

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
