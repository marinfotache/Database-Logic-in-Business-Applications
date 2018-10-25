--
DROP TABLE iesiri_intrari ;
DROP TABLE iesiri_materiale ;
DROP TABLE iesiri ;
DROP TABLE intrari_materiale ;
DROP TABLE intrari ;
DROP TABLE materiale ;

CREATE TABLE materiale (
	IdSortiment NUMBER(7) PRIMARY KEY,
	DenSortiment VARCHAR2(30) UNIQUE,
	UM VARCHAR2(10),
	ContClasa3 VARCHAR2(15),
	Grupa VARCHAR2(30),
	StocSiguranta NUMBER(10) DEFAULT 0 NOT NULL 
	) ;

CREATE TABLE intrari (
	IdIntrare NUMBER(10) NOT NULL PRIMARY KEY,
	DataOraIntrare DATE,
	IdSursaIntrare NUMBER(6)
	) ;

CREATE TABLE intrari_materiale (
	IdIntrare NUMBER(10) NOT NULL REFERENCES intrari (IdIntrare),
	IdSortiment NUMBER(7) NOT NULL REFERENCES materiale (IdSortiment),
	CantIntrata NUMBER(10),
	PretUnitIntrare NUMBER(10,2),
	CantRamasa NUMBER(10) DEFAULT 0,
	PRIMARY KEY (IdIntrare, IdSortiment)
	) ;

CREATE TABLE iesiri (
	IdIesire NUMBER(10) NOT NULL PRIMARY KEY,
	DataOraIesire DATE,
	IdDestinatie NUMBER(6)
	) ;

CREATE TABLE iesiri_materiale (
	IdIesire NUMBER(10) NOT NULL REFERENCES iesiri (IdIesire),
	IdSortiment NUMBER(7) NOT NULL REFERENCES materiale (IdSortiment),
	CantIesita NUMBER(10),
	ValIesire NUMBER(12,2),
	PRIMARY KEY (IdIesire, IdSortiment)
	) ;

CREATE TABLE iesiri_intrari (
	IdIesire NUMBER(10) NOT NULL REFERENCES iesiri (IdIesire),
	IdIntrare NUMBER(10) NOT NULL REFERENCES intrari (IdIntrare),
	IdSortiment NUMBER(7) NOT NULL REFERENCES materiale (IdSortiment),
	CantDescarcata NUMBER(10),
	PRIMARY KEY (IdIesire, IdIntrare, IdSortiment)
	) ;


INSERT INTO materiale VALUES (1111, 'Sortiment X', 'kg', '3011.01', 'Materiale constructie', 0) ;
INSERT INTO materiale VALUES (1112, 'Sortiment Y', 'kg', '3011.01', 'Materiale constructie', 0) ;

INSERT INTO intrari VALUES (12345, TO_DATE('02/02/2005 10:00:00', 'DD/MM/YYYY HH24:MI:SS'), 123) ;
INSERT INTO intrari VALUES (12346, TO_DATE('02/02/2005 10:10:00', 'DD/MM/YYYY HH24:MI:SS'), 124) ;
INSERT INTO intrari VALUES (12467, TO_DATE('03/02/2005 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), 123) ;

INSERT INTO intrari_materiale VALUES (12345, 1111, 5, 1000, 5) ;
INSERT INTO intrari_materiale VALUES (12345, 1112, 10, 1200, 10) ;
INSERT INTO intrari_materiale VALUES (12467, 1111, 3, 1100, 3) ;

INSERT INTO iesiri VALUES (14101, TO_DATE('03/02/2005 10:00:00', 'DD/MM/YYYY HH24:MI:SS'), 898) ;
INSERT INTO iesiri VALUES (14102, TO_DATE('03/02/2005 10:07:00', 'DD/MM/YYYY HH24:MI:SS'), 780) ;



CREATE OR REPLACE TRIGGER trg_iesiri_materiale 
	BEFORE INSERT ON iesiri_materiale FOR EACH ROW
DECLARE
	CURSOR c_stoc (idsortiment_ materiale.IdSortiment%TYPE) IS
		SELECT * FROM intrari_materiale 
		WHERE IdSortiment = idsortiment_ AND CantRamasa > 0
		ORDER BY IdIntrare ; 	
	v_cant_de_repartizat iesiri_materiale.CantIesita%TYPE ;
BEGIN
	v_cant_de_repartizat := :NEW.CantIesita ;
	:NEW.ValIesire := 0 ;
	FOR rec_stoc IN c_stoc (:NEW.IdSortiment) LOOP 
		IF rec_stoc.CantRamasa >= v_cant_de_repartizat THEN 
			INSERT INTO iesiri_intrari VALUES (:NEW.IdIesire, rec_stoc.IdIntrare,
				:NEW.IdSortiment, v_cant_de_repartizat) ;
			UPDATE intrari_materiale SET CantRamasa = CantRamasa - v_cant_de_repartizat
			WHERE IdIntrare=rec_Stoc.IdIntrare AND IdSortiment=rec_stoc.IdSortiment ;
			:NEW.ValIesire := :NEW.ValIesire + rec_stoc.PretUnitIntrare * v_cant_de_repartizat ;
			v_cant_de_repartizat := 0 ;
			EXIT ;
		ELSE
			INSERT INTO iesiri_intrari VALUES (:NEW.IdIesire, rec_stoc.IdIntrare,
				:NEW.IdSortiment, rec_stoc.CantRamasa) ;
			UPDATE intrari_materiale SET CantRamasa = 0
			WHERE IdIntrare=rec_Stoc.IdIntrare AND IdSortiment=rec_stoc.IdSortiment ;
			v_cant_de_repartizat := v_cant_de_repartizat - rec_stoc.CantRamasa ;
			:NEW.ValIesire := :NEW.ValIesire + rec_stoc.PretUnitIntrare * rec_stoc.CantRamasa ;
		END IF ;		
	END LOOP ;
	IF v_cant_de_repartizat > 0 THEN 
		RAISE_APPLICATION_ERROR (-20881, 'Stoc insuficient !') ;
	END IF ;
END ;
/


INSERT INTO iesiri_materiale VALUES (14101, 1111, 6, 0) ;


