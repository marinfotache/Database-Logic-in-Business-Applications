DECLARE
 linie_personal personal%ROWTYPE ;
BEGIN 
 -- initializarea valorii atributelor
 linie_personal.marca := 1011 ;
 linie_personal.numepren := 'Angajat 1011' ;
 linie_personal.compart := NULL ;
 linie_personal.datasv := TO_DATE ('12/05/1997', 'DD/MM/YYYY') ;
 linie_personal.salorar := NULL ;
 linie_personal.salorarco := NULL ;
 linie_personal.colaborator := NULL ;
 
 -- apelul procedurii
 pac_insert.p_insert (linie_personal) ;
 commit ;
END ;
/
