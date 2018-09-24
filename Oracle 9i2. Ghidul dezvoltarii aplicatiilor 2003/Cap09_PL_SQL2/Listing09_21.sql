CREATE OR REPLACE FUNCTION f_exista_sp_re_sa (
  marca_ personal.marca%TYPE, 
  an_ salarii.an%TYPE,
  luna_ salarii.luna%TYPE,
  tabela_ VARCHAR2) RETURN BOOLEAN
AS 
 v_unu NUMBER(1) ;
BEGIN 
 CASE
  WHEN UPPER(tabela_) = 'SPORURI' THEN 
   SELECT 1 INTO v_unu FROM sporuri 
   WHERE marca=marca_ AND an=an_ AND luna=luna_ ;

  WHEN UPPER(tabela_) = 'RETINERI' THEN 
   SELECT 1 INTO v_unu FROM retineri 
   WHERE marca=marca_ AND an=an_ AND luna=luna_ ;

  WHEN UPPER(tabela_) = 'SALARII' THEN 
   SELECT 1 INTO v_unu FROM salarii 
   WHERE marca=marca_ AND an=an_ AND luna=luna_ ;
 END CASE ;
 
 RETURN TRUE ;
 
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
  RETURN FALSE ;
END ;
/


