-- crearea unei tabele folosind  pachetul PAC_ADMINISTRARE
DECLARE
 v_atrib pac_administrare.t_atribute ;
 v_tip_atrib pac_administrare.t_atribute ;
 v_restr_atrib pac_administrare.t_restrictii_atribute ;
 v_restr_tab pac_administrare.t_atribute ;
BEGIN 
 -- atributele si restrictiile lor
 v_atrib(1) := 'marca' ; 
 v_tip_atrib(1) := 'INTEGER' ; 
 v_restr_atrib(1)(1) := 'NOT NULL' ;
 v_restr_atrib(1)(2) := 'REFERENCES personal (marca)' ;

 v_atrib(2) := 'datai' ; 
 v_tip_atrib(2) := 'DATE' ; 
 v_restr_atrib(2)(1) := 'NOT NULL' ;
 v_restr_atrib(2)(2) := 'CHECK (EXTRACT (YEAR FROM datai) >= 2003) ' ;
 
 v_atrib(3) := 'dataf' ; 
 v_tip_atrib(3) := 'DATE' ; 
 v_restr_atrib(3)(1) := 'NOT NULL' ;

 -- restrictiile la nivel de tabela  
 v_restr_tab (1) := 'CHECK (dataf >= datai)' ;
 v_restr_tab (2) := 'CHECK (dataf - datai < 90)' ;
 v_restr_tab (3) := 'PRIMARY KEY (marca, datai)' ; 

 -- si acum, marele apel 
 pac_administrare.p_creare_tabele ('CONCEDII', v_atrib, v_tip_atrib, 
   v_restr_atrib, v_restr_tab) ;
END ;


