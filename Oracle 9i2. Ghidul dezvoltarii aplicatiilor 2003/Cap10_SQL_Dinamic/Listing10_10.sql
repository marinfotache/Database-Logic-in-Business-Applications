CREATE OR REPLACE PACKAGE pac_sterge AS
 v1 VARCHAR2(100) := 'Valoare 1' ;
 v2 VARCHAR2(100) ;
END pac_sterge ;
/

BEGIN
 pac_sterge.v2:= pac_sterge.v1 ;
 EXECUTE IMMEDIATE ' BEGIN pac_sterge.v2:= '''||'Valoare 2'||''' ; END ; ' ;
 DBMS_OUTPUT.PUT_LINE(pac_sterge.v2) ;
END ; 

