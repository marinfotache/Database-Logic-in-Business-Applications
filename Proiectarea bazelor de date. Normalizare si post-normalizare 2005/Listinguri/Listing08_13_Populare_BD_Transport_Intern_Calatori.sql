
DELETE FROM plecari ;
DELETE FROM loc_rute ;
DELETE FROM rute ;
DELETE FROM distante ;
DELETE FROM localit ;
DELETE FROM tarife ;
DELETE FROM autovehicole ;
DELETE FROM tipuri_auto ;

INSERT INTO tipuri_auto VALUES ('Micro 1', 16) ;
INSERT INTO tipuri_auto VALUES ('Micro 2', 26) ;
INSERT INTO tipuri_auto VALUES ('Autocar 1', 50) ;

INSERT INTO autovehicole VALUES ('IS-20-TRA', 'Micro 1') ;
INSERT INTO autovehicole VALUES ('IS-21-TRA', 'Micro 1') ;
INSERT INTO autovehicole VALUES ('IS-22-TRA', 'Micro 1') ;
INSERT INTO autovehicole VALUES ('IS-23-TRA', 'Micro 2') ;
INSERT INTO autovehicole VALUES ('IS-28-TRA', 'Micro 2') ;
INSERT INTO autovehicole VALUES ('IS-29-TRA', 'Micro 2') ;
INSERT INTO autovehicole VALUES ('IS-40-TRA', 'Autocar 1') ;
INSERT INTO autovehicole VALUES ('IS-41-TRA', 'Autocar 1') ;

INSERT INTO tarife VALUES ( 0, 20, 1500) ;
INSERT INTO tarife VALUES (20, 40, 1450) ;
INSERT INTO tarife VALUES (40, 70, 1425) ;
INSERT INTO tarife VALUES (70, 100, 1400) ;
INSERT INTO tarife VALUES (100, 150, 1350) ;
INSERT INTO tarife VALUES (150, 200, 1325) ;
INSERT INTO tarife VALUES (200, 9999, 1300) ;

INSERT INTO localit VALUES ('Iasi', 'Iasi', NULL) ;
INSERT INTO localit VALUES ('Tg.Frumos', 'Iasi', NULL) ;
INSERT INTO localit VALUES ('Pascani', 'Iasi', 'Se circula prin centru') ;
INSERT INTO localit VALUES ('Motca', 'Iasi', NULL) ;
INSERT INTO localit VALUES ('Roman', 'Neamt', NULL) ;
INSERT INTO localit VALUES ('Bacau', 'Bacau', 'Se circula prin centru') ;
INSERT INTO localit VALUES ('Vaslui', 'Vaslui', 'Se circula pe centura') ;
INSERT INTO localit VALUES ('Birlad', 'Vaslui', NULL) ;
INSERT INTO localit VALUES ('Tecuci', 'Galati', 'Se circula pe centura') ;
INSERT INTO localit VALUES ('Galati', 'Galati', NULL) ;
INSERT INTO localit VALUES ('Adjud', 'Vrancea', NULL) ;
INSERT INTO localit VALUES ('Tisita', 'Vrancea', NULL) ;
INSERT INTO localit VALUES ('Focsani', 'Vrancea', NULL) ;
INSERT INTO localit VALUES ('Rm.Sarat', 'Buzau', NULL) ;
INSERT INTO localit VALUES ('Buzau', 'Buzau', 'Se circula pe centura') ;
INSERT INTO localit VALUES ('Braila', 'Braila', NULL) ;

