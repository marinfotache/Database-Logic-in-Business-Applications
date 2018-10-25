CREATE OR REPLACE TRIGGER trg_exemplare_ins
 BEFORE INSERT ON exemplare FOR EACH ROW
BEGIN 
		/* se incrementeaza numarul exemplarelor pentru ISBN-ul din linia inserata */
 UPDATE titluri SET NrExemplare = NrExemplare + 1
	 	WHERE isbn = :NEW.isbn ;
END ;
/

CREATE OR REPLACE TRIGGER trg_exemplare_upd
	BEFORE UPDATE OF isbn ON exemplare	FOR EACH ROW
BEGIN 
		/* se scade cu 1 numarul exemplarelor pentru 
			vechiul ISBN (valoarea dinaintea modificarii) */
		UPDATE titluri SET NrExemplare = NrExemplare - 1	WHERE isbn = :OLD.isbn	;

	 	/* se incrementeaza numarul exemplarelor pentru	ISBN-ul din linia inserata */
		UPDATE titluri SET NrExemplare = NrExemplare + 1	WHERE isbn = :NEW.isbn ;
END ;
/

CREATE OR REPLACE TRIGGER trg_exemplare_del
	BEFORE DELETE ON exemplare FOR EACH ROW
BEGIN 
	/* se scade cu 1 numarul exemplarelor pentru ISBN-ul sters */
	UPDATE titluri SET NrExemplare = NrExemplare - 1	WHERE isbn = :OLD.isbn	;
END ;

