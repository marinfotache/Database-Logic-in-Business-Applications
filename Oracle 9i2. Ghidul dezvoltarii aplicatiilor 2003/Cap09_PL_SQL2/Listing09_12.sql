SET HEADING OFF
SELECT text AS “ “
FROM user_source
WHERE name = ‘P_POPULARE_PONTAJE_AN’ 
ORDER BY line ;
SPOOL f:\oracle_carte\p_populare_pontaje_an.sql
/
SPOOL OFF
SET HEADING ON
