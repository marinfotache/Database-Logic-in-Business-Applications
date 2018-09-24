-- Apelul procedurii de stergere 
BEGIN 
  p_sterge ('CONCEDII') ;

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
END ;
