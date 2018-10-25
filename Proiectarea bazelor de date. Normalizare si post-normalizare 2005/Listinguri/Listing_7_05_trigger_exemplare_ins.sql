CREATE OR REPLACE TRIGGER trg_exemplare_ins
 BEFORE INSERT ON exemplare
 FOR EACH ROW
DECLARE 
 v_nrexemplare NUMBER(5) := 0 ;
BEGIN 
 SELECT COUNT(*) INTO v_nrexemplare
 FROM exemplare WHERE isbn = :NEW.isbn ;

 IF v_nrexemplare > 9 THEN 
	 RAISE_APPLICATION_ERROR (-20801, 'Nr. exemplarelor acestei carti creste peste 10 !') ;
 END IF ;
END ;

