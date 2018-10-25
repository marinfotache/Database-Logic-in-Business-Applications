--ALTER TABLE fact ADD (NrLinii NUMBER(2)) ;

-- ==== Pachetul PAC_VINZARI
---------------------------------------------
CREATE OR REPLACE PACKAGE pac_vinzari AS
	v_trg_liniifact BOOLEAN := FALSE ;
	v_trg_incas_fact BOOLEAN := FALSE ;
	FUNCTION f_nrlinii (nrfact_ fact.NrFact%TYPE) RETURN fact.NrLinii%TYPE ;
	v_nrfact fact.NrFact%TYPE ;
	v_liniestearsa linii_fact.Linie%TYPE ;
	v_trg_liniifact_del BOOLEAN := FALSE ;
END pac_vinzari ;
/
--------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_vinzari AS
	FUNCTION f_nrlinii (nrfact_ fact.NrFact%TYPE) RETURN fact.NrLinii%TYPE
IS
	v_nrlinii fact.NrLinii%TYPE ;
BEGIN
	SELECT NrLinii INTO v_nrlinii FROM fact	WHERE NrFact = nrfact_ ;
	RETURN v_nrlinii ;
END f_nrlinii ;
END pac_vinzari ;
/


-- ==== Declansatoarele de inserare si modificare pentru FACT
---------------------------------------------
CREATE OR REPLACE TRIGGER trg_fact_ins
	BEFORE INSERT ON fact FOR EACH ROW
BEGIN
	:NEW.ValTotala := 0 ;
	:NEW.TVAFact  := 0 ;
	:NEW.ValIncasata := 0 ;
	:NEW.NrLinii := 0 ;
END ;
/
---------------------------------------------
CREATE OR REPLACE TRIGGER trg_fact_upd2
	AFTER UPDATE OF ValTotala, TVAFact, ValIncasata, NrLinii
	ON fact FOR EACH ROW
BEGIN
	-- atribute modificate din LINII_FACT
	IF :NEW.ValTotala <> :OLD.ValTotala OR :NEW.TVAFact <> :OLD.TVAFact 
		OR :NEW.NrLinii <> :OLD.NrLinii THEN
		IF pac_vinzari.v_trg_liniifact = FALSE THEN
			RAISE_APPLICATION_ERROR(-20876, 
			'NrLinii, ValTotala si TVAFact nu pot fi modificate interactiv !');
		END IF ;
	END IF ;
	-- atribute modificate din INCAS_FACT
	IF :NEW.ValIncasata <> :OLD.ValIncasata THEN
		IF pac_vinzari.v_trg_incas_fact = FALSE THEN
			RAISE_APPLICATION_ERROR(-20876, 
			'ValIncasata nu poate fi modificata interactiv !');
		END IF ;
	END IF ;
END ;
/


-- == Declansatoarele tabelei LINII_FACT
---------------------------------------------
-- se pastreaza TRG_LF_INS

---------------------------------------------
-- nou declansator de inserare (BEFORE-ROW) 
CREATE OR REPLACE TRIGGER trg_lf_ins0
	 BEFORE INSERT ON linii_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_liniifact := TRUE ;	
	:NEW.Linie := pac_vinzari.f_nrlinii (:NEW.NrFact) + 1 ;
	UPDATE fact SET NrLinii = NrLinii + 1
		WHERE NrFact = :NEW.NrFact ;
	pac_vinzari.v_trg_liniifact := FALSE ;	
END ;
/
---------------------------------------------
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
		      (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)),
		TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
		     (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)
	WHERE nrfact=:OLD.nrfact ;
	pac_vinzari.v_trg_liniifact := FALSE ;	
END ;
/
---------------------------------------------
-- stergere in LINII_FACT - la nivel de COMANDA
CREATE OR REPLACE TRIGGER trg_lf_del2
	AFTER DELETE ON linii_fact 
BEGIN
	IF pac_vinzari.v_nrfact IS NULL OR pac_vinzari.v_liniestearsa IS NULL THEN
		-- nu s-a sters nici o linie 
		NULL ;
	ELSE
		pac_vinzari.v_trg_liniifact := TRUE ;	
		IF pac_vinzari.f_nrlinii(pac_vinzari.v_nrfact) = 
				pac_vinzari.v_liniestearsa THEN
			-- linia stearsa din factura este ultima
			NULL ;
		ELSE
			-- liniei sterse i se da un numar mai mare pentru a nu se viola cheia primara
			pac_vinzari.v_trg_liniifact_del := TRUE ;
			UPDATE linii_fact 
			SET linie =  pac_vinzari.f_nrlinii(pac_vinzari.v_nrfact) + 1
			WHERE NrFact = pac_vinzari.v_nrfact AND linie = pac_vinzari.v_liniestearsa ;

			-- se scade valoarea atributului LINIE pentru liniile ulterioare celei sterse
			UPDATE linii_fact 
			SET linie =  linie - 1
			WHERE NrFact = pac_vinzari.v_nrfact AND linie > pac_vinzari.v_liniestearsa ;
			pac_vinzari.v_trg_liniifact_del := FALSE ;
		END IF ;
		UPDATE fact 
		SET NrLinii =  NrLinii - 1
		WHERE NrFact = pac_vinzari.v_nrfact ;

		pac_vinzari.v_nrfact := NULL ;
		pac_vinzari.v_liniestearsa := NULL ;
		pac_vinzari.v_trg_liniifact := FALSE ;	
	END IF ;
