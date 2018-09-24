DECLARE
 v_marca personal.marca%TYPE := 1006;
 v_numepren personal.numepren%TYPE := 'Angajat 6' ;
 v_compart personal.compart%TYPE := 'CONTA' ;
 v_datasv personal.datasv%TYPE := TO_DATE ('23/11/1989', 'DD/MM/YYYY') ;
BEGIN
 -- varianta 1 - FARA variabile legate
 EXECUTE IMMEDIATE 'INSERT INTO personal (marca, numepren, compart, datasv) 
  VALUES (1005, ''Angajat 5'', ''IT'', TO_DATE(''12/05/1992'', ''DD/MM/YYYY'')) ' ;

 -- varianta 2 - CU variabile legate
 EXECUTE IMMEDIATE 'INSERT INTO personal (marca, numepren, compart, datasv) 
  VALUES (:1, :2, :3, :4 ) ' USING v_marca, v_numepren, v_compart, v_datasv ;


 COMMIT ;
END ;
