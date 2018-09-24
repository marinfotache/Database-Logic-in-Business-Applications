DROP TABLE transe_sv ;
DROP TABLE salarii	;
DROP TABLE retineri	;
DROP TABLE sporuri	;
DROP TABLE pontaje	;
DROP TABLE personal	;

CREATE TABLE personal (
	marca INTEGER 
  		CONSTRAINT pk_personal PRIMARY KEY 
  		CONSTRAINT nn_personal_marca NOT NULL
    CONSTRAINT ck_personal_marca CHECK ( marca > 100 ) 	
	, numepren VARCHAR2(40) 
 		 CONSTRAINT nn_personal_numepren NOT NULL
    CONSTRAINT un_personal_nuempren UNIQUE
  		CONSTRAINT ck_personal_numepren CHECK (numepren=LTRIM(INITCAP(numepren)))		
	, compart VARCHAR2(5) DEFAULT  'PROD' 
		CONSTRAINT ck_personal_compart CHECK
				(compart in ( 'CONTA', 'FIN', 'PERS', 'MARK','PROD', 'IT' ) )
	, dataSV	DATE DEFAULT SYSDATE 
 		 CONSTRAINT nn_personal_datasv NOT NULL
	, salorar NUMBER(16,2) DEFAULT 45000
	, salorarco NUMBER(16,2) DEFAULT 40000
	, colaborator CHAR(1) DEFAULT 'N' 
    CONSTRAINT nn_personal_colaborator NOT NULL 
  		CONSTRAINT ck_personal_colaborator CHECK (colaborator IN ('D','N'))
	) ;


CREATE TABLE pontaje (
	marca INTEGER 
   		CONSTRAINT nn_pontaje_marca NOT NULL
   		CONSTRAINT fk_pontaje_personal REFERENCES personal (marca)
	, data DATE	DEFAULT SYSDATE 
    CONSTRAINT nn_pontaje_data NOT NULL
    CONSTRAINT ck_pontaje_data CHECK 
     (TO_CHAR(data,'YYYY') BETWEEN '2003' AND '2010') 
	, orelucrate 	NUMBER(2) DEFAULT 8
    CONSTRAINT ck_pontaje_orelucrate CHECK (orelucrate BETWEEN 0 AND 12)
	, oreco		NUMBER(2) DEFAULT 0
    CONSTRAINT ck_pontaje_oreco CHECK (oreco BETWEEN 0 AND 8)
	, orenoapte	NUMBER(2) DEFAULT 0
	, oreabsnem	NUMBER(2) DEFAULT 0
	, CONSTRAINT pk_pontaje PRIMARY KEY (marca,data)
 , CONSTRAINT ck_pontaje1 CHECK ((orelucrate = 0 AND oreco >=0) OR (orelucrate >=0 AND oreco = 0)) 
 , CONSTRAINT ck_pontaje2 CHECK (orelucrate >= orenoapte) 
 , CONSTRAINT ck_pontaje3 CHECK (orelucrate >= oreabsnem) 
 	) ;


CREATE TABLE sporuri (
 	marca INTEGER 
		CONSTRAINT nn_sporuri_marca NOT NULL
  CONSTRAINT fk_sporuri_personal REFERENCES personal (marca)
	, an	NUMBER(4)
		CONSTRAINT nn_sporuri_an NOT NULL		
		CONSTRAINT ck_sporuri_an CHECK ( an BETWEEN 2003 AND 2010 )		
	, luna	NUMBER(2)
		CONSTRAINT nn_sporuri_luna NOT NULL		
		CONSTRAINT ck_sporuri_luna CHECK (luna BETWEEN 1 AND 12)		
	, spvech NUMBER(16,2)
	, orenoapte	NUMBER(3)
	, spnoapte 	NUMBER(16,2)
	, altesp	NUMBER(16,2)
 , CONSTRAINT pk_sporuri PRIMARY KEY (marca, an, luna)
	) ;

CREATE TABLE retineri (
 	marca INTEGER 
		CONSTRAINT nn_retineri_marca NOT NULL
		CONSTRAINT fk_retineri_marca REFERENCES personal (marca)
	,an	NUMBER(4)
		CONSTRAINT nn_retineri_an NOT NULL		
		CONSTRAINT ck_retineri_an CHECK ( an BETWEEN 2001 AND 2012 )		
	,luna NUMBER(2)
		CONSTRAINT nn_retineri_luna NOT NULL		
		CONSTRAINT ck_retineri_luna CHECK (luna BETWEEN 1 AND 12)		
	, popriri	NUMBER(16,2)
	, CAR	 	NUMBER(16,2)
	, alteret	NUMBER(16,2)
	,	CONSTRAINT pk_retineri PRIMARY KEY (marca, an, luna)
	) ;

CREATE TABLE salarii (
 	marca INTEGER 
		CONSTRAINT nn_salarii_marca NOT NULL
		CONSTRAINT fk_salarii_personal REFERENCES personal (marca)
	,an	NUMBER(4)
		CONSTRAINT nn_salarii_an NOT NULL		
		CONSTRAINT ck_salarii_an CHECK ( an BETWEEN 2001 AND 2012 )		
	, luna	NUMBER(2)
		CONSTRAINT nn_salarii_luna NOT NULL		
		CONSTRAINT ck_salarii_luna CHECK (luna BETWEEN 1 AND 12)		
	, orelucrate	NUMBER(3)
	, oreco		NUMBER(3)
	, venitbaza	NUMBER(16,2)
	, sporuri	NUMBER(16,2)
	, impozit	NUMBER(16,2)
	, retineri	NUMBER(16,2)
	,	CONSTRAINT pk_salarii PRIMARY KEY (marca, an, luna)
	) ;
 
CREATE TABLE transe_sv (
 ani_limita_inf INTEGER
 ,ani_limita_sup INTEGER
 ,procent_sv NUMBER (4,2)
 ) ;

