
-- consemnarea modificarii valorii atribututelor legate de adresa
DROP TABLE clienti_codpost ;
DROP TABLE clienti_tel ;
DROP TABLE clienti_bloc ;
DROP TABLE clienti_nr ;
DROP TABLE clienti_strazi ;

CREATE TABLE clienti_strazi (
	CodCl NUMBER(6) NOT NULL REFERENCES clienti2(CodCl),
	StradaCl VARCHAR2(30),
	DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
	DataFinala DATE DEFAULT NULL,
	PRIMARY KEY (CodCl, StradaCl, DataInitiala)
	) ;

CREATE TABLE clienti_nr (
	CodCl NUMBER(6) NOT NULL REFERENCES clienti2(CodCl),
	NrStradaCl VARCHAR2(7),
	DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
	DataFinala DATE DEFAULT NULL,
	PRIMARY KEY (CodCl, NrStradaCl, DataInitiala)
	) ;

CREATE TABLE clienti_bloc (
	CodCl NUMBER(6) NOT NULL REFERENCES clienti2(CodCl),
	BlocScApCl VARCHAR2(20),
	DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
	DataFinala DATE DEFAULT NULL,
	PRIMARY KEY (CodCl, BlocScApCl, DataInitiala)
	) ;


CREATE TABLE clienti_tel (
	CodCl NUMBER(6) NOT NULL REFERENCES clienti2(CodCl),
	TelefonCl VARCHAR2(20),
	DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
	DataFinala DATE DEFAULT NULL,
	PRIMARY KEY (CodCl, TelefonCl, DataInitiala)
	) ;


CREATE TABLE clienti_codpost (
	CodCl NUMBER(6) NOT NULL REFERENCES clienti2(CodCl),
	CodPost NUMBER(6) REFERENCES coduri_postale(CodPost),
	DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
	DataFinala DATE DEFAULT NULL,
	PRIMARY KEY (CodCl, CodPost, DataInitiala)
	) ;


    codcl NUMBER(6) PRIMARY KEY CHECK (codcl > 1000),
    dencl VARCHAR2(30) CHECK (SUBSTR(dencl,1,1) = UPPER(SUBSTR(dencl,1,1))),
    codfiscal CHAR(9) NOT NULL 
        CHECK (SUBSTR(codfiscal,1,1) = UPPER(SUBSTR(codfiscal,1,1))),
    stradacl VARCHAR2(30)
        CHECK (SUBSTR(stradacl,1,1) = UPPER(SUBSTR(stradacl,1,1))),
    nrstradacl VARCHAR2(7),
    blocscapcl VARCHAR2(20),
    telefon VARCHAR2(10),
    codpost NUMBER(6) REFERENCES coduri_postale(codpost)
    ) ;



-- modificarea unui element din adresa in tabele CLIENTI
CREATE OR REPLACE TRIGGER trg_clienti_upd2
	AFTER UPDATE OF StradaCl, NrStradaCl, BlocScApCl,
	Telefon, CodPost ON clienti2 FOR EACH ROW
BEGIN
	IF NEW.StradaCl <> :OLD.StradaCl THEN
		-- 
		INSERT INTO clienti_strazi VALUES (:OLD.CodCl,:OLD.StradaCl,
			
 (
	CodCl NUMBER(6) NOT NULL REFERENCES clienti2(CodCl),
	StradaCl VARCHAR2(30),
	DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
	DataFinala DATE DEFAULT NULL,
	PRIMARY KEY (CodCl, StradaCl, DataInitiala)
	) ;
END ;
/

DELETE FROM linii_fact WHERE NrFact >= 10 ;
DELETE FROM fact WHERE NrFact >= 10 ;

INSERT INTO fact (nrfact, datafact, codcl) VALUES (10, SYSDATE,1001);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (11, SYSDATE,1001);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (12, SYSDATE,1002);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (13, SYSDATE,1003);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (14, SYSDATE,1002);


COMMIT ;

-- @F:\Useri\Marin\ProiectareaBD2004\Cap10_Temporalitate\Listing_10_02_promotii.sql