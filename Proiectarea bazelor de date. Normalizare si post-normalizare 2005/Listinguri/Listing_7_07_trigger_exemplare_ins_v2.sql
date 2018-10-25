CREATE OR REPLACE TRIGGER trg_exemplare_ins
 BEFORE INSERT ON exemplare
 FOR EACH ROW
BEGIN 
IF f_NrExemplare (:NEW.isbn) > 9 THEN
	 RAISE_APPLICATION_ERROR (-20801, 
   'Nr. exemplarelor acestei carti creste peste 10 !') ;
ELSE
	/* se incrementeaza numarul exemplarelor pentru	ISBN-ul din linia inserata */
	UPDATE titluri SET NrExemplare = NrExemplare + 1 	WHERE isbn = :NEW.isbn ;
END IF ;

END ;



