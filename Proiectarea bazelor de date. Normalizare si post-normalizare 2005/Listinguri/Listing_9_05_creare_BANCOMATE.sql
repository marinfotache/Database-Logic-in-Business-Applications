-- creare BD BANCOMATE
DROP TABLE plati_puncte_vinzare ;
DROP TABLE puncte_vinzare ;
DROP TABLE plati_prin_bancomat ;
DROP TABLE conturi_destinatie ;
DROP TABLE retrageri_numerar ;
DROP TABLE bancomate ;
DROP TABLE plati ;
DROP TABLE tipuri_plati  ;
DROP TABLE alimentare_conturi ;
DROP TABLE operatiuni_card ;
DROP TABLE conturi_card ;
DROP TABLE titulari_card ;

CREATE TABLE titulari_card (
 CNPPosesor CHAR(13) NOT NULL PRIMARY KEY,
 NumePrenume VARCHAR2(45) NOT NULL, 
 Adresa VARCHAR2(60)
 );
 
CREATE TABLE conturi_card (
 IdCont NUMBER(14) NOT NULL PRIMARY KEY,
 CNPPosesor CHAR(13) NOT NULL REFERENCES titulari_card (CNPPosesor),
 DateDeschidere DATE DEFAULT CURRENT_DATE NOT NULL,
 TipCont VARCHAR2(15) NOT NULL,
 NrCont NUMBER(16) NOT NULL,
 PlafonCreditare NUMBER(14) NOT NULL,
 SoldInitial NUMBER(14) NOT NULL
 );
 
CREATE TABLE operatiuni_card (
 IdOperatiune NUMBER(16) NOT NULL PRIMARY KEY,
 DataOraOp DATE DEFAULT CURRENT_DATE NOT NULL,
 IdCont NUMBER(14) NOT NULL REFERENCES conturi_card (IdCont)
 );
 
CREATE TABLE alimentare_conturi (
 IdAlimCont NUMBER(15) NOT NULL PRIMARY KEY,
 SumaAlimCont NUMBER (14) NOT NULL CHECK (SumaAlimCont > 0),
 IdOperatiune NUMBER(16) NOT NULL REFERENCES operatiuni_card (IdOperatiune)
 );

CREATE TABLE tipuri_plati (
 TipPlata VARCHAR2(15) NOT NULL PRIMARY KEY,
 ProcentComision NUMBER(4,4)
 );

CREATE TABLE plati (
 IdPlata NUMBER(15) NOT NULL PRIMARY KEY,
 TipPlata VARCHAR2(15) NOT NULL REFERENCES tipuri_plati (TipPlata),
 SumaPlata NUMBER(14),
 IdOperatiune NUMBER(20) NOT NULL REFERENCES operatiuni_card (IdOperatiune)
 );

CREATE TABLE bancomate (
 IdBancomat NUMBER(7) NOT NULL PRIMARY KEY,
 Banca VARCHAR2(30) NOT NULL, 
 NrBcmt NUMBER(5) NOT NULL,
 AdresaBcmt VARCHAR2(50)
 );

CREATE TABLE retrageri_numerar (
 IdRetrNumerar NUMBER(15) NOT NULL PRIMARY KEY,
 IdPlata NUMBER(15) NOT NULL REFERENCES plati (IdPlata),
 IdBancomat NUMBER(7) NOT NULL REFERENCES bancomate (IdBancomat)
 );

CREATE TABLE conturi_destinatie (
 IdContDest NUMBER(10) NOT NULL PRIMARY KEY,
 NrContDest NUMBER(20) NOT NULL,
 Banca VARCHAR2(30) NOT NULL,
 IBAN_ContDest VARCHAR2(20) NOT NULL
 );

CREATE TABLE plati_prin_bancomat (
 IdPlataBancomat NUMBER(15) NOT NULL PRIMARY KEY,
 IdPlata NUMBER(15) NOT NULL REFERENCES plati (IdPlata),
 IdBancomat NUMBER(7) NOT NULL REFERENCES bancomate (IdBancomat),
 IdContDest NUMBER(10) NOT NULL REFERENCES conturi_destinatie (IdContDest)
 );
 
CREATE TABLE puncte_vinzare (
 IdPunctVinzare NUMBER(10) NOT NULL PRIMARY KEY,
 DenPV VARCHAR2(30),
 AdresaPV VARCHAR2(50)
  );
 
CREATE TABLE plati_puncte_vinzare (
 IdPlPunctVinz NUMBER(14) NOT NULL PRIMARY KEY,
 IdPlata NUMBER(15) NOT NULL REFERENCES plati (IdPlata),
 IdPunctVinz NUMBER(10) NOT NULL REFERENCES puncte_vinzare (IdPunctVinzare),
 IdContDest NUMBER(10) NOT NULL REFERENCES conturi_destinatie (IdContDest)
 );
 
 
 
 
-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_05_creare_BANCOMATE.sql