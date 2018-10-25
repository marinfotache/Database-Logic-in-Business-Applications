ALTER TABLE fact ADD ValTotala NUMBER (15) ;
ALTER TABLE fact ADD TVAFact NUMBER (15) ;
ALTER TABLE fact ADD ValIncasata NUMBER (15) ;

CREATE OR REPLACE TRIGGER trg_lf_ins
 AFTER INSERT ON linii_fact FOR EACH ROW
BEGIN
	UPDATE fact SET
  valtotala = NVL(valtotala,0) + :NEW.cantitate *:NEW.pretunit * (1 +
      (SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)),
  TVAfact = NVL(TVAfact,0) + :NEW.cantitate * :NEW.pretunit * 
     (SELECT procTVA FROM produse WHERE codpr=:NEW.codpr)
 WHERE nrfact=:NEW.nrfact ;
END ;
/

CREATE OR REPLACE TRIGGER trg_if_ins
  AFTER INSERT ON Incas_fact FOR EACH ROW
BEGIN
	UPDATE fact 
 SET ValIncasata = NVL(ValIncasata,0) + :NEW.transa
 WHERE nrfact=:NEW.nrfact ;
END ;
/


-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_02_trg_liniifact_incasfact_ins.sql