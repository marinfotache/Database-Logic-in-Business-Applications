CREATE OR REPLACE TRIGGER trg_comp_upd
 AFTER UPDATE OF IdCompetenta ON competente FOR EACH ROW
BEGIN
 UPDATE competente SET IdCompSuperioara=:NEW.IdCompetenta
    WHERE IdCompSuperioara=:OLD.IdCompetenta ;
 UPDATE competente_elementare SET idcompfrunza=:NEW.IdCompetenta
    WHERE idcompfrunza=:OLD.IdCompetenta ;
END ;
/ 

CREATE OR REPLACE TRIGGER trg_comp_elem_upd
 AFTER UPDATE OF IdCompFrunza ON competente_elementare FOR EACH ROW
BEGIN
 UPDATE competente_posturi SET IdCompFrunza=:NEW.IdCompFrunza
    WHERE IdCompFrunza=:OLD.IdCompFrunza ;
 UPDATE competente_personal SET IdCompFrunza=:NEW.IdCompFrunza
    WHERE IdCompFrunza=:OLD.IdCompFrunza ;
END ;
/ 

CREATE OR REPLACE TRIGGER trg_posturi_upd
 AFTER UPDATE OF IdPost ON posturi FOR EACH ROW
BEGIN
 UPDATE competente_posturi SET IdPost=:NEW.IdPost
    WHERE IdPost=:OLD.IdPost ;
 UPDATE personal9 SET IdPost=:NEW.IdPost
    WHERE IdPost=:OLD.IdPost ;
END ;
/ 

CREATE OR REPLACE TRIGGER trg_compart_upd
 AFTER UPDATE OF compartiment ON compartimente FOR EACH ROW
BEGIN
 UPDATE personal9 SET compartiment=:NEW.compartiment
    WHERE compartiment=:OLD.compartiment ;
END ;
/ 

CREATE OR REPLACE TRIGGER trg_pers9_upd
 AFTER UPDATE OF marca ON personal9 FOR EACH ROW
BEGIN
 UPDATE compartimente SET MarcaSef=:NEW.Marca
    WHERE MarcaSef=:OLD.Marca ;
 UPDATE competente_personal SET marca=:NEW.Marca
    WHERE marca=:OLD.marca ;
END ;
/ 

 
