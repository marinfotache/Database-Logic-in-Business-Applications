BEGIN
 pac_sterge.v2:= pac_sterge.v1 ;
 EXECUTE IMMEDIATE 'SELECT '''||'Valoare 2'||''' FROM dual' INTO pac_sterge.v2 ;
 DBMS_OUTPUT.PUT_LINE(pac_sterge.v2) ;
END ; 

