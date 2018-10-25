DELETE FROM  incas_fact ;
DELETE FROM  incasari ;
DELETE FROM  linii_fact ;
DELETE FROM  fact ;
DELETE FROM  produse ;
DELETE FROM  clienti2 ;
DELETE FROM  coduri_postale ;
DELETE FROM  judete ;

INSERT INTO judete (jud, judet) VALUES ('IS', 'Iasi') ;

INSERT INTO coduri_postale VALUES (700505, 'Iasi', NULL, 'IS') ;

INSERT INTO produse VALUES (1, 'P1', 'kg', NULL, 0.19) ;
INSERT INTO produse VALUES (2, 'P2', 'kg', NULL, 0.09) ;
INSERT INTO produse VALUES (3, 'P3', 'kg', NULL, 0.19) ;


INSERT INTO clienti2 VALUES (1001, 'CL1', 'R1', 'Str.1', '1', 'bl1', '1111111', 700505) ;
INSERT INTO clienti2 VALUES (1002, 'CL2', 'R2', 'Str.2', '2', 'bl2', '1111112', 700505) ;
INSERT INTO clienti2 VALUES (1003, 'CL3', 'R3', 'Str.3', '3', 'bl3', '1111113', 700505) ;


INSERT INTO fact (nrfact, codcl) VALUES (1, 1001);
INSERT INTO fact (nrfact, codcl) VALUES (2, 1001);
INSERT INTO fact (nrfact, codcl) VALUES (3, 1002);
INSERT INTO fact (nrfact, codcl) VALUES (4, 1003);
INSERT INTO fact (nrfact, codcl) VALUES (5, 1002);


INSERT INTO linii_fact VALUES (1, 1, 1, 1000, 1500) ;
INSERT INTO linii_fact VALUES (1, 2, 2, 500, 1400) ;
INSERT INTO linii_fact VALUES (2, 1, 3, 600, 1300) ;
INSERT INTO linii_fact VALUES (3, 1, 1, 700, 1200) ;
INSERT INTO linii_fact VALUES (3, 2, 2, 800, 1600) ;
INSERT INTO linii_fact VALUES (3, 3, 3, 900, 1700) ;
INSERT INTO linii_fact VALUES (4, 1, 1, 800, 1250) ;

INSERT INTO incasari VALUES (1, SYSDATE, 'OP', '4444', SYSDATE-4);
INSERT INTO incasari VALUES (2, SYSDATE, 'OP', '4445', SYSDATE-3);


INSERT INTO incas_fact VALUES (1, 1, 1000000) ;
INSERT INTO incas_fact VALUES (1, 2, 500000) ;
INSERT INTO incas_fact VALUES (1, 3, 100000) ;

INSERT INTO incas_fact VALUES (2, 1, 1100000) ;
INSERT INTO incas_fact VALUES (2, 2, 600000) ;
INSERT INTO incas_fact VALUES (2, 3, 700000) ;

-- @f:\useri\marin\proiectareabd2004\cap09_denormalizare\Listing_9_04bis_pop_bd_vinzari.sql