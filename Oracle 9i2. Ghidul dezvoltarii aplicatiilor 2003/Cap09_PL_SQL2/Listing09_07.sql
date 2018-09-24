CREATE OR REPLACE PROCEDURE Eroare_Controlata
 (se_declanseaza IN BOOLEAN,
  parametru_de_IO IN OUT VARCHAR2)
AS
 o_exceptie EXCEPTION ; 
BEGIN 
  parametru_de_IO := 'Suntem la inceputul procedurii EROARE_CONTROLATA' ;
  IF se_declanseaza THEN 
    RAISE o_exceptie ;
  ELSE
   	parametru_de_IO := 'Parametru modificat' ;
  END IF ;
 END  Eroare_Controlata ;