END ;
/


---------------------------------------------
-- declansatorul de actualizare in LINII_FACT de tip BEFORE ROW
CREATE OR REPLACE TRIGGER trg_lf_upd
	BEFORE UPDATE ON linii_fact FOR EACH ROW
BEGIN
	IF :NEW.Linie <> :OLD.Linie AND pac_vinzari.v_trg_liniifact = FALSE THEN 	
		RAISE_APPLICATION_ERROR (-20870, 'Atributul Linie nu poate fi modificat direct !');
	END IF ;		

	IF pac_vinzari.v_trg_liniifact_del = FALSE THEN
		pac_vinzari.v_trg_liniifact := TRUE ;	
		IF :NEW.nrfact <> :OLD.nrfact THEN 	
			-- linia a fost trasferata in alta factura
			--		mai intii, se scade valoarea, TVA-ul si se renumeroteaza 
			--			liniile facturii din care "a plecat"
			pac_vinzari.v_nrfact := :OLD.NrFact ;
			pac_vinzari.v_liniestearsa := :OLD.Linie ;
			UPDATE fact SET
				NrLinii = NrLinii - 1,
				valtotala = valtotala - :OLD.cantitate * :OLD.pretunit * (1 +
				      (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)),
				TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
				     (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)
			WHERE nrfact=:OLD.nrfact ;

			-- 	restul face declansatorul UPD AFTER STATEMENT (trg_lf_upd2)
	
			--		apoi, se atribute numarul liniei facturii in care "a ajuns"
			--			si se actualizeaza valoarea si TVA-ul
			:NEW.Linie := pac_vinzari.f_nrlinii (:NEW.NrFact) + 1 ;
			UPDATE fact SET
  				NrLinii = NrLinii + 1,
				valtotala = valtotala + :NEW.cantitate *:NEW.pretunit * (1 +
				  (SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)),
		  		TVAfact = TVAfact + :NEW.cantitate * :NEW.pretunit * 
			  	(SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)
	  		WHERE nrfact=:NEW.nrfact ;

		ELSE 
			-- nu s-a modificat nici NrFact, nici Linie
			pac_vinzari.v_nrfact := NULL ;
			pac_vinzari.v_liniestearsa := NULL ;
 			UPDATE fact SET
				valtotala = valtotala - :OLD.cantitate *:OLD.pretunit * 
					(1 + (SELECT procTVA FROM produse 
						WHERE codpr=:OLD.codpr)) +
				       :NEW.cantitate *:NEW.pretunit * (1 +
    		 			(SELECT procTVA FROM produse 
						WHERE codpr=:NEW.codpr)),
				TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
					(SELECT procTVA FROM produse WHERE codpr=:OLD.codpr) 
			WHERE nrfact=:NEW.nrfact ;
		END IF ;
		pac_vinzari.v_trg_liniifact := FALSE ;	
	END IF ;

END ;
/


-----------------------------------------------------------------
-- declansatorul de actualizare in LINII_FACT de tip AFTER STATEMENT
CREATE OR REPLACE TRIGGER trg_lf_upd2 AFTER UPDATE ON linii_fact 
BEGIN
	IF pac_vinzari.v_trg_liniifact_del = FALSE THEN
		IF pac_vinzari.v_nrfact IS NULL OR pac_vinzari.v_liniestearsa IS NULL THEN
			-- nu s-a facut trasferul liniei in alta factura, deci stam linistiti !
			NULL ;
		ELSE
			pac_vinzari.v_trg_liniifact := TRUE ;	
			IF pac_vinzari.f_nrlinii(pac_vinzari.v_nrfact) + 1 = 
					pac_vinzari.v_liniestearsa THEN
				-- linia transferata din factura este ultima
				NULL ;
			ELSE
				-- se scade valoarea atributului LINIE pentru liniile ulterioare celei transferare
				pac_vinzari.v_trg_liniifact_del := TRUE ;
				UPDATE linii_fact 
				SET linie =  linie - 1
				WHERE NrFact = pac_vinzari.v_nrfact AND linie >= pac_vinzari.v_liniestearsa ;
				pac_vinzari.v_trg_liniifact_del := FALSE ;
			END IF ;
			pac_vinzari.v_nrfact := NULL ;
			pac_vinzari.v_liniestearsa := NULL ;
			pac_vinzari.v_trg_liniifact := FALSE ;	
		END IF ;
	END IF ;
END;
/


-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_06_un_alt_atribut_sintetic.sql

