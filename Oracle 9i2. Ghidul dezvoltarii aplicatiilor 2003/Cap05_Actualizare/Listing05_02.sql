DELETE FROM personal ;

DROP SEQUENCE seq_marca ;

CREATE SEQUENCE seq_marca INCREMENT BY 1 
  MINVALUE 101 MAXVALUE 5555 NOCYCLE NOCACHE ORDER ;

INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 1', 'IT', 
 DATE'1980-10-12',56000, 55000, 'N') ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 2', 'CONTA',
 DATE'1978-11-12',57500, 56000, 'N') ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 3', 'IT', 
 DATE'1976-07-02',67500, 66000, 'N' ) ;
INSERT INTO personal (marca, numepren, datasv) VALUES (seq_marca.NextVal, 'Angajat 4', 
 DATE'1982-01-05') ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 5', 'IT', 
 DATE'1977-11-12',62500, 62000, 'N' ) ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 6', 'CONTA', 
 DATE'1985-04-11',71500, 70000, 'N' ) ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 7', 'CONTA', 
 DATE'1991-11-21', 61500, 60000, 'N' ) ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 8', 'PROD', 
 DATE'1994-12-30', 54500, 52000, 'N' ) ;

COMMIT ;
