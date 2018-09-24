CREATE OR REPLACE FUNCTION f_ani_vechime (
  datasv_ personal.datasv%TYPE,
  an_ IN  salarii.an%TYPE, 
  luna_ salarii.luna%TYPE ) RETURN transe_sv.ani_limita_inf%TYPE
AS 
 -- variabila care stocheaza data de 1 a lunii
  prima_zi DATE := TO_DATE('01/'||luna_||'/'||an_, 'DD/MM/YYYY') ;
BEGIN 
  RETURN TRUNCATE(MONTHS_BETWEEN(prima_zi, datasv_) / 12,0) ;
END ;
/


