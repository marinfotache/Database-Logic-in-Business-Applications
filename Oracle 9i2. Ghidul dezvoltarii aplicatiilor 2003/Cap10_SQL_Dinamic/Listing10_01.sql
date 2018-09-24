-- doua variante de creare a tabelei CONCEDII dintr-un bloc anonim PL/SQL
DECLARE
 tabela VARCHAR2(30) ;
 atribut1 VARCHAR2(50) ;
 restrictii_atribut1 VARCHAR2(500) ;
 atribut2 VARCHAR2(50) ;
 restrictii_atribut2 VARCHAR2(500) ;
 atribut3 VARCHAR2(50) ;
 restrictii_atribut3 VARCHAR2(500) ;
 restrictie1 VARCHAR2(500) ;
 restrictie2 VARCHAR2(500) ;
 restrictie3 VARCHAR2(500) ;
 
BEGIN 
 -- prima versiune de creare a tabelei CONCEDII
  EXECUTE IMMEDIATE '
  CREATE TABLE concedii (
    	marca INTEGER 
   		CONSTRAINT nn_concedii_marca NOT NULL
   		CONSTRAINT fk_concedii_personal REFERENCES personal (marca)
	, datai DATE	
	, dataf DATE 
	, CONSTRAINT ck_concedii1 CHECK (dataf >= datai)
	, CONSTRAINT ck_concedii2 CHECK (dataf - datai < 90)
	, CONSTRAINT pk_concedii3 PRIMARY KEY (marca,datai)
 	) ' ;

 -- a doua varianta de creare

 -- mai intii, stergem tabela 
 EXECUTE IMMEDIATE 'DROP TABLE concedii'  ;
 
 -- apoi o re-cream, folosind variabile
 tabela := 'concedii' ;
 atribut1 := 'marca INTEGER '  ;
 restrictii_atribut1 := ' CONSTRAINT nn_concedii_marca NOT NULL
   		CONSTRAINT fk_concedii_personal REFERENCES personal (marca) ' ;
 atribut2 := 'datai DATE	'  ;
 restrictii_atribut2 := '' ;
 atribut3 := 'dataf DATE	' ;
 restrictii_atribut3 := '' ;
 restrictie1 := ' CONSTRAINT ck_concedii1 CHECK (dataf >= datai) ' ;
 restrictie2 := '	CONSTRAINT ck_concedii2 CHECK (dataf - datai < 90) ' ;
 restrictie3 := ' CONSTRAINT pk_concedii PRIMARY KEY (marca,datai) ' ;

 EXECUTE IMMEDIATE 'CREATE TABLE ' || tabela || ' ( ' ||
  atribut1 || restrictii_atribut1 ||
  ', ' || atribut2 || restrictii_atribut2 ||  
  ', ' || atribut3 || restrictii_atribut3 ||  
  ', ' || restrictie1 ||   
  ', ' || restrictie2 ||   
  ', ' || restrictie3 || ' ) ' ;

END ;

/*
INSERT INTO concedii VALUES (101, TO_DATE('03/10/2003', 'DD/MM/YYYY'), TO_DATE('23/10/2003', 'DD/MM/YYYY')) ;
INSERT INTO concedii VALUES (102, TO_DATE('23/03/2003', 'DD/MM/YYYY'), TO_DATE('14/04/2003', 'DD/MM/YYYY')) ;
INSERT INTO concedii VALUES (102, TO_DATE('07/08/2003', 'DD/MM/YYYY'), TO_DATE('15/08/2003', 'DD/MM/YYYY')) ;

INSERT INTO concedii VALUES (103, TO_DATE('01/03/2003', 'DD/MM/YYYY'), TO_DATE('31/03/2003', 'DD/MM/YYYY')) ;

INSERT INTO concedii VALUES (104, TO_DATE('07/03/2003', 'DD/MM/YYYY'), TO_DATE('15/03/2003', 'DD/MM/YYYY')) ;
*/
