Set up the database (sub)schema with the following steps:

(1) Create table COUNTRY_GENDATA by launching the script in file `Import-country_gendata-xlsx.sql`

(2) Create table COUNTRY__POP_COORD by launching the script in file `Import-country__pop_coord-xlsx.sql`

(3) Create table COUNTRY__OTHER_DATA by launching the script in file `Import-country__other_data-xlsx.sql`

(4) Create table COVID_DATA by launching the script in file `Import-covid_data__2020-10-01-xlsx.sql`

(5) Declare the PRIMARY KEY in each table. Please notice that in table COUNTRY__POP_COORD most of the
records are duplicated, and you have to remove the duplicates before creating the PRIMARY KEY

(6) Examine all tables structure and adjust the attribute length in order to create the foreign keys

(7) Declare the foreign keys
