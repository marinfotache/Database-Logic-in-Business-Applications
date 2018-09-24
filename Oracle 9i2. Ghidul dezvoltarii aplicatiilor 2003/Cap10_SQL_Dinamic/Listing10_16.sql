DECLARE
 v_marca personal.marca%TYPE := 1099;
 v_numepren personal.numepren%TYPE := 'Angajat 99' ;
 v_compart personal.compart%TYPE := 'CONTA' ;
 v_datasv personal.datasv%TYPE := TO_DATE ('20/09/1997', 'DD/MM/YYYY') ;
 v_tabela VARCHAR2 (30) := 'PERSONAL' ;
BEGIN
 -- tentativa nr.3 
 EXECUTE IMMEDIATE 'INSERT INTO ' || v_tabela || 
  '  (marca, numepren, compart, datasv) VALUES (:1, :2, :3, :4 ) ' 
   USING v_marca, v_numepren, v_compart, v_datasv ;
END ;
