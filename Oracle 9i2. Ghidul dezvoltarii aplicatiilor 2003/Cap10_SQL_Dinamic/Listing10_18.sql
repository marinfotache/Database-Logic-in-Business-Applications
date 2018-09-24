BEGIN
 DBMS_OUTPUT.PUT_LINE('In tabela ' || 'TRANSE_SV' || 
  ' sunt ' || f_nr_linii('TRANSE_SV', NULL) 
  ||' linii ');
END ;
/

BEGIN
 DBMS_OUTPUT.PUT_LINE('In tabela ' || 'PERSONAL' || 
  ' sunt ' || f_nr_linii('PERSONAL', 'compart = ''IT''') 
  ||' angajat in compartimentul IT ');
END ;
/
