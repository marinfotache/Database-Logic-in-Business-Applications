DROP TABLE incas_fact ;
DROP TABLE incasari ;
DROP TABLE linii_fact ;
DROP TABLE fact ;
DROP TABLE produse ;
DROP TABLE clienti2 ;
DROP TABLE coduri_postale ;
DROP TABLE judete ;

CREATE TABLE judete (
    jud CHAR(2) PRIMARY KEY CHECK (jud=LTRIM(UPPER(jud))),
    judet VARCHAR2(25) UNIQUE NOT NULL CHECK (judet=LTRIM(INITCAP(judet))),
    regiune VARCHAR2(15) DEFAULT 'Moldova'
        CHECK (regiune IN ('Banat', 'Transilvania', 'Dobrogea',
            'Oltenia', 'Muntenia', 'Moldova'))
    ) ;

CREATE TABLE coduri_postale (
    codpost NUMBER(6) PRIMARY KEY,
    localitate VARCHAR2(25) NOT NULL CHECK (localitate=LTRIM(INITCAP(localitate))),
    comuna VARCHAR2(20) CHECK (comuna=LTRIM(INITCAP(comuna))),      
    jud CHAR(2) DEFAULT 'IS' REFERENCES judete(jud)
    ) ;

CREATE TABLE produse (
    codpr NUMBER(6) PRIMARY KEY CHECK (codpr > 0),
    denpr VARCHAR2(30) CHECK (SUBSTR(denpr,1,1) = UPPER(SUBSTR(denpr,1,1))),
    um VARCHAR2(10),
    grupa VARCHAR2(15) CHECK (SUBSTR(grupa,1,1) = UPPER(SUBSTR(grupa,1,1))),
    procTVA NUMBER(2,2) DEFAULT .19
    ) ;

CREATE TABLE clienti2 (
    codcl NUMBER(6) PRIMARY KEY CHECK (codcl > 1000),
    dencl VARCHAR2(30) CHECK (SUBSTR(dencl,1,1) = UPPER(SUBSTR(dencl,1,1))),
    codfiscal CHAR(9) NOT NULL 
        CHECK (SUBSTR(codfiscal,1,1) = UPPER(SUBSTR(codfiscal,1,1))),
    stradacl VARCHAR2(30)
        CHECK (SUBSTR(stradacl,1,1) = UPPER(SUBSTR(stradacl,1,1))),
    nrstradacl VARCHAR2(7),
    blocscapcl VARCHAR2(20),
    telefon VARCHAR2(10),
    codpost NUMBER(6) REFERENCES coduri_postale(codpost)
    ) ;

CREATE TABLE fact (
    nrfact NUMBER(8) PRIMARY KEY,
    datafact DATE DEFAULT SYSDATE,
    codcl NUMBER(6) REFERENCES clienti2(codcl) ,
    Obs VARCHAR2(50)
    ) ;

CREATE TABLE linii_fact (
    nrfact NUMBER(8) REFERENCES fact(nrfact),
    linie NUMBER(2) CHECK (linie > 0),
    codpr NUMBER(6) REFERENCES produse(codpr),
    cantitate NUMBER(10),
    pretunit NUMBER (12),
    PRIMARY KEY (nrfact,linie)
    ) ;

CREATE TABLE incasari (
    codinc NUMBER(8) PRIMARY KEY,
    datainc DATE DEFAULT SYSDATE,
    coddoc CHAR(4) CHECK(coddoc=UPPER(LTRIM(coddoc))),
    nrdoc VARCHAR2(16),
    datadoc DATE DEFAULT SYSDATE - 7
    ) ;

CREATE TABLE incas_fact (
    codinc NUMBER(8) REFERENCES incasari(codinc) ,
    nrfact NUMBER(8) REFERENCES fact(nrfact),
    transa NUMBER(16) NOT NULL,
    PRIMARY KEY (codinc, nrfact)
    ) ;

-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_01_creare_bd_vinzari.sql