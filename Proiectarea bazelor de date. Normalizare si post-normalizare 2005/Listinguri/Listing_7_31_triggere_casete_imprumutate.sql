-------------------------------------------------------------------
-- pachetul cu variabile publice se intoarce
CREATE OR REPLACE PACKAGE pac_centru AS
	-- variabila pentru semnalizarea locului de actualizare
	-- 	in CASETE_FILME
	vp_trg_casete_filme_del BOOLEAN := FALSE ;
	vp_idcaseta casete.IdCaseta%TYPE ;
	vp_filmnr casete_filme.FilmNr%TYPE ;

	-- variabile pentru semnalizarea modificarilor in cascada
	vp_trg_casete_upd BOOLEAN := FALSE ;
	vp_trg_filme_upd BOOLEAN := FALSE ;

	-- functii
	FUNCTION f_nrcaseteinchiriate1 (cnpclient_ clienti.CNPClient%TYPE)
		RETURN clienti.NrCaseteImprumutate%TYPE;
	FUNCTION f_nrcaseteinchiriate2 (idimpr_ imprumuturi.IdImpr%TYPE)
		RETURN clienti.NrCaseteImprumutate%TYPE;
	FUNCTION f_cnpclient (idimpr_ imprumuturi.IdImpr%TYPE)
		RETURN clienti.CNPClient%TYPE;
	FUNCTION f_chiriezi (idcaseta_ casete.Idcaseta%TYPE) 
		RETURN NUMBER ;	
	FUNCTION f_pretcaseta (idcaseta_ casete.IdCaseta%TYPE) 
		RETURN casete.PretCumparare%TYPE ;
	FUNCTION f_dataimpr (idimpr_ casete_imprumutate.IdImpr%TYPE) 
		RETURN imprumuturi.DataOraImpr%TYPE ;
	FUNCTION f_casetadisponibila (idcaseta_ casete.IdCaseta%TYPE) 
		RETURN BOOLEAN ;

END pac_centru ;
/
-------------------------------------------------
-- corpul pachetului
CREATE OR REPLACE PACKAGE BODY pac_centru AS
	FUNCTION f_nrcaseteinchiriate1 (cnpclient_ clienti.CNPClient%TYPE)
		RETURN clienti.NrCaseteImprumutate%TYPE
	IS
		V_nrci clienti.NrCaseteImprumutate%TYPE ;
	BEGIN
		SELECT NrCaseteImprumutate INTO v_nrci
		FROM clienti 
		WHERE CNPClient = cnpclient_ ;
		RETURN v_nrci ;		
	END f_nrcaseteinchiriate1 ;
	--------------------------
	FUNCTION f_nrcaseteinchiriate2 (idimpr_ imprumuturi.IdImpr%TYPE)
		RETURN clienti.NrCaseteImprumutate%TYPE
	IS
		V_nrci clienti.NrCaseteImprumutate%TYPE ;
	BEGIN
		SELECT NrCaseteImprumutate INTO v_nrci
		FROM clienti 
		WHERE CNPClient = f_cnpclient(idimpr_) ;
		RETURN v_nrci ;
	END f_nrcaseteinchiriate2  ;
	---------------------------
	FUNCTION f_cnpclient (idimpr_ imprumuturi.IdImpr%TYPE)
		RETURN clienti.CNPClient%TYPE
	IS
		v_cnpclient clienti.CNPClient%TYPE ;
	BEGIN
		SELECT CNPClient INTO v_cnpclient
		FROM imprumuturi 
		WHERE IdImpr = idimpr_ ;
		RETURN v_cnpclient ;
	END f_cnpclient ;
	---------------------------
	FUNCTION f_chiriezi (idcaseta_ casete.Idcaseta%TYPE) 
		RETURN NUMBER
	IS
		v_anprodcaseta casete.AnProdCaseta%TYPE ;
	BEGIN
		SELECT NVL(AnProdCaseta, EXTRACT (YEAR FROM SYSDATE))
		INTO v_anprodcaseta 
		FROM casete WHERE Idcaseta=idcaseta_ ;
		CASE 
		WHEN EXTRACT (YEAR FROM SYSDATE) - v_anprodcaseta
				BETWEEN 0 AND 1 THEN 
			RETURN 50000 ;
		WHEN EXTRACT (YEAR FROM SYSDATE) - v_anprodcaseta
				BETWEEN 2 AND 3 THEN
			RETURN 40000  ;
		ELSE
			RETURN 30000 ;
		END CASE ;		
	END f_chiriezi ;
	---------------------------
	FUNCTION f_pretcaseta (idcaseta_ casete.IdCaseta%TYPE) 
		RETURN casete.PretCumparare%TYPE 
	IS
		v_pret casete.PretCumparare%TYPE ;
	BEGIN
		SELECT PretCumparare INTO v_pret FROM casete
		WHERE Idcaseta=idcaseta_ ;
		RETURN v_pret ;
	END f_pretcaseta ;
	---------------------------
	FUNCTION f_dataimpr (idimpr_ casete_imprumutate.IdImpr%TYPE) 
		RETURN imprumuturi.DataOraImpr%TYPE 
	IS
		v_data imprumuturi.DataOraImpr%TYPE ;
	BEGIN
		SELECT DataOraImpr INTO v_data
		FROM imprumuturi WHERE IdImpr = idimpr_ ;
		RETURN v_data ;
	END f_dataimpr ;
	----------------------------
	FUNCTION f_casetadisponibila (idcaseta_ casete.IdCaseta%TYPE) 
		RETURN BOOLEAN 
	IS
		v_disponibilitate CHAR(1);
	BEGIN
		SELECT Disponibilitate INTO v_disponibilitate
		FROM casete WHERE IdCaseta=idcaseta_ ;
		IF v_disponibilitate='D' THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE ;
		END IF ;	
	END f_casetadisponibila ;

END pac_centru ;
/

-------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_casete_imprumutate_ins
	BEFORE INSERT ON casete_imprumutate FOR EACH ROW

DECLARE
	v_rest NUMBER(2) ; -- restul impartirii la 11 (pt. caseta 
			    --		inchiriata gratuit)
BEGIN
	-- se inregistreaza imprumutul unei casete

	-- se creste numarul casetelor imprumutate clientului respectiv
	UPDATE clienti 
	SET NrCaseteImprumutate = NrCaseteImprumutate + 1
	WHERE CNPClient = pac_centru.f_cnpclient(:NEW.IdImpr) ;

	v_rest := MOD(pac_centru.f_nrcaseteinchiriate2(:NEW.IdImpr),11) ;

	IF v_rest = 0 THEN
		:NEW.Gratuita := 'D' ;
	ELSE
		:NEW.Gratuita := 'N' ;	
		UPDATE imprumuturi SET ValoareInchir = ValoareInchir +
			pac_centru.f_chiriezi(:NEW.IdCaseta)
		WHERE IdImpr = :NEW.IdImpr ;	
	END IF ;

	IF :NEW.DataOraRestituirii IS NULL THEN  
		-- se verifica disponibilitatea casetei
		IF pac_centru.f_casetadisponibila(:NEW.IdCaseta) = FALSE THEN 
			RAISE_APPLICATION_ERROR(-20678, 'Caseta indisponibila') ;
		END IF ;

		-- caseta se declara indisponibila (pina la returnare)
		UPDATE casete SET Disponibilitate='N'
			WHERE IdCaseta = :NEW.IdCaseta ;
		:NEW.penalizare := 0 ;
	ELSE
		-- caseta e deja returnata (se opereaza simultan
		-- 	inchirierea si returnarea)
		UPDATE casete SET Disponibilitate='D'
			WHERE IdCaseta = :NEW.IdCaseta ;

		-- se incrementeaza numarul casetelor retrnate
		-- 	de clientul respectiv
		UPDATE clienti 
		SET NrCaseteRestituite = NrCaseteRestituite + 1
		WHERE CNPClient IN 
			(SELECT CNPClient FROM imprumuturi
	 		WHERE IdImpr=:NEW.IdImpr) ;

		-- se verifica daca sunt intirzieri la returnare (mai mult de 2 zile)
		IF :NEW.DataOraRestituirii - pac_centru.f_dataimpr (:NEW.IdImpr) > 2 THEN 
			:NEW.penalizare := 0.75 * pac_centru.f_chiriezi(:NEW.IdCaseta) *
			(:NEW.DataOraRestituirii - pac_centru.f_dataimpr (:NEW.IdImpr) - 2)  ;
		ELSE
			:NEW.penalizare := 0 ;
		END IF ;		
	END IF ;

	IF :NEW.StareLaRestituire IN ('Pierduta', 'Distrusa') THEN
		UPDATE casete 
		SET StareCaseta = :NEW.StareLaRestituire 
		WHERE IdCaseta=:NEW.Idcaseta ;
		:NEW.Penalizare := :NEW.Penalizare + 
			2 * pac_centru.f_pretcaseta(:NEW.IdCaseta) ;
	END IF ;

END ;



-- @F:\USERI\MARIN\PROIECTAREABD2004\CAP07_Surogate_Restrictii_Incluziuni\Listing_7_31_triggere_casete_imprumutate.sql

