CREATE OR REPLACE PACKAGE pac_arhivare AUTHID CURRENT_USER AS
PROCEDURE arhivare_pontaje (an_ salarii.an%TYPE)   ;
PROCEDURE fuziune_pontaje (data_initiala DATE, data_finala DATE) ;
END pac_arhivare ;
/

CREATE OR REPLACE PACKAGE BODY pac_arhivare AS

PROCEDURE fuziune_pontaje (data_initiala DATE, data_finala DATE) 
IS
	an_inceput NUMBER (4) ;  -- primul an din intervalul de fuziune
	an_sfirsit NUMBER (4) ;  -- ultimul an din intervalul de fuziune 
	data_in_an_crt DATE ;   -- data de inceput din anul curent
	data_sf_an_crt DATE ;   -- data de final din anul curent
	TYPE rc_tabela IS REF CURSOR ;
	c_tabela rc_tabela ;
	tab_ VARCHAR2(30) ;
BEGIN 
	-- folosim o tabela - PONTAJE_TEMP, pe care o cream (daca e nevoie)
	BEGIN 
		SELECT table_name INTO tab_	FROM user_tables WHERE table_name = 'PONTAJE_TEMP' ;	
			EXECUTE IMMEDIATE 'DELETE FROM ' || tab_ ;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN 
			EXECUTE IMMEDIATE	'CREATE TABLE pontaje_temp AS SELECT * FROM pontaje WHERE 1=2' ;
	END ;	
	-- dupa acest bloc PONTAJE_TEMP exista si n-are inregistrari

	-- extragerea anilor initial si final ai intervalului calendaristic
	an_inceput := TO_NUMBER(TO_CHAR(data_initiala, 'YYYY')) ;
	an_sfirsit := TO_NUMBER(TO_CHAR(data_finala, 'YYYY')) ;

	FOR i IN an_inceput .. an_sfirsit LOOP 	-- bucla executata pentru fiecare an din interval 
   tab_ := 'PONTAJE_' || i ;
		 -- cursorul C_TABELA contine cel mult o linie, daca exista tabela PONTAJE_nnnn, unde nnnn = i
    OPEN c_tabela FOR 'SELECT table_name FROM user_tables WHERE table_name = :1 ' USING tab_ ;
    FETCH c_tabela INTO tab_ ;
  
		 IF c_tabela%ROWCOUNT > 0 THEN	-- exista tabela pentru acest an
 	 		-- pentru anul curent, datele initiale si finale implicite sunt 1 ian. si 31 dec.
			  data_in_an_crt := TO_DATE('01/01/'||i, 'DD/MM/YYYY') ;
			  data_sf_an_crt := TO_DATE('31/12/'||i, 'DD/MM/YYYY') ;

  			-- daca e primul an din interval, data initiala ia valoarea - DATA_IN
		  	IF i = an_inceput THEN 	 
  				data_in_an_crt := data_initiala ;
		  	END IF ;
			
  			-- daca e ultimul an din interval, data finala	ia valoarea DATA_SF
		  	IF i = an_sfirsit THEN 	-- este ultimul an din interval 
				  data_sf_an_crt := data_finala ;
  			END IF	;			
			
		  	-- inserarea liniilor din PONTAJE_nnnn in PONTAJE_TEMP
  			EXECUTE IMMEDIATE
		  		'INSERT INTO pontaje_temp SELECT * FROM pontaje_' || i || ' WHERE data BETWEEN :1 AND :2 ' 
  		  		USING data_in_an_crt, data_sf_an_crt ;
   END IF ;

 COMMIT;
	END LOOP ;
END ;


-----------------------------------------------------------------------------
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
