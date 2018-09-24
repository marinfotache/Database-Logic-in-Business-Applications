CREATE OR REPLACE FUNCTION f_personal (
  marca_ personal.marca%TYPE, atribut_ VARCHAR2)
   RETURN VARCHAR2
AS 
 v_valoare VARCHAR2(50) ;
BEGIN 
 CASE
  WHEN UPPER(atribut_) = 'SALORAR' THEN 
   SELECT TO_CHAR(salorar, '999999999999999') INTO v_valoare
   FROM personal WHERE marca=marca_ ;

  WHEN UPPER(atribut_) = 'SALORARCO' THEN 
   SELECT TO_CHAR(salorarco, '999999999999999') INTO v_valoare
   FROM personal WHERE marca=marca_ ;
    
 WHEN UPPER(atribut_) = 'DATASV' THEN 
   SELECT TO_CHAR(datasv, 'DD/MM/YYYY') INTO v_valoare
   FROM personal WHERE marca=marca_ ;
 END CASE ;
 
 RETURN v_valoare ;
 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
  RETURN NULL ;
END ;
/


