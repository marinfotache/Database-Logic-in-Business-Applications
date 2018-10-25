CREATE OR REPLACE PACKAGE pac_vinzari AS
	v_trg_liniifact BOOLEAN := FALSE ;
	v_trg_incas_fact BOOLEAN := FALSE ;
END pac_vinzari ;
/

---------------------------------------------
CREATE OR REPLACE TRIGGER trg_lf_ins
 AFTER INSERT ON linii_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_liniifact := TRUE ;
	UPDATE fact SET
	  valtotala = NVL(valtotala,0) + 
		:NEW.cantitate *:NEW.pretunit * (1 +
	      	(SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)),
	  TVAfact = NVL(TVAfact,0) + :NEW.cantitate * :NEW.pretunit * 
     		(SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)
	WHERE nrfact=:NEW.nrfact ;
	pac_vinzari.v_trg_liniifact := FALSE ;
END ;

/

CREATE OR REPLACE TRIGGER trg_if_ins
  AFTER INSERT ON incas_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_incas_fact := TRUE ;
	UPDATE fact 
	SET ValIncasata = NVL(ValIncasata,0) + :NEW.transa
	WHERE nrfact=:NEW.nrfact ;
	pac_vinzari.v_trg_incas_fact := FALSE ;
END ;
/


-- actualizare in LINII_FACT 
CREATE OR REPLACE TRIGGER trg_lf_upd
	AFTER UPDATE ON linii_fact FOR EACH ROW
BEGIN
	IF :NEW.nrfact <> :OLD.nrfact THEN -- trebuie scazut de la vecheia factura
		pac_vinzari.v_trg_liniifact := TRUE ;
		UPDATE fact SET                  -- si adaugat la noua
			valtotala = valtotala - :OLD.cantitate *:OLD.pretunit * (1 +
			      (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)),
				TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
			       (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)
		WHERE nrfact=:NEW.nrfact ;

		UPDATE fact SET
		  valtotala = valtotala + :NEW.cantitate *:NEW.pretunit * (1 +
			  (SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)),
  		TVAfact = TVAfact + :NEW.cantitate * :NEW.pretunit * 
		  	(SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)
  		WHERE nrfact=:NEW.nrfact ;
		pac_vinzari.v_trg_liniifact := FALSE ;
	ELSE  -- nu s-a schimbat numarul facturii
 		pac_vinzari.v_trg_liniifact := TRUE ;
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
		pac_vinzari.v_trg_liniifact := FALSE ;
 	END IF ;
END ;
/

-- stergere in LINII_FACT 
CREATE OR REPLACE TRIGGER trg_lf_del
	BEFORE DELETE ON linii_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_liniifact := TRUE ;	
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


-- actualizare in INCAS_FACT
CREATE OR REPLACE TRIGGER trg_if_upd
	AFTER UPDATE ON Incas_fact FOR EACH ROW
BEGIN
	IF :NEW.nrfact <> :OLD.nrfact THEN -- trebuie scazut de la vecheia factura
		pac_vinzari.v_trg_incas_fact := TRUE ;
		UPDATE fact SET                  -- si adaugat la noua 
		     ValIncasata = ValIncasata - :OLD.transa
		WHERE nrfact=:OLD.nrfact ;

		UPDATE fact SET ValIncasata = ValIncasata + :NEW.transa
		WHERE nrfact=:NEW.nrfact ;
		pac_vinzari.v_trg_incas_fact := FALSE ;
	ELSE
		pac_vinzari.v_trg_incas_fact := TRUE ;
		UPDATE fact SET ValIncasata = ValIncasata - 
			:OLD.transa - :NEW.transa
		WHERE nrfact=:NEW.nrfact ;
		pac_vinzari.v_trg_incas_fact := FALSE ;
	END IF;
END ;
/

-- stergere in INCAS_FACT
CREATE OR REPLACE TRIGGER trg_if_del
	BEFORE DELETE ON Incas_fact FOR EACH ROW
BEGIN
	pac_vinzari.v_trg_incas_fact := TRUE ;
	UPDATE fact 
	SET ValIncasata = ValIncasata - :OLD.transa
	WHERE nrfact=:OLD.nrfact ;
	pac_vinzari.v_trg_incas_fact := FALSE ;
END ;
/


CREATE OR REPLACE TRIGGER trg_fact_ins
	BEFORE INSERT ON fact FOR EACH ROW
BEGIN
	:NEW.ValTotala := 0 ;
	:NEW.TVAFact  := 0 ;
	:NEW.ValIncasata := 0 ;
END ;
/

CREATE OR REPLACE TRIGGER trg_fact_upd2
	AFTER UPDATE OF ValTotala, TVAFact, ValIncasata 
	ON fact FOR EACH ROW
BEGIN
	IF :NEW.ValTotala <> :OLD.ValTotala OR
			:NEW.TVAFact <> :OLD.TVAFact THEN
		IF pac_vinzari.v_trg_liniifact = FALSE THEN
			RAISE_APPLICATION_ERROR(-20876, 
			'ValTotala si TVAFact nu pot fi modificate interactiv !');
		END IF ;
	END IF ;

	IF :NEW.ValIncasata <> :OLD.ValIncasata THEN
		IF pac_vinzari.v_trg_incas_fact = FALSE THEN
			RAISE_APPLICATION_ERROR(-20876, 
			'ValIncasata nu poate fi modificata interactiv !');
		END IF ;
	END IF ;
		

END ;
/


-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_04_blocarea_atributelor_sintetice.sql

