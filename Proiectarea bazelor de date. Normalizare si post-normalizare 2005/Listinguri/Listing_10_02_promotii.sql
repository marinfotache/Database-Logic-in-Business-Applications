--
--

ALTER TABLE produse RENAME COLUMN ProcTVA TO ProcCurentTVA ;

ALTER TABLE produse ADD PretCurent NUMBER(12) ;

UPDATE produse SET PretCurent=1500 WHERE CodPr=1 ;
UPDATE produse SET PretCurent=1400 WHERE CodPr=2 ;
UPDATE produse SET PretCurent=1300 WHERE CodPr=3 ;
UPDATE produse SET PretCurent=1200 WHERE CodPr=4 ;
UPDATE produse SET PretCurent=1450 WHERE CodPr=5 ;
UPDATE produse SET PretCurent=1500 WHERE CodPr=6 ;


DROP TABLE promotii ;
CREATE TABLE promotii (
	CodPr NUMBER(6) NOT NULL REFERENCES produse (CodPr), 
	DataInceputProm DATE, 
	DataFinalProm DATE, 
	PretPromotional NUMBER(12)
	) ; 

INSERT INTO promotii VALUES (1, DATE'2005-01-01', NULL, 1475) ;

INSERT INTO promotii VALUES (3, DATE'2005-10-20', DATE'2005-02-02', 1325) ;

INSERT INTO promotii VALUES (5, DATE'2005-02-01', NULL, 1325) ;

-- stergere in LINII_FACT - la nivel de LINIE
CREATE OR REPLACE TRIGGER trg_lf_del
	BEFORE DELETE ON linii_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_liniifact := TRUE ;	
	pac_vinzari.v_nrfact := :OLD.NrFact ;
	pac_vinzari.v_liniestearsa := :OLD.Linie ;
	UPDATE fact SET
		valtotala = valtotala - :OLD.cantitate * 
			:OLD.pretunit * (1 +
		      (SELECT ProcCurentTVA FROM produse WHERE codpr=:OLD.codpr)),
		TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
		     (SELECT ProcCurentTVA FROM produse WHERE codpr=:OLD.codpr)
	WHERE nrfact=:OLD.nrfact ;
	pac_vinzari.v_trg_liniifact := FALSE ;	
END ;
/

DELETE FROM linii_fact WHERE NrFact >= 10 ;
DELETE FROM fact WHERE NrFact >= 10 ;

INSERT INTO fact (nrfact, datafact, codcl) VALUES (10, SYSDATE,1001);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (11, SYSDATE,1001);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (12, SYSDATE,1002);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (13, SYSDATE,1003);
INSERT INTO fact (nrfact, datafact, codcl) VALUES (14, SYSDATE,1002);

----------------------------------------------------------
CREATE OR REPLACE FUNCTION f_datafact (nrfact_ fact.NrFact%TYPE)
	RETURN DATE 
IS
	v_data DATE ;	
BEGIN
	SELECT DataFact INTO v_data FROM fact 
	WHERE NrFact=nrfact_ ;
	RETURN v_data ;
END f_datafact ;
/

----------------------------------------------------------
CREATE OR REPLACE FUNCTION f_pret (codpr_ produse.codpr%TYPE, 
	nrfact_ fact.nrfact%TYPE)
		RETURN produse.PretCurent%TYPE
IS
	v_pret	produse.PretCurent%TYPE ;
BEGIN
	SELECT PretPromotional INTO v_pret FROM promotii
	WHERE CodPr = codpr_ AND f_datafact (nrfact_) BETWEEN 
		DataInceputProm	AND NVL(DataFinalProm,SYSDATE) ;
	RETURN v_pret ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		SELECT PretCurent INTO v_pret FROM produse
			WHERE CodPr=codpr_ ;
		RETURN v_pret ;
END ;
/


-- modificam declansatorul BEFORE-INSERT-ROW in LINII_FACT
-- 	(versiunea anterioara era in Listing 9.6 (partea a II-a)
CREATE OR REPLACE TRIGGER trg_lf_ins0
	 BEFORE INSERT ON linii_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_liniifact := TRUE ;	
	:NEW.Linie := pac_vinzari.f_nrlinii (:NEW.NrFact) + 1 ;
	UPDATE fact SET NrLinii = NrLinii + 1
		WHERE NrFact = :NEW.NrFact ;
	:NEW.PretUnit := f_pret (:NEW.CodPr, :NEW.NrFact) ;
	pac_vinzari.v_trg_liniifact := FALSE ;	
END ;
/

---------------------------------------------
CREATE OR REPLACE TRIGGER trg_lf_ins
AFTER INSERT ON linii_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_liniifact := TRUE ;
	UPDATE fact SET
	  valtotala = NVL(valtotala,0) + 
		:NEW.cantitate *:NEW.pretunit * (1 +
	      	(SELECT ProcCurentTVA FROM produse WHERE codpr=:NEW.codpr)),
	  TVAfact = NVL(TVAfact,0) + :NEW.cantitate * :NEW.pretunit * 
     		(SELECT ProcCurentTVA FROM produse WHERE codpr=:NEW.codpr)
	WHERE nrfact=:NEW.nrfact ;
	pac_vinzari.v_trg_liniifact := FALSE ;
END ;


INSERT INTO linii_fact VALUES (10, 1, 4, 950, NULL) ;
INSERT INTO linii_fact VALUES (11, 2, 5, 580, NULL) ;
INSERT INTO linii_fact VALUES (11, 1, 3, 630, NULL) ;
INSERT INTO linii_fact VALUES (12, 1, 6, 790, NULL) ;
INSERT INTO linii_fact VALUES (12, 2, 2, 850, NULL) ;
INSERT INTO linii_fact VALUES (12, 3, 2, 950, NULL) ;
INSERT INTO linii_fact VALUES (13, 1, 1, 850, NULL) ;

COMMIT ;

-- @F:\Useri\Marin\ProiectareaBD2004\Cap10_Temporalitate\Listing_10_02_promotii.sql