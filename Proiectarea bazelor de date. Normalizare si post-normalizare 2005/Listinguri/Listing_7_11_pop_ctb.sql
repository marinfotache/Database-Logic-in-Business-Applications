DROP SEQUENCE seq_idnota ;
CREATE SEQUENCE seq_idnota START WITH 1001 
  MINVALUE 1001 MAXVALUE 9999999999 NOCACHE NOCYCLE ORDER ;

DELETE FROM detalii_operatiuni ;
DELETE FROM operatiuni ;
DELETE FROM note_contabile ;

INSERT INTO note_contabile VALUES (0, 5, DATE'2004-11-30', '...') ;
INSERT INTO note_contabile VALUES (0, 6, DATE'2004-12-01', '...') ;

INSERT INTO operatiuni VALUES (10001, 1, seq_idnota.CurrVal-1, '...') ;
INSERT INTO operatiuni VALUES (10002, 2, seq_idnota.CurrVal-1, '...') ;
INSERT INTO operatiuni VALUES (10003, 1, seq_idnota.CurrVal, '...') ;

INSERT INTO detalii_operatiuni VALUES (10001, '300', '401', 10000000) ;
INSERT INTO detalii_operatiuni VALUES (10001, '4426', '401', 1900000) ;
INSERT INTO detalii_operatiuni VALUES (10002, '401', '5311', 7000000) ;
INSERT INTO detalii_operatiuni VALUES (10002, '401', '5121', 4800000) ;
INSERT INTO detalii_operatiuni VALUES (10003, '5121', '700', 5250000) ;

COMMIT ;


