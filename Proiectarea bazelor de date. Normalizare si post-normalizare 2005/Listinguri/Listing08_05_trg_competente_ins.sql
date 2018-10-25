CREATE OR REPLACE PACKAGE pac_competente
AS
 v_intra BOOLEAN := TRUE ;
 v_competente competente%ROWTYPE ;
END pac_competente ;
/

---------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_competente_ins_before
 BEFORE INSERT ON competente FOR EACH ROW
BEGIN
   IF pac_competente.v_intra = TRUE THEN 
     SELECT seq_idcompetente.NextVal INTO :NEW.IdCompetenta FROM dual ;
     pac_competente.v_competente.IdCompetenta := :NEW.IdCompetenta ;
     pac_competente.v_competente.DenCompetenta := :NEW.DenCompetenta ;
     pac_competente.v_competente.UM := :NEW.UM ;
     pac_competente.v_competente.ModEvaluare := :NEW.ModEvaluare ;   
     pac_competente.v_competente.IdCompSuperioara := :NEW.IdCompSuperioara ;
   END IF ;  
END ;
/

CREATE OR REPLACE TRIGGER trg_competente_ins_after
 AFTER INSERT ON competente 
DECLARE
  v_id competente.IdCompetenta%TYPE ;
BEGIN
   IF pac_competente.v_intra = TRUE THEN
     IF f_este_compfrunza (pac_competente.v_competente.IdCompSuperioara) THEN
		     -- parintele era "frunza" înaintea inserarii
 		    IF f_deja_folosita (pac_competente.v_competente.IdCompSuperioara) = FALSE THEN
         -- competenta parinte nu apare in evaluarea niciunui post/angajat
         UPDATE competente_elementare SET IdCompFrunza = pac_competente.v_competente.IdCompetenta
          WHERE IdCompFrunza = pac_competente.v_competente.IdCompSuperioara ;
       ELSE
         -- competenta parinte este deja folosita in COMPETENTE_POSTURI sau COMPETENTE_ANGAJATI
        INSERT INTO competente_elementare VALUES (pac_competente.v_competente.IdCompetenta) ;        

        SELECT * INTO pac_competente.v_competente FROM competente
 	      WHERE IdCompetenta = pac_competente.v_competente.IdCompSuperioara ;
   	     
        SELECT seq_idcompetente.NextVal INTO v_id FROM dual ;

        pac_competente.v_intra := FALSE ;     
        INSERT INTO competente VALUES (v_id, pac_competente.v_competente.DenCompetenta || '_VECHE_', 
          pac_competente.v_competente.UM, pac_competente.v_competente.ModEvaluare, 
           pac_competente.v_competente.IdCompetenta) ;      
        pac_competente.v_intra := FALSE ;     
     
    	 	 UPDATE competente_elementare SET IdCompFrunza = v_id
    	   WHERE IdCompFrunza = pac_competente.v_competente.IdCompetenta ;
      END IF ;
    ELSE 
      -- parintele NU era "frunza" înaintea inserarii    
      INSERT INTO competente_elementare VALUES (pac_competente.v_competente.IdCompetenta) ;              
    END IF ;        
  END IF ;
END ;
/

