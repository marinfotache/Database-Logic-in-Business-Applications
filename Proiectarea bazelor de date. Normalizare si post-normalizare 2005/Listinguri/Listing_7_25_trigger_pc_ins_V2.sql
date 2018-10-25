CREATE OR REPLACE TRIGGER trg_pc_ins
 AFTER INSERT ON plan_conturi FOR EACH ROW
DECLARE
	v_parinte VARCHAR(15) ;
	v_gata BOOLEAN := FALSE ;
	v_nr NUMBER(3) := 0 ;
BEGIN
	v_parinte := SUBSTR(:NEW.SimbolCont,1, LENGTH(:NEW.SimbolCont)-1);

	WHILE LENGTH(v_parinte) > 3 LOOP
		DELETE FROM conturi_elementare
		WHERE ContElementar = v_parinte ;
		
		IF SQL%ROWCOUNT > 0 THEN -- exista un parinte-frunza 
			IF f_apare (v_parinte) THEN
     RAISE_APPLICATION_ERROR(-20193, 'EROARE ! Nu se poate adauga contul dorit !!!') ; 
			END IF ;
		END IF;
		v_parinte := SUBSTR(v_parinte,1,LENGTH(v_parinte)-1);
	END LOOP ;
	-- noul cont este frunza !!!
	INSERT INTO conturi_elementare VALUES (:NEW.SimbolCont) ;
END ;

