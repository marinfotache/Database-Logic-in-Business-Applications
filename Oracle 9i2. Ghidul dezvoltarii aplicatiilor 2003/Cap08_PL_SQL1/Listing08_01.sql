-- acest bloc nu face aproape nimic
DECLARE
/* prima sectiune este cea a declaratiilor (numai de variabile, cursoare, exceptii) */
prima_variabila INTEGER ; 	/* o variabila întreaga */	
a_doua_variabila VARCHAR2(50) ; 		/* o alta de tip sir de caractere de lungime variabila */
a_treia_variabila DATE ; 		/* la fel de inutila, dar de tip data calendaristica */
ultima_variabila BOOLEAN ;   	/* un tip de variabila (BOOLEAN) ce nu poate fi stocat în tabele */

BEGIN
 -- in aceasta sectiune se scriu comenzile efective
 DBMS_OUTPUT.PUT_LINE('Servus !') ; --echivalentul ardelenesc al lui Hello, World ;
 -- atentie, in SQL*Plus pentru afisare este necesara comanda SET SERVEROUTPUT ON

 END;
