-- rezolvarea problemei tabelei mutante

-- se sterge declansatorul anterior
--DROP TRIGGER trg_personal_compartiment ;
--/

-- declansatorul la nivel de linie preia noua valoare a COMPARTimentului
CREATE OR REPLACE TRIGGER trg_personal_compart_linie
 AFTER INSERT OR UPDATE OF compart ON personal 
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
BEGIN 
 dbms_output.put_line('trg_personal_compartiment_linie') ;
 pachet_salarizare.v_compart_nou := :NEW.compart ;
END ;
/

-- declansatorul la nivel de companda
CREATE OR REPLACE TRIGGER trg_personal_compart_comanda
 AFTER INSERT OR UPDATE OF compart ON personal 
 REFERENCING OLD AS OLD NEW AS NEW
DECLARE
 v_citi NUMBER(4) ; 
BEGIN 
 dbms_output.put_line('trg_personal_compartiment_comanda') ;
  SELECT COUNT(*) INTO v_citi FROM personal WHERE compart = pachet_salarizare.v_compart_nou ;
  IF v_citi > 10 THEN   
    RAISE_APPLICATION_ERROR (-20520, 'Un compartiment nu poate depasi 10 angajati');
  END IF ;  
END ;
/


