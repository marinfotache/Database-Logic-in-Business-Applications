CREATE OR REPLACE TRIGGER trg_pc_ins
 BEFORE INSERT ON plan_conturi FOR EACH ROW
DECLARE
	v_parinte VARCHAR(15) ;
	v_gata BOOLEAN := FALSE ;
	v_nr NUMBER(3) := 0 ;
BEGIN
	IF LENGTH(:NEW.SimbolCont) > 3 THEN
   --contul este sintetic de ordin 2 sau analitic

    -- se încearca gasirea parintelor, taind, pe rând câte un caracter
  		v_parinte := :NEW.SimbolCont ;
		  WHILE v_gata=FALSE AND LENGTH(v_parinte)>3 LOOP 
    			v_parinte := SUBSTR(v_parinte,1, LENGTH(v_parinte) - 1);
    			SELECT COUNT(*) INTO v_nr FROM plan_conturi
			    WHERE SimbolCont=v_parinte ;
    			IF NVL(v_nr,0) = 1 THEN
				     v_gata := TRUE ;
     				EXIT ;
    			END IF ;
    END LOOP ;
  		IF v_gata THEN
		   	-- exista un parinte pentru noul cont
   			-- testam daca parintele este frunza
	  		 SELECT COUNT(ContDebitor)+ COUNT(ContCreditor)
 		  	INTO v_nr FROM detalii_operatiuni
	 		  WHERE ContDebitor=v_parinte OR ContCreditor=v_parinte ;
   			IF NVL(v_nr,0) >= 1 THEN
        RAISE_APPLICATION_ERROR (-20196, 'EROARE ! Contul parinte apare deja in operatiuni,'|| 
           ' iar noul cont nu mai poate fi adaugat !!!') ;
			   END IF ;
   			UPDATE plan_conturi SET EsteFrunza = 'N' WHERE SimbolCont = v_parinte ;
  	END IF;
	END IF ;
	:NEW.EsteFrunza := 'D' ;
END ;

