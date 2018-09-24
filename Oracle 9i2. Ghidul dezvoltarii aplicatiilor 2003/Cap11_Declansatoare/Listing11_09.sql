-- declansator pentru verificarea numarului maxim de angajati intr-un compartiment
CREATE OR REPLACE TRIGGER trg_personal_compartiment
 AFTER INSERT OR UPDATE OF compart ON personal 
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
DECLARE
 v_citi NUMBER(4) ; 
BEGIN 
 dbms_output.put_line('trg_personal_compartiment') ;
  SELECT COUNT(*) INTO v_citi FROM personal WHERE compart = :NEW.compart ;
  IF v_citi > 10 THEN   
    RAISE_APPLICATION_ERROR (-20520, 'Un compartiment nu poate depasi 10 angajati');
  END IF ;  
END ;
/
