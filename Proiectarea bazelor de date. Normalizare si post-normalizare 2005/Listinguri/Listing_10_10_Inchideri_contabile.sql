ALTER TABLE fact ADD definitivata CHAR(1) DEFAULT 'N'
	NOT NULL CHECK (definitivata IN ('D','N')) ;

CREATE OR REPLACE TRIGGER trg_fact_del
	BEFORE DELETE ON fact FOR EACH ROW
BEGIN
	IF :OLD.definitivata='D' THEN
		RAISE_APPLICATION_ERROR(-20349, 
			'Nu puteti sterge o factura definitivata !');
	END IF ;
END ;
/
