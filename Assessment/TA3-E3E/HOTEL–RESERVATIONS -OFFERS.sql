
DROP TABLE ROOMS_RESERVATIONS;
DROP TABLE RESERVATION;
DROP TABLE CUSTOMERS;
DROP TABLE ROOMS;
DROP TABLE SPECIAL_OFFERS;  
  

CREATE TABLE SPECIAL_OFFERS (
    Room_Number NUMBER(10)
        CONSTRAINT nn_Room_Number NOT NULL,
    From__Date DATE
        CONSTRAINT nn_From__DateNOT NULL,
    Until__Date DATE
        CONSTRAINT nn_Until__Date NOT NULL,
    Special_Price_Per_Night NUMBER(10)
        CONSTRAINT nn_Special_Price_Per_Night NOT NULL,
    CONSTRAINT pk_Discounts PRIMARY KEY(Room_Number, From__Date)
);
  
  
CREATE TABLE ROOMS (
    Room_Number NUMBER(10)
        CONSTRAINT PK_ROOMS PRIMARY KEY,
    Floor NUMBER(2)
        CONSTRAINT nn_Floor NOT NULL,
    N_of_beds NUMBER(2)
        CONSTRAINT nn_N_of_beds NOT NULL,
    Price_per_night NUMBER(10)
        CONSTRAINT nn_Price_per_night NOT NULL
);
  
CREATE TABLE CUSTOMERS (
    Cust_Id Number(10)
        CONSTRAINT PK_CUSTOMERS PRIMARY KEY,
    Cust_Name VARCHAR2(100)
        CONSTRAINT nn_Cust_Name NOT NULL,
    Address VARCHAR2(100),
  City VARCHAR2(100),
  Country VARCHAR2(100)
);  



CREATE TABLE RESERVATION (
    Reservation_Id Number(10)
        CONSTRAINT PK_RESERVATION PRIMARY KEY,
    Reservation_Timestamp DATE
        CONSTRAINT nn_Reservation_Timestamp NOT NULL,
    Cust_Id NUMBER(10)
    CONSTRAINT FK_RESERVATION_Cust_Id REFERENCES CUSTOMERS(Cust_Id)
    CONSTRAINT nn_Cust_Id NOT NULL,
  Reserved_Room NUMBER(10)
    CONSTRAINT FK_RESERVATION_NR_CAMERA_REZ REFERENCES ROOMS(Room_Number)
    CONSTRAINT nn_Reserved_Room NOT NULL,
  Reserved_From DATE
    CONSTRAINT nn_Reserved_From NOT NULL,
  Reserved_Until DATE
    CONSTRAINT nn_Reserved_Until NOT NULL,
  Amount_To_Be_Paid Number
);  


CREATE TABLE ROOMS_RESERVATIONS (
    Reservation_date DATE
    CONSTRAINT nn_Reservation_date NOT NULL,
  Room_Number NUMBER(10)
    CONSTRAINT FK_ROOMS_RESERVATIONS_NR_ROOMS REFERENCES ROOMS(Room_Number)
    CONSTRAINT nn_RRRoom_Number NOT NULL,
  Status VARCHAR2(100),
  Reservation_Id NUMBER(10)
    CONSTRAINT FK_RESERVATION_Reservation_Id REFERENCES RESERVATION(Reservation_Id)
    CONSTRAINT nn_Reservation_Id NOT NULL,    
    CONSTRAINT pk_ROOMS_RESERVATIONS PRIMARY KEY(Reservation_date, Room_Number)
);
  
  
  
BEGIN
  -- insert ROOMS
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (1, 0, 2, 250);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (2, 0, 2, 150);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (3, 0, 2, 350);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (4, 0, 1, 100);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (5, 0, 2, 250);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (6, 1, 2, 250);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (7, 1, 2, 150);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (8, 1, 2, 350);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (9, 1, 1, 100);
    
    INSERT INTO ROOMS (Room_Number, Floor, N_of_beds, Price_per_night)
    VALUES (10, 1, 2, 250);

  
    -- insert CUSTOMERS
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (1, 'Andrei', NULL, 'Iasi', 'Romania');
    
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (2, 'Andreea', NULL, 'Cluj-Napoca', 'Romania');
    
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (3, 'George', NULL, NULL, NULL);
    
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (4, 'Georgeta', NULL, NULL, 'Romania');
    
  

     -- insert SPECIAL_OFFERS
   INSERT INTO SPECIAL_OFFERS (Room_Number, From__Date, Until__Date,Special_Price_Per_Night)
    VALUES (1, TO_DATE('12/12/2017', 'dd/mm/yyyy'),TO_DATE('23/12/2017', 'dd/mm/yyyy'),230);
   INSERT INTO SPECIAL_OFFERS (Room_Number, From__Date, Until__Date,Special_Price_Per_Night)
    VALUES (1, TO_DATE('10/04/2017', 'dd/mm/yyyy'),TO_DATE('10/05/2017', 'dd/mm/yyyy'),180);
   INSERT INTO SPECIAL_OFFERS (Room_Number, From__Date, Until__Date,Special_Price_Per_Night)
    VALUES (3, TO_DATE('12/12/2017', 'dd/mm/yyyy'),TO_DATE('23/12/2017', 'dd/mm/yyyy'),300);
   INSERT INTO SPECIAL_OFFERS (Room_Number, From__Date, Until__Date,Special_Price_Per_Night)
    VALUES (3, TO_DATE('10/04/2017', 'dd/mm/yyyy'),TO_DATE('10/07/2017', 'dd/mm/yyyy'),250);  
  
    -- insert RESERVATION
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (1, SYSDATE, 1, 3, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (2, sysdate, 1, 2, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (3, SYSDATE, 2, 1, TO_DATE('15/12/2017', 'dd/mm/yyyy'), TO_DATE('18/12/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (4, SYSDATE, 2, 3, TO_DATE('20/05/2017', 'dd/mm/yyyy'), TO_DATE('25/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (5, SYSDATE, 3, 1, TO_DATE('16/05/2017', 'dd/mm/yyyy'), TO_DATE('21/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (6, SYSDATE, 4, 5, TO_DATE('12/05/2017', 'dd/mm/yyyy'), TO_DATE('17/05/2017', 'dd/mm/yyyy'));
    
    COMMIT;
END;
/
