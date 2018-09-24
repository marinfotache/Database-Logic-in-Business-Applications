SET HEADING OFF
SELECT ' ALTER PROCEDURE ' || object_name || ' COMPILE ;'
 FROM user_objects
 WHERE object_type = 'PROCEDURE' 
ORDER BY object_id ;
SPOOL f:\oracle_carte\cap09_PL_SQL2\recompilare_proceduri.txt
/
SPOOL OFF
SET HEADING ON
@f:\oracle_carte\cap09_PL_SQL2\recompilare_proceduri.txt

