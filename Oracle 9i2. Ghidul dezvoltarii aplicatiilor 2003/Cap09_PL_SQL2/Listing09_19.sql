CREATE OR REPLACE FUNCTION f_procent_spor_vechime (
  ani_ transe_sv.ani_limita_inf%TYPE)
   RETURN transe_sv.procent_sv%TYPE
AS 
 v_procent transe_sv.procent_sv%TYPE ;
BEGIN 
 SELECT procent_sv INTO v_procent FROM transe_sv 
  WHERE ani_ >= ani_limita_inf AND ani_ < ani_limita_sup ;
  RETURN v_procent ;
EXCEPTION
 WHEN NO_DATA_FOUND THEN 
  RETURN 0 ;
END ;
/


