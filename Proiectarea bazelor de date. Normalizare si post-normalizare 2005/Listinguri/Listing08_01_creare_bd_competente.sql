
DROP TABLE competente_personal ;
ALTER TABLE compartimente DROP CONSTRAINT fk_compart_pers ;
DROP TABLE personal9 ;
DROP TABLE compartimente ;
DROP TABLE competente_posturi ;
DROP TABLE posturi ;
DROP TABLE competente_elementare ;
DROP TABLE competente ;

CREATE TABLE competente (
 idcompetenta NUMBER (10) CONSTRAINT pk_comp PRIMARY KEY,
 dencompetenta VARCHAR2(30) CONSTRAINT nn_comp_dencomp NOT NULL,
 um VARCHAR2(10),
 modevaluare VARCHAR2(15),
 idcompsuperioara NUMBER(10) CONSTRAINT fk_compsup_comp REFERENCES competente(idcompetenta)
 ) ;
 
CREATE TABLE competente_elementare (
 idcompfrunza NUMBER (10) CONSTRAINT pk_comp_elem PRIMARY KEY
 CONSTRAINT fk_compelem_comp REFERENCES competente(idcompetenta)
 ) ;
 
CREATE TABLE posturi (
 idpost NUMBER (8) CONSTRAINT pk_post PRIMARY KEY,
 denpost VARCHAR2(30) CONSTRAINT nn_post_denpost NOT NULL,
 salariu NUMBER(15)
 ) ;

CREATE TABLE competente_posturi (
 idpost NUMBER (8) CONSTRAINT fk_comppost_post REFERENCES posturi(idpost),
 idcompfrunza NUMBER (10) CONSTRAINT fk_comppost_compelem 
   REFERENCES competente_elementare(idcompfrunza),
 nivelminimacceptat NUMBER(5) CONSTRAINT nn_nivelminacc NOT NULL,   
 CONSTRAINT pk_comp_post PRIMARY KEY (idpost, idcompfrunza)
 ) ;

CREATE TABLE compartimente (
 compartiment VARCHAR2 (20) CONSTRAINT pk_compart PRIMARY KEY,
 marcasef NUMBER(6)
 ) ;
 
CREATE TABLE personal9 (
 marca NUMBER (6) CONSTRAINT pk_personal9 PRIMARY KEY,
 numepren VARCHAR2(40) CONSTRAINT nn_numepren9 NOT NULL,
 datasv DATE,
 compartiment VARCHAR2(20) CONSTRAINT fk_pers_compart9 
   REFERENCES compartimente(compartiment),
 idpost NUMBER(10) CONSTRAINT fk_personal_post9 REFERENCES posturi(idpost)
 ) ;
 
ALTER TABLE compartimente ADD CONSTRAINT fk_compart_pers 
 FOREIGN KEY (marcasef) REFERENCES personal9 (marca) ; 

CREATE TABLE competente_personal (
 marca NUMBER (6) CONSTRAINT fk_comppers_pers REFERENCES personal9(marca),
 idcompfrunza NUMBER (10) CONSTRAINT fk_comppers_compelem 
   REFERENCES competente_elementare(idcompfrunza),
 nivel NUMBER(5) CONSTRAINT nn_nivel NOT NULL,   
 CONSTRAINT pk_comp_pers PRIMARY KEY (marca, idcompfrunza)
 ) ;
 
