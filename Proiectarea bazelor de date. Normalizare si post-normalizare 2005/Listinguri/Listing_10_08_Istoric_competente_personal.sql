DROP TABLE ist_competente_personal ;
CREATE TABLE ist_competente_personal (
 marca NUMBER (6) NOT NULL,
 idcompfrunza NUMBER (10) NOT NULL,
 nivel NUMBER(5) NOT NULL,   
 data_init DATE DEFAULT CURRENT_DATE NOT NULL,
 data_fin DATE DEFAULT NULL,
 PRIMARY KEY (marca, idcompfrunza, data_init)
 ) ;

---
CREATE OR REPLACE TRIGGER trg_competente_personal_ins
	AFTER INSERT ON competente_personal
	FOR EACH ROW
BEGIN
	INSERT INTO ist_competente_personal VALUES (:NEW.marca, 
		:NEW.idcompfrunza, :NEW.Nivel, SYSDATE, NULL) ;
END ;
/

---
CREATE OR REPLACE TRIGGER trg_competente_personal_del
	AFTER DELETE ON competente_personal
	FOR EACH ROW
BEGIN
	UPDATE ist_competente_personal SET data_fin = SYSDATE
	WHERE marca=:OLD.marca AND
 idcompfrunza=:OLD.IdCompFrunza AND data_fin IS NULL ;
END ;
/

---
CREATE OR REPLACE TRIGGER trg_competente_personal_upd
	AFTER UPDATE ON competente_personal
	FOR EACH ROW
DECLARE 
	v_data DATE := SYSDATE ;
BEGIN
	-- se declara "expirate" vechile valori
	UPDATE ist_competente_personal SET data_fin = v_data
	WHERE marca=:OLD.marca AND
 idcompfrunza=:OLD.IdCompFrunza AND data_fin IS NULL ;

	-- se insereaza noile valori
	INSERT INTO ist_competente_personal VALUES (:NEW.marca, 
		:NEW.idcompfrunza, :NEW.Nivel, 
v_data + 1 /(24*60*60), NULL) ;
END ;
/
