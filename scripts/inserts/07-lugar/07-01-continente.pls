CREATE OR REPLACE PROCEDURE ins_continente IS
BEGIN 
  INSERT INTO Lugar (id, fk_lugar, tipo, nombre, localizacion) VALUES (1,NULL,'CONTINENTE','América', NULL);
  INSERT INTO Lugar (id, fk_lugar, tipo, nombre, localizacion) VALUES (2,NULL,'CONTINENTE','Asia',NULL);
  INSERT INTO Lugar (id, fk_lugar, tipo, nombre, localizacion) VALUES (3,NULL,'CONTINENTE','Africa',NULL);
  INSERT INTO Lugar (id, fk_lugar, tipo, nombre, localizacion) VALUES (4,NULL,'CONTINENTE','Europa',NULL);
  INSERT INTO Lugar (id, fk_lugar, tipo, nombre, localizacion) VALUES (6,NULL,'CONTINENTE','Oceanía',NULL);
  INSERT INTO Lugar (id, fk_lugar, tipo, nombre, localizacion) VALUES (7,NULL,'CONTINENTE','Antártida', NULL);
END;
/