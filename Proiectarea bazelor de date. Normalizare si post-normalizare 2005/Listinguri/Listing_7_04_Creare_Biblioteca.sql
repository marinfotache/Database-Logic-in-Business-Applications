DROP TABLE exemplare ;
DROP TABLE titluri ;
DROP TABLE edituri ;

CREATE TABLE edituri (
 editura VARCHAR2(30) PRIMARY KEY,
 LocSediuEd VARCHAR2(30)
 ) ;

CREATE TABLE titluri (
 ISBN CHAR(13) NOT NULL PRIMARY KEY,
 titlu VARCHAR2(60) NOT NULL, 
 editura VARCHAR2(30) NOT NULL REFERENCES edituri (editura),
 anparitie NUMBER(4) DEFAULT EXTRACT (YEAR FROM CURRENT_DATE)
 ) ;

CREATE TABLE exemplare (
 cota VARCHAR2(15) NOT NULL PRIMARY KEY, 
 ISBN CHAR(13) NOT NULL REFERENCES titluri (ISBN)
 ); 

CREATE TABLE titluri_autori (
 ISBN CHAR(13) NOT NULL REFERENCES titluri (ISBN),
 autor VARCHAR2(30) NOT NULL, 
 PRIMARY KEY (ISBN, autor)
 ) ;
 
CREATE TABLE titluri_cuvintecheie (
 ISBN CHAR(13) NOT NULL REFERENCES titluri (ISBN),
 cuvintcheie VARCHAR2(30),
 PRIMARY KEY (ISBN, cuvintcheie) 
);

 
