DROP TABLE RezervariCamere;
DROP TABLE Rezervari;
DROP TABLE Clienti;
DROP TABLE Camere;
DROP TABLE Reduceri;  

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

CREATE TABLE Reduceri (
    SumaDeLa Number CONSTRAINT nn_SumaDeLa NOT NULL,
    SumaPanaLa Number CONSTRAINT nn_SumaPanaLa NOT NULL,
    ProcentReducere Number(2),
    CONSTRAINT pk_Reduceri PRIMARY KEY(SumaDeLa, SumaPanaLa)
);  

CREATE TABLE Rezervari (
    IdRezervare Number(10) CONSTRAINT PK_RESERVATION PRIMARY KEY,
    DataRezervare DATE CONSTRAINT nn_DataRezervareCamera NOT NULL,
    IdClient NUMBER(10) CONSTRAINT FK_IdRezervareClient REFERENCES Clienti(IdClient) CONSTRAINT nn_IdClient NOT NULL,
    IdCameraRezervata NUMBER(10) CONSTRAINT FK_RESERVATION_NR_CAMERA_REZ REFERENCES Camere(IdCamera) CONSTRAINT nn_IdCameraRezervata NOT NULL,
    RezervataDeLa DATE CONSTRAINT nn_RezervataDeLa NOT NULL,
    RezervataPanaLa DATE CONSTRAINT nn_RezervataPanaLa NOT NULL,
    SumaDePlatit Number,
    Reducere Number
);  

CREATE TABLE RezervariCamere (
    DataRezervare DATE CONSTRAINT nn_DataRezervare NOT NULL,
    IdCamera NUMBER(10) CONSTRAINT FK_RezervariCamere_NR_Camere REFERENCES Camere(IdCamera) CONSTRAINT nn_IdCameraRez NOT NULL,
    Status VARCHAR2(100),
    IdRezervare NUMBER(10) CONSTRAINT FK_RESERVATION_IdRezervare REFERENCES Rezervari(IdRezervare) CONSTRAINT nn_IdRezervareCamera NOT NULL,    
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

    INSERT INTO Reduceri (SumaDeLa, SumaPanaLa, ProcentReducere)
    VALUES (0, 100,NULL);
    INSERT INTO Reduceri (SumaDeLa, SumaPanaLa, ProcentReducere)
    VALUES (101, 200,5);
    INSERT INTO Reduceri (SumaDeLa, SumaPanaLa, ProcentReducere)
    VALUES (201, 500,10);
    INSERT INTO Reduceri (SumaDeLa, SumaPanaLa, ProcentReducere)
    VALUES (501, 1000,15);  
 
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (1, SYSDATE, 1, 1, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (2, sysdate, 1, 2, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (3, SYSDATE, 2, 3, TO_DATE('08/05/2017', 'dd/mm/yyyy'), TO_DATE('13/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (4, SYSDATE, 2, 3, TO_DATE('20/05/2017', 'dd/mm/yyyy'), TO_DATE('25/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (5, SYSDATE, 3, 1, TO_DATE('16/05/2017', 'dd/mm/yyyy'), TO_DATE('21/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, IdCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (6, SYSDATE, 4, 5, TO_DATE('12/05/2017', 'dd/mm/yyyy'), TO_DATE('17/05/2017', 'dd/mm/yyyy'));
    
    COMMIT;
END;
/
