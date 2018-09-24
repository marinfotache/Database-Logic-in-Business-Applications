DELETE FROM personal ;

INSERT INTO personal VALUES (101, 'Angajat 1', 'IT', TO_DATE('12/10/1980', 'DD/MM/YYYY'),56000, 55000, 'N') ;
INSERT INTO personal VALUES (102, 'Angajat 2', 'CONTA', TO_DATE('12/11/1978', 'DD/MM/YYYY'),57500, 56000, 'N') ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 3', 'IT', TO_DATE('02/07/1976', 'DD/MM/YYYY'),67500, 66000, 'N' ) ;

-- se folosesc valorile implicite ale atributelor Compart, SalOrar, SalOrarCO si Colaborator
INSERT INTO personal (marca, numepren, datasv) VALUES (seq_marca.NextVal, 'Angajat 4', DATE'1982-01-05') ;

INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 5', 'IT', TO_DATE('12/11/1977', 'DD/MM/YYYY'),62500, 62000, 'N' ) ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 6', 'CONTA', TO_DATE('11/04/1985', 'DD/MM/YYYY'),71500, 70000, 'N' ) ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 7', 'CONTA', TO_DATE('21/11/1991', 'DD/MM/YYYY'),61500, 60000, 'N' ) ;
INSERT INTO personal VALUES (seq_marca.NextVal, 'Angajat 8', 'PROD', TO_DATE('30/12/1994', 'DD/MM/YYYY'),54500, 52000, 'N' ) ;

COMMIT ;
