-- DROP TABLE COUNTRIES_MODEL CASCADE CONSTRAINTS ;

CREATE TABLE COUNTRIES_MODEL (	
  	COUNTRY_CODE VARCHAR(10) PRIMARY KEY, 
	COUNTRY_NAME VARCHAR(255) UNIQUE, 
	REGION VARCHAR(255), 
	INCOME_GROUP VARCHAR(255)
   ) ;

SET DEFINE OFF;


INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ABW','Aruba','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('AFG','Afghanistan','South Asia','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('AGO','Angola','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ALB','Albania','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('AND','Andorra','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ARE','United Arab Emirates','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ARG','Argentina','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ARM','Armenia','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ASM','American Samoa','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ATG','Antigua and Barbuda','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('AUS','Australia','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('AUT','Austria','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('AZE','Azerbaijan','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BDI','Burundi','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BEL','Belgium','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BEN','Benin','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BFA','Burkina Faso','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BGD','Bangladesh','South Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BGR','Bulgaria','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BHR','Bahrain','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BHS','Bahamas, The','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BIH','Bosnia and Herzegovina','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BLR','Belarus','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BLZ','Belize','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BMU','Bermuda','North America','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BOL','Bolivia','Latin America and  Caribbean','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BRA','Brazil','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BRB','Barbados','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BRN','Brunei Darussalam','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BTN','Bhutan','South Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('BWA','Botswana','Sub-Saharan Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CAF','Central African Republic','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CAN','Canada','North America','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CHE','Switzerland','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CHI','Channel Islands','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CHL','Chile','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CHN','China','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CIV','Cote d''Ivoire','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CMR','Cameroon','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('COD','Congo, Dem. Rep.','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('COG','Congo, Rep.','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('COL','Colombia','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('COM','Comoros','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CPV','Cabo Verde','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CRI','Costa Rica','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CUB','Cuba','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CUW','Curacao','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CYM','Cayman Islands','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CYP','Cyprus','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('CZE','Czech Republic','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('DEU','Germany','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('DJI','Djibouti','Middle East and  North Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('DMA','Dominica','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('DNK','Denmark','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('DOM','Dominican Republic','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('DZA','Algeria','Middle East and  North Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ECU','Ecuador','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('EGY','Egypt, Arab Rep.','Middle East and  North Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ERI','Eritrea','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ESP','Spain','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('EST','Estonia','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ETH','Ethiopia','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('FIN','Finland','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('FJI','Fiji','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('FRA','France','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('FRO','Faroe Islands','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('FSM','Micronesia, Fed. Sts.','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GAB','Gabon','Sub-Saharan Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GBR','United Kingdom','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GEO','Georgia','Europe and  Central Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GHA','Ghana','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GIB','Gibraltar','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GIN','Guinea','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GMB','Gambia, The','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GNB','Guinea-Bissau','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GNQ','Equatorial Guinea','Sub-Saharan Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GRC','Greece','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GRD','Grenada','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GRL','Greenland','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GTM','Guatemala','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GUM','Guam','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('GUY','Guyana','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('HKG','Hong Kong SAR, China','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('HND','Honduras','Latin America and  Caribbean','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('HRV','Croatia','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('HTI','Haiti','Latin America and  Caribbean','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('HUN','Hungary','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('IDN','Indonesia','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('IMN','Isle of Man','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('IND','India','South Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('IRL','Ireland','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('IRN','Iran, Islamic Rep.','Middle East and  North Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('IRQ','Iraq','Middle East and  North Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ISL','Iceland','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ISR','Israel','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ITA','Italy','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('JAM','Jamaica','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('JOR','Jordan','Middle East and  North Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('JPN','Japan','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KAZ','Kazakhstan','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KEN','Kenya','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KGZ','Kyrgyz Republic','Europe and  Central Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KHM','Cambodia','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KIR','Kiribati','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KNA','St. Kitts and Nevis','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KOR','Korea, Rep.','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('KWT','Kuwait','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LAO','Lao PDR','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LBN','Lebanon','Middle East and  North Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LBR','Liberia','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LBY','Libya','Middle East and  North Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LCA','St. Lucia','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LIE','Liechtenstein','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LKA','Sri Lanka','South Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LSO','Lesotho','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LTU','Lithuania','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LUX','Luxembourg','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('LVA','Latvia','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MAC','Macao SAR, China','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MAF','St. Martin (French part)','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MAR','Morocco','Middle East and  North Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MCO','Monaco','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MDA','Moldova','Europe and  Central Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MDG','Madagascar','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MDV','Maldives','South Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MEX','Mexico','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MHL','Marshall Islands','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MKD','Macedonia, FYR','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MLI','Mali','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MLT','Malta','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MMR','Myanmar','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MNE','Montenegro','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MNG','Mongolia','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MNP','Northern Mariana Islands','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MOZ','Mozambique','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MRT','Mauritania','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MUS','Mauritius','Sub-Saharan Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MWI','Malawi','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('MYS','Malaysia','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NAM','Namibia','Sub-Saharan Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NCL','New Caledonia','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NER','Niger','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NGA','Nigeria','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NIC','Nicaragua','Latin America and  Caribbean','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NLD','Netherlands','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NOR','Norway','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NPL','Nepal','South Asia','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NRU','Nauru','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('NZL','New Zealand','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('OMN','Oman','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PAK','Pakistan','South Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PAN','Panama','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PER','Peru','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PHL','Philippines','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PLW','Palau','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PNG','Papua New Guinea','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('POL','Poland','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PRI','Puerto Rico','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PRK','Korea, Dem. People’s Rep.','East Asia and  Pacific','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PRT','Portugal','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PRY','Paraguay','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PSE','West Bank and Gaza','Middle East and  North Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('PYF','French Polynesia','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('QAT','Qatar','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ROU','Romania','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('RUS','Russian Federation','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('RWA','Rwanda','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SAU','Saudi Arabia','Middle East and  North Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SDN','Sudan','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SEN','Senegal','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SGP','Singapore','East Asia and  Pacific','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SLB','Solomon Islands','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SLE','Sierra Leone','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SLV','El Salvador','Latin America and  Caribbean','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SMR','San Marino','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SOM','Somalia','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SRB','Serbia','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SSD','South Sudan','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('STP','Sao Tome and Principe','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SUR','Suriname','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SVK','Slovak Republic','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SVN','Slovenia','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SWE','Sweden','Europe and  Central Asia','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SWZ','Eswatini','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SXM','Sint Maarten (Dutch part)','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SYC','Seychelles','Sub-Saharan Africa','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('SYR','Syrian Arab Republic','Middle East and  North Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TCA','Turks and Caicos Islands','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TCD','Chad','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TGO','Togo','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('THA','Thailand','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TJK','Tajikistan','Europe and  Central Asia','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TKM','Turkmenistan','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TLS','Timor-Leste','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TON','Tonga','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TTO','Trinidad and Tobago','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TUN','Tunisia','Middle East and  North Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TUR','Turkey','Europe and  Central Asia','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TUV','Tuvalu','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('TZA','Tanzania','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('UGA','Uganda','Sub-Saharan Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('UKR','Ukraine','Europe and  Central Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('URY','Uruguay','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('USA','United States','North America','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('UZB','Uzbekistan','Europe and  Central Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('VCT','St. Vincent and the Grenadines','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('VEN','Venezuela, RB','Latin America and  Caribbean','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('VGB','British Virgin Islands','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('VIR','Virgin Islands (U.S.)','Latin America and  Caribbean','High income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('VNM','Vietnam','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('VUT','Vanuatu','East Asia and  Pacific','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('WSM','Samoa','East Asia and  Pacific','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('XKX','Kosovo','Europe and  Central Asia','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('YEM','Yemen, Rep.','Middle East and  North Africa','Low income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ZAF','South Africa','Sub-Saharan Africa','Upper middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ZMB','Zambia','Sub-Saharan Africa','Lower middle income');
INSERT INTO COUNTRIES_MODEL (COUNTRY_CODE,COUNTRY_NAME,REGION,INCOME_GROUP)
 values ('ZWE','Zimbabwe','Sub-Saharan Africa','Low income');
--------------------------------------------------------
COMMIT ;