/* se creste cu 10% salariul orar al celor mai vechi TREI angajati 
 din fiecare compartiment... */
DECLARE
 /* nu mai declaram cursorul pentru compartimente, deoarece folosim un
  FOR cu subconsultare */

 /*  pentru cursorul (parametrizat) C_SALARIATI se declara clauza FOR UPDATE OF  */
  CURSOR c_salariati (v_compart personal.compart%TYPE) IS 
   SELECT marca, numepren, compart, salorar, 
     TRUNC(MONTHS_BETWEEN(SYSDATE, datasv)/12, 0) AS ani_vechime
   FROM personal WHERE compart = v_compart ORDER BY 3 DESC  
   FOR UPDATE OF salorar ;

    v_ani INTEGER ;  /* anii de vechime ai celui mai recent angajat cu marirea de salariu */
    nr_total INTEGER := 7 ;  -- nr. total salariatilor carora li s-a marit salariul orar
    nr_max INTEGER := 15 ; -- nr maxim de salariati ce pot beneficia de marirea salariului
  prea_multi EXCEPTION ;  -- exceptie
   
BEGIN
  -- de data aceasta cursorul este definit ad-hoc, prin subconsultare
  FOR rec_compart IN (SELECT DISTINCT compart FROM personal ) LOOP 
   -- initializarea variabilelor la nivel de compartiment
   v_ani := 99 ;

   /* secventa pentru prelucrarea cursorului C_SALARIATI. La descihderea cursorului
    se blocheaza inregistrarile corespondente din tabela PERSONAL */
   FOR rec_salariati IN c_salariati (rec_compart.compart) LOOP  
    IF c_salariati%ROWCOUNT > 3 AND rec_salariati.ani_vechime < v_ani THEN 
     -- pentru acest compartiment, acordarea sporului este epuizata
     NULL ;
   ELSE
     -- se acorda sporul si acestui angajat 
    UPDATE personal 
    SET salorar = salorar + salorar * .1
    WHERE CURRENT OF c_salariati ;

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
