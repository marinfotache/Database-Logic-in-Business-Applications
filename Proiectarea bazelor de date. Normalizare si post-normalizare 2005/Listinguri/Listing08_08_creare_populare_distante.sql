DROP TABLE distante ;
CREATE TABLE distante
  (Loc1 VARCHAR2(20),
   Loc2 VARCHAR2(20),
   Distanta NUMBER(5),
   PRIMARY KEY (Loc1, Loc2)
   ) ; 
INSERT INTO distante VALUES ('Iasi', 'Vaslui', 71) ;
INSERT INTO distante VALUES ('Iasi', 'Tg.Frumos', 53) ;
INSERT INTO distante VALUES ('Tg.Frumos', 'Roman', 40) ;
INSERT INTO distante VALUES ('Roman', 'Bacau', 41) ;
INSERT INTO distante VALUES ('Roman', 'Vaslui', 80) ;
INSERT INTO distante VALUES ('Vaslui', 'Birlad', 54) ;
INSERT INTO distante VALUES ('Birlad', 'Tecuci', 48) ;   
INSERT INTO distante VALUES ('Tecuci', 'Tisita', 20) ;
INSERT INTO distante VALUES ('Tisita', 'Focsani', 13) ;
INSERT INTO distante VALUES ('Bacau', 'Adjud', 60) ;
INSERT INTO distante VALUES ('Bacau', 'Vaslui', 85) ;
INSERT INTO distante VALUES ('Adjud', 'Tisita', 32) ;
INSERT INTO distante VALUES ('Focsani', 'Galati', 80) ;
INSERT INTO distante VALUES ('Focsani', 'Braila', 86) ;
INSERT INTO distante VALUES ('Focsani', 'Rm.Sarat', 42) ;
INSERT INTO distante VALUES ('Rm.Sarat', 'Braila', 84) ;
INSERT INTO distante VALUES ('Braila', 'Galati', 11) ;
INSERT INTO distante VALUES ('Tecuci', 'Galati', 67) ;

COMMIT ;
