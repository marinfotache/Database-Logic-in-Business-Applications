/* se creste cu 10% salariul orar al celor mai vechi TREI angajati 
 din fiecare compartiment. ....
 De data aceasta se stabileste un numar maxim de angajati care pot
 primi sporul si se genereaza o eroare daca cind acest NR_MAX este depasit  */
 

DECLARE
 /* folosim un cursor si pentru compartimente */
 CURSOR c_compart IS SELECT DISTINCT compart FROM personal ;

 /*  cursorul C_SALARIATI se intoarce, un pic schimbat */
  CURSOR c_salariati (v_compart personal.compart%TYPE) IS 
   SELECT marca, numepren, compart, salorar, 
     TRUNC(MONTHS_BETWEEN(SYSDATE, datasv)/12, 0) AS ani_vechime
   FROM personal WHERE compart = v_compart ORDER BY 3 DESC  ;

 -- V_ANI isi pastreaza semnificatia
   v_ani INTEGER ;
 
 /* NR_COMPART reprezinta citi angajati din compartimentul curent au primit
  deja sporul, in tip ce NR_TOTAL citi angajati au primit sporul la un moment dat */
    nr_compart INTEGER := 1 ; 
    nr_total INTEGER := 1 ; 
    
 -- declaram citi angajati pot primi sporul 
  nr_max INTEGER := 15 ;
  
 -- in premiera, definim si o exceptie
 prea_multi EXCEPTION ;
   
BEGIN
  -- secventa repetitiva pentru prelucrarea inregistrarilor cursorului C_COMPART
  FOR rec_compart IN c_compart LOOP 
   -- initializarea variabilelor la nivel de compartiment
   nr_compart := 1 ;
   v_ani := 99 ;

   /* secventa iterativa pentru prelucrarea inregistrarilor cursorului C_SALARIATI,
   care, spre deosebire de celalalt, este un cursor parametrizat */
   FOR rec_salariati IN c_salariati (rec_compart.compart) LOOP  
    IF nr_compart > 3 AND rec_salariati.ani_vechime < v_ani THEN 
     -- pentru acest compartiment, acordarea sporului este epuizata
     NULL ;
   ELSE
     -- se acorda sporul si acestui angajat 
    UPDATE personal 
    SET salorar = salorar + salorar * .1
    WHERE marca = rec_salariati.marca ;

    -- se actualizeaza variabile contor si etalon
    nr_compart := nr_compart + 1 ;
    v_ani := rec_salariati.ani_vechime ;
    nr_total := nr_total + 1 ;

    -- se verifica daca numarul total admis de angajati nu a fost deja depasit
    IF nr_total > nr_max THEN
     -- se declanseaza exceptia-utilizator
     RAISE prea_multi ;
    END IF ;
    
   END IF ;  

  END LOOP; 
  -- incarcarea urmatoarei inregistrari din cursor se face automat
 END LOOP ;

EXCEPTION
 /* tratarea exceptiei utilizator */
 WHEN prea_multi THEN
  ROLLBACK ;
  DBMS_OUTPUT.PUT_LINE('A fost depasit numarul maxim admis de angajati care pot primi sporul !' ) ;

END ;   
