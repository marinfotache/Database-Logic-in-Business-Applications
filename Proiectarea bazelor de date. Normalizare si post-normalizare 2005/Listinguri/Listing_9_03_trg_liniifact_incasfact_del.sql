-- actualizare in LINII_FACT 
CREATE OR REPLACE TRIGGER trg_lf_upd
 AFTER UPDATE ON linii_fact FOR EACH ROW
BEGIN
 IF :NEW.nrfact <> :OLD.nrfact THEN -- trebuie scazut de la vecheia factura
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

 ELSE  -- nu s-a schimbat numarul facturii
 
  	UPDATE fact SET
    valtotala = valtotala - :OLD.cantitate *:OLD.pretunit * (1 +
       (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)) +
       :NEW.cantitate *:NEW.pretunit * (1 +
    		 	(SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)),
    TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
      (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr) 
   WHERE nrfact=:NEW.nrfact ;
  END IF ;
END ;
/

-- stergere in LINII_FACT 
CREATE OR REPLACE TRIGGER trg_lf_del
 BEFORE DELETE ON linii_fact FOR EACH ROW
BEGIN
	UPDATE fact SET
  valtotala = valtotala - :OLD.cantitate *:OLD.pretunit * (1 +
      (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)),
  TVAfact = TVAfact - :OLD.cantitate * :OLD.pretunit * 
     (SELECT procTVA FROM produse WHERE codpr=:OLD.codpr)
 WHERE nrfact=:OLD.nrfact ;
END ;
/


-- actualizare in INCAS_FACT
CREATE OR REPLACE TRIGGER trg_if_upd
  AFTER UPDATE ON Incas_fact FOR EACH ROW
BEGIN
 IF :NEW.nrfact <> :OLD.nrfact THEN -- trebuie scazut de la vecheia factura
   UPDATE fact SET                  -- si adaugat la noua 
     ValIncasata = ValIncasata - :OLD.transa
   WHERE nrfact=:OLD.nrfact ;

   UPDATE fact SET ValIncasata = ValIncasata + :NEW.transa
   WHERE nrfact=:NEW.nrfact ;

 ELSE
   UPDATE fact SET ValIncasata = ValIncasata - :OLD.transa - :NEW.transa
   WHERE nrfact=:NEW.nrfact ;
 END IF;
END ;
/

-- stergere in INCAS_FACT
CREATE OR REPLACE TRIGGER trg_if_del
  BEFORE DELETE ON Incas_fact FOR EACH ROW
BEGIN
	UPDATE fact 
	SET ValIncasata = ValIncasata - :OLD.transa
	WHERE nrfact=:OLD.nrfact ;
END ;
/


-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_03_trg_liniifact_incasfact_del.sql