INSERT INTO distante VALUES ('Iasi', 'Vaslui', 71) ;
INSERT INTO distante VALUES ('Iasi', 'Tg.Frumos', 53) ;
INSERT INTO distante VALUES ('Roman', 'Tg.Frumos', 40) ;
INSERT INTO distante VALUES ('Bacau', 'Roman', 41) ;
INSERT INTO distante VALUES ('Roman', 'Vaslui', 80) ;
INSERT INTO distante VALUES ('Birlad', 'Vaslui', 54) ;
INSERT INTO distante VALUES ('Birlad', 'Tecuci', 48) ;   
INSERT INTO distante VALUES ('Tecuci', 'Tisita', 20) ;
INSERT INTO distante VALUES ('Focsani', 'Tisita', 13) ;
INSERT INTO distante VALUES ('Adjud', 'Bacau', 60) ;
INSERT INTO distante VALUES ('Bacau', 'Vaslui', 85) ;
INSERT INTO distante VALUES ('Adjud', 'Tisita', 32) ;
INSERT INTO distante VALUES ('Focsani', 'Galati', 80) ;
INSERT INTO distante VALUES ('Braila', 'Focsani', 86) ;
INSERT INTO distante VALUES ('Focsani', 'Rm.Sarat', 42) ;
INSERT INTO distante VALUES ('Braila', 'Rm.Sarat', 84) ;
INSERT INTO distante VALUES ('Braila', 'Galati', 11) ;
INSERT INTO distante VALUES ('Galati', 'Tecuci', 67) ;

DROP SEQUENCE seq_idruta ;
CREATE SEQUENCE seq_idruta START WITH 1 MINVALUE 1 
	MAXVALUE 555555 ORDER NOCYCLE NOCACHE INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_rute_ins BEFORE INSERT ON rute FOR EACH ROW 
BEGIN 
 SELECT seq_idruta.NextVal INTO :NEW.idruta FROM dual ;
END ;
/  

CREATE OR REPLACE TRIGGER trg_loc_rute_ins BEFORE INSERT ON loc_rute FOR EACH ROW 
DECLARE 
	v_ultim_nrloc NUMBER(5) := 0 ;
BEGIN 
	SELECT MAX(LocalitNr) INTO v_ultim_nrloc FROM loc_rute WHERE idruta = :NEW.idruta ;
	IF NVL(v_ultim_nrloc,0) = 0 THEN
		:NEW.LocalitNr := 1 ;
	ELSE 
		:NEW.LocalitNr := v_ultim_nrloc + 1 ;
	END IF ;     
END ;
/

------------------
CREATE OR REPLACE PROCEDURE p_generare_rute (
 loc_init VARCHAR2, loc_dest VARCHAR2) IS
