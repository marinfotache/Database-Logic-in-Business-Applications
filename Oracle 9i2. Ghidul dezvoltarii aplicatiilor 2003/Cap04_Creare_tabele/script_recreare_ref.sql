
spool f:\oracle_carte\cap04_creare_tabele\re_creare_ref.sql


SELECT 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || constraint_name || ' CASCADE ;'
	AS "--Stergere restr. ref."
FROM user_constraints 
WHERE constraint_type = 'R' ;


SELECT 'ALTER TABLE ' || uc_copil.table_name || ' ADD CONSTRAINT ' || constraint_name || 
	' FOREIGN KEY  ' || '(' ||atrc1 || 
	CASE WHEN atrc2 IS NOT NULL THEN ', ' || atrc2 END || 
	CASE WHEN atrc3 IS NOT NULL THEN ', ' || atrc3 END	
	|| ') ' ||
	' REFERENCES ' || uc_parinte.table_name || ' (' ||atrp1 || 
	CASE WHEN atrp2 IS NOT NULL THEN ', ' || atrp2 END || 
	CASE WHEN atrp3 IS NOT NULL THEN ', ' || atrp3 END	
	|| ') ' AS "--Restrictii referentiale"
FROM user_constraints uc_copil 
	INNER JOIN user_constraints uc_parinte 
		ON uc_copil.r_constraint_name = uc_parinte.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atrc1
		 FROM user_cons_columns
		 WHERE position = 1) c1 ON uc_copil.constraint_name = c1.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atrc2
		 FROM user_cons_columns
		 WHERE position = 2) c2 ON uc_copil.constraint_name = c2.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atrc3
		 FROM user_cons_columns
		 WHERE position = 3) c3 ON uc_copil.constraint_name = c3.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atrp1
		 FROM user_cons_columns
		 WHERE position = 1) p1 ON uc_parinte.constraint_name = p1.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atrp2
		 FROM user_cons_columns
		 WHERE position = 2) p2 ON uc_parinte.constraint_name = p2.constraint_name
	LEFT OUTER JOIN  
		(SELECT constraint_name, column_name AS atrp3
		 FROM user_cons_columns
		 WHERE position = 3) p3 ON uc_parinte.constraint_name = p3.constraint_name
WHERE uc_copil.constraint_type = 'R' ;

spool off


