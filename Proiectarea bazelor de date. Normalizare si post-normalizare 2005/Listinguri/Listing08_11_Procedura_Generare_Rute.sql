CREATE OR REPLACE PROCEDURE p_generare_rute (
 loc_init VARCHAR2, loc_dest VARCHAR2) IS
BEGIN 
 pac_loc.loc_init := loc_init ;
 pac_loc.loc_dest := loc_dest ;

 FOR rec_view IN (SELECT * FROM v_ordin1  
     WHERE loc1= pac_loc.f_loc_init() AND loc2=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc2, rec_view.sir, rec_view.distanta) ;
   INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
   INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
 END LOOP ;
 
 FOR rec_view IN (SELECT * FROM v_ordin2  
    WHERE loc1= pac_loc.f_loc_init() AND loc3=pac_loc.f_loc_dest() ) LOOP 
  INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
    VALUES (rec_view.loc1, rec_view.loc3, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
 END LOOP ;
 
 
 FOR rec_view IN (SELECT * FROM v_ordin3
     WHERE loc1= pac_loc.f_loc_init() AND loc4=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc4, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
 END LOOP ;

 FOR rec_view IN (SELECT * FROM v_ordin4  
     WHERE loc1= pac_loc.f_loc_init() AND loc5=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc5, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
 END LOOP ;
 
 FOR rec_view IN (SELECT * FROM v_ordin5  
      WHERE loc1= pac_loc.f_loc_init() AND loc6=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc6, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
 END LOOP ;

 FOR rec_view IN (SELECT * FROM v_ordin6  
      WHERE loc1= pac_loc.f_loc_init() AND loc7=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc7, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
 END LOOP ;

 FOR rec_view IN (SELECT * FROM v_ordin7  
      WHERE loc1= pac_loc.f_loc_init() AND loc8=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc8, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc8) ;

 END LOOP ;
 
  FOR rec_view IN (SELECT * FROM v_ordin8  
       WHERE loc1= pac_loc.f_loc_init() AND loc9=pac_loc.f_loc_dest() ) LOOP 
   INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
     VALUES (rec_view.loc1, rec_view.loc9, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc8) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc9) ;
 END LOOP ;
 
 FOR rec_view IN (SELECT * FROM v_ordin9  
  WHERE loc1= pac_loc.f_loc_init() AND loc10=pac_loc.f_loc_dest() ) LOOP 
    INSERT INTO rute (loc_init, loc_dest, sir, distanta) 
      VALUES (rec_view.loc1, rec_view.loc10, rec_view.sir, rec_view.distanta) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc1) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc2) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc3) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc4) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc5) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc6) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc7) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc8) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc9) ;
  INSERT INTO loc_rute (idruta, loc) VALUES  (seq_idruta.CurrVal, rec_view.loc10) ;
 END LOOP ;

END ;

