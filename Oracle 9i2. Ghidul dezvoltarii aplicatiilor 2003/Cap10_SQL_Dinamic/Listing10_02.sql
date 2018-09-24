-- procedura de stergere a unei tabele
CREATE OR REPLACE PROCEDURE p_sterge (
 tabela VARCHAR2) 
IS
 v_unu NUMBER(1) := 0 ; 
BEGIN
 SELECT 1 INTO v_unu FROM USER_TABLES WHERE table_name = UPPER(tabela) ;
 EXECUTE IMMEDIATE ' DROP TABLE ' || tabela ;
EXCEPTION 
 WHEN NO_DATA_FOUND THEN
  -- tabela nu exista, asa ca e mai bine sa n-o stergem !
  NULL ;
END p_sterge ;       


