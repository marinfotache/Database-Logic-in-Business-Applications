DROP TRIGGER trg_personal_compart_comanda ;
/

-- declansatorul BEFORE STATEMENT goleste vectorul 
CREATE OR REPLACE TRIGGER trg_personal_compart_bef_stat
 BEFORE INSERT OR UPDATE OF compart ON personal 
 REFERENCING OLD AS OLD NEW AS NEW
BEGIN 
 pachet_salarizare.v_compart_noi.DELETE ;
END ;
/

-- declansatorul la nivel de linie preia toate noile valori ale COMPARTimentului
CREATE OR REPLACE TRIGGER trg_personal_compart_linie
 AFTER INSERT OR UPDATE OF compart ON personal 
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
BEGIN 
 pachet_salarizare.v_compart_noi (pachet_salarizare.v_compart_noi.COUNT + 1) := :NEW.compart ;
END ;
/

-- declansatorul AFTER STATEMENT
CREATE OR REPLACE TRIGGER trg_personal_compart_comanda
 AFTER INSERT OR UPDATE OF compart ON personal 
 REFERENCING OLD AS OLD NEW AS NEW
DECLARE
 v_citi NUMBER(4) ; 
BEGIN 
  FOR i IN 1..pachet_salarizare.v_compart_noi.COUNT LOOP 
     SELECT COUNT(*) INTO v_citi FROM personal 
     WHERE compart = pachet_salarizare.v_compart_noi (i) ;
    IF v_citi > 10 THEN   
      RAISE_APPLICATION_ERROR (-20520, 'Compartimentul ' || ' depaseste 10 angajati !!!');
     END IF ;  
  END LOOP ;
END ;
/


