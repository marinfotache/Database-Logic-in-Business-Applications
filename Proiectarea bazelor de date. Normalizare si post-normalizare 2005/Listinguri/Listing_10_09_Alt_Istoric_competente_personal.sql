DROP SEQUENCE seq_idjurnalizare ;
CREATE SEQUENCE seq_idjurnalizare 
	START WITH 1 MINVALUE 1 MAXVALUE 99999999999999
	NOCYCLE NOCACHE ORDER INCREMENT BY 1 ;

DROP TABLE ist_competente_personal ;

CREATE TABLE ist_competente_personal (
 idjurnalizare_init NUMBER(14) PRIMARY KEY, 
 marca NUMBER (6) NOT NULL,
 idcompfrunza NUMBER (10) NOT NULL,
 nivel NUMBER(5) NOT NULL,   
 data_init DATE DEFAULT CURRENT_DATE NOT NULL,
 data_fin DATE DEFAULT NULL,
 idjurnalizare_fin NUMBER(14) DEFAULT NULL
 ) ;


-------
CREATE OR REPLACE TRIGGER trg_competente_personal_ins
	AFTER INSERT ON competente_personal
	FOR EACH ROW
BEGIN
	INSERT INTO ist_competente_personal VALUES (seq_idjurnalizare.NextVal,
		:NEW.marca, :NEW.idcompfrunza, :NEW.Nivel, SYSDATE, NULL, NULL) ;
END ;
/

-----
CREATE OR REPLACE TRIGGER trg_competente_personal_del
	AFTER DELETE ON competente_personal
	FOR EACH ROW
BEGIN
	UPDATE ist_competente_personal 
	SET data_fin = SYSDATE, idjurnalizare_fin = seq_idjurnalizare.NextVal
	WHERE marca=:OLD.marca AND idcompfrunza=:OLD.IdCompFrunza
		AND data_fin IS NULL ;
END ;
/

-----
CREATE OR REPLACE TRIGGER trg_competente_personal_upd
	AFTER UPDATE ON competente_personal
	FOR EACH ROW
DECLARE 
	v_data DATE ;
BEGIN
	v_data := SYSDATE ;

	-- se declara "expirate" vechile valori
	UPDATE ist_competente_personal 
	SET data_fin = v_data, idjurnalizare_fin = seq_idjurnalizare.NextVal
	WHERE marca=:OLD.marca AND idcompfrunza=:OLD.IdCompFrunza
		AND data_fin IS NULL ;

	-- se insereaza noile valori
	INSERT INTO ist_competente_personal VALUES (seq_idjurnalizare.CurrVal,
		:NEW.marca, :NEW.idcompfrunza, 
		:NEW.Nivel, v_data + 1 /(24*60*60), NULL, NULL) ;

END ;
/


-----
SELECT *
FROM 
	(SELECT * 
	FROM ist_competente_personal
	START WITH marca IN (SELECT marca
			FROM personal9
			WHERE numepren='Mihuleac Iulian')
	CONNECT BY PRIOR idjurnalizare_init=idjurnalizare_fin
	)
ORDER BY data_init


--------------------------------------------
SELECT dencompetenta, nivel
FROM competente c INNER JOIN 
	(SELECT *
	FROM 
		(SELECT * 
		FROM ist_competente_personal
		START WITH marca IN (SELECT marca
			FROM personal9
			WHERE numepren='Mihuleac Iulian')
		CONNECT BY PRIOR idjurnalizare_init=idjurnalizare_fin
		)
	WHERE	TO_DATE('2005-02-16 10:25','YYYY-MM-DD HH24:MI')
		BETWEEN data_init AND NVL(data_fin, SYSDATE)
	) cp ON c.idcompetenta=cp.idcompfrunza










