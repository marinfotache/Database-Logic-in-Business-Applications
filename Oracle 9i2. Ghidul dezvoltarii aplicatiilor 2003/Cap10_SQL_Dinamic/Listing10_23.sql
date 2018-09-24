-- SQL dinamic si inmanunchiat
CREATE OR REPLACE PACKAGE pac_arhivare AUTHID CURRENT_USER AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE)   ;
END pac_arhivare ;
/

CREATE OR REPLACE PACKAGE BODY pac_arhivare AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE) 
IS
 v_unu NUMBER(1) := 0 ;
  TYPE t_marca IS TABLE OF pontaje.marca%TYPE INDEX BY PLS_INTEGER ;
  v_marca t_marca ;
  TYPE t_data IS TABLE OF pontaje.data%TYPE INDEX BY PLS_INTEGER ;
  v_data t_data ;
BEGIN 
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

 	-- se salveaza in doi vectori cheile primare ale înregistrarilor ce urmeaza a fi actualizate
   EXECUTE IMMEDIATE 'SELECT marca, data FROM pontaje_'||an_ || ' WHERE (marca, data) IN 
    (SELECT marca, data FROM pontaje) ' BULK COLLECT INTO v_marca, v_data ;

  -- se folosesc cele doua tablouri pentru actualizarea PONTAJE_2002
  FORALL i IN 1..v_marca.COUNT EXECUTE IMMEDIATE
     'UPDATE pontaje_'|| an_ || ' p1 
      SET (orelucrate, oreco, orenoapte, oreabsnem) =
         (SELECT orelucrate, oreco, orenoapte, oreabsnem FROM pontaje  p2 
          WHERE p2.marca = p1.marca AND p1.data = p2.data)
     WHERE marca = :1 AND data = :2 ' USING v_marca(i), v_data(i) ;

   -- se insereaza in PONTAJE_nnnn liniile din PONTAJE ce nu exista in prima tabela
 EXECUTE IMMEDIATE 'INSERT INTO pontaje_'|| an_ || 
   ' SELECT * FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, ''YYYY'')) = :1
      AND (marca, data) NOT IN (SELECT marca, data FROM pontaje_'||an_|| ') ' USING an_ ;

  -- se sterg din PONTAJE liniile arhivate
  DELETE FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, 'YYYY')) = an_ ;
  COMMIT ;
END arhivare_pontaje ;

END pac_arhivare ;
