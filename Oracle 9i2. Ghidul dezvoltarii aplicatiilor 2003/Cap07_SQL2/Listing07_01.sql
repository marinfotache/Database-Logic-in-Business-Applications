DROP TABLE ierarhie	;

CREATE TABLE ierarhie (
	marca INTEGER 
   		CONSTRAINT nn_ierarhie_marca NOT NULL
     CONSTRAINT pk_ierarhie PRIMARY KEY 
   		CONSTRAINT fk_ierarhie_personal REFERENCES personal (marca)
 , marca_sef INTEGER 
   		CONSTRAINT fk_ierarhie_personal2 REFERENCES personal (marca)
	) ;

INSERT INTO ierarhie VALUES (104, NULL) ;
INSERT INTO ierarhie VALUES (108, 104) ;
INSERT INTO ierarhie VALUES (106, 104) ;
INSERT INTO ierarhie VALUES (105, 104) ;
INSERT INTO ierarhie VALUES (110, 108) ;
INSERT INTO ierarhie VALUES (102, 106) ;
INSERT INTO ierarhie VALUES (107, 106) ;
INSERT INTO ierarhie VALUES (103, 105) ;
INSERT INTO ierarhie VALUES (101, 105) ;
INSERT INTO ierarhie VALUES (109, 103) ;
COMMIT ;
