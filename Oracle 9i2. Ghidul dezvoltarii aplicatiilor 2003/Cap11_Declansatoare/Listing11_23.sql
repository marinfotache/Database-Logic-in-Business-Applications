CREATE OR REPLACE PACKAGE pac_administrare 
 AUTHID CURRENT_USER 
AS


  TYPE t_temp IS TABLE OF VARCHAR2(3000) INDEX BY PLS_INTEGER ;
  v_temp t_temp ;

 -- restul ca in listing 10.4

TYPE t_atribute IS TABLE OF VARCHAR2 (200) INDEX BY PLS_INTEGER ;

TYPE t_restrictii_atribute IS TABLE OF t_atribute INDEX BY PLS_INTEGER ;

TYPE t_RefCursor IS REF CURSOR ;

PROCEDURE p_creare_tabele (
 tabela VARCHAR2, 
 v_atribute t_atribute, 
 v_tip_atribute t_atribute,
 v_restrictii_atribute t_restrictii_atribute,
 v_restrictii_tabela t_atribute ) ;

PROCEDURE p_sterge_tabela (tabela VARCHAR2) ;

PROCEDURE p_dezactiveaza_restrictii (tabela VARCHAR2) ;

PROCEDURE p_dezactiveaza_restrictii (v_restrictii t_atribute ) ;
 
PROCEDURE p_activeaza_restrictii (tabela VARCHAR2) ;

PROCEDURE p_activeaza_restrictii (v_restrictii t_atribute ) ;

END pac_administrare ;

