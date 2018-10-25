CREATE OR REPLACE TRIGGER trg_exemplare_upd
 BEFORE UPDATE OF isbn ON exemplare
 FOR EACH ROW
BEGIN 
 IF f_NrExemplare (:NEW.isbn) > 3 THEN
	 RAISE_APPLICATION_ERROR (-20801, 
   'Nr. exemplarelor acestei carti creste peste 10 !') ;
 ELSE
		/* se scade cu 1 numarul exemplarelor pentru 
   vechiul ISBN (valoarea dinaintea modificarii) */
		UPDATE titluri SET NrExemplare = NrExemplare - 1	WHERE isbn = :OLD.isbn	;

 	/* se incrementeaza numarul exemplarelor pentru	ISBN-ul din linia inserata */
	 UPDATE titluri SET NrExemplare = NrExemplare + 1	WHERE isbn = :NEW.isbn ;
 END IF ;
END ;


