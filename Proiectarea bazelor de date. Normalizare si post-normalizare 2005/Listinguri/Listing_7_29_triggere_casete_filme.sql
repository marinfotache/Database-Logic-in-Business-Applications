-------------------------------------------------------------------
-- declansatorul de inserare
CREATE OR REPLACE TRIGGER trg_casete_filme_ins
	BEFORE INSERT ON casete_filme FOR EACH ROW
DECLARE
	v_filmnr casete_filme.FilmNr%TYPE ;
BEGIN
	SELECT MAX(FilmNr) INTO v_filmnr FROM casete_filme
	WHERE IdCaseta = :NEW.IdCaseta ;

	:NEW.FilmNr := NVL(v_filmnr,0) + 1 ;
END ;
/


-------------------------------------------------------------------
-- pachetul cu variabile publice 
CREATE OR REPLACE PACKAGE pac_centru AS
	-- variabila pentru semnalizarea locului de actualizare
	-- 	in CASETE_FILME
	vp_trg_casete_filme_del BOOLEAN := FALSE ;
	vp_idcaseta casete.IdCaseta%TYPE ;
	vp_filmnr casete_filme.FilmNr%TYPE ;

	-- variabile pentru semnalizarea modificarilor in cascada
	vp_trg_casete_upd BOOLEAN := FALSE ;
	vp_trg_filme_upd BOOLEAN := FALSE ;
	
END pac_centru ;
/


-------------------------------------------------------------------
-- declansator de stergere LA NIVEL DE LINIE
CREATE OR REPLACE TRIGGER trg_casete_filme_del_after_row
	AFTER DELETE ON casete_filme FOR EACH ROW
DECLARE
	v_filmnrcrt casete_filme.FilmNr%TYPE ;
BEGIN
	pac_centru.vp_trg_casete_filme_del := TRUE ;
	pac_centru.vp_idcaseta := :OLD.IdCaseta ;
	pac_centru.vp_filmnr := :OLD.FilmNr ;
	pac_centru.vp_trg_casete_filme_del := TRUE ;
END;
/


-- declasatorul de stergere LA NIVEL DE COMANDA 
CREATE OR REPLACE TRIGGER trg_casete_filme_del_stat
	AFTER DELETE ON casete_filme
DECLARE
	v_filmcrt casete_filme.FilmNr%TYPE ;
	
	CURSOR c_casete_filme (idcaseta_ casete.IdCaseta%TYPE, 
				filmcrt_ casete_filme.FilmNr%TYPE) 
		IS SELECT * FROM casete_filme
		 WHERE IdCaseta = idcaseta_ AND FilmNr >= filmcrt_
			ORDER BY FilmNr ;
BEGIN
	pac_centru.vp_trg_casete_filme_del := TRUE ;
	v_filmcrt := pac_centru.vp_filmnr ;	

	FOR rec_casete_filme IN c_casete_filme (pac_centru.vp_idcaseta,
			pac_centru.vp_filmnr) LOOP
		IF rec_casete_filme.FilmNr = v_filmcrt THEN
			UPDATE casete_filme 
			SET FilmNr = 29
			WHERE IdCaseta=rec_casete_filme.IdCaseta AND
				FilmNr=rec_casete_filme.FilmNr ;
		ELSE
			UPDATE casete_filme 
			SET FilmNr = v_filmcrt
			WHERE IdCaseta = rec_casete_filme.IdCaseta AND
				FilmNr=rec_casete_filme.FilmNr ;
			v_filmcrt := v_filmcrt + 1 ;
		END IF ;
	END LOOP;

	pac_centru.vp_trg_casete_filme_del := FALSE ;
END;
/


-------------------------------------------------------------------	
-- declansator de modificare 
CREATE OR REPLACE TRIGGER trg_casete_filme_upd
	BEFORE UPDATE ON casete_filme FOR EACH ROW
DECLARE
	v_filmnrcrt casete_filme.FilmNr%TYPE ;
BEGIN
	IF :NEW.IdCaseta <> :OLD.IdCaseta AND pac_centru.vp_trg_casete_upd = FALSE THEN 
		RAISE_APPLICATION_ERROR(-20789, 'Nu puteti modifica interactiv IdCaseta !');
	END IF;
	IF :NEW.IdFilm <> :OLD.IdFilm AND pac_centru.vp_trg_filme_upd = FALSE THEN 
		RAISE_APPLICATION_ERROR(-20788, 'Nu puteti modifica interactiv IdFilm !');
	END IF;
	IF :OLD.FilmNr <> :NEW.FilmNr AND pac_centru.vp_trg_casete_filme_del = FALSE THEN
		RAISE_APPLICATION_ERROR(-20787, 'Nu puteti modifica interactiv FilmNr !');
	END IF;
END;
/


-- @F:\USERI\MARIN\PROIECTAREABD2004\CAP07_Surogate_Restrictii_Incluziuni\Listing_7_29_triggere_casete_filme.sql

