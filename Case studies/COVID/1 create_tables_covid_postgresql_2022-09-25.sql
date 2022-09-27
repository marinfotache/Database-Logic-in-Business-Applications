-- drop tables
DROP TABLE IF EXISTS covid_data ;
DROP TABLE IF EXISTS country__other_data ;
DROP TABLE IF EXISTS country__pop_coord ;
DROP TABLE IF EXISTS country_gen_info ;

-- create tables

--
CREATE TABLE country_gen_info (
    country_code VARCHAR(26),
    country_name VARCHAR(100),
    region VARCHAR(128),
    country_income_group VARCHAR(100));

ALTER TABLE country_gen_info ADD PRIMARY KEY (country_code) ;
ALTER TABLE country_gen_info ADD UNIQUE (country_name) ;


--
CREATE TABLE country__pop_coord (
    country_code3 VARCHAR(26),
    population NUMERIC(12),
    latitude VARCHAR(26),
    longitude VARCHAR(26));

ALTER TABLE country__pop_coord ADD PRIMARY KEY (country_code3) ;

ALTER TABLE country__pop_coord ADD CONSTRAINT fk_cpc_countries
    FOREIGN KEY (country_code3) REFERENCES country_gen_info (country_code) ;


--
CREATE TABLE country__other_data (
    country_code_iso3 VARCHAR(26),
    gdp_per_capita NUMERIC(21, 13),
    health_exp NUMERIC(19, 17),
    pop_65 NUMERIC(19, 15),
    pop_female NUMERIC(19, 15),
    smoking_females NUMERIC(20, 16),
    smoking_males NUMERIC(19, 15));

ALTER TABLE country__other_data ADD PRIMARY KEY (country_code_iso3) ;

ALTER TABLE country__other_data ADD CONSTRAINT fk_cod_countries
    FOREIGN KEY (country_code_iso3) REFERENCES country_gen_info (country_code) ;


--
CREATE TABLE covid_data (
    COUNTRY_CODE VARCHAR(26),
    REPORT_DATE DATE,
    CONFIRMED NUMERIC(15),
    DEATHS NUMERIC(15),
    RECOVERED NUMERIC(15),
    TESTS NUMERIC(15),
    VACCINES NUMERIC(15),
    people_vaccinated NUMERIC(15),
    people_fully_vaccinated NUMERIC(15),
    HOSP NUMERIC(15),
    ICU NUMERIC(15),
    VENT NUMERIC(15),
    SCHOOL_CLOSING NUMERIC(3),
    WORKPLACE_CLOSING NUMERIC(3),
    CANCEL_EVENTS NUMERIC(3),
    GATHERINGS_RESTRICTIONS NUMERIC(3),
    TRANSPORT_CLOSING NUMERIC(3),
    STAY_HOME_RESTRICTIONS NUMERIC(3),
    INTERNAL_MOVEMENT_RESTRICTIONS NUMERIC(3),
    INTERNATIONAL_MOVEMENT_RESTRICTIONS NUMERIC(3),
    INFORMATION_CAMPAIGNS NUMERIC(3),
    TESTING_POLICY NUMERIC(3),
    CONTACT_TRACING NUMERIC(3),
    facial_coverings NUMERIC(3),
    vaccination_policy NUMERIC(3),
    elderly_people_protection NUMERIC(3),
    government_response_index  NUMERIC(6, 2),
    STRINGENCY_INDEX NUMERIC(6, 2),
    containment_health_index NUMERIC(6, 2),
    economic_support_index NUMERIC(6, 2)
    );

ALTER TABLE covid_data ADD PRIMARY KEY (COUNTRY_CODE, REPORT_DATE) ;

ALTER TABLE covid_data ADD CONSTRAINT fk_covid_countries
    FOREIGN KEY (COUNTRY_CODE) REFERENCES country_gen_info (country_code) ;

--
-- Next,  import records from `csv` files using `pgAdmin`
--
