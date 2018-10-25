CREATE OR REPLACE FUNCTION f_cost_bilet (
 vLocUrcare localitati.Localitate%TYPE,
 vLocCoborire localitati.Localitate%TYPE,
 vIdRuta rute.IdRuta%TYPE ) RETURN NUMBER 
IS
 i_urcare NUMBER(3) := 0 ;
 i_coborire NUMBER(3) := 0 ;
 v_nrkm NUMBER(4) := 0 ;
 v_distanta NUMBER(4) := 0 ;
 v_cost tarife.CostPeKm%TYPE := 0;
 v_loc1 localitati.Localitate%TYPE ;
 v_loc2 localitati.Localitate%TYPE ;
BEGIN 
 SELECT LocalitNr INTO i_urcare FROM loc_rute WHERE IdRuta=vIdRuta AND loc=vLocUrcare ;
 SELECT LocalitNr INTO i_coborire FROM loc_rute WHERE IdRuta=vIdRuta AND loc=vLocCoborire ;
 
 IF i_urcare >= i_coborire THEN 
  RAISE_APPLICATION_ERROR(-20177, 'Ruta/localitati gresite !');
 END IF ; 
 
 FOR rec_loc IN (SELECT * FROM loc_rute WHERE IdRuta=vIdRuta 
       AND LocalitNr BETWEEN i_urcare AND i_coborire ORDER BY LocalitNr ) LOOP       
  IF rec_loc.LocalitNr = i_urcare THEN 
   v_loc1 := rec_loc.Loc ;
  ELSE
   v_loc2 := rec_Loc.Loc ;
   SELECT distanta INTO v_distanta FROM distante WHERE loc1 = LEAST(v_loc1, v_loc2) AND
    loc2 = GREATEST(v_loc1, v_loc2) ;
   v_NrKm := v_NrKm + v_distanta ;
   v_loc1 := v_loc2 ;  
  END IF ;
 END LOOP ;

  insert into temp values (v_NrKm);   
  commit ;
 
 SELECT ROUND(CostPeKm * v_NrKm,-3) INTO v_cost FROM tarife 
 WHERE v_NrKm >= KmLimitaInf AND v_NrKm < KmLimitaSup ;
 
 RETURN v_cost ;
 
END ; 

