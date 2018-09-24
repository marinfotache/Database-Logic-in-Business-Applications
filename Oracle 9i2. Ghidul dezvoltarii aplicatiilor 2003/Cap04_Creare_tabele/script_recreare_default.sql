
DROP TABLE temp2;
DROP TABLE temp1;

CREATE TABLE temp1 (
	tabela VARCHAR2(25),
	atribut VARCHAR2(25),
	id_atribut NUMBER(2),
	tip_atribut VARCHAR2(20),
	val_implicita CLOB
	) ;

CREATE TABLE temp2 (
	tabela VARCHAR2(30),
	atribut VARCHAR2(30),
	id_atribut NUMBER(3),
	tip_atribut VARCHAR2(30),
	val_implicita VARCHAR2(30)
	) ;


INSERT INTO temp1
	SELECT table_name, column_name, column_id, data_type, 
		TO_LOB(data_default)
	FROM user_tab_columns
	WHERE data_default IS NOT NULL ;

INSERT INTO temp2
	SELECT tabela, atribut, id_atribut, tip_atribut, 
		TRIM (BOTH CHR(10) FROM val_implicita)
	FROM temp1 ;

COMMIT ;

spool f:\oracle_carte\cap04_creare_tabele\re_creare_default.sql

SELECT ' ALTER TABLE ' || tabela || ' MODIFY ' || 
	atribut || ' DEFAULT '|| RTRIM(val_implicita) || ';' AS  " -- coloana "
FROM temp2 ;

spool off


