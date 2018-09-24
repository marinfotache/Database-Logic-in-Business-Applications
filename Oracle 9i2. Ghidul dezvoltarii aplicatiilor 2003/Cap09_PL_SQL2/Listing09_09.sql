CREATE OR REPLACE PROCEDURE p_No_Copy
 (se_declanseaza IN BOOLEAN,
  parametru_de_IO IN OUT NOCOPY VARCHAR2)
AS
 o_exceptie EXCEPTION ; 
BEGIN 
 parametru_de_IO := 'Valoare la inceputul procedurii P_NO_COPY' ;
 IF se_declanseaza THEN 
  RAISE o_exceptie ;
 ELSE
	 parametru_de_IO := 'Valoare modificata in sectiunea executabila a P_NO_COPY' ;
 END IF ;
END  p_No_Copy ;

