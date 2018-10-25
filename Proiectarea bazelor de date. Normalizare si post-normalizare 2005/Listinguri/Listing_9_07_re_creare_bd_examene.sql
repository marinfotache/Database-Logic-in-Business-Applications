DROP TABLE note_finale ;
DROP TABLE note ;
DROP TABLE sali_ex ;
DROP TABLE disc_spec_profi ;
DROP TABLE profi_specializari ;
DROP TABLE profesori ;
DROP TABLE discipline ;
DROP TABLE studenti ;
DROP TABLE specializari ;

CREATE TABLE specializari (
 idspec NUMBER(5) NOT NULL PRIMARY KEY,
 spec VARCHAR2(50) NOT NULL
 );
INSERT INTO specializari VALUES (1, 'Trunchi comun');

CREATE TABLE studenti (
 matricol VARCHAR2(18) NOT NULL PRIMARY KEY,
 numepren VARCHAR2(50) NOT NULL,
 an NUMBER(1) DEFAULT 1 NOT NULL CHECK (an BETWEEN 1 AND 5),
 modul CHAR(1) DEFAULT '1' NOT NULL CHECK (modul IN ('1', '2')),
 idspec NUMBER(5) DEFAULT 1 NOT NULL REFERENCES specializari (idspec),
 grupa NUMBER(4),
 CHECK (an <= 2 AND idspec=1 OR an > 2) -- la anii 1 si 2 exista doar 
 );                                     -- trunchi comun, nu specializare !

CREATE TABLE discipline (
 coddisc CHAR(6) NOT NULL PRIMARY KEY,
 dendisc VARCHAR2(60) NOT NULL,
 nrcreddisc NUMBER(2) CHECK (nrcreddisc <= 8)
 );

CREATE TABLE profesori (
 codprof NUMBER(5) NOT NULL PRIMARY KEY,
 numeprof VARCHAR2(40) NOT NULL,
 gradprof VARCHAR2(12) NOT NULL 
  CHECK (gradprof IN ('colaborator', 'preparator', 'asistent', 
  'lector', 'conferentiar', 'profesor'))
 );

CREATE TABLE profi_specializari (
 an NUMBER(1) DEFAULT 1 NOT NULL CHECK (an BETWEEN 1 AND 5),
 modul CHAR(1) DEFAULT '1' NOT NULL CHECK (modul IN ('1', '2')),
 idspec NUMBER(5) DEFAULT 1 NOT NULL REFERENCES specializari (idspec),
 codprof NUMBER(5) NOT NULL REFERENCES profesori (codprof),
 PRIMARY KEY (an, modul, idspec, codprof)
 );

CREATE TABLE disc_spec_profi (
 coddisc CHAR(6) NOT NULL REFERENCES discipline (coddisc),
 an NUMBER(1) DEFAULT 1 NOT NULL,
 modul CHAR(1) DEFAULT '1' NOT NULL ,
 idspec NUMBER(5) DEFAULT 1 NOT NULL ,
 codprof NUMBER(5) NOT NULL,
 PRIMARY KEY (coddisc, an, modul, idspec),
 FOREIGN KEY (an, modul, idspec, codprof) 
    REFERENCES profi_specializari(an, modul, idspec, codprof)
);

CREATE TABLE sali_ex(
 an NUMBER(1) DEFAULT 1 NOT NULL CHECK (an BETWEEN 1 AND 5),
 modul CHAR(1) DEFAULT '1' NOT NULL CHECK (modul IN ('1', '2')),
 idspec NUMBER(5) DEFAULT 1 NOT NULL REFERENCES specializari (idspec),
 coddisc CHAR(6) NOT NULL REFERENCES discipline (coddisc),
 dataex DATE CHECK (EXTRACT (MONTH FROM dataex) IN (1,2,5,6,7)),
 salaex VARCHAR2(20),
 PRIMARY KEY (an, modul, idspec, coddisc, dataex)
 );
 
CREATE TABLE note (
 matricol VARCHAR2(18) NOT NULL REFERENCES studenti(matricol),
 coddisc CHAR(6) NOT NULL REFERENCES discipline (coddisc),
 dataex DATE CHECK (EXTRACT (MONTH FROM dataex) IN (1,2,5,6,7)),
 nota NUMBER(2) CHECK (nota BETWEEN 1 AND 10)
);

CREATE TABLE note_finale (
 Matricol VARCHAR2(18) NOT NULL REFERENCES studenti(matricol),
 CodDisc CHAR(6) NOT NULL REFERENCES discipline (coddisc),
 NotaFinala NUMBER(2) CHECK (nota BETWEEN 1 AND 10)
);
  
