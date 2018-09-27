DROP TABLE VEHICULE;

CREATE TABLE VEHICULE (
   IdVeh INTEGER
       CONSTRAINT pk_IDVeh PRIMARY KEY,      
   NrInmatr VARCHAR(10) 
		CONSTRAINT un_NrImnatr UNIQUE
        CONSTRAINT nn_NrImnatr NOT NULL,
   Model VARCHAR(35) NOT NULL,
   SerieSasiu CHAR(17) 
		CONSTRAINT un_SerieSasiu UNIQUE
        CONSTRAINT nn_SerieSasiu NOT NULL,        
   AnFabric NUMERIC(4) NOT NULL,
   CapCilindr INTEGER,
   Combustibil CHAR(7)
        CONSTRAINT ck_Combustibil CHECK (Combustibil IN('Benzina', 'Diesel'))
        CONSTRAINT nn_Combustibil NOT NULL,
   IdLocInmatr INTEGER,
   DataInmatr DATE NOT NULL   
   )  ;
   
   
DROP TABLE PERMISE;

CREATE TABLE PERMISE (
   IdPermis INTEGER
       CONSTRAINT pk_IdPermis PRIMARY KEY,
   DataEmiterii DATE NOT NULL,
   IdSofer INTEGER NOT NULL,
   Categ VARCHAR(5)
        CONSTRAINT ck_Categ CHECK (Categ=UPPER(Categ))
        CONSTRAINT nn_Categ NOT NULL
   ) ;
   
   
DROP TABLE LOCALITATI;

CREATE TABLE LOCALITATI (   
   IdLoc INT
    	CONSTRAINT pk_IdLoc PRIMARY KEY ,
   DenLoc VARCHAR(50)
        CONSTRAINT ck_DenLoc CHECK (DenLoc=INITCAP(DenLoc))
        CONSTRAINT nn_DenLoc NOT NULL,
   Jud VARCHAR(2) NOT NULL
        CONSTRAINT ck_Jud CHECK (Jud=LTRIM(UPPER(Jud)))
   ) ;
   
   
DROP TABLE SOFERI;

CREATE TABLE SOFERI (
   IdSofer INT
    	CONSTRAINT pk_IdSofer PRIMARY KEY NOT NULL,
   CNPSofer CHAR(13)
        CONSTRAINT un_CNPSofer UNIQUE,
   NumeSofer VARCHAR(40) NOT NULL,
   DataNasterii DATE,
   IdLocSofer INT NOT NULL
	  ) ;
    
    
DROP TABLE CONTRAVENTII_VITEZA;

CREATE TABLE CONTRAVENTII_VITEZA (
   IdCont INT
  	CONSTRAINT pk_IdCont PRIMARY KEY NOT NULL,
   VitMaxLegala INT NOT NULL,
   VitezaEfectiva INT NOT NULL

   ) ;

DROP TABLE CONTRAVENTII;

CREATE TABLE CONTRAVENTII (
   IdContr INT
    CONSTRAINT pk_IdContr PRIMARY KEY NOT NULL,
   DataContr DATE NOT NULL,
   Descriere VARCHAR(100) NOT NULL,
   IdLocContr INT NOT NULL,
   NrLuni_Suspendare_Permis INT,
   NrPctPenaliz INT NOT NULL,
   ValAmenda INT NOT NULL,
   IdSofer INT NOT NULL,
   IDVehicul INT NOT NULL
   ) ;
   
   
DROP TABLE PLATI_AMENZI;

	CREATE TABLE PLATI_AMENZI (
   IdPlata INT
	CONSTRAINT pk_IdPlata PRIMARY KEY NOT NULL,
   DataPlata DATE DEFAULT CURRENT_DATE 
    CONSTRAINT nn_DataPlata NOT NULL,
   DocPlata VARCHAR(13) NOT NULL,
   IdLocPlata INT NOT NULL,
   IdContr INT
        CONSTRAINT un_IdContr UNIQUE
        CONSTRAINT nn_IdCOntr NOT NULL,
   ValoarePlata NUMERIC(6) NOT NULL
   ) ;


ALTER TABLE VEHICULE ADD CONSTRAINT fk_veh_loc
  FOREIGN KEY (IdLocInmatr) REFERENCES localitati(idloc);
  
ALTER TABLE SOFERI ADD CONSTRAINT fk_soferi_loc
  FOREIGN KEY (IdLocSofer) REFERENCES localitati(idloc);
  
ALTER TABLE CONTRAVENTII ADD CONSTRAINT fk_contr_loc
  FOREIGN KEY (IdLocContr) REFERENCES localitati(idloc);

ALTER TABLE PLATI_AMENZI ADD CONSTRAINT fk_plati_loc
  FOREIGN KEY (IdLocPlata) REFERENCES localitati(idloc);


  
