/* Tablouri incapsulate (NESTED TABLES) - partea I  */

 /* in prealabil trebuie lansata in SQL*Plus comanda pentru crearea obiectului:
 CREATE OR REPLACE TYPE scolaritate AS OBJECT (
 an_inceput NUMBER(4),
 an_final NUMBER (4),
 institutie VARCHAR2(50),
 specializare_sectie VARCHAR2(100) ) ;
 /
 */
DECLARE
-- tipul de tabel încapsulat 
TYPE t_scolaritate IS TABLE OF scolaritate ;

v_scolaritate t_scolaritate := t_scolaritate() ;	 /* initializarea unui tabel încapsulat, chiar fara elemente, 
este obligatorie ; altminteri, s-ar declansa exceptia COLLECTION_IS_NULL.
       T_SCOLARITATE() reprezinta constructorul (are acelasi nume ca si tipul însusi)  */
BEGIN 
-- lungimea initiala a tabelului încapsulat era zero, asa ca îl marim un pic
v_scolaritate.EXTEND ;

-- prima perioada de scolarizare
v_scolaritate(1) := scolaritate (1990, 1994, 'Liceul de Informatica Iasi', 'Informatica') ;

/* am prins curaj, asa ca initializam si a doua componenta, ce reprezinta 
a doua perioada de scolarizare */ 
v_scolaritate.EXTEND ;
v_scolaritate(2) := scolaritate (1994, 1998, 'Univ. Al.I.Cuza Iasi', 
'Facult. de Economie si Admininistrarea Afacerilor - spec. Informatica Economica') ;

-- mai adaugam trei componente la tablou
v_scolaritate.EXTEND (3) ;

-- lasam doua componente neocupate, întrucit o vom initializa numai pe a 4-a
v_scolaritate(4) := scolaritate (2001, NULL, 'Univ. Al.I.Cuza Iasi', 
'FEAA - ELITEC - Master Sisteme Informationale (MIS)') ; 

DBMS_OUTPUT.PUT_LINE('Tabloul incapsulat are ' || v_scolaritate.COUNT || ' componente ') ;
DBMS_OUTPUT.PUT_LINE('Indexul primeia este ' || v_scolaritate.FIRST) ;
DBMS_OUTPUT.PUT_LINE('Indexul ultimeia este ' || v_scolaritate.LAST) ;
  
FOR i IN v_scolaritate.FIRST..v_scolaritate.LAST LOOP 
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------') ;
DBMS_OUTPUT.PUT_LINE(i) ;
IF v_scolaritate(i) IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE(v_scolaritate(i).an_inceput) ;
DBMS_OUTPUT.PUT_LINE(v_scolaritate(i).an_final) ;
DBMS_OUTPUT.PUT_LINE(v_scolaritate(i).institutie) ;
DBMS_OUTPUT.PUT_LINE(v_scolaritate(i).specializare_sectie) ;
ELSE
DBMS_OUTPUT.PUT_LINE('Aceasta componenta nu e initializata') ; 
END IF ;
END LOOP ;
 END ;

 
 
 
