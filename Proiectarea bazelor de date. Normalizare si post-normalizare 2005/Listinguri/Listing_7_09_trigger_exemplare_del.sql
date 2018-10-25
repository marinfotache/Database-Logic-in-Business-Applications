CREATE OR REPLACE TRIGGER trg_exemplare_del
 BEFORE DELETE ON exemplare FOR EACH ROW
BEGIN 
		/* se scade cu 1 numarul exemplarelor pentru ISBN-ul sters */
		UPDATE titluri SET NrExemplare = NrExemplare - 1	WHERE isbn = :OLD.isbn	;

END ;


