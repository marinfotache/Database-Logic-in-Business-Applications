column "--Creare_tabele" FORMAT A60
column C2 FORMAT A40

spool f:\oracle_carte\cap04_creare_tabele\re_creare_tabele.sql
SELECT
    '  CREATE TABLE ' || table_name || ' ( '  AS "--Creare_tabele",
    '--' || RPAD(table_name,30) || ' ' as c2
FROM user_tables
UNION
 SELECT CASE column_id WHEN 1 THEN ' ' ELSE ',' END ||
            column_name || ' ' || data_type ||
	CASE WHEN data_type NOT IN ('NUMBER', 'CHAR', 'VARCHAR2') THEN ' '	
		ELSE ' ( ' ||
                    NVL(data_precision, data_length) ||
		            CASE WHEN data_scale > 0 THEN ', '|| data_scale ELSE '' END
	            || ')'
	END ,
            '--' || RPAD(table_name,30) || TO_CHAR(column_id,'999')
    FROM user_tab_columns
 UNION
    SELECT ' ) ;' || CHR(13) , '--' || RPAD(table_name,30) || ' ' || CHR(123)
    FROM user_tables
UNION
    SELECT ' ' || CHR(13) , '--' || RPAD(table_name,30) || ' ' || CHR(124)
    FROM user_tables
ORDER BY 2  ;

spool off