spool f:\oracle_carte\cap04_creare_tabele\re_creare_check.sql

DROP TABLE temp1;

CREATE TABLE temp1 (
	restrictie VARCHAR2(30),
	tip_restrictie varchar(20),
	tabela VARCHAR2(30),
	expresie CLOB
	) ;

INSERT INTO temp1
	SELECT constraint_name, constraint_type, table_name, 
		TO_LOB(search_condition)
	FROM user_constraints
	WHERE constraint_type = 'C' ;

COMMIT ;

SELECT 'ALTER TABLE ' || tabela || ' DROP CONSTRAINT ' || restrictie || ' ;'
	AS "--Stergere reguli de validare"
FROM temp1  
WHERE expresie NOT LIKE '%NULL%' ;


SELECT ' ALTER TABLE ' || tabela  || ' ADD CONSTRAINT ' || restrictie ||
	' CHECK (' || CAST (expresie AS VARCHAR2(300)) || ') ;' AS "-- check-uri"
FROM temp1
WHERE expresie NOT LIKE '%NULL%' ;

spool off


