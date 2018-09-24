CREATE OR REPLACE PACKAGE pac_arhivare AUTHID CURRENT_USER AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE)   ;
END pac_arhivare ;
/

CREATE OR REPLACE PACKAGE BODY pac_arhivare AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE) 
IS
 TYPE t_refcursor IS REF CURSOR ; -- declararea tipului variabila-cursor
 v_cursor t_refcursor ;
 rec_cursor pontaje%ROWTYPE ;
 v_unu NUMBER(1) := 0 ;
 TYPE t_pontaje IS RECORD (orelucrate pontaje.orelucrate%TYPE, oreco pontaje.oreco%TYPE,
   orenoapte pontaje.orenoapte%TYPE, oreabsnem pontaje.oreabsnem%TYPE ) ;
  v_pontaje t_pontaje ;
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

 -- se extrag eventualele linii din PONTAJE_nnnn care exista in PONTAJE pentru a fi actualizate
 OPEN v_cursor FOR 'SELECT marca, data FROM pontaje_'||an_|| 
   ' WHERE (marca, data) IN (SELECT marca, data FROM pontaje) ' ; 
 LOOP 
   FETCH v_cursor INTO rec_cursor ;
   EXIT WHEN v_cursor%NOTFOUND ;
  	EXECUTE IMMEDIATE 'SELECT orelucrate, oreco, orenoapte, oreabsnem 
          FROM pontaje WHERE marca = :1 AND data = :2 '
           INTO v_pontaje USING rec_cursor.marca, rec_cursor.data   ;

   EXECUTE IMMEDIATE 'UPDATE pontaje_' || an_ || 
    ' SET orelucrate = :1 , oreco = :2, orenoapte = :3, oreabsnem = :4 
        WHERE marca= :5 AND data = :6 ' USING v_pontaje.orelucrate, 
          v_pontaje.oreco, v_pontaje.orenoapte, v_pontaje.oreabsnem, 
          rec_cursor.marca, rec_cursor.data ;

  END LOOP ;
  CLOSE v_cursor ;
  
 -- se insereaza in PONTAJE_nnnn liniile din PONTAJE ce nu exista in prima tabela
 EXECUTE IMMEDIATE 'INSERT INTO pontaje_'|| an_ || 
   ' SELECT * FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, ''YYYY'')) = :1
      AND (marca, data) NOT IN (SELECT marca, data FROM pontaje_'||an_|| ') ' USING an_ ;

  -- se sterg din PONTAJE liniile arhivate
  DELETE FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, 'YYYY')) = an_ ;
 
  COMMIT ;
END arhivare_pontaje ;

END pac_arhivare ;
