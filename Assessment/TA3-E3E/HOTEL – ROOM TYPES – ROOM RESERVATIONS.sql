DROP TABLE ROOMS_RESERVATIONS;
DROP TABLE RESERVATION;
DROP TABLE CUSTOMERS;
DROP TABLE ROOMS;
DROP TABLE ROOM_TYPES;  




  

CREATE TABLE ROOM_TYPES 
(
    Room_Type NUMBER(2)
         CONSTRAINT PK_Room_Type PRIMARY KEY,
    N_of_Beds NUMBER(3)
        CONSTRAINT nn_N_of_Beds NOT NULL,
    Price_Per_Night NUMBER(10)
        CONSTRAINT nn_Price_Per_Night NOT NULL
);

CREATE TABLE ROOMS (
    Room_Number NUMBER(10)
        CONSTRAINT PK_ROOMS PRIMARY KEY,
    Floor NUMBER(2)
        CONSTRAINT nn_Floor NOT NULL,
    Room_Type NUMBER(10)
        CONSTRAINT nn_Room_Type NOT NULL
    CONSTRAINT FK_Room_Type REFERENCES ROOM_TYPES(Room_Type)
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
  ROOM_TYPE NUMBER(10)
    CONSTRAINT FK_ROOM_TYPES REFERENCES ROOM_TYPES(ROOM_TYPE)
    CONSTRAINT nn_RROOM_TYPE NOT NULL,
  Status VARCHAR2(100),
  Reservation_Id NUMBER(10)
    CONSTRAINT FK_RESERVATION_Reservation_Id REFERENCES RESERVATION(Reservation_Id)
    CONSTRAINT nn_Reservation_Id NOT NULL,    
    CONSTRAINT pk_ROOMS_RESERVATIONS PRIMARY KEY(Reservation_date, ROOM_TYPE),
  Day_Price   DATE
);
  
  

  


  
BEGIN

  -- insert ROOM_TYPES
  
   INSERT INTO ROOM_TYPES (Room_Type, N_of_Beds, Price_Per_Night)
    VALUES (1, 1, 100);
   INSERT INTO ROOM_TYPES (Room_Type, N_of_Beds, Price_Per_Night)
    VALUES (2, 1, 150);
  INSERT INTO ROOM_TYPES (Room_Type, N_of_Beds, Price_Per_Night)
    VALUES (3, 2, 250);
     
  -- insert ROOMS
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (1, 0, 1);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (2, 0, 2);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (3, 0, 1);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (4, 0, 3);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (5, 0, 1);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (6, 1, 2);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (7, 1, 2);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (8, 1, 3);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (9, 1, 1);
    
    INSERT INTO ROOMS (Room_Number, Floor, Room_Type)
    VALUES (10, 1, 3);

  
    -- insert CUSTOMERS
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (1, 'Andrei', NULL, 'Iasi', 'Romania');
    
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (2, 'Andreea', NULL, 'Cluj-Napoca', 'Romania');
    
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (3, 'George', NULL, NULL, NULL);
    
    INSERT INTO CUSTOMERS (Cust_Id, Cust_Name, Address, City, Country)
    VALUES (4, 'Georgeta', NULL, NULL, 'Romania');
    

  
    -- insert RESERVATION
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (1, SYSDATE, 1, 1, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (2, sysdate, 1, 2, TO_DATE('10/05/2017', 'dd/mm/yyyy'), TO_DATE('15/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (3, SYSDATE, 2, 3, TO_DATE('08/05/2017', 'dd/mm/yyyy'), TO_DATE('13/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (4, SYSDATE, 2, 3, TO_DATE('20/05/2017', 'dd/mm/yyyy'), TO_DATE('25/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (5, SYSDATE, 3, 1, TO_DATE('16/05/2017', 'dd/mm/yyyy'), TO_DATE('21/05/2017', 'dd/mm/yyyy'));
    
    INSERT INTO RESERVATION (Reservation_Id, Reservation_Timestamp, Cust_Id, Reserved_Room, Reserved_From, Reserved_Until)
    VALUES (6, SYSDATE, 4, 5, TO_DATE('12/05/2017', 'dd/mm/yyyy'), TO_DATE('17/05/2017', 'dd/mm/yyyy'));
    
    COMMIT;
END;
/
