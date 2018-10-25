--
--

DROP TABLE tva_produse ;

CREATE TABLE tva_produse (
	CodPr NUMBER(6) NOT NULL REFERENCES produse (CodPr), 
	DataIntroducerii DATE, 
	DataRenuntarii DATE, 
	ProcTVA NUMBER(4,2)
	) ; 

DELETE FROM linii_fact WHERE nrfact >=5 ;
DELETE FROM fact WHERE nrfact >=5 ;
DELETE FROM produse WHERE CodPr > 3 ;

INSERT INTO produse VALUES (4, 'P4', 'mc', 'Textile', .19) ;
INSERT INTO produse VALUES (5, 'P5', 'ml', 'Cafea', .19) ;
INSERT INTO produse VALUES (6, 'P6', 'buc', 'Bere', .19) ;


INSERT INTO TVA_Produse VALUES (1, DATE'1999-01-01', DATE'2001-12-31', 22) ;
INSERT INTO TVA_Produse VALUES (1, DATE'2002-01-01', DATE'2004-12-31', 19) ;
INSERT INTO TVA_Produse VALUES (1, DATE'2005-01-01', NULL, 9) ;

INSERT INTO TVA_Produse VALUES (2, DATE'1999-01-01', DATE'2001-12-31', 19) ;
INSERT INTO TVA_Produse VALUES (2, DATE'2002-01-01', DATE'2004-12-31', 9) ;
INSERT INTO TVA_Produse VALUES (2, DATE'2005-01-01', NULL, 0) ;

INSERT INTO TVA_Produse VALUES (3, DATE'1999-01-01', NULL, 19) ;

INSERT INTO TVA_Produse VALUES (4, DATE'1999-01-01', DATE'2004-12-31', 9) ;
INSERT INTO TVA_Produse VALUES (4, DATE'2005-01-01', NULL, 19) ;

INSERT INTO TVA_Produse VALUES (5, DATE'1999-01-01', NULL, 9) ;

INSERT INTO TVA_Produse VALUES (6, DATE'1999-01-01', NULL, 19) ;


UPDATE fact SET datafact = DATE'2001-12-30' WHERE NrFact =1 OR NrFact=3 ;
UPDATE fact SET datafact = DATE'2004-07-26' WHERE NrFact =2 OR NrFact=4 ;

INSERT INTO fact (nrfact, datafact, codcl) VALUES (5, DATE'1999-01-31',1001);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (6, DATE'2003-12-12',1001);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (7, DATE'2005-01-10',1002);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (8, DATE'2005-01-05',1003);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (9, DATE'2004-11-29',1002);


INSERT INTO linii_fact VALUES (5, 1, 4, 950, 1800) ;
INSERT INTO linii_fact VALUES (5, 2, 5, 580, 1300) ;
INSERT INTO linii_fact VALUES (6, 1, 3, 630, 1450) ;
INSERT INTO linii_fact VALUES (7, 1, 6, 790, 1500) ;
INSERT INTO linii_fact VALUES (7, 2, 2, 850, 1800) ;
INSERT INTO linii_fact VALUES (7, 3, 2, 950, 1500) ;
INSERT INTO linii_fact VALUES (8, 1, 1, 850, 1450) ;

COMMIT ;

-- @F:\Useri\Marin\ProiectareaBD2004\Cap10_Temporalitate\Listing_10_01_tva_produse.sql