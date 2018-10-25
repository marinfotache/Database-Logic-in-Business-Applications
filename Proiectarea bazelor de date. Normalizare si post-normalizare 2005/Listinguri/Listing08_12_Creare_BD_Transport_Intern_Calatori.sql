
DROP TABLE bilete ;
DROP TABLE rezervari ;
DROP TABLE curse2 ;
DROP TABLE suspendari ;
DROP TABLE plecari ;
DROP TABLE  loc_rute ;
DROP TABLE  rute ;
DROP TABLE  distante ;
DROP TABLE  localit ;
DROP TABLE  tarife ;
DROP TABLE  autovehicole ;
DROP TABLE  tipuri_auto ;

CREATE TABLE tipuri_auto (
 TipAuto VARCHAR2(15) NOT NULL PRIMARY KEY,
 NrLocuri NUMBER(3) DEFAULT 16 NOT NULL
 ) ;

CREATE TABLE autovehicole (
 NrAuto CHAR(10) PRIMARY KEY,
 TipAuto VARCHAR2(15) NOT NULL REFERENCES tipuri_auto (TipAuto)
 ) ;

CREATE TABLE tarife (
 KmLimitaInf NUMBER(4) NOT NULL,
 KmLimitaSup NUMBER(4) NOT NULL,
 CostPeKm NUMBER(7) NOT NULL,
 PRIMARY KEY (KmLimitaInf, KmLimitaSup)
 ) ;

CREATE TABLE localit (
 Localitate VARCHAR2(30) PRIMARY KEY,
 Judet VARCHAR2(30) NOT NULL,
 Obs VARCHAR2(150)
 ) ;
 
CREATE TABLE distante (
 Loc1 VARCHAR2(30) REFERENCES localit (Localitate),
 Loc2 VARCHAR2(30) REFERENCES localit (Localitate),
 Distanta NUMBER(4) NOT NULL,
 PRIMARY KEY (Loc1, Loc2), 
 CHECK (Loc1 < Loc2)  -- pentru a evita introducerea de doua ori
 ) ;                  -- a distantei dintre doua localitati
 
CREATE TABLE rute (
 IdRuta NUMBER(6) NOT NULL PRIMARY KEY,
 LocPlecare VARCHAR2(30) REFERENCES localit (Localitate),
 LocDestinatie VARCHAR2(30) REFERENCES localit (Localitate),
 DenRuta VARCHAR2(400) NOT NULL,
 Distanta NUMBER(4) NOT NULL 
  ) ;
  
CREATE TABLE loc_rute (
 IdRuta NUMBER(6) NOT NULL REFERENCES rute (IdRuta) ON DELETE CASCADE,
 LocalitNr NUMBER(2) DEFAULT 1 NOT NULL ,
 Loc VARCHAR2(30) REFERENCES localit (Localitate),
 PRIMARY KEY (IdRuta, LocalitNr)
 ) ;
 
CREATE TABLE plecari (
 IdPlecare NUMBER(10) NOT NULL PRIMARY KEY,
 IdRuta NUMBER(6) NOT NULL REFERENCES rute (IdRuta),
 OraPlecare CHAR(5) DEFAULT '10:00' NOT NULL, 
 CirculaSD  CHAR(5) DEFAULT '18:00' NOT NULL, 
 Tip_Auto VARCHAR2(15) NOT NULL REFERENCES tipuri_auto (TipAuto)
  ) ;

CREATE TABLE suspendari (
 IdSuspendare NUMBER(10) NOT NULL PRIMARY KEY,
 DataSuspendare DATE DEFAULT CURRENT_DATE NOT NULL, 
 IdPlecare NUMBER(10) NOT NULL REFERENCES plecari (IdPlecare),
 DataInitiala DATE DEFAULT CURRENT_DATE NOT NULL,
 DataFinala DATE
 ) ;
 
CREATE TABLE curse2 (
 IdCursa NUMBER(12) NOT NULL PRIMARY KEY,
 IdPlecare NUMBER(10) NOT NULL REFERENCES plecari (IdPlecare),
 DataCursa DATE DEFAULT CURRENT_DATE NOT NULL, 
 Sofer VARCHAR2(30),
 NrAuto CHAR(10) REFERENCES autovehicole (NrAuto)
 ) ;
 
CREATE TABLE rezervari (
 IdRezervare NUMBER(8) NOT NULL PRIMARY KEY,
 DataOraRez DATE DEFAULT CURRENT_DATE NOT NULL,
 NumeRez VARCHAR2(30) NOT NULL,
 TelRez VARCHAR2(14),
 IdCursa NUMBER(12) NOT NULL REFERENCES curse2 (IdCursa),
 NrBilete NUMBER(3) DEFAULT 1 NOT NULL,
 DeLa VARCHAR2(30) REFERENCES localit (Localitate),
 PinaLa VARCHAR2(30) REFERENCES localit (Localitate)
  ) ;
  

CREATE TABLE bilete (
 IdBilet NUMBER(14) NOT NULL PRIMARY KEY,
 DataOraBilet DATE DEFAULT CURRENT_DATE NOT NULL,
 SerieNrBilet VARCHAR2(15) NOT NULL,
 IdCursa NUMBER(12) NOT NULL REFERENCES curse2 (IdCursa),
 DeLa VARCHAR2(30) REFERENCES localit (Localitate),
 PinaLa VARCHAR2(30) REFERENCES localit (Localitate),
 ValBilet NUMBER(12) NOT NULL,
 IdRezervare NUMBER(8) NOT NULL REFERENCES rezervari (IdRezervare)
 ) ; 

