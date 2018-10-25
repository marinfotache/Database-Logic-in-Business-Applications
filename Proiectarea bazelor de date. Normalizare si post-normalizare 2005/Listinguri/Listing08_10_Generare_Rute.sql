DROP SEQUENCE seq_idruta ;
CREATE SEQUENCE seq_idruta START WITH 1 MINVALUE 1 
 MAXVALUE 555555 ORDER NOCYCLE NOCACHE INCREMENT BY 1;

DROP TABLE loc_rute ;
DROP TABLE rute ;
CREATE TABLE rute (
 idruta NUMBER(6) NOT NULL PRIMARY KEY, 
 data_generarii DATE DEFAULT CURRENT_DATE NOT NULL,
 loc_init VARCHAR(20), 
 loc_dest VARCHAR(20), 
 sir VARCHAR2(500), 
 distanta NUMBER(5)
 );

CREATE TABLE loc_rute (
 idruta NUMBER(6) NOT NULL REFERENCES rute (idruta)
  ON DELETE CASCADE,  
 loc_nr NUMBER(4) NOT NULL,
 loc VARCHAR(20) NOT NULL
 );

CREATE OR REPLACE TRIGGER trg_rute_ins
 BEFORE INSERT ON rute FOR EACH ROW 
BEGIN 
 SELECT seq_idruta.NextVal INTO :NEW.idruta FROM dual ;
END ;
/  

CREATE OR REPLACE TRIGGER trg_loc_rute_ins
 BEFORE INSERT ON loc_rute FOR EACH ROW 
DECLARE 
 v_ultim_nrloc NUMBER(5) := 0 ;
BEGIN 
 SELECT MAX(loc_nr) INTO v_ultim_nrloc FROM loc_rute WHERE idruta = :NEW.idruta ;
 IF NVL(v_ultim_nrloc,0) = 0 THEN
   :NEW.loc_nr := 1 ;
 ELSE 
   :NEW.loc_nr := v_ultim_nrloc + 1 ;
 END IF ;     
END ;
/  

