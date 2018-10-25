DROP TABLE linii_fact_arhivate ;
DROP TABLE incas_fact_arhivate ;
DROP TABLE incasari_arhivate ;
DROP TABLE fact_arhivate ;
CREATE TABLE fact_arhivate AS SELECT * FROM fact WHERE 1=2 ;
CREATE TABLE linii_fact_arhivate AS SELECT * FROM linii_fact WHERE 1=2 ;
CREATE TABLE incasari_arhivate AS SELECT * FROM incasari WHERE 1=2 ;
CREATE TABLE incas_fact_arhivate AS SELECT * FROM incas_fact WHERE 1=2 ;

ALTER TABLE fact_arhivate ADD DataArhivarii DATE ;
ALTER TABLE fact_arhivate ADD PRIMARY KEY (NrFact) ;

ALTER TABLE linii_fact_arhivate ADD DataArhivarii DATE ;
ALTER TABLE linii_fact_arhivate ADD PRIMARY KEY (NrFact, Linie) ;

ALTER TABLE incasari_arhivate ADD DataArhivarii DATE ;
ALTER TABLE incasari_arhivate ADD PRIMARY KEY (CodInc) ;

ALTER TABLE incas_fact_arhivate ADD DataArhivarii DATE ;
ALTER TABLE incas_fact_arhivate ADD PRIMARY KEY (CodInc, NrFact) ;


CREATE OR REPLACE PROCEDURE p_arhivare_fact (datafact_ DATE)
IS
BEGIN
	-- se adauga liniile de arhivat in tabele-arhiva
	INSERT INTO linii_fact_arhivate 
		SELECT linii_fact.*, SYSDATE 
		FROM linii_fact 
		WHERE nrfact IN 
			(SELECT nrfact FROM fact 
				WHERE datafact <= datafact_) ;
	INSERT INTO fact_arhivate 
		SELECT fact.*, SYSDATE FROM fact WHERE datafact <= datafact_ ;

	INSERT INTO incasari_arhivate 
		SELECT incasari.*, SYSDATE FROM incasari 
		WHERE codinc IN 
			(SELECT codinc FROM incas_fact WHERE nrfact IN 
			(SELECT nrfact FROM fact WHERE datafact <= datafact_) 
				);
	INSERT INTO incas_fact_arhivate 
		SELECT incas_fact.*, SYSDATE FROM incas_fact
		WHERE nrfact IN (SELECT nrfact FROM fact 
				WHERE datafact <= datafact_) ;


	-- se dezactivea declasatoarele, pentru a evita verificarile suplimentare
	-- 	si actualizarea atributelor calculate
	EXECUTE IMMEDIATE ' ALTER TABLE linii_fact DISABLE ALL TRIGGERS ' ;
	EXECUTE IMMEDIATE ' ALTER TABLE incas_fact DISABLE ALL TRIGGERS ' ;
	EXECUTE IMMEDIATE ' ALTER TABLE fact DISABLE ALL TRIGGERS ' ;
	EXECUTE IMMEDIATE ' ALTER TABLE incasari DISABLE ALL TRIGGERS ' ;

	-- se sterg liniile arhivate
	DELETE FROM linii_fact	WHERE nrfact IN 
		(SELECT nrfact FROM fact WHERE datafact <= datafact_) ;
	DELETE FROM incas_fact WHERE nrfact IN 
		(SELECT nrfact FROM fact WHERE datafact <= datafact_) ;
	DELETE FROM incasari WHERE codinc IN 
		(SELECT codinc FROM incasari_arhivate) ;

	DELETE FROM fact WHERE datafact <= datafact_ ;

	-- se reactiveaza declasatoarele
	EXECUTE IMMEDIATE 'ALTER TABLE linii_fact ENABLE ALL TRIGGERS ' ;
	EXECUTE IMMEDIATE 'ALTER TABLE fact ENABLE ALL TRIGGERS ' ;
	EXECUTE IMMEDIATE 'ALTER TABLE incasari ENABLE ALL TRIGGERS ' ;
	EXECUTE IMMEDIATE 'ALTER TABLE incas_fact ENABLE ALL TRIGGERS ' ;
END ;
/