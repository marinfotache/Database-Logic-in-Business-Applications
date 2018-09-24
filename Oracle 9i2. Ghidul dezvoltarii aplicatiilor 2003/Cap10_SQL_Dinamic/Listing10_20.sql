CREATE OR REPLACE PACKAGE pac_arhivare AUTHID CURRENT_USER AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE)   ;
END pac_arhivare ;
/
CREATE OR REPLACE PACKAGE BODY pac_arhivare AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE) 
IS
v_unu NUMBER(1) := 0 ;
BEGIN 
-- se verifica daca exista PONTAJE_nnnn
BEGIN 
SELECT 1 INTO v_unu FROM user_tables WHERE table_name = 'PONTAJE_' || an_ ;
EXCEPTION
WHEN NO_DATA_FOUND THEN -- nu exista, asa ca se creaza tabela
EXECUTE IMMEDIATE 'CREATE TABLE pontaje_' || an_ || 
' AS SELECT * FROM pontaje WHERE 1=2 '  ;

		-- se declara cheia primara a noii tabele	
EXECUTE IMMEDIATE 'ALTER TABLE pontaje_' || an_ || 
' ADD CONSTRAINT pk_pontaje_'|| an_ || ' PRIMARY KEY (marca, data) '  ;
  	END ;

-- se insereaza în PONTAJE_nnnn liniile din PONTAJE 
EXECUTE IMMEDIATE 'INSERT INTO pontaje_'|| an_ || 
' SELECT * FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, ''YYYY'')) = :1' USING an_ ;
-- se sterg din PONTAJE liniile arhivate
DELETE FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, 'YYYY')) = an_ ;
	COMMIT ;
END arhivare_pontaje ;

END pac_arhivare ;
/

