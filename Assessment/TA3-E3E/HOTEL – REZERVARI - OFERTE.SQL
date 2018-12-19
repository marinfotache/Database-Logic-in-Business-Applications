DROP TABLE RezervariCamere;
DROP TABLE Rezervari;
DROP TABLE Clienti;
DROP TABLE Camere;
DROP TABLE Oferte;  

CREATE TABLE Oferte (
    IdCamera NUMBER(10) CONSTRAINT nn_IdCamera NOT NULL,
    DeLa DATE CONSTRAINT nn_DeLaNOT NULL,
    PanaLa DATE CONSTRAINT nn_PanaLa NOT NULL,
    PretPeNoapteSpecial NUMBER(10) CONSTRAINT nn_PretPeNoapteSpecial NOT NULL,
    CONSTRAINT pk_Discounts PRIMARY KEY(IdCamera, DeLa)
);
  
CREATE TABLE Camere (
    IdCamera NUMBER(10) CONSTRAINT PK_Camere PRIMARY KEY,
    Etaj NUMBER(2) CONSTRAINT nn_Etaj NOT NULL,
    NrPaturi NUMBER(2) CONSTRAINT nn_NrPaturi NOT NULL,
    PretPeNoapte NUMBER(10) CONSTRAINT nn_PretPeNoapte NOT NULL
);
  
CREATE TABLE Clienti (
    IdClient Number(10) CONSTRAINT PK_Clienti PRIMARY KEY,
    NumeClient VARCHAR2(100) CONSTRAINT nn_NumeClient NOT NULL,
    Adresa VARCHAR2(100),
    Oras VARCHAR2(100),
    Tara VARCHAR2(100)
);  

CREATE TABLE Rezervari (
    IdRezervare Number(10) CONSTRAINT PK_Rezervari PRIMARY KEY,
    DataRezervare DATE CONSTRAINT nn_DataRezervare NOT NULL,
    IdClient NUMBER(10) CONSTRAINT FK_IdRezervareClient REFERENCES Clienti(IdClient) CONSTRAINT nn_IdClient NOT NULL,
    IdCameraRezervata NUMBER(10) CONSTRAINT FK_Rezervari_NR_CAMERA_REZ REFERENCES Camere(IdCamera) CONSTRAINT nn_IdCameraRezervata NOT NULL,
    RezervataDeLa DATE CONSTRAINT nn_RezervataDeLa NOT NULL,
    RezervataPanaLa DATE CONSTRAINT nn_RezervataPanaLa NOT NULL,
    SumaDePlatit Number
);  

CREATE TABLE RezervariCamere (
    DataRezervare DATE CONSTRAINT nn_DataRezervareC NOT NULL,
    IdCamera NUMBER(10) CONSTRAINT FK_RezervariCamere_NR_Camere REFERENCES Camere(IdCamera) CONSTRAINT nn_RRIdCamera NOT NULL,
    Status VARCHAR2(100),
    IdRezervare NUMBER(10) CONSTRAINT FK_Rezervari_IdRezervare REFERENCES Rezervari(IdRezervare) CONSTRAINT nn_IdRezervare NOT NULL,    
    CONSTRAINT pk_RezervariCamere PRIMARY KEY(DataRezervare, IdCamera)
);
  
BEGIN
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (1, 0, 2, 250);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (2, 0, 2, 150);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (3, 0, 2, 350);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (4, 0, 1, 100);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (5, 0, 2, 250);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (6, 1, 2, 250);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (7, 1, 2, 150);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (8, 1, 2, 350);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (9, 1, 1, 100);
    INSERT INTO Camere (IdCamera, Etaj, NrPaturi, PretPeNoapte)
    VALUES (10, 1, 2, 250);

    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (1, 'Andrei', NULL, 'Iasi', 'Romania');
    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (2, 'Andreea', NULL, 'Cluj-Napoca', 'Romania');
    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (3, 'George', NULL, NULL, NULL);
    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (4, 'Georgeta', NULL, NULL, 'Romania');

    INSERT INTO Oferte (IdCamera, DeLa, PanaLa,PretPeNoapteSpecial)
    VALUES (1, TO_DATE('12/12/2017', 'dd/mm/yyyy'),TO_DATE('23/12/2017', 'dd/mm/yyyy'),230);
    INSERT INTO Oferte (IdCamera, DeLa, PanaLa,PretPeNoapteSpecial)
    VALUES (1, TO_DATE('10/04/2017', 'dd/mm/yyyy'),TO_DATE('10/05/2017', 'dd/mm/yyyy'),180);
    INSERT INTO Oferte (IdCamera, DeLa, PanaLa,PretPeNoapteSpecial)
    VALUES (3, TO_DATE('12/12/2017', 'dd/mm/yyyy'),TO_DATE('23/12/2017', 'dd/mm/yyyy'),300);
    INSERT INTO Oferte (IdCamera, DeLa, PanaLa,PretPeNoapteSpecial)
    VALUES (3, TO_DATE('10/04/2017', 'dd/mm/yyyy'),TO_DATE('10/07/2017', 'dd/mm/yyyy'),250);  
  
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (1, SYSDATE, 1, 3, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (2, sysdate, 1, 2, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (3, SYSDATE, 2, 1, TO_DATE('15/12/2017', 'dd/mm/yyyy'), TO_DATE('18/12/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (4, SYSDATE, 2, 3, TO_DATE('20/05/2017', 'dd/mm/yyyy'), TO_DATE('25/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (5, SYSDATE, 3, 1, TO_DATE('16/05/2017', 'dd/mm/yyyy'), TO_DATE('21/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (6, SYSDATE, 4, 5, TO_DATE('12/05/2017', 'dd/mm/yyyy'), TO_DATE('17/05/2017', 'dd/mm/yyyy'));
    
    COMMIT;
END;
/
