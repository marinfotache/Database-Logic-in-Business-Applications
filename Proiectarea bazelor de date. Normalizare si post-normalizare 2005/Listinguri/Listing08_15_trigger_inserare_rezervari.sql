DROP SEQUENCE seq_IdRezervare ;
CREATE SEQUENCE seq_IdRezervare START WITH 1 INCREMENT BY 1 MINVALUE 1
 MAXVALUE 99999999 NOCYCLE NOCACHE ORDER ;

CREATE OR REPLACE FUNCTION f_ordine_loc (Loc_ loc_rute.Loc%TYPE,
 IdRuta_ loc_rute.IdRuta%TYPE) RETURN loc_rute.LocalitNr%TYPE
IS
 v_nr loc_rute.LocalitNr%TYPE ;
BEGIN 
 SELECT LocalitNr INTO v_nr FROM loc_rute 
 WHERE IdRuta=IdRuta_ AND loc=Loc_ ;
 RETURN v_nr ;  
END ;
/ 
 
CREATE OR REPLACE TRIGGER trg_rezervari_ins
 BEFORE INSERT ON rezervari FOR EACH ROW
DECLARE
  v_NrRezervari rezervari.NrBilete%TYPE := 0 ;
  v_NrLocuriAuto rezervari.NrBilete%TYPE := 0 ;
  i_urcare NUMBER(3) := 0 ;
	 i_coborire NUMBER(3) := 0 ;
	 i NUMBER(3) := 0 ;
  v_IdRuta rute.IdRuta%TYPE ;
BEGIN 
 -- In variabile v_NrLocuriAuto se stocheaza capacitatea auto/micro-buzului
 SELECT NrLocuri INTO v_NrLocuriAuto FROM tipuri_auto WHERE TipAuto=
  (SELECT TipAuto FROM autovehicole WHERE NrAuto=
   (SELECT NrAuto FROM curse2 WHERE IdCursa = :NEW.IdCursa)) ; 

 -- se determina Id-ul rutei pentru a vedea ce localitati se parcurg
 SELECT IdRuta INTO v_IdRuta 
 FROM curse2 c INNER JOIN plecari p ON c.IdPlecare=p.IdPlecare
 WHERE IdCursa=:NEW.IdCursa ; 
 
 -- se obtine numarul localitatii de urcare si al celei de coborire de pe traseu
	i_urcare := f_ordine_loc (:NEW.DeLa, v_IdRuta) ;
 i_coborire :=  f_ordine_loc (:NEW.PinaLa, v_IdRuta) ;
	IF i_urcare >= i_coborire THEN 
		RAISE_APPLICATION_ERROR(-20177, 'Ruta/localitati gresite !');
	END IF ; 

 -- se parcurge fiecare portiune dintre localitatile de urcare si coborire
 -- si se verifica daca nr. rezervarilor depaseste numarul locurilor din autovehicol
	FOR i IN i_urcare..i_coborire-1 LOOP 
  SELECT SUM(NrBilete) INTO v_NrRezervari 
   FROM (SELECT * FROM rezervari WHERE IdCursa=:NEW.IdCursa)
  WHERE f_ordine_loc(DeLa, v_IdRuta) <= i 
          AND f_ordine_loc(PinaLa, v_IdRuta) >= i + 1 ;
 
	 IF NVL(v_NrRezervari,0) + :NEW.NrBilete >= v_NrLocuriAuto  THEN 
		 RAISE_APPLICATION_ERROR(-20178, 'Nu mai sunt locuri ! ');
	 END IF ; 
	END LOOP ;

 SELECT seq_IdRezervare.NextVal INTO :NEW.IdRezervare FROM dual ;

EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
  RAISE_APPLICATION_ERROR (-20179, 'Ruta/cursa pentru care se doreste rezervarea nu este introdusa !') ; 

END ; 

