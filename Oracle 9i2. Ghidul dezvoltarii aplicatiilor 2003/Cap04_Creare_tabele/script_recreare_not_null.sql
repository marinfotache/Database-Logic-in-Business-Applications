spool f:\oracle_carte\cap04_creare_tabele\re_creare_notnull.sql


SELECT ' ALTER TABLE ' || table_name|| ' MODIFY ( ' || column_name
	|| ' CONSTRAINT NN_' || table_name || '_' || column_name || ' NOT NULL ); '
FROM user_tab_columns 
WHERE nullable = 'N' 
ORDER BY table_name, column_name ;

spool off


