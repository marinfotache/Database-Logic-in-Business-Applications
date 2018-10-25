--CREATE SEQUENCE seq_idnota START WITH 1001 
-- MINVALUE 1001 MAXVALUE 9999999999 NOCACHE NOCYCLE ORDER 


DROP TABLE detalii_operatiuni ;
DROP TABLE operatiuni ;
DROP TABLE note_contabile ;

CREATE TABLE note_contabile (
 IdNotaContabila NUMBER(10) PRIMARY KEY,
 NrNota NUMBER(5), 
 Data DATE DEFAULT CURRENT_DATE, 
 ExplicatiiNota VARCHAR2(100)
 ) ;

CREATE TABLE operatiuni (
 IdOperatiune NUMBER(10) NOT NULL PRIMARY KEY, 
 NrOp NUMBER(2) NOT NULL, 
 IdNotaContabila NUMBER(10) NOT NULL REFERENCES note_contabile (IdNotaContabila), 
 ExplicatiiOp VARCHAR2(100)
 ); 

CREATE TABLE detalii_operatiuni (
 IdOperatiune NUMBER(10) NOT NULL REFERENCES operatiuni (IdOperatiune), 
 ContDebitor VARCHAR2(15) NOT NULL, 
 ContCreditor VARCHAR2(15) NOT NULL, 
 Suma NUMBER(15) NOT NULL,
 PRIMARY KEY (IdOperatiune, ContDebitor, ContCreditor)
 ) ;
