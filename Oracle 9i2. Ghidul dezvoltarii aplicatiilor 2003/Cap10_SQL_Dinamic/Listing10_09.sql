DECLARE
 v1 VARCHAR2(100) := 'Valoare 1' ;
 v2 VARCHAR2(100) ;
BEGIN
 EXECUTE IMMEDIATE ' BEGIN v2:= '''||'Valoare 2'||''' ; END ; ' ;
 DBMS_OUTPUT.PUT_LINE(v2) ;
END ; 

