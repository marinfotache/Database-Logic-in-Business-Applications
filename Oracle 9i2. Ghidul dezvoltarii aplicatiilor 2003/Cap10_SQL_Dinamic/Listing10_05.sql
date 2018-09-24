CREATE OR REPLACE PACKAGE BODY pac_administrare  AS
---------------------------------------------------------------------
PROCEDURE p_creare_tabele ( 
tabela VARCHAR2, v_atribute t_atribute,  
v_tip_atribute t_atribute,  v_restrictii_atribute t_restrictii_atribute,
v_restrictii_tabela t_atribute ) 
IS
sir1 VARCHAR2 (4000) := ' ' ;
sir2 VARCHAR2 (2000) := ' ' ;
ultimul_check NUMBER(2) := 0 ;
ultimul_unique NUMBER(2) := 0 ; 
ultimul_reference NUMBER(2) := 0 ;  
ultimul_atribut VARCHAR2(30) := NULL ;
nume_restrictie VARCHAR2(30) ;
 BEGIN 
p_sterge_tabela (tabela) ;
sir1 := 'CREATE TABLE ' || tabela || ' (' ;

-- se parcurg atributele 
FOR i IN 1..v_atribute.COUNT LOOP
-- de la al doilea atribut introducem separatorul virgula
IF i > 1 THEN 
sir1 := sir1 || ', ' ;
END IF   ;
sir1 := sir1 || v_atribute (i) || ' ' || v_tip_atribute (i) || ' ' ;
  
-- pentru fiecare atribut se trec în revista restrictiile sale
FOR j IN 1..99 LOOP
-- atentie la formatul EXISTS pentru vectorii bidimensionali !
IF v_restrictii_atribute(i).EXISTS(j) THEN 
-- se cauta un nume pentru restrictie
CASE
WHEN v_restrictii_atribute(i)(j) LIKE '%PRIMARY KEY%' THEN
nume_restrictie := 'PK_' || tabela ;
WHEN v_restrictii_atribute(i)(j) LIKE '%UNIQUE%' THEN     
nume_restrictie := 'UN_' || tabela || '_' || v_atribute (i) ;
WHEN v_restrictii_atribute(i)(j) LIKE '%NOT NULL%' THEN     
nume_restrictie := 'NN_' || tabela || '_' || v_atribute (i) ;
WHEN v_restrictii_atribute(i)(j) LIKE '%REFERENCES%' THEN     
nume_restrictie := 'FK_' || tabela || '_' || v_atribute (i) ;
WHEN v_restrictii_atribute(i)(j) LIKE '%CHECK%' THEN     
-- sunt posibile mai multe CHECK-uri pentru acelasi atribut
IF NVL(ultimul_atribut, ' ' ) =  v_atribute (i) THEN 
ultimul_check := ultimul_check + 1 ;
ELSE
ultimul_atribut := v_atribute (i) ;
ultimul_check := 1 ;
END IF ; 
nume_restrictie := 'CK_' || tabela || '_' || v_atribute (i) || '_' || ultimul_check ;
END CASE ;
-- se introduce în comanda CREATE TABLE clauza CONSTRAINT
sir1 := sir1 || ' CONSTRAINT '|| nume_restrictie || ' ' || v_restrictii_atribute(i)(j) || ' ' ;    
ELSE
EXIT ;  
END IF ;
END LOOP ; 
END LOOP ;
-- se trec în revista eventualele restrictii la nivel de înregistrare
ultimul_unique := 0 ;
ultimul_check := 0 ;
ultimul_reference := 0 ;
FOR i IN 1..99 LOOP 
IF v_restrictii_tabela.EXISTS(i) THEN 
-- mai întâi se cauta un nume pentru restrictie
CASE
WHEN v_restrictii_tabela(i) LIKE '%PRIMARY KEY%' THEN
nume_restrictie := 'PK_' || tabela ;
WHEN v_restrictii_tabela(i) LIKE '%UNIQUE%' THEN     
-- sunt posibile mai multe UNIQUE-uri la nivel de tabela
ultimul_unique := ultimul_unique + 1  ;
nume_restrictie := 'UN_' || tabela || '_' || ultimul_unique ;
WHEN v_restrictii_tabela(i) LIKE '%CHECK%' THEN     
-- sunt posibile mai multe CHECK-uri
ultimul_check := ultimul_check + 1  ;
nume_restrictie := 'CK_' || tabela || '_' || ultimul_check ;
WHEN v_restrictii_tabela(i) LIKE '%REFERENCES%' THEN     
-- sunt posibile mai multe REFERENCES-uri 
ultimul_reference := ultimul_reference + 1  ;
nume_restrictie := 'FK_' || tabela || '_' || ultimul_reference ;
END CASE ;
-- se introduce clauza CONSTRAINT pentru restrictiile la nivel de înregistrare
sir2 := sir2 || ', CONSTRAINT '|| nume_restrictie || ' ' || v_restrictii_tabela(i) || ' ' ;    
ELSE
EXIT ;  
END IF ;
END LOOP ;
sir2 := sir2 || ' )' ;

