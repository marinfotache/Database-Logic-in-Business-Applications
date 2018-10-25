-- autoincrementarea atributulUi CINEASTI.IdCineast
DROP SEQUENCE seq_IdCineast ;
CREATE SEQUENCE seq_IdCineast START WITH 1 
	MINVALUE 1 MAXVALUE 999999
	NOCYCLE NOCACHE ORDER ;

CREATE OR REPLACE TRIGGER trg_cineasti_ins
	BEFORE INSERT ON cineasti FOR EACH ROW
BEGIN 
	SELECT seq_IdCineast.NextVal INTO :NEW.IdCineast FROM dual ;
END;
/


-- autoincrementarea atributulUi FILME.IdFilm
DROP SEQUENCE seq_IdFilm ;
CREATE SEQUENCE seq_IdFilm START WITH 1 
	MINVALUE 1 MAXVALUE 9999999999
	NOCYCLE NOCACHE ORDER ;

CREATE OR REPLACE TRIGGER trg_filme_ins
	BEFORE INSERT ON filme FOR EACH ROW
BEGIN 
	SELECT seq_IdFilm.NextVal INTO :NEW.IdFilm FROM dual ;
END;
/

-- autoincrementarea atributulUi CASETE.IdCaseta
DROP SEQUENCE seq_IdCaseta ;
CREATE SEQUENCE seq_IdCaseta START WITH 10000000001 
	MINVALUE 1 MAXVALUE 999999999999
	NOCYCLE NOCACHE ORDER ;

CREATE OR REPLACE TRIGGER trg_casete_ins
	BEFORE INSERT ON casete FOR EACH ROW
BEGIN 
	SELECT seq_IdCaseta.NextVal INTO :NEW.IdCaseta FROM dual ;
END;
/

-- autoincrementarea atributulUi IMPRUMUTURI.IdImpr
DROP SEQUENCE seq_IdImpr ;
CREATE SEQUENCE seq_IdImpr START WITH 1000000000001 
	MINVALUE 1 MAXVALUE 99999999999999
	NOCYCLE NOCACHE ORDER ;

CREATE OR REPLACE TRIGGER trg_imprumuturi_ins
	BEFORE INSERT ON imprumuturi FOR EACH ROW
BEGIN 
	SELECT seq_IdImpr.NextVal INTO :NEW.IdImpr FROM dual ;
END;
/




-- @F:\USERI\MARIN\PROIECTAREABD2004\CAP07_Surogate_Restrictii_Incluziuni\Listing_7_28_secvente_triggere_chei_surogat.sql

