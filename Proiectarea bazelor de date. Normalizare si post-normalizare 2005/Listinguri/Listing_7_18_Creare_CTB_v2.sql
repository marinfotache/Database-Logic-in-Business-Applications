
DROP TABLE detalii_operatiuni ;
DROP TABLE operatiuni ;
DROP TABLE note_contabile ;
DROP TABLE plan_conturi ;

CREATE TABLE plan_conturi (
  SimbolCont VARCHAR2(12) NOT NULL PRIMARY KEY CHECK (LENGTH(SimbolCont) >= 3), 
  DenumireCont VARCHAR2(60) NOT NULL UNIQUE,
  TipCont CHAR(1) DEFAULT 'A' NOT NULL CHECK (TipCont IN ('A','P', 'B'))
  ); 

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
 ExplicatiiOp VARCHAR2(100),
 NrConturiDebitoare NUMBER (3),
 NrConturiCreditoare NUMBER (3),
 UnContDebitor VARCHAR(14),
 UnContCreditor VARCHAR(14), 
 CONSTRAINT ck_nrconturi CHECK ( NOT (NVL(nrconturidebitoare,0) > 1 AND
   NVL(nrconturicreditoare,0) > 1) ) 
 ); 
 
CREATE TABLE detalii_operatiuni (
 IdOperatiune NUMBER(10) NOT NULL REFERENCES operatiuni (IdOperatiune), 
 ContDebitor VARCHAR2(15) NOT NULL, 
 ContCreditor VARCHAR2(15) NOT NULL, 
 Suma NUMBER(15) NOT NULL,
 PRIMARY KEY (IdOperatiune, ContDebitor, ContCreditor)
 ) ;
