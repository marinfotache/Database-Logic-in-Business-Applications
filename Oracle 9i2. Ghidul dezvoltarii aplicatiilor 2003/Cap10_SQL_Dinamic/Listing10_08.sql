CREATE OR REPLACE PROCEDURE p_pachet_user (utilizator VARCHAR2) 
AUTHID CURRENT_USER  AS
 v_unu NUMBER(1) ;
BEGIN 
 BEGIN 
   SELECT 1 INTO v_unu FROM user_objects WHERE object_type='PACKAGE'
    AND object_name = 'PACHET_'||utilizator ;
   -- DBMS_OUTPUT.PUT_LINE( 'pachet_'|| utilizator || '.data_ultimei_modificari := SYSDATE ;') ; 
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
    EXECUTE IMMEDIATE  'CREATE OR REPLACE PACKAGE pachet_' || utilizator
    || ' AUTHID CURRENT_USER AS data_ultimei_modificari DATE ; END pachet_'|| utilizator ||';' ; 
  END ;
--  DBMS_OUTPUT.PUT_LINE ('pachet_'|| utilizator || '.data_ultimei_modificari :=  SYSDATE ;');
  EXECUTE IMMEDIATE 'BEGIN pachet_'|| utilizator || '.data_ultimei_modificari := SYSDATE; END ;' ; 
END p_pachet_user ;


