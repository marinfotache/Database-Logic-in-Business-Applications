SET HEADING OFF
SELECT ' ALTER FUNCTION ' || object_name || ' COMPILE ;'
 FROM user_objects
 WHERE object_type = 'FUNCTION' 
ORDER BY object_id ;
SPOOL f:\oracle_carte\cap09_PL_SQL2\recompilare_functii.txt
/
SPOOL OFF
SET HEADING ON
@f:\oracle_carte\cap09_PL_SQL2\recompilare_functii.txt

