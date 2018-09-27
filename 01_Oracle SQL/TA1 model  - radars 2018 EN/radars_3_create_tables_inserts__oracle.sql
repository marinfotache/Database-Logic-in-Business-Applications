-- Script for creating the tables of database RADARS
-- Last update: 2017-10-07


----------------------------------------------------------------------------
-- 							Drop the tables (if exists)
-- 
DROP TABLE payments;
DROP TABLE infringements_for_speed;
DROP TABLE infringements;
DROP TABLE driving_licences;
DROP TABLE drivers;
DROP TABLE cars FORCE;
DROP TABLE cities;


CREATE TABLE cities (   
   city_id INT
    	CONSTRAINT pk_cities PRIMARY KEY ,
   city_name VARCHAR(50)
        CONSTRAINT ck_city_name CHECK (city_name=INITCAP(city_name))
        CONSTRAINT nn_city_name NOT NULL,
   county_abbrev VARCHAR(2) NOT NULL
        CONSTRAINT ck_county_abbrev CHECK (county_abbrev=LTRIM(UPPER(county_abbrev)))
   ) ;


CREATE TABLE cars (
   car_id INTEGER
       CONSTRAINT pk_cars PRIMARY KEY,      
   licence_plate VARCHAR(10) 
		CONSTRAINT un_licence_plate UNIQUE
        CONSTRAINT nn_licence_plate NOT NULL,
   car_model_name VARCHAR(35) NOT NULL,
   chasis_serial_number CHAR(17) 
		CONSTRAINT un_chasis_serial_number UNIQUE
        CONSTRAINT nn_chasis_serial_number NOT NULL,        
   manufacturing_year NUMERIC(4) NOT NULL,
   displacement_cc INTEGER,
   fuel_type CHAR(8)
        CONSTRAINT ck_fuel_type CHECK (fuel_type IN('gasoline', 'diesel'))
        CONSTRAINT nn_fuel_type NOT NULL,
   car_registration_city_id INTEGER,
   car_registration_date DATE NOT NULL   
   )  ;
   

CREATE TABLE drivers (
   driver_id INT
    	CONSTRAINT pk_drivers PRIMARY KEY NOT NULL,
   driver_national_code CHAR(13)
        CONSTRAINT un_driver_national_code UNIQUE,
   driver_name VARCHAR(40) NOT NULL,
   date_of_birth DATE,
   city_driver_id INT NOT NULL
	  ) ;
    
   
CREATE TABLE driving_licences (
   drv_licence_id INTEGER
       CONSTRAINT pk_drv_licences PRIMARY KEY,
   drv_licence_date DATE NOT NULL,
   driver_id INTEGER NOT NULL,
   type_of_vehicles VARCHAR(5)
        CONSTRAINT ck_type_of_vehicles CHECK (type_of_vehicles=UPPER(type_of_vehicles))
        CONSTRAINT nn_type_of_vehicles NOT NULL
   ) ;
   

CREATE TABLE infringements (
   infringement_id INT
    CONSTRAINT pk_infringements PRIMARY KEY NOT NULL,
   infringement_date DATE NOT NULL,
   infringement_details VARCHAR(100) NOT NULL,
   city_infringement_id INT NOT NULL,
   driving_suspension_months INT,
   penalty_points INT NOT NULL,
   penalty_amount INT NOT NULL,
   driver_id INT NOT NULL,
   car_id INT NOT NULL
   ) ;
   
   
CREATE TABLE infringements_for_speed (
   infringement_id INT
  	CONSTRAINT pk_infringements_speed PRIMARY KEY NOT NULL,
   allowed_max_speed INT NOT NULL,
   recorded_speed INT NOT NULL

   ) ;


CREATE TABLE payments (
   payment_id INT
	CONSTRAINT pk_payments PRIMARY KEY NOT NULL,
   payment_date DATE DEFAULT CURRENT_DATE 
    CONSTRAINT nn_payment_date NOT NULL,
   payment_order VARCHAR(13) NOT NULL,
   city_payment_id INT NOT NULL,
   infringement_id INT
        CONSTRAINT un_infringement_id UNIQUE
        CONSTRAINT nn_infringement_id NOT NULL,
   paid_amount NUMERIC(6) NOT NULL
   ) ;


