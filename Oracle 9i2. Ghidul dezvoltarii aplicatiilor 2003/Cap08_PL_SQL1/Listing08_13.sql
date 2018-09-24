/* se creste cu 10% salariul orar al celor mai vechi TREI angajati din fiecare compartiment. 
Atentie, daca exista mai multi angajati cu aceeasi vechime ca a unuia din cei trei, 
se acorda sporul si la acestia !!!  */
DECLARE
 -- se declara cusorul in care se calculeaza numarul de ani de vechime
 -- iar liniile se ordoneaza pe compartimente, si dupa anii de vechime
  CURSOR c_salariati IS 
   SELECT marca, numepren, compart, salorar, 
     TRUNC(MONTHS_BETWEEN(SYSDATE, datasv)/12, 0) AS ani_vechime
   FROM personal
   ORDER BY compart, 3 DESC  ;

 rec_salariati c_salariati%ROWTYPE ;

 -- variabila V_COMPART va stoca, in orice moment, codul compartimentului 
 -- celui mai recent angajat procesat 
 v_compart personal.compart%TYPE := 'XYZ';

 -- variabila V_ANI contine, in orice moment, anii de vechime celui mai recent
 -- angajat din compartiment caruia i s-a acordat sporul
  v_ani INTEGER := 99 ;
  
 -- contorul numarului de angajati dintr-un compartiment care au primit deja 
 -- marirea
 numar INTEGER := 1 ; 
   
BEGIN

 
 OPEN c_salariati ;
 FETCH c_salariati INTO rec_salariati ;
 WHILE c_salariati%FOUND LOOP
  IF rec_salariati.compart <> v_compart THEN -- s-a schimbat compartimentu' ! 
   numar := 1 ;
   v_compart := rec_salariati.compart ;
   v_ani := rec_salariati.ani_vechime ;
   UPDATE personal 
   SET salorar = salorar + salorar * .1 
   WHERE marca = rec_salariati.marca ;

  ELSE
  
   IF numar > 3 AND rec_salariati.ani_vechime < v_ani THEN 
     -- pentru acest compartiment, acordarea sporului este epuizata
     NULL ;
   ELSE
     -- se acorda sporul si acestui angajat 
    numar := numar + 1 ;
    v_ani := rec_salariati.ani_vechime ;

    UPDATE personal 
    SET salorar = salorar + salorar * .1
    WHERE marca = rec_salariati.marca ;
    
   END IF ;  

  END IF; 
  FETCH c_salariati INTO rec_salariati ;
 END LOOP ;
 CLOSE c_salariati ;


END ;   
