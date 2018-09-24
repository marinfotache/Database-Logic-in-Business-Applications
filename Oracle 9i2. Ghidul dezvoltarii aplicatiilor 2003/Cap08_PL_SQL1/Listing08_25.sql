/* Refacerea blocului din listing 8.18, cu folosirea unui  tablou asociativ  si a unui vector cu marime variabila*/
DECLARE
v_an salarii.an%TYPE := 2003 ;
v_luna salarii.luna%TYPE := 1  ;

-- C_ORE calculeaza totalul orelor lucrate, de concediu si de noapte pentru luna data
CURSOR c_ore IS
SELECT marca, SUM(orelucrate) AS ore_l, SUM(oreco) AS ore_co, SUM(orenoapte) AS ore_n
FROM pontaje
WHERE TO_NUMBER(TO_CHAR(data,'YYYY')) = v_an AND 
TO_NUMBER(TO_CHAR(data,'MM')) = v_luna 
GROUP BY marca ;

/* se declara un tip RECORD pentru extragerea informatiilor necesare calculului
 venitului de baza si sporurilor (data spor vechime, salarii orare */
TYPE r_personal IS RECORD (datasv personal.datasv%TYPE, 
salorar personal.salorar%TYPE, salorarco personal.salorarco%TYPE ) ;

-- tipul si variabila vector asociativ
TYPE t_personal IS TABLE OF r_personal INDEX BY BINARY_INTEGER ;
v_personal t_personal ; 	

-- tipul si variabila vector cu marime variabila
TYPE t_sporv IS VARRAY(6) OF transe_sv%ROWTYPE ;--sunt 6 transe de vechime (în TRANSE_SV)
v_sporv t_sporv := t_sporv() ;

-- variabile necesare calculului sporului de vechime
v_ani_vechime NUMBER(4,2) ;
v_proc_sv transe_sv.procent_sv%TYPE ;
v_spvech sporuri.spvech%TYPE ;

-- variabile pentru venitul de baza, sporul de noapte si total sporuri
v_venitbaza salarii.venitbaza%TYPE ;
v_spnoapte sporuri.spnoapte%TYPE ;
v_sporuri salarii.sporuri%TYPE ;

-- o variabila contoar
i_vechime PLS_INTEGER := 1 ;
 
BEGIN 
/* înca de la început initializam vectorul asociativ cu DATA_SV, SALORAR si SALORARCO
ale tuturor angajatilor; cheia tabloului e chiar Marca */
FOR rec_personal IN (SELECT * FROM personal) LOOP 
v_personal(rec_personal.marca).datasv := rec_personal.datasv ;
v_personal(rec_personal.marca).salorar := rec_personal.salorar ;
v_personal(rec_personal.marca).salorarco := rec_personal.salorarco ;
END LOOP ;
 
-- tot la început initializam vectorul cu marime variabila care contine tabela TRANSE_SV
FOR rec_transe_sv IN (SELECT * FROM transe_sv ORDER BY ani_limita_inf) LOOP 
v_sporv.EXTEND ;
v_sporv(v_sporv.COUNT).ani_limita_inf := rec_transe_sv.ani_limita_inf ;
v_sporv(v_sporv.COUNT).ani_limita_sup := rec_transe_sv.ani_limita_sup ;
v_sporv( v_sporv.COUNT).procent_sv := rec_transe_sv.procent_sv ;
END LOOP ;
  
FOR rec_ore IN c_ore LOOP
v_ani_vechime := MONTHS_BETWEEN( TO_DATE('01/'||v_luna||'/'||v_an, 'DD/MM/YYYY'), 
			 v_personal(rec_ore.marca).datasv) / 12 ;   

 -- în loc de consultarea tabelei TRANSE_SV, procentul se va afla din VARRAY
FOR i IN 1..v_sporv.COUNT LOOP
IF v_ani_vechime >= v_sporv(i).ani_limita_inf AND 
v_ani_vechime < v_sporv(i).ani_limita_sup  THEN 
-- componenta curenta a VARRAY-ului este care contine procentul corect
i_vechime := i ;
EXIT ; 
END IF ;
END LOOP      ;
v_proc_sv := v_sporv(i_vechime).procent ;
/* se calculeaza venitul de baza, sporul de vechime si sporul de noapte; indexul vectorului
 asociativ este chiar marca curenta din C_ORE*/
v_venitbaza := ROUND(rec_ore.ore_l * v_personal(rec_ore.marca).salorar + 
rec_ore.ore_co * v_personal(rec_ore.marca).salorarco,-2) ;
v_spvech := ROUND(v_venitbaza * v_proc_sv / 100, -3) ; 
v_spnoapte := ROUND(rec_ore.ore_n * v_personal(rec_ore.marca).salorar * .15, -3) ;

-- se actualizeaza tabela SPORURI pentru angajatul curent
UPDATE sporuri 
SET spvech = v_spvech, orenoapte = rec_ore.ore_n, spnoapte = v_spnoapte
WHERE marca=rec_ore.marca AND an=v_an AND luna=v_luna ;

/* daca UPDATE nu a prelucrat nici o linie, se insereaza o înregistrare în SPORURI */
IF SQL%NOTFOUND THEN   
INSERT INTO sporuri VALUES (rec_ore.marca, v_an, v_luna, v_spvech, 
rec_ore.ore_n, v_spnoapte, 0) ;
END IF ;

-- se procedeaza analog pentru tabela SALARII
UPDATE salarii 
SET orelucrate = rec_ore.ore_l, oreco = rec_ore.ore_co,  venitbaza = v_venitbaza, sporuri = 
 (SELECT spvech + spnoapte + altesp 
 FROM sporuri 
 WHERE an=v_an AND luna=v_luna AND marca = rec_ore.marca)
WHERE marca=rec_ore.marca AND an=v_an AND luna=v_luna ;

IF SQL%NOTFOUND THEN 
INSERT INTO salarii VALUES (rec_ore.marca, v_an, v_luna, rec_ore.ore_l, 
rec_ore.ore_co, v_venitbaza,     
(SELECT spvech + spnoapte + altesp 
 FROM sporuri 
 WHERE an=v_an AND luna=v_luna AND marca = rec_ore.marca),	
0, 0) ;
END IF ;
END LOOP ;
END ;