----------------------------------------------------------------------------
-- 								Declare foreign keys
-- 


ALTER TABLE cars ADD CONSTRAINT fk_veh_cities
  FOREIGN KEY (car_registration_city_id) REFERENCES cities(city_id);
  
ALTER TABLE drivers ADD CONSTRAINT fk_drivers_cities
  FOREIGN KEY (city_driver_id) REFERENCES cities(city_id);

ALTER TABLE driving_licences ADD CONSTRAINT fk_drv_lic_drivers
  FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);
  
ALTER TABLE infringements ADD CONSTRAINT fk_infr_cities
  FOREIGN KEY (city_infringement_id) REFERENCES cities(city_id);

ALTER TABLE infringements ADD CONSTRAINT fk_infr_drivers
  FOREIGN KEY (driver_id) REFERENCES drivers(driver_id);

ALTER TABLE infringements ADD CONSTRAINT fk_infr_cars
  FOREIGN KEY (car_id) REFERENCES cars(car_id);

ALTER TABLE infringements_for_speed ADD CONSTRAINT fk_infr_speed_infr
  FOREIGN KEY (infringement_id) REFERENCES infringements (infringement_id);

ALTER TABLE payments ADD CONSTRAINT fk_pay_cities
  FOREIGN KEY (city_payment_id) REFERENCES cities(city_id);

ALTER TABLE payments ADD CONSTRAINT fk_pay_infring
  FOREIGN KEY (infringement_id) REFERENCES infringements (infringement_id);



----------------------------------------------------------------------------
-- 									inserts

DELETE FROM payments ;
DELETE FROM infringements_for_speed ;
DELETE FROM infringements ;
DELETE FROM driving_licences ;
DELETE FROM drivers ;
DELETE FROM cars ;
DELETE FROM cities ;


INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(4,'Flamanzi','BT');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(28,'Rosiori','NT');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(83,'Traian','NT');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(96,'Pocreaca','IS');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(13,'Adjud','VN');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(45,'Iasi','IS');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(7,'Valeni','VS');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(6,'Neamt','NT');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(66,'Beba Veche','TM');
INSERT INTO cities(city_id,city_name,county_abbrev)
VALUES(33,'Calugareni','CT');


INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(3,'VS 88 RTU', 'Opel Corsa', '15478G1547', 2012, 3200, 'gasoline', 7, to_date('25-01-2012','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(18,'BT 85 MAX','VW Golf','45683A5282',2008,4200,'diesel',4,to_date('04-10-2013','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(20,'NT 76 PAU','Skoda Octavia','6425F5532',2011,4200,'gasoline',28,to_date('08-09-2012','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(33,'NT 03 FAK','KIA Rio','3105FA8832',2005,2500,'diesel',83,to_date('17-12-2008','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(101,'NT 67 NFS','BMW X5','4002JL9879',2015,5000,'gasoline',6,to_date('14-01-2016','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(8,'IS 67 MNS','Porsche 911','235DC2031',2014,5500,'diesel',96,to_date('25-05-2014','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(131,'VN 05 BEP','Dodge Charger','3986YI0529',2016,2000,'gasoline',13,to_date('18-03-2016','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(85,'TM 03 ZEZ','Dacia 1310','4129RE3381',2003,6000,'diesel',66,to_date('17-04-2007','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(588,'IS 67 MSA','Alfa Romeo C5','1751PM9995',2007,2800,'gasoline',45,to_date('24-10-2012','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(176,'CT 56 OSS','Ford Mondeo','8884LA3265',2000,2000,'gasoline',33,to_date('12-07-2001','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(857,'IS 06 ZEN','Ford Mondeo','8884LA3165',2000,2500,'gasoline',45,to_date('16-08-2005','DD-MM-YYYY'));
INSERT INTO cars(car_id,licence_plate,car_model_name,chasis_serial_number,manufacturing_year,displacement_cc,fuel_type,car_registration_city_id,car_registration_date)
VALUES(564,'VN 52 BOS','KIA Rio','8884LA3785',2006,1700,'gasoline',13,to_date('12-07-2006','DD-MM-YYYY'));


-- S-a creat tabela drivers

INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(3, 2751102226598, 'Popa Ana', to_date('02-11-1975', 'DD-MM-YYYY'), 7);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(7, 1830523458796, 'Aelenei Dan', to_date('23-05-1983', 'DD-MM-YYYY'), 45);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(8, 1831104259876, 'Ionescu Andrei', to_date('04-11-1983', 'DD-MM-YYYY'), 33);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(10, 2910202154879, 'Popescu Diana', to_date('02-02-1991', 'DD-MM-YYYY'), 13);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(5, 1681215256987, 'Maneta Gheorghe', to_date('15-12-1968', 'DD-MM-YYYY'), 96);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(1, 1961214225487, 'Agache Dan', to_date('14-12-1996', 'DD-MM-YYYY'), 6);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(2, 2941111569874, 'Cristescu Ramona',to_date('11-11-1994', 'DD-MM-YYYY'), 33);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(4, 2870206458632, 'Donici Zara', to_date('06-02-1996', 'DD-MM-YYYY'), 28);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(6, 1900521554785, 'Zota Cristian', to_date('21-04-1990', 'DD-MM-YYYY'), 4);
INSERT INTO drivers(driver_id, driver_national_code, driver_name, date_of_birth, city_driver_id)
VALUES(9, 1931215225487, 'Partene Marius', to_date('15-12-1993', 'DD-MM-YYYY'), 66);

-- S-a creat tabela driving_licences

INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(1,to_date('01-01-2000','DD-MM-YYYY'),2,'A');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(2,to_date('02-02-2012','DD-MM-YYYY'),4,'B');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(3,to_date('14-03-2008','DD-MM-YYYY'),6,'C');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(4,to_date('24-04-2004','DD-MM-YYYY'),1,'D');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(5,to_date('10-05-2012','DD-MM-YYYY'),5,'E');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(6,to_date('09-06-2011','DD-MM-YYYY'),7,'A1');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(7,to_date('02-07-2007','DD-MM-YYYY'),9,'B1');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(8,to_date('08-08-2005','DD-MM-YYYY'),8,'B');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(9,to_date('26-09-2008','DD-MM-YYYY'),3,'A');
INSERT INTO driving_licences(drv_licence_id,drv_licence_date,driver_id,type_of_vehicles)
VALUES(10,to_date('22-09-2009','DD-MM-YYYY'),10,'A');







-- S-a creat tabela infringements

INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (25, to_date('12-05-2009', 'DD-MM-YYYY'), 'Depasire viteza', 33, 3, 6, 360, 3, 18);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (27, to_date('17-09-2009', 'DD-MM-YYYY'), 'Depasire viteza', 13, 6, 12, 800, 7, 20);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (28, to_date('19-09-2009', 'DD-MM-YYYY'), 'Depasire viteza', 13, 3, 12, 500, 8, 101);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (29, to_date('30-09-2009', 'DD-MM-YYYY'), 'Depasire viteza', 13, 9, 12, 1200, 7, 20);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (30, to_date('18-11-2009', 'DD-MM-YYYY'), 'Neacordare prioritare', 66, 9, 12, 850, 8, 101);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (38, to_date('30-03-2010', 'DD-MM-YYYY'), 'Depasire viteza', 96, 3, 6, 500, 10, 3);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (47, to_date('05-07-2011', 'DD-MM-YYYY'), 'Depasire viteza', 7, 3, 6, 500, 3, 18);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (50, to_date('07-08-2013', 'DD-MM-YYYY'), 'Trecere pe culoarea rosie', 28, 9, 15, 1500, 9, 33);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (51, to_date('28-01-2014', 'DD-MM-YYYY'), 'Depasire viteza', 83, 6, 12, 1200, 8, 101);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (52, to_date('10-09-2015', 'DD-MM-YYYY'), 'Neacordare prioritare', 45, 3, 6, 600, 10, 3);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (67, to_date('30-04-2016', 'DD-MM-YYYY'), 'Depasire viteza', 83, 6, 9, 750, 3, 18);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (73, to_date('15-08-2016', 'DD-MM-YYYY'), 'Depasire viteza', 96, 6, 9, 560, 7, 20);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (81, to_date('17-09-2016', 'DD-MM-YYYY'), 'Depasire viteza', 7, 3, 6, 450,10, 3);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (83, to_date('18-09-2016', 'DD-MM-YYYY'), 'Trecerea pe culoarea rosie', 13, 6, 9, 900, 9, 33);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (87, to_date('11-01-2017', 'DD-MM-YYYY'), 'Neacordare prioritate', 66, 9, 12, 820, 3, 18);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (89, to_date('19-01-2017', 'DD-MM-YYYY'), 'Neacordare prioritate', 45, 9, 12, 850, 3, 18);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (90, to_date('22-01-2017', 'DD-MM-YYYY'), 'Trecerea pe culoare rosie', 45, 3, 6, 500, 5, 33);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (97, to_date('31-01-2017', 'DD-MM-YYYY'), 'Depasire viteza', 28, 9, 9, 950, 9, 33);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (107, to_date('31-03-2014', 'DD-MM-YYYY'), 'Trecerea pe culoarea rosie', 66, 3, 6, 550, 5, 33);
INSERT INTO infringements(infringement_id, infringement_date, infringement_details, city_infringement_id, driving_suspension_months, penalty_points, penalty_amount, driver_id, car_id)
VALUES (201, to_date('26-02-2017', 'DD-MM-YYYY'), 'Depasire viteza', 13, 6, 6, 400, 3, 18);

-- S-a creat tabela infringements_for_speed
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (25, 50, 120);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (27, 80, 150);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (38, 50, 100);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (47, 30, 80);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (51, 50, 130);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (67, 70, 80);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (73, 50, 90);
INSERT INTO infringements_for_speed(infringement_id, allowed_max_speed, recorded_speed)
VALUES (81, 80, 170);

   -- S-a creat tabela payments

INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (5, to_date('14-05-2009', 'DD-MM-YYYY'), 'Chitanta', 33, 25, 360);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (15, to_date('18-09-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 27, 800);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (21, to_date('18-11-2009', 'DD-MM-YYYY'), 'Chitanta', 7, 30, 850);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (25, to_date('31-03-2010', 'DD-MM-YYYY'), 'Chitanta', 96, 38, 500);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (45, to_date('06-07-2011', 'DD-MM-YYYY'), 'Chitanta', 7, 47, 500);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (53, to_date('10-08-2013', 'DD-MM-YYYY'), 'Chitanta', 45, 50, 3000);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (61, to_date('29-01-2015', 'DD-MM-YYYY'), 'Chitanta', 13, 51, 1200);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (78, to_date('10-09-2015', 'DD-MM-YYYY'), 'Chitanta', 45, 52, 600);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (89, to_date('30-04-2016', 'DD-MM-YYYY'), 'Chitanta', 83, 67, 750);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (103, to_date('16-08-2016', 'DD-MM-YYYY'), 'Chitanta', 96, 73, 560);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (120, to_date('17-10-2016', 'DD-MM-YYYY'), 'Chitanta', 7, 81, 450);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (131, to_date('19-09-2016', 'DD-MM-YYYY'), 'Chitanta', 13, 83, 900);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (148, to_date('11-01-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 87, 820);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (150, to_date('18-09-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 28, 800);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (210, to_date('19-09-2009', 'DD-MM-YYYY'), 'Chitanta', 13, 29, 500);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (348, to_date('30-01-2017', 'DD-MM-YYYY'), 'Chitanta', 45, 89, 1200);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (508, to_date('06-04-2017', 'DD-MM-YYYY'), 'Chitanta', 45, 90, 2500);
INSERT INTO payments(payment_id, payment_date, payment_order, city_payment_id, infringement_id, paid_amount)
VALUES (600, to_date('07-04-2017', 'DD-MM-YYYY'), 'Chitanta', 28, 97, 2000);



  
