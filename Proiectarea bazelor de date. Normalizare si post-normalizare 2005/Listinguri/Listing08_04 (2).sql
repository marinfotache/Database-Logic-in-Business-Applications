CREATE OR REPLACE TRIGGER trg_competente_ins
 BEFORE INSERT ON competente FOR EACH ROW
DECLARE
  v_dencompetenta competente.dencompetenta%TYPE ;
  v_um competente.um%TYPE ;
  v_modevaluare competente.modevaluare%TYPE ;
BEGIN
   SELECT seq_idcompetente.NextVal INTO :NEW.IdCompetenta FROM dual ;
   INSERT INTO competente_elementare VALUES (seq_idcompetente.CurrVal)
  	IF f_este_frunza (:NEW.IdCompSuperioara) THEN
		    -- parintele era "frunza" înaintea inserarii
 		   SELECT DenCompetenta, UM, ModEvaluare
      INTO v_dencompetenta, v_um, v_modevaluare
 		   FROM competente
	 	   WHERE IdCompetenta = :NEW.IdCompSuperioara ;
     
    		UPDATE competente_elementare
		    SET IdCompFrunza = seq_idcompetente.CurrVal + 1
   	  WHERE IdCompFrunza = :NEW.IdCompSuperioara ;
?????

   END IF ;
END ;



