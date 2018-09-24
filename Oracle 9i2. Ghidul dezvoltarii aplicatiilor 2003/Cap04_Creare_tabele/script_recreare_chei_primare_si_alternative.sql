spool f:\oracle_carte\cap04_creare_tabele\re_creare_chei_primare_si_alternative.sql

SELECT 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || constraint_name || ' CASCADE ;'
	AS "--Stergere restrictie"
FROM user_constraints ;

SELECT 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT pk_' || table_name ||
	' PRIMARY KEY ' || '(' ||atr1 || 
	CASE WHEN atr2 IS NOT NULL THEN ', ' || atr2 END || 
	CASE WHEN atr3 IS NOT NULL THEN ', ' || atr3 END	
	|| ') ;' AS "--Cheile primare"
FROM user_constraints uc 
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atr1
		 FROM user_cons_columns
		 WHERE position = 1) a1 ON uc.constraint_name = a1.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atr2
		 FROM user_cons_columns
		 WHERE position = 2) a2 ON uc.constraint_name = a2.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atr3
		 FROM user_cons_columns
		 WHERE position = 3) a3 ON uc.constraint_name = a3.constraint_name
WHERE constraint_type = 'P';


SELECT 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT un_' || table_name || 
	'_' || atr1 ||
	CASE WHEN atr2 IS NOT NULL THEN '_' || atr2 END || 
	CASE WHEN atr3 IS NOT NULL THEN '_' || atr3 END	
	|| ' UNIQUE ' || '(' ||atr1 || 
	CASE WHEN atr2 IS NOT NULL THEN ', ' || atr2 END || 
	CASE WHEN atr3 IS NOT NULL THEN ', ' || atr3 END	
	|| ') ;' AS "--Cheile alternative"
FROM user_constraints uc 
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atr1
		 FROM user_cons_columns
		 WHERE position = 1) a1 ON uc.constraint_name = a1.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atr2
		 FROM user_cons_columns
		 WHERE position = 2) a2 ON uc.constraint_name = a2.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atr3
		 FROM user_cons_columns
		 WHERE position = 3) a3 ON uc.constraint_name = a3.constraint_name
WHERE constraint_type = 'U' ;

spool off


