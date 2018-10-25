
DROP TABLE rezultate_curse ;
DROP TABLE curse ;
DROP TABLE locuri_puncte ;
DROP TABLE piloti ;
DROP TABLE circuite ;

CREATE TABLE circuite (
 IdCircuit NUMBER(5) NOT NULL PRIMARY KEY, 
 DenCircuit VARCHAR2(50) NOT NULL UNIQUE, 
 Localitate VARCHAR2(40), 
 Tara VARCHAR2(30), 
 LungimePista NUMBER(5), 
 NrTururi NUMBER(3)
 );

CREATE TABLE piloti (
 IdPilot NUMBER(10) NOT NULL PRIMARY KEY,
 NumePilot VARCHAR2(50) NOT NULL UNIQUE, 
 Echipa VARCHAR2(30) NOT NULL 
 );



CREATE TABLE locuri_puncte (
 PozitieSosire NUMBER(3) PRIMARY KEY CHECK (PozitieSosire > 0), 
 PunctePozitie NUMBER(3)
 );

CREATE TABLE curse (
 IdCursa NUMBER(10) NOT NULL PRIMARY KEY, 
 DataCursa DATE DEFAULT CURRENT_DATE NOT NULL,
 IdCircuit NUMBER(5) NOT NULL REFERENCES circuite (IdCircuit)
 );
 
CREATE TABLE rezultate_curse (
 IdCursa NUMBER(10) NOT NULL REFERENCES curse (IdCursa), 
 PozitieSosire NUMBER(3) NOT NULL CHECK (PozitieSosire BETWEEN 1 AND 300), 
 IdPilot NUMBER(10) NOT NULL REFERENCES piloti (IdPilot),
 PRIMARY KEY (IdCursa, PozitieSosire, IdPilot)
 );


