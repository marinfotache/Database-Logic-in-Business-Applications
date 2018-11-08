-- DROP TABLE TARI_MODEL CASCADE CONSTRAINTS ;

  
  CREATE TABLE TARI_MODEL (	
  	COD_TARA VARCHAR(10) PRIMARY KEY, 
	NUME_TARA VARCHAR(255) UNIQUE, 
	REGIUNE VARCHAR(255), 
	GRUP_VENIT VARCHAR(255)
   ) ;

SET DEFINE OFF;


INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ABW','Aruba','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('AFG','Afghanistan','South Asia','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('AGO','Angola','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ALB','Albania','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('AND','Andorra','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ARE','United Arab Emirates','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ARG','Argentina','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ARM','Armenia','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ASM','American Samoa','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ATG','Antigua and Barbuda','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('AUS','Australia','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('AUT','Austria','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('AZE','Azerbaijan','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BDI','Burundi','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BEL','Belgium','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BEN','Benin','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BFA','Burkina Faso','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BGD','Bangladesh','South Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BGR','Bulgaria','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BHR','Bahrain','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BHS','Bahamas, The','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BIH','Bosnia and Herzegovina','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BLR','Belarus','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BLZ','Belize','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BMU','Bermuda','North America','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BOL','Bolivia','Latin America and  Caribbean','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BRA','Brazil','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BRB','Barbados','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BRN','Brunei Darussalam','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BTN','Bhutan','South Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('BWA','Botswana','Sub-Saharan Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CAF','Central African Republic','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CAN','Canada','North America','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CHE','Switzerland','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CHI','Channel Islands','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CHL','Chile','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CHN','China','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CIV','Cote d''Ivoire','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CMR','Cameroon','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('COD','Congo, Dem. Rep.','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('COG','Congo, Rep.','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('COL','Colombia','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('COM','Comoros','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CPV','Cabo Verde','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CRI','Costa Rica','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CUB','Cuba','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CUW','Curacao','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CYM','Cayman Islands','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CYP','Cyprus','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('CZE','Czech Republic','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('DEU','Germany','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('DJI','Djibouti','Middle East and  North Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('DMA','Dominica','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('DNK','Denmark','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('DOM','Dominican Republic','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('DZA','Algeria','Middle East and  North Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ECU','Ecuador','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('EGY','Egypt, Arab Rep.','Middle East and  North Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ERI','Eritrea','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ESP','Spain','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('EST','Estonia','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ETH','Ethiopia','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('FIN','Finland','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('FJI','Fiji','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('FRA','France','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('FRO','Faroe Islands','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('FSM','Micronesia, Fed. Sts.','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GAB','Gabon','Sub-Saharan Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GBR','United Kingdom','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GEO','Georgia','Europe and  Central Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GHA','Ghana','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GIB','Gibraltar','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GIN','Guinea','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GMB','Gambia, The','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GNB','Guinea-Bissau','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GNQ','Equatorial Guinea','Sub-Saharan Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GRC','Greece','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GRD','Grenada','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GRL','Greenland','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GTM','Guatemala','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GUM','Guam','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('GUY','Guyana','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('HKG','Hong Kong SAR, China','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('HND','Honduras','Latin America and  Caribbean','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('HRV','Croatia','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('HTI','Haiti','Latin America and  Caribbean','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('HUN','Hungary','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('IDN','Indonesia','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('IMN','Isle of Man','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('IND','India','South Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('IRL','Ireland','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('IRN','Iran, Islamic Rep.','Middle East and  North Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('IRQ','Iraq','Middle East and  North Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ISL','Iceland','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ISR','Israel','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ITA','Italy','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('JAM','Jamaica','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('JOR','Jordan','Middle East and  North Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('JPN','Japan','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KAZ','Kazakhstan','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KEN','Kenya','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KGZ','Kyrgyz Republic','Europe and  Central Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KHM','Cambodia','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KIR','Kiribati','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KNA','St. Kitts and Nevis','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KOR','Korea, Rep.','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('KWT','Kuwait','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LAO','Lao PDR','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LBN','Lebanon','Middle East and  North Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LBR','Liberia','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LBY','Libya','Middle East and  North Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LCA','St. Lucia','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LIE','Liechtenstein','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LKA','Sri Lanka','South Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LSO','Lesotho','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LTU','Lithuania','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LUX','Luxembourg','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('LVA','Latvia','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MAC','Macao SAR, China','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MAF','St. Martin (French part)','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MAR','Morocco','Middle East and  North Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MCO','Monaco','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MDA','Moldova','Europe and  Central Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MDG','Madagascar','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MDV','Maldives','South Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MEX','Mexico','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MHL','Marshall Islands','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MKD','Macedonia, FYR','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MLI','Mali','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MLT','Malta','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MMR','Myanmar','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MNE','Montenegro','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MNG','Mongolia','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MNP','Northern Mariana Islands','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MOZ','Mozambique','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MRT','Mauritania','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MUS','Mauritius','Sub-Saharan Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MWI','Malawi','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('MYS','Malaysia','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NAM','Namibia','Sub-Saharan Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NCL','New Caledonia','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NER','Niger','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NGA','Nigeria','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NIC','Nicaragua','Latin America and  Caribbean','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NLD','Netherlands','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NOR','Norway','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NPL','Nepal','South Asia','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NRU','Nauru','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('NZL','New Zealand','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('OMN','Oman','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PAK','Pakistan','South Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PAN','Panama','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PER','Peru','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PHL','Philippines','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PLW','Palau','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PNG','Papua New Guinea','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('POL','Poland','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PRI','Puerto Rico','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PRK','Korea, Dem. People’s Rep.','East Asia and  Pacific','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PRT','Portugal','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PRY','Paraguay','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PSE','West Bank and Gaza','Middle East and  North Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('PYF','French Polynesia','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('QAT','Qatar','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ROU','Romania','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('RUS','Russian Federation','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('RWA','Rwanda','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SAU','Saudi Arabia','Middle East and  North Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SDN','Sudan','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SEN','Senegal','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SGP','Singapore','East Asia and  Pacific','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SLB','Solomon Islands','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SLE','Sierra Leone','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SLV','El Salvador','Latin America and  Caribbean','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SMR','San Marino','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SOM','Somalia','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SRB','Serbia','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SSD','South Sudan','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('STP','Sao Tome and Principe','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SUR','Suriname','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SVK','Slovak Republic','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SVN','Slovenia','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SWE','Sweden','Europe and  Central Asia','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SWZ','Eswatini','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SXM','Sint Maarten (Dutch part)','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SYC','Seychelles','Sub-Saharan Africa','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('SYR','Syrian Arab Republic','Middle East and  North Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TCA','Turks and Caicos Islands','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TCD','Chad','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TGO','Togo','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('THA','Thailand','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TJK','Tajikistan','Europe and  Central Asia','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TKM','Turkmenistan','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TLS','Timor-Leste','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TON','Tonga','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TTO','Trinidad and Tobago','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TUN','Tunisia','Middle East and  North Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TUR','Turkey','Europe and  Central Asia','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TUV','Tuvalu','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('TZA','Tanzania','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('UGA','Uganda','Sub-Saharan Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('UKR','Ukraine','Europe and  Central Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('URY','Uruguay','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('USA','United States','North America','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('UZB','Uzbekistan','Europe and  Central Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('VCT','St. Vincent and the Grenadines','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('VEN','Venezuela, RB','Latin America and  Caribbean','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('VGB','British Virgin Islands','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('VIR','Virgin Islands (U.S.)','Latin America and  Caribbean','High income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('VNM','Vietnam','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('VUT','Vanuatu','East Asia and  Pacific','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('WSM','Samoa','East Asia and  Pacific','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('XKX','Kosovo','Europe and  Central Asia','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('YEM','Yemen, Rep.','Middle East and  North Africa','Low income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ZAF','South Africa','Sub-Saharan Africa','Upper middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ZMB','Zambia','Sub-Saharan Africa','Lower middle income');
INSERT INTO TARI_MODEL (COD_TARA,NUME_TARA,REGIUNE,GRUP_VENIT) values ('ZWE','Zimbabwe','Sub-Saharan Africa','Low income');
--------------------------------------------------------
COMMIT ;