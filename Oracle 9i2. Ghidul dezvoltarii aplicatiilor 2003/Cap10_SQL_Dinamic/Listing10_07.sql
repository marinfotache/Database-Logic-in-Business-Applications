-- activari si dezactivari de restrictii folosind SQL dinamic

DECLARE
 v_restr pac_administrare.t_atribute ;

BEGIN 
 DBMS_OUTPUT.PUT_LINE ('INAINTE de dezactivare, restrictiile tabelei CONCEDII:') ;  
 FOR rec_1 IN (SELECT constraint_name, status FROM user_constraints 
    WHERE table_name = 'CONCEDII') LOOP
   DBMS_OUTPUT.PUT_LINE ('Restrictie '|| rec_1.constraint_name || ', stare:'||rec_1.status) ;
 END LOOP ;

  -- se dezactiveaza toate restrictiile tabelei CONCEDII
  pac_administrare.p_dezactiveaza_restrictii('CONCEDII');
 DBMS_OUTPUT.PUT_LINE (' ');
 DBMS_OUTPUT.PUT_LINE ('DUPA dezactivare, restrictiile tabelei CONCEDII:') ;  
 FOR rec_1 IN (SELECT constraint_name, status FROM user_constraints 
    WHERE table_name = 'CONCEDII') LOOP
   DBMS_OUTPUT.PUT_LINE ('Restrictie '|| rec_1.constraint_name || ', stare:'||rec_1.status) ;
  END LOOP ;

  -- se RE-activeaza toate restrictiile tabelei CONCEDII
 pac_administrare.p_activeaza_restrictii('CONCEDII');
 DBMS_OUTPUT.PUT_LINE (' ');
 DBMS_OUTPUT.PUT_LINE ('Dupa RE-activare, restrictiile tabelei CONCEDII:') ;  
 FOR rec_1 IN (SELECT constraint_name, status FROM user_constraints 
    WHERE table_name = 'CONCEDII') LOOP
   DBMS_OUTPUT.PUT_LINE ('Restrictie '|| rec_1.constraint_name || ', stare:'||rec_1.status) ;
  END LOOP ;

 v_restr (1) := 'PK_CONCEDII' ;
 v_restr (2) := 'FK_CONCEDII_MARCA' ;
 pac_administrare.p_dezactiveaza_restrictii(v_restr) ;

 DBMS_OUTPUT.PUT_LINE (' ');
 DBMS_OUTPUT.PUT_LINE ('Dupa dezactivarea celor doua, restrictiile tabelei CONCEDII:') ;  
 FOR rec_1 IN (SELECT constraint_name, status FROM user_constraints 
    WHERE table_name = 'CONCEDII') LOOP
   DBMS_OUTPUT.PUT_LINE ('Restrictie '|| rec_1.constraint_name || ', stare:'||rec_1.status) ;
  END LOOP ;


END ;