-- si acum, crearea !!!
EXECUTE IMMEDIATE ' ' || sir1 || sir2 ;
END p_creare_tabele  ;


---------------------------------------------------------------------
PROCEDURE p_sterge_tabela (tabela VARCHAR2) 
IS
v_unu NUMBER(1) := 0 ; 
BEGIN
SELECT 1 INTO v_unu FROM USER_TABLES WHERE table_name = UPPER(tabela) ;
EXECUTE IMMEDIATE ' DROP TABLE ' || tabela ;
EXCEPTION 
WHEN NO_DATA_FOUND THEN
-- tabela nu exista, asa ca e mai bine sa n-o stergem !
NULL ;
END p_sterge_tabela ;       


---------------------------------------------------------------------
PROCEDURE p_dezactiveaza_restrictii (tabela VARCHAR2)
IS
v_restrictii t_atribute ;
BEGIN
SELECT constraint_name BULK COLLECT INTO v_restrictii 
FROM user_constraints WHERE table_name = UPPER(RTRIM(tabela)) ;
 
FOR i IN 1..v_restrictii.COUNT LOOP
EXECUTE IMMEDIATE 'ALTER TABLE ' || tabela || ' DISABLE CONSTRAINT ' || v_restrictii (i) ;
END LOOP ;
END p_dezactiveaza_restrictii ;

---------------------------------------------------------------------
PROCEDURE p_dezactiveaza_restrictii (v_restrictii t_atribute )
IS
tabela VARCHAR2 (50) ;
BEGIN
FOR i IN 1..v_restrictii.COUNT LOOP
SELECT table_name INTO tabela FROM user_constraints 
WHERE constraint_name = UPPER(RTRIM(v_restrictii (i))) ;
EXECUTE IMMEDIATE 'ALTER TABLE ' || tabela || ' DISABLE CONSTRAINT ' || v_restrictii (i) ;
END LOOP ;
END p_dezactiveaza_restrictii ;


--------------------------------------------------------------------- 
PROCEDURE p_activeaza_restrictii (tabela VARCHAR2) 
IS
v_restrictii t_atribute ;
BEGIN
SELECT constraint_name BULK COLLECT INTO v_restrictii 
FROM user_constraints WHERE table_name = UPPER(RTRIM(tabela)) ;
FOR i IN 1..v_restrictii.COUNT LOOP
EXECUTE IMMEDIATE 'ALTER TABLE ' || tabela || ' ENABLE CONSTRAINT ' || v_restrictii (i) ;
END LOOP ;
END p_activeaza_restrictii ;


-------------------------------------------------------------------------
PROCEDURE p_activeaza_restrictii (v_restrictii t_atribute )
IS
tabela VARCHAR2 (50) ;
BEGIN
FOR i IN 1..v_restrictii.COUNT LOOP
SELECT table_name INTO tabela FROM user_constraints 
WHERE constraint_name = UPPER(RTRIM(v_restrictii (i))) ;
 EXECUTE IMMEDIATE 'ALTER TABLE ' || tabela || ' ENABLE CONSTRAINT ' || v_restrictii (i) ;
END LOOP ;
END p_activeaza_restrictii ;

END pac_administrare ;

