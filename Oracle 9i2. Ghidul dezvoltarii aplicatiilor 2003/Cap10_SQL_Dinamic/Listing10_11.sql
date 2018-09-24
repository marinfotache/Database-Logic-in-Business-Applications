CREATE OR REPLACE PACKAGE pac_insert AS
 v_enull BOOLEAN := FALSE ;
-- v_atribut VARCHAR2(100) ;
 v_sir VARCHAR2(100);
 v_personal personal%ROWTYPE ;
 FUNCTION f_val (atribut_ VARCHAR2) RETURN VARCHAR2 ;
 FUNCTION f_val (atribut_ NUMBER) RETURN VARCHAR2 ;
 FUNCTION f_val (atribut_ DATE) RETURN VARCHAR2 ;
 PROCEDURE p_insert (rec_personal personal%ROWTYPE) ;
END pac_insert ;
/

CREATE OR REPLACE PACKAGE BODY pac_insert AS
-- prelucrarea valorilor de tip SIR DE CARACTERE
FUNCTION f_val (atribut_ VARCHAR2) RETURN VARCHAR2 IS
BEGIN
 RETURN '''' || atribut_  ||'''';
END f_val ; 

-- prelucrarea valorilor de tip NUMERIC
FUNCTION f_val (atribut_ NUMBER) RETURN VARCHAR2 IS
BEGIN
 RETURN ' ' || atribut_ || ' ' ;
END f_val ;

-- prelucrarea valorilor de tip DATA CALENDARISTICA
FUNCTION f_val (atribut_ DATE) RETURN VARCHAR2 IS
BEGIN
 RETURN ' TO_DATE (''' || TO_CHAR(atribut_,'DD/MM/YYYY') || ''', ''DD/MM/YYYY'') ' ;
END f_val ;

/* procedura de preluare a valorilor unei inregistrari din PERSONAL si generare
    dinamica a comenzii INSERT */
PROCEDURE p_insert (rec_personal personal%ROWTYPE) IS
 sir_atribute VARCHAR2 (2000)  ; -- INSERT INTO personal (atribut_i, atribut_j...)
 sir_valori VARCHAR2 (2000)    ; -- VALUES (valoarea_i, valoare_j, ...)
BEGIN 
 v_personal := rec_personal ; -- copierea valorilor in variabila din pachet
 
 -- se parcurg toate atributele tabelei si se testeaza care au valori
 -- NULLe pentru a genera dinamic comanda INSERT
 FOR rec_atribute IN (SELECT column_name, column_id, data_type FROM USER_TAB_COLUMNS 
       WHERE TABLE_NAME ='PERSONAL'  ORDER BY column_id) LOOP
   IF rec_atribute.column_id = 1 THEN --  primul atribut 
     sir_atribute := ' INSERT INTO PERSONAL ( ' ;
     sir_valori :=  ' VALUES ( ' ;
   END IF ;  
   
   -- se testeaza daca valoarea atributului curent este NULL
   --     artificiul consta in folosirea unui bloc dinamic care atribuie valoarea 
   --     TRUE sau FALSE variabilei publice V_ENULL
   EXECUTE IMMEDIATE ' BEGIN IF pac_insert.v_personal.'|| rec_atribute.column_name ||
      ' IS NULL THEN pac_insert.v_enull := TRUE ; ELSE pac_insert.v_enull := FALSE ; END IF; END;  ' ;
   IF v_enull = TRUE THEN 
     -- se omite din lista atributelor si cea a valorilor
     NULL ;
   ELSE
     -- valoarea atributului curente nu este NULL, deci trebuie modificate si 
     --     lista atributelor si cea a valorilor
     IF rec_atribute.column_id > 1 THEN 
       sir_atribute := sir_atribute || ', ' ;
       sir_valori := sir_valori || ', ' ;
     END IF ;  
     -- se adauga numele in lista atributelor
     sir_atribute := sir_atribute || rec_atribute.column_name ;

     /* un alt artificiu, si cel mai interesant: valoarea atributului curent se paseaza
          unei functii F_VAL din pachet; aceasta va returna variabilei publice V_SIR
          sirul de caractere ce trebuie inclus in clauza VALUES din comanda INSERT; 
          intrucit valoarea atributului poate fi numerica, sir de caractere sau 
          data calendaristica, ne bazam pe supraincarcarea functiei F_VAL */
     EXECUTE IMMEDIATE ' BEGIN pac_insert.v_sir := pac_insert.f_val ( pac_insert.v_personal.'||
      rec_atribute.column_name || ') ; END;  ' ;
    -- se adauga valoarea V_SIR in lista valorilor clauzei VALUES
    sir_valori := sir_valori || pac_insert.v_sir ;
   END IF ;  
 END LOOP ;
 sir_atribute := sir_atribute || ' ) ' ;
 sir_valori := sir_valori || ') '  ;

 -- pentru impresie, se afiseaza cele doua parti ale comenzii INSERT
 DBMS_OUTPUT.PUT_LINE(sir_atribute) ;
 DBMS_OUTPUT.PUT_LINE(sir_valori) ;

 -- in fine, ECCE INSERT-ul !
 EXECUTE IMMEDIATE sir_atribute || ' ' || sir_valori ; 

END p_insert ;

END pac_insert ;
/
