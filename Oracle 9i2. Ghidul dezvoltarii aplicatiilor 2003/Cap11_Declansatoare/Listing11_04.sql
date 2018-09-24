-- declansatorul pentru generarea automata a marcii - ver. 2.0
CREATE OR REPLACE TRIGGER trg_personal_ins_befo_row
    BEFORE INSERT ON personal FOR EACH ROW
DECLARE
 v_noua_marca personal.marca%TYPE ;
BEGIN
  	 v_noua_marca := pachet_salarizare.f_prima_gaura_marca() ;
 	  :NEW.marca := v_noua_marca ;
    pachet_salarizare.v_marci (v_noua_marca) := v_noua_marca ;
END ;

