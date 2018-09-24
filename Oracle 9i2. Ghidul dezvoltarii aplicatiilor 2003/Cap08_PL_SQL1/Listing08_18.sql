/* Acest bloc actualizeaza, pentru o luna data, tabelele SPORURI si SALARII pe baza datelor dn PONTAJE */
DECLARE
v_an salarii.an%TYPE := 2003 ;
v_luna salarii.luna%TYPE := 1  ;

-- C_ORE calculeaza totalul orelor lucrate, de concediu si de noapte petru luna data
CURSOR c_ore IS
SELECT marca, SUM(orelucrate) AS ore_l, SUM(oreco) AS ore_co, 
SUM(orenoapte) AS ore_n
FROM pontaje
WHERE TO_NUMBER(TO_CHAR(data,'YYYY')) = v_an 
AND TO_NUMBER(TO_CHAR(data,'MM')) = v_luna 
GROUP BY marca ;

/* se declara un tip RECORD pentru extragerea informatiilor necesare calculului 
venitului de baza si sporurilor */
TYPE t_personal IS RECORD
(datasv personal.datasv%TYPE, 
salorar personal.salorar%TYPE, 
salorarco personal.salorarco%TYPE ) ;
   
rec_personal t_personal ; 		-- o variabila de tipul de mai sus

  	-- variabile necesare calculului sporului de vechime
v_ani_vechime NUMBER(4,2) ;
v_proc_sv transe_sv.procent_sv%TYPE ;
v_spvech sporuri.spvech%TYPE ;

-- variabile pentru venitul de baza, sporul de noapte si total sporuri
v_venitbaza salarii.venitbaza%TYPE ;
v_spnoapte sporuri.spnoapte%TYPE ;
v_sporuri salarii.sporuri%TYPE ;
 
BEGIN 
FOR rec_ore IN c_ore LOOP
-- se extrag datele pentru salariatul din linia curenta a cursorului C_ORE
SELECT datasv, salorar, salorarco  INTO rec_personal 
FROM personal WHERE marca = rec_ore.marca ;   
  
-- pentru calculul anilor de vechime se recurge la functia MONTHS_BETWEEN
v_ani_vechime := MONTHS_BETWEEN( TO_DATE('01/'||v_luna||'/'||v_an, 'DD/MM/YYYY'), 
	rec_personal.datasv) / 12 ;   

-- prin consularea tabelei TRANSE_SV se determina procentul sporului de vechime
SELECT procent_sv INTO v_proc_sv FROM transe_sv
WHERE v_ani_vechime >= ani_limita_inf AND v_ani_vechime < ani_limita_sup ;
  
/* se calculeaza venitul de baza, sporul de vechime si sporul de noapte;
functia ROUND asigura rotunjirea la ordinul sutelor */
v_venitbaza := ROUND(rec_ore.ore_l * NVL((rec_personal.salorar,0) + 
rec_ore.ore_co * NVL(rec_personal.salorarco,0),-2) ;
v_spvech := ROUND(v_venitbaza * v_proc_sv / 100, -3) ; 
v_spnoapte := ROUND(rec_ore.ore_n * NVL(rec_personal.salorar,0) * .15, -3) ;

-- se actualizeaza tabela SPORURI pentru angajatul curent
UPDATE sporuri 
SET spvech = v_spvech, orenoapte = rec_ore.ore_n, spnoapte = v_spnoapte
WHERE marca=rec_ore.marca AND an=v_an AND luna=v_luna ;

/* daca UPDATE nu a prelucrat nici o linie, se insereaza o înregistrare în SPORURI */
IF SQL%NOTFOUND THEN    -- reamintiti-va discutia de la cursoare implicite
INSERT INTO sporuri VALUES (rec_ore.marca, v_an, v_luna, 
v_spvech, rec_ore.ore_n, v_spnoapte, 0) ;
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

