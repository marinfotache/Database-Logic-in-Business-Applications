DROP TABLE RezervariCamere;
DROP TABLE Rezervari;
DROP TABLE Clienti;
DROP TABLE Camere;
DROP TABLE TipuriCamere;  
DROP TABLE Reduceri;

CREATE TABLE Reduceri (
    SumaDeLa Number CONSTRAINT nn_SumaDeLa NOT NULL,
    SumaPanaLa Number CONSTRAINT nn_SumaPanaLa NOT NULL,
    ProcentReducere Number(2),
    CONSTRAINT pk_Reduceri PRIMARY KEY(SumaDeLa, SumaPanaLa)
);  
  
CREATE TABLE TipuriCamere (
    TipCamera NUMBER(2) CONSTRAINT PK_TipCamera PRIMARY KEY,
    NrPaturi NUMBER(3) CONSTRAINT nn_NrPaturi NOT NULL,
    PretPeNoapte NUMBER(10) CONSTRAINT nn_PretPeNoapte NOT NULL
);

CREATE TABLE Camere (
    IdCamera NUMBER(10) CONSTRAINT PK_Camere PRIMARY KEY,
    Etaj NUMBER(2) CONSTRAINT nn_Etaj NOT NULL,
    TipCamera NUMBER(10) CONSTRAINT nn_TipCamera NOT NULL CONSTRAINT FK_TipCamera REFERENCES TipuriCamere(TipCamera)
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
    TipCameraRezervata NUMBER(10) CONSTRAINT FK_TipuriCamere_REZ REFERENCES TipuriCamere(TipCamera) CONSTRAINT nn_Reserved_Room NOT NULL,
    RezervataDeLa DATE CONSTRAINT nn_RezervataDeLa NOT NULL,
    RezervataPanaLa DATE CONSTRAINT nn_RezervataPanaLa NOT NULL,
    SumaDePlatit Number,
	  Discount Number(2)
);  

CREATE TABLE RezervariCamere (
    Rezervari_date DATE CONSTRAINT nn_Rezervari_date NOT NULL,
    TipCamera NUMBER(10) CONSTRAINT FK_TipuriCamere REFERENCES TipuriCamere(TipCamera) CONSTRAINT nn_RTipCamera NOT NULL,
    Status VARCHAR2(100),
    IdRezervare NUMBER(10) CONSTRAINT FK_Rezervari_IdRezervare REFERENCES Rezervari(IdRezervare) CONSTRAINT nn_IdRezervare NOT NULL,    
    CONSTRAINT pk_RezervariCamere PRIMARY KEY(Rezervari_date, TipCamera),
    ZiPret DATE
);
  
BEGIN
  
    INSERT INTO TipuriCamere (TipCamera, NrPaturi, PretPeNoapte)
    VALUES (1, 1, 100);
    INSERT INTO TipuriCamere (TipCamera, NrPaturi, PretPeNoapte)
    VALUES (2, 1, 150);
    INSERT INTO TipuriCamere (TipCamera, NrPaturi, PretPeNoapte)
    VALUES (3, 2, 250);

    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (1, 0, 1);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (2, 0, 2);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (3, 0, 1);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (4, 0, 3);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (5, 0, 1);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (6, 1, 2);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (7, 1, 2);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (8, 1, 3);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (9, 1, 1);
    INSERT INTO Camere (IdCamera, Etaj, TipCamera)
    VALUES (10, 1, 3);

    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (1, 'Andrei', NULL, 'Iasi', 'Romania');
    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (2, 'Andreea', NULL, 'Cluj-Napoca', 'Romania');
    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (3, 'George', NULL, NULL, NULL);
    INSERT INTO Clienti (IdClient, NumeClient, Adresa, Oras, Tara)
    VALUES (4, 'Georgeta', NULL, NULL, 'Romania');

    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, TipCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (1, SYSDATE, 1, 1, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, TipCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (2, sysdate, 1, 2, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, TipCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (3, SYSDATE, 2, 3, TO_DATE('08/05/2017', 'dd/mm/yyyy'), TO_DATE('13/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, TipCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (4, SYSDATE, 2, 1, TO_DATE('20/05/2017', 'dd/mm/yyyy'), TO_DATE('25/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, TipCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (5, SYSDATE, 3, 1, TO_DATE('16/05/2017', 'dd/mm/yyyy'), TO_DATE('21/05/2017', 'dd/mm/yyyy'));
    INSERT INTO Rezervari (IdRezervare, DataRezervare, IdClient, TipCameraRezervata, RezervataDeLa, RezervataPanaLa)
    VALUES (6, SYSDATE, 4, 2, TO_DATE('12/05/2017', 'dd/mm/yyyy'), TO_DATE('17/05/2017', 'dd/mm/yyyy'));
    
    COMMIT;
END;
/
