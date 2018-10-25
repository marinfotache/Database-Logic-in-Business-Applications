-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_cineasti_upd
	AFTER UPDATE OF IdCineast ON cineasti FOR EACH ROW
DECLARE
	v_urmatorulid cineasti.IdCineast%TYPE ;
BEGIN
	SELECT last_number INTO v_urmatorulid 
	FROM user_sequences 
	WHERE sequence_name='SEQ_IDCINEAST' ;
	IF :NEW.IdCineast >= v_urmatorulid THEN 
		RAISE_APPLICATION_ERROR(-20779, 
			'Valoarea IdCineast depaseste valoarea curenta a secventei !');
	ELSE
		UPDATE distributie SET Actor=:NEW.IdCineast 
			WHERE Actor=:OLD.IdCineast ;
		UPDATE premii_interpretare SET Actor=:NEW.IdCineast 
			WHERE Actor=:OLD.IdCineast ;
		UPDATE producatori SET Producator=:NEW.IdCineast 
			WHERE Producator=:OLD.IdCineast ;
		UPDATE regizori SET Regizor=:NEW.IdCineast 
			WHERE Regizor=:OLD.IdCineast ;
		UPDATE scenaristi SET Scenarist=:NEW.IdCineast 
			WHERE Scenarist=:OLD.IdCineast ;
	END IF ;
END ;
/

-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_filme_upd
	AFTER UPDATE OF IdFilm ON filme FOR EACH ROW
DECLARE
	v_urmatorulid filme.IdFilm%TYPE ;
BEGIN
	SELECT last_number INTO v_urmatorulid 
	FROM user_sequences 
	WHERE sequence_name='SEQ_IDFILM' ;
	IF :NEW.IdFilm >= v_urmatorulid THEN 
		RAISE_APPLICATION_ERROR(-20778, 
			'Valoarea IdFilm depaseste valoarea curenta a secventei !');
	ELSE
		pac_centru.vp_trg_filme_upd := TRUE ;
		UPDATE distributie SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE distributie SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE premii_filme SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE premii_interpretare SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE producatori SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE regizori SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE scenaristi SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE filme_genuri SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE casete_filme SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		UPDATE aprecieri_filme SET IdFilm=:NEW.IdFilm
			WHERE IdFilm=:OLD.IdFilm ;
		pac_centru.vp_trg_filme_upd := FALSE ;
	END IF ;
END ;
/

-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_casete_upd
	AFTER UPDATE OF IdCaseta ON casete FOR EACH ROW
DECLARE
	v_urmatorulid casete.IdCaseta%TYPE ;
BEGIN
	SELECT last_number INTO v_urmatorulid 
	FROM user_sequences 
	WHERE sequence_name='SEQ_IDCASETA' ;
	IF :NEW.Idcaseta >= v_urmatorulid THEN 
		RAISE_APPLICATION_ERROR(-20778, 
			'Valoarea IdCaseta depaseste valoarea curenta a secventei !');
	ELSE
		pac_centru.vp_trg_casete_upd := TRUE ;
		UPDATE casete_filme SET IdCaseta=:NEW.IdCaseta
			WHERE Idcaseta=:OLD.Idcaseta ;
		UPDATE casete_imprumutate SET IdCaseta=:NEW.IdCaseta
			WHERE Idcaseta=:OLD.Idcaseta ;
		pac_centru.vp_trg_casete_upd := FALSE ;
	END IF ;
END ;
/

-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_clienti_upd
	AFTER UPDATE OF CNPClient ON clienti FOR EACH ROW
BEGIN
	UPDATE imprumuturi SET CNPClient=:NEW.CNPClient
		WHERE CNPClient=:OLD.CNPClient ;
	UPDATE aprecieri_filme SET CNPClient=:NEW.CNPClient
		WHERE CNPClient=:OLD.CNPClient ;	
END ;
/

-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_imprumuturi_upd
	AFTER UPDATE OF IdImpr ON imprumuturi FOR EACH ROW
DECLARE
	v_urmatorulid imprumuturi.IdImpr%TYPE ;
BEGIN
	SELECT last_number INTO v_urmatorulid 
	FROM user_sequences 
	WHERE sequence_name='SEQ_IDIMPR' ;
	IF :NEW.IdImpr >= v_urmatorulid THEN 
		RAISE_APPLICATION_ERROR(-20778, 
			'Valoarea IdImpr depaseste valoarea curenta a secventei !');
	ELSE
		UPDATE casete_imprumutate SET IdImpr=:NEW.IdImpr
			WHERE IdImpr=:OLD.IdImpr ;
	END IF ;
END ;
/



-- @F:\USERI\MARIN\PROIECTAREABD2004\CAP07_Surogate_Restrictii_Incluziuni\Listing_7_30_triggere_update_cascade.sql