BEGIN 
 pac_loc.loc_init := loc_init ;
 pac_loc.loc_dest := loc_dest ;

 FOR rec_view IN (SELECT * FROM v_ordin1  
     WHERE loc1= pac_loc.f_loc_init() AND loc2=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc2, rec_view.sir, rec_view.distanta) ;
   INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
   INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
 END LOOP ;
 
 FOR rec_view IN (SELECT * FROM v_ordin2  
    WHERE loc1= pac_loc.f_loc_init() AND loc3=pac_loc.f_loc_dest() ) LOOP 
  INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
    VALUES (rec_view.loc1, rec_view.loc3, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
 END LOOP ;
 
 
 FOR rec_view IN (SELECT * FROM v_ordin3
     WHERE loc1= pac_loc.f_loc_init() AND loc4=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc4, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
 END LOOP ;

 FOR rec_view IN (SELECT * FROM v_ordin4  
     WHERE loc1= pac_loc.f_loc_init() AND loc5=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc5, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
 END LOOP ;
 
 FOR rec_view IN (SELECT * FROM v_ordin5  
      WHERE loc1= pac_loc.f_loc_init() AND loc6=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc6, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
 END LOOP ;

 FOR rec_view IN (SELECT * FROM v_ordin6  
      WHERE loc1= pac_loc.f_loc_init() AND loc7=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc7, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
 END LOOP ;

 FOR rec_view IN (SELECT * FROM v_ordin7  
      WHERE loc1= pac_loc.f_loc_init() AND loc8=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc8, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc8) ;

 END LOOP ;
 
  FOR rec_view IN (SELECT * FROM v_ordin8  
       WHERE loc1= pac_loc.f_loc_init() AND loc9=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
     VALUES (rec_view.loc1, rec_view.loc9, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc8) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc9) ;
 END LOOP ;
 
 FOR rec_view IN (SELECT * FROM v_ordin9  
  WHERE loc1= pac_loc.f_loc_init() AND loc10=pac_loc.f_loc_dest() ) LOOP 
    INSERT INTO rute(LocPlecare, LocDestinatie, DenRuta, Distanta) 
      VALUES (rec_view.loc1, rec_view.loc10, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc8) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc9) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc10) ;
 END LOOP ;

END ;
/

------------------
BEGIN
 p_generare_rute('Iasi', 'Focsani');
 p_generare_rute('Bacau', 'Braila');
 p_generare_rute('Roman', 'Galati'); 
END ;
/

DELETE FROM rute WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND distanta > 250 ;
DELETE FROM rute WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND distanta > 250 ;
DELETE FROM rute WHERE LocPlecare='Roman' AND LocDestinatie='Galati' AND 
 denruta LIKE '%*Focsani*%'  ;
DELETE FROM rute WHERE denruta LIKE '%*Galati**Focsani*%' OR denruta LIKE '%*Focsani**Galati*%'  ;
DELETE FROM rute WHERE denruta LIKE '%*Focsani**Braila*%' OR denruta LIKE '%*Braila**Focsani*%'  ;
DELETE FROM rute WHERE denruta LIKE '%*Vaslui**Roman*%' OR denruta LIKE '%*Roman**Vaslui*%'  ;
DELETE FROM rute WHERE denruta LIKE '%*Vaslui**Bacau*%' OR denruta LIKE '%*Bacau**Vaslui*%'  ;

INSERT INTO plecari SELECT 501, IdRuta, '06:00', 'N', 'Micro 1' FROM rute 
  WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND  denruta LIKE '%*Birlad**Tecuci*%'; 
INSERT INTO plecari SELECT 502, IdRuta, '09:30', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND  denruta LIKE '%*Birlad**Tecuci*%'; 
INSERT INTO plecari SELECT 503, IdRuta, '13:30', 'D', 'Autocar 1' FROM rute 
  WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND  denruta LIKE '%*Birlad**Tecuci*%'; 
INSERT INTO plecari SELECT 504, IdRuta, '16:30', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND  denruta LIKE '%*Birlad**Tecuci*%'; 

INSERT INTO plecari SELECT 510, IdRuta, '07:00', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND  denruta LIKE '%*Tg.Frumos*%'; 
INSERT INTO plecari SELECT 511, IdRuta, '12:00', 'D', 'Micro 2' FROM rute 
  WHERE LocPlecare='Iasi' AND LocDestinatie='Focsani' AND  denruta LIKE '%*Tg.Frumos*%'; 
 
INSERT INTO plecari SELECT 515, IdRuta, '06:30', 'N', 'Micro 1' FROM rute 
  WHERE LocPlecare='Roman' AND LocDestinatie='Galati' AND  denruta LIKE '%*Tisita*%'; 
INSERT INTO plecari SELECT 516, IdRuta, '10:30', 'N', 'Micro 1' FROM rute 
  WHERE LocPlecare='Roman' AND LocDestinatie='Galati' AND  denruta LIKE '%*Tisita*%'; 
INSERT INTO plecari SELECT 517, IdRuta, '14:30', 'D', 'Micro 2' FROM rute 
  WHERE LocPlecare='Roman' AND LocDestinatie='Galati' AND  denruta LIKE '%*Tisita*%'; 

INSERT INTO plecari SELECT 518, IdRuta, '9:00', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Roman' AND LocDestinatie='Galati' AND  denruta LIKE '%*Iasi*%'; 
INSERT INTO plecari SELECT 519, IdRuta, '13:00', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Roman' AND LocDestinatie='Galati' AND  denruta LIKE '%*Iasi*%'; 

INSERT INTO plecari SELECT 521, IdRuta, '5:30', 'N', 'Micro 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Rm.Sarat*%'; 
INSERT INTO plecari SELECT 522, IdRuta, '10:30', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Rm.Sarat*%'; 
INSERT INTO plecari SELECT 523, IdRuta, '15:30', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Rm.Sarat*%'; 

INSERT INTO plecari SELECT 525, IdRuta, '7:30', 'N', 'Micro 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Galati*%'; 
INSERT INTO plecari SELECT 526, IdRuta, '10:30', 'D', 'Autocar 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Galati*%'; 
INSERT INTO plecari SELECT 527, IdRuta, '12:30', 'D', 'Micro 2' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Galati*%'; 
INSERT INTO plecari SELECT 528, IdRuta, '15:30', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Galati*%'; 
INSERT INTO plecari SELECT 529, IdRuta, '17:30', 'D', 'Micro 1' FROM rute 
  WHERE LocPlecare='Bacau' AND LocDestinatie='Braila' AND  denruta LIKE '%*Galati*%'; 


INSERT INTO suspendari VALUES (51, DATE'2004-11-10', 529, DATE'2004-11-15', DATE'2004-12-15') ;

INSERT INTO curse2 VALUES (11111, 501, DATE'2004-12-02', 'Muntenescu Adrian', 'IS-20-TRA') ;
INSERT INTO curse2 VALUES (11112, 501, DATE'2004-12-03', 'Vasilescu Adrian', 'IS-21-TRA') ;
INSERT INTO curse2 VALUES (11113, 501, DATE'2004-12-04', 'Muntenescu Adrian', 'IS-20-TRA') ;

INSERT INTO curse2 VALUES (11114, 502, DATE'2004-12-02', 'Lazar Ionut', 'IS-21-TRA') ;
INSERT INTO curse2 VALUES (11115, 502, DATE'2004-12-03', 'Senzitivu Gica', 'IS-22-TRA') ;
INSERT INTO curse2 VALUES (11116, 502, DATE'2004-12-04', 'Bucur Cerasela', 'IS-21-TRA') ;


COMMIT ; 

       
/* 

INSERT INTO rezervari (numerez, idcursa, nrbilete, dela, pinala) 
 VALUES ('Georgescu Mircea', 11111, 2, 'Iasi', 'Birlad') ;
 
INSERT INTO rezervari (numerez, idcursa, nrbilete, dela, pinala) 
 VALUES ('Trandafir Iulian', 11111, 4, 'Iasi', 'Tecuci') ;

INSERT INTO rezervari (numerez, idcursa, nrbilete, dela, pinala) 
 VALUES ('Toiu Viorel', 11111, 2, 'Vaslui', 'Birlad') ;


CREATE TABLE rezervari (
 IdRezervare NUMBER(8) NOT NULL PRIMARY KEY,
 DataOraRez DATE DEFAULT CURRENT_SYSDATE NOT NULL,
 NumeRez VARCHAR2(30) NOT NULL,
 TelRez VARCHAR2(14),
 IdCursa NUMBER(12) NOT NULL REFERENCES curse (IdCursa),
 NrBilete NUMBER(3) DEFAULT 1 NOT NULL,
 DeLa VARCHAR2(30) REFERENCES localit (Localitate),
 PinaLa VARCHAR2(30) REFERENCES localit (Localitate),
  ) ;
  

CREATE TABLE bilete (
 IdBilet NUMBER(14) NOT NULL PRIMARY KEY,
 DataOraBilet DATE DEFAULT CURRENT_SYSDATE NOT NULL,
 SerieNrBilet VARCHAR2(15) NOT NULL,
 IdCursa NUMBER(12) NOT NULL REFERENCES curse (IdCursa)
 DeLa VARCHAR2(30) REFERENCES localit (Localitate),
 PinaLa VARCHAR2(30) REFERENCES localit (Localitate),
 ValBilet NUMBER(12) NOT NULL,
 IdRezervare NUMBER(8) NOT NULL REFERENCES rezervari (IdRezervare)
 ) ; 
*/

COMMIT ;

