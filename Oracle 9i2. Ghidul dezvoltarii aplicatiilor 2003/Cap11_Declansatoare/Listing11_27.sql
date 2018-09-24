
SPOOL f:\oracle_carte\cap11_declansatoare\re_creare_triggere.sql

SELECT text
FROM 
	(SELECT name, line, text
	 FROM user_triggers ut INNER JOIN user_source us ON ut.trigger_name=us.name
		UNION 
	 SELECT trigger_name, 0, 'CREATE OR REPLACE '
	 FROM user_triggers
		UNION 
	 SELECT trigger_name, -1, '-------------------------------------------------------- '
	 FROM USER_triggers 
		UNION 
	 SELECT trigger_name, -2, ' '
	 FROM USER_triggers 
	 ORDER BY 1,2
	 ) ;

SPOOL OFF

h