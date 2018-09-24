DROP TABLE temp1;

CREATE TABLE temp1 (
	descriere VARCHAR2(500),
	corp_trigger CLOB
	) ;

INSERT INTO temp1
	SELECT description, TO_LOB(trigger_body)
FROM user_triggers ;

COMMIT ;

SPOOL f:\oracle_carte\cap11_declansatoare\re_creare_triggere.sql

SELECT 'CREATE OR REPLACE TRIGGER ' || descriere || '  ' || 
	CAST (corp_trigger AS VARCHAR2(3000)) || ' ;'
	AS "--Re-creare declansatoare"
FROM temp1  ;

SPOOL OFF
