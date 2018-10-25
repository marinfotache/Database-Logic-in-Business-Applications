--
-- creare BD centru de inchirieri VIDEO
--

DROP TABLE aprecieri_filme ;
DROP TABLE casete_imprumutate ;
DROP TABLE imprumuturi ;
DROP TABLE clienti ;
DROP TABLE casete_filme ;
DROP TABLE casete ;
DROP TABLE premii_interpretare ;
DROP TABLE premii_filme ;
DROP TABLE premii_denumiri ;
DROP TABLE scenaristi ;
DROP TABLE regizori ;
DROP TABLE producatori ;
DROP TABLE distributie ;
DROP TABLE filme_genuri ;
DROP TABLE cineasti ;
DROP TABLE filme ;

CREATE TABLE cineasti (
	IdCineast NUMBER(6) NOT NULL PRIMARY KEY, 
	NumeCineast VARCHAR2(40) NOT NULL, 
	DataNasterii DATE, 
	DataMortii DATE, 
	Naþionalitate VARCHAR2(30), 
	PaginaWeb VARCHAR2(200), 
	CHECK (NVL(DataNasterii, DATE'1970-01-01') < 
		NVL2(DataMortii, DataNasterii, DATE'1970-01-02'))
	);

CREATE TABLE filme (
	IdFilm NUMBER(10) NOT NULL PRIMARY KEY, 
	TitluOriginal VARCHAR2(100), 
	TitluRO VARCHAR2(100) NOT NULL, 
	AnLans NUMBER(4) CHECK (AnLans > 1900)
	) ;

CREATE TABLE filme_genuri (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	Gen VARCHAR2(25) NOT NULL,
	PRIMARY KEY (IdFilm, Gen)
	) ;

CREATE TABLE distributie (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	Rol VARCHAR2(30) NOT NULL, 
	Actor NUMBER(6) REFERENCES cineasti (IdCineast),
	PRIMARY KEY (IdFilm, Rol)
	);

CREATE TABLE producatori (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	Producator NUMBER(6) NOT NULL REFERENCES cineasti (IdCineast),
	PRIMARY KEY (IdFilm, Producator)
	);

CREATE TABLE regizori (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	Regizor NUMBER(6) NOT NULL REFERENCES cineasti (IdCineast),
	PRIMARY KEY (IdFilm, Regizor)	
	) ;

CREATE TABLE scenaristi (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	Scenarist NUMBER(6) NOT NULL REFERENCES cineasti (IdCineast),
	PRIMARY KEY (IdFilm, Scenarist)
	);

CREATE TABLE premii_denumiri (
	DenPremiu VARCHAR2(40) NOT NULL PRIMARY KEY, 
	LocDecernare VARCHAR2(50)
	);

CREATE TABLE premii_filme (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	DenPremiu VARCHAR2(40) NOT NULL REFERENCES premii_denumiri (DenPremiu), 
	Categorie VARCHAR2(30) NOT NULL,
	AnPremiu NUMBER(4) CHECK (Anpremiu > 1920),
	PRIMARY KEY (IdFilm, DenPremiu, Categorie)
	);

CREATE TABLE premii_interpretare (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	Actor NUMBER(6) REFERENCES cineasti (IdCineast), 
	DenPremiu VARCHAR2(40) NOT NULL REFERENCES premii_denumiri (DenPremiu), 
	Categorie VARCHAR2(30) NOT NULL, 
	AnPremiu NUMBER(4) CHECK (AnPremiu > 1920),
	PRIMARY KEY (IdFilm, Actor, DenPremiu, Categorie)
	) ;

CREATE TABLE casete (
	IdCaseta NUMBER(12) NOT NULL PRIMARY KEY, 
	DataCumpararii DATE CHECK (DataCumpararii > DATE'1998-01-01'), 
	ProducãtorCaseta VARCHAR2(30), 
	AnProdCaseta NUMBER(4) DEFAULT EXTRACT (YEAR FROM CURRENT_DATE)
		CHECK (AnProdCaseta > 1980),  
	PreþCumparare NUMBER(8), 
	StareCaseta VARCHAR2(20) DEFAULT 'Ok' NOT NULL 
		CHECK (StareCaseta IN ('Ok', 'Pierduta', 'Distrusa', 'Casata', 'Uzata')), 
	Disponibilitate CHAR(1) DEFAULT 'D' NOT NULL 
		CHECK (Disponibilitate IN ('D','N'))
	);

CREATE TABLE casete_filme (
	IdCaseta NUMBER(12) NOT NULL REFERENCES casete (Idcaseta), 
	FilmNr NUMBER(2) DEFAULT 1 NOT NULL
		CHECK (FilmNr BETWEEN 1 AND 30), 
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	ParteFilm NUMBER(2) DEFAULT 1 NOT NULL
		CHECK (ParteFilm BETWEEN 1 AND 30), 
	PRIMARY KEY (IdCaseta, FilmNr)
	) ;

CREATE TABLE clienti (
	CNPClient NUMBER(13) NOT NULL PRIMARY KEY, 
	NumeClient VARCHAR2(45) NOT NULL, 
	AdresaClient VARCHAR2(100), 
	TelefonClient VARCHAR2(25), 
	DataNasteriiClient DATE, 
	NivelStudiiClient VARCHAR2(15) DEFAULT 'Medii', 
	NrCaseteImprumutate NUMBER(6) DEFAULT 0
		CHECK (NrCaseteImprumutate >= 0), 	
	NrCaseteRestituite NUMBER(6) DEFAULT 0
		CHECK (NrCaseteRestituite >= 0),
	CHECK (NrCaseteImprumutate - NrCaseteRestituite BETWEEN 0 AND 4)
	);

CREATE TABLE imprumuturi (
	IdImpr NUMBER(15) NOT NULL PRIMARY KEY, 
	DataOraImpr DATE DEFAULT CURRENT_DATE, 
	CNPClient NUMBER(13) NOT NULL REFERENCES clienti(CNPClient),
	ValoareInchir NUMBER(7) DEFAULT 0 NOT NULL ;
	);

CREATE TABLE casete_imprumutate (
	IdImpr NUMBER(15) NOT NULL REFERENCES imprumuturi (IdImpr), 
	IdCaseta  NUMBER(12) NOT NULL REFERENCES casete (Idcaseta), 
	DataOraRestituirii DATE, 
	StareLaRestituire VARCHAR2(20) DEFAULT 'Ok'
		CHECK (StareLaRestituire IN ('Ok', 'Pierduta', 'Distrusa')), 
	Gratuita CHAR(1) DEFAULT 'N' NOT NULL 
		CHECK (Gratuita IN ('D','N')),
	Penalizare NUMBER(9) DEFAULT 0,
	PRIMARY KEY (IdImpr, IdCaseta)
	);

CREATE TABLE aprecieri_filme (
	IdFilm NUMBER(10) NOT NULL REFERENCES filme (IdFilm), 
	CNPClient  NUMBER(13) NOT NULL REFERENCES clienti(CNPClient), 
	Punctaj NUMBER(2) DEFAULT 0 NOT NULL
		CHECK (Punctaj BETWEEN 0 AND 10),
	PRIMARY KEY (IdFilm, CNPClient)
	);


-- @F:\USERI\MARIN\PROIECTAREABD2004\CAP07_Surogate_Restrictii_Incluziuni\Listing_7_27_creare_bd_centru_inchiriere.sql