
DELETE FROM PLATI_AMENZI ;

DELETE FROM CONTRAVENTII_VITEZA ;

DELETE FROM CONTRAVENTII ;

DELETE FROM PERMISE ;

DELETE FROM SOFERI ;

DELETE FROM VEHICULE ;

DELETE FROM LOCALITATI ;

-- S-a creat tabela Localitati

INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(4,'Flamanzi','BT');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(28,'Rosiori','NT');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(83,'Traian','NT');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(96,'Pocreaca','IS');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(13,'Adjud','VN');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(45,'Iasi','IS');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(7,'Valeni','VS');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(6,'Neamt','NT');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(66,'Beba Veche','TM');
INSERT INTO LOCALITATI(IdLoc,DenLoc,Jud)
VALUES(33,'Calugareni','CT');


INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(3,'VS 88 RTU', 'Opel Corsa', '15478G1547', 2012, 3200, 'Benzina', 7, to_date('25-01-2012','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(18,'BT 85 MAX','VW Golf','45683A5282',2008,4200,'Diesel',4,to_date('04-10-2013','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(20,'NT 76 PAU','Skoda Octavia','6425F5532',2011,4200,'Benzina',28,to_date('08-09-2012','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(33,'NT 03 FAK','KIA Rio','3105FA8832',2005,2500,'Diesel',83,to_date('17-12-2008','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(101,'NT 67 NFS','BMW X5','4002JL9879',2015,5000,'Benzina',6,to_date('14-01-2016','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(8,'IS 67 MNS','Porsche 911','235DC2031',2014,5500,'Diesel',96,to_date('25-05-2014','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(131,'VN 05 BEP','Dodge Charger','3986YI0529',2016,2000,'Benzina',13,to_date('18-03-2016','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(85,'TM 03 ZEZ','Dacia 1310','4129RE3381',2003,6000,'Diesel',66,to_date('17-04-2007','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(588,'IS 67 MSA','Alfa Romeo C5','1751PM9995',2007,2800,'Benzina',45,to_date('24-10-2012','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(176,'CT 56 OSS','Ford Mondeo','8884LA3265',2000,2000,'Benzina',33,to_date('12-07-2001','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(857,'IS 06 ZEN','Ford Mondeo','8884LA3165',2000,2500,'Benzina',45,to_date('16-08-2005','DD-MM-YYYY'));
INSERT INTO VEHICULE(IDVeh,NrInmatr,Model,SerieSasiu,AnFabric,CapCilindr,Combustibil,IdLocInmatr,DataInmatr)
VALUES(564,'VN 52 BOS','KIA Rio','8884LA3785',2006,1700,'Benzina',13,to_date('12-07-2006','DD-MM-YYYY'));


-- S-a creat tabela Soferi

INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(3, 2751102226598, 'Popa Ana', to_date('02-11-1975', 'DD-MM-YYYY'), 7);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(7, 1830523458796, 'Aelenei Dan', to_date('23-05-1983', 'DD-MM-YYYY'), 45);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(8, 1831104259876, 'Ionescu Andrei', to_date('04-11-1983', 'DD-MM-YYYY'), 33);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(10, 2910202154879, 'Popescu Diana', to_date('02-02-1991', 'DD-MM-YYYY'), 13);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(5, 1681215256987, 'Maneta Gheorghe', to_date('15-12-1968', 'DD-MM-YYYY'), 96);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(1, 1961214225487, 'Agache Dan', to_date('14-12-1996', 'DD-MM-YYYY'), 6);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(2, 2941111569874, 'Cristescu Ramona',to_date('11-11-1994', 'DD-MM-YYYY'), 33);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(4, 2870206458632, 'Donici Zara', to_date('06-02-1996', 'DD-MM-YYYY'), 28);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(6, 1900521554785, 'Zota Cristian', to_date('21-04-1990', 'DD-MM-YYYY'), 4);
INSERT INTO SOFERI(IdSofer, CNPSofer, NumeSofer, DataNasterii, IdLocSofer)
VALUES(9, 1931215225487, 'Partene Marius', to_date('15-12-1993', 'DD-MM-YYYY'), 66);

-- S-a creat tabela Permise

INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(1,to_date('01-01-2000','DD-MM-YYYY'),2,'A');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(2,to_date('02-02-2012','DD-MM-YYYY'),4,'B');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(3,to_date('14-03-2008','DD-MM-YYYY'),6,'C');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(4,to_date('24-04-2004','DD-MM-YYYY'),1,'D');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(5,to_date('10-05-2012','DD-MM-YYYY'),5,'E');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(6,to_date('09-06-2011','DD-MM-YYYY'),7,'A1');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(7,to_date('02-07-2007','DD-MM-YYYY'),9,'B1');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(8,to_date('08-08-2005','DD-MM-YYYY'),8,'B');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(9,to_date('26-09-2008','DD-MM-YYYY'),3,'A');
INSERT INTO PERMISE(IdPermis,DataEmiterii,IdSofer,Categ)
VALUES(10,to_date('22-09-2009','DD-MM-YYYY'),10,'A');







-- S-a creat tabela Contraventii

INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (25, to_date('12-05-2009', 'DD-MM-YYYY'), 'Depasire viteza', 33, 3, 6, 360, 3, 18);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (27, to_date('17-09-2009', 'DD-MM-YYYY'), 'Depasire viteza', 13, 6, 12, 800, 7, 20);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (28, to_date('19-09-2009', 'DD-MM-YYYY'), 'Depasire viteza', 13, 3, 12, 500, 8, 101);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (29, to_date('30-09-2009', 'DD-MM-YYYY'), 'Depasire viteza', 13, 9, 12, 1200, 7, 20);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (30, to_date('18-11-2009', 'DD-MM-YYYY'), 'Neacordare prioritare', 66, 9, 12, 850, 8, 101);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (38, to_date('30-03-2010', 'DD-MM-YYYY'), 'Depasire viteza', 96, 3, 6, 500, 10, 3);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (47, to_date('05-07-2011', 'DD-MM-YYYY'), 'Depasire viteza', 7, 3, 6, 500, 3, 18);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (50, to_date('07-08-2013', 'DD-MM-YYYY'), 'Trecere pe culoarea rosie', 28, 9, 15, 1500, 9, 33);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (51, to_date('28-01-2014', 'DD-MM-YYYY'), 'Depasire viteza', 83, 6, 12, 1200, 8, 101);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (52, to_date('10-09-2015', 'DD-MM-YYYY'), 'Neacordare prioritare', 45, 3, 6, 600, 10, 3);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (67, to_date('30-04-2016', 'DD-MM-YYYY'), 'Depasire viteza', 83, 6, 9, 750, 3, 18);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (73, to_date('15-08-2016', 'DD-MM-YYYY'), 'Depasire viteza', 96, 6, 9, 560, 7, 20);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (81, to_date('17-09-2016', 'DD-MM-YYYY'), 'Depasire viteza', 7, 3, 6, 450,10, 3);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (83, to_date('18-09-2016', 'DD-MM-YYYY'), 'Trecerea pe culoarea rosie', 13, 6, 9, 900, 9, 33);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (87, to_date('11-01-2017', 'DD-MM-YYYY'), 'Neacordare prioritate', 66, 9, 12, 820, 3, 18);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (89, to_date('19-01-2017', 'DD-MM-YYYY'), 'Neacordare prioritate', 45, 9, 12, 850, 3, 18);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (90, to_date('22-01-2017', 'DD-MM-YYYY'), 'Trecerea pe culoare rosie', 45, 3, 6, 500, 5, 33);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (97, to_date('31-01-2017', 'DD-MM-YYYY'), 'Depasire viteza', 28, 9, 9, 950, 9, 33);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (107, to_date('31-03-2014', 'DD-MM-YYYY'), 'Trecerea pe culoarea rosie', 66, 3, 6, 550, 5, 33);
INSERT INTO CONTRAVENTII(IdContr, DataContr, Descriere, IdLocContr, NrLuni_Suspendare_Permis, NrPctPenaliz, ValAmenda, IdSofer, IDVehicul)
VALUES (201, to_date('26-08-2014', 'DD-MM-YYYY'), 'Depasire viteza', 13, 6, 6, 400, 3, 18);

-- S-a creat tabela Contraventii_Viteza
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (25, 50, 120);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (27, 80, 150);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (38, 50, 100);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (47, 30, 80);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (51, 50, 130);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (67, 70, 80);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (73, 50, 90);
INSERT INTO CONTRAVENTII_VITEZA(IdCont, VitMaxLegala, VitezaEfectiva)
VALUES (81, 80, 170);

   -- S-a creat tabela Plati_Amenzi

INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (5, to_date('14-05-2009', 'DD-MM-YYYY'), 'Chitanta', 33, 25, 360);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (15, to_date('18-09-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 27, 800);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (21, to_date('18-11-2009', 'DD-MM-YYYY'), 'Chitanta', 7, 30, 850);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (25, to_date('31-03-2010', 'DD-MM-YYYY'), 'Chitanta', 96, 38, 500);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (45, to_date('06-07-2011', 'DD-MM-YYYY'), 'Chitanta', 7, 47, 500);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (53, to_date('10-08-2013', 'DD-MM-YYYY'), 'Chitanta', 45, 50, 3000);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (61, to_date('29-01-2015', 'DD-MM-YYYY'), 'Chitanta', 13, 51, 1200);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (78, to_date('10-09-2015', 'DD-MM-YYYY'), 'Chitanta', 45, 52, 600);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (89, to_date('30-04-2016', 'DD-MM-YYYY'), 'Chitanta', 83, 67, 750);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (103, to_date('16-08-2016', 'DD-MM-YYYY'), 'Chitanta', 96, 73, 560);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (120, to_date('17-10-2016', 'DD-MM-YYYY'), 'Chitanta', 7, 81, 450);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (131, to_date('19-09-2016', 'DD-MM-YYYY'), 'Chitanta', 13, 83, 900);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (148, to_date('11-01-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 87, 820);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (150, to_date('18-09-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 28, 800);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (210, to_date('19-09-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 29, 500);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (348, to_date('30-01-2017', 'DD-MM-YYYY'), 'Chitanta', 45, 89, 1200);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (508, to_date('06-04-2017', 'DD-MM-YYYY'), 'Chitanta', 45, 90, 2500);
INSERT INTO PLATI_AMENZI(IdPlata, DataPlata, DocPlata, IdLocPlata, IdContr, ValoarePlata)
VALUES (600, to_date('07-04-2017', 'DD-MM-YYYY'), 'Chitanta', 28, 97, 2000);









