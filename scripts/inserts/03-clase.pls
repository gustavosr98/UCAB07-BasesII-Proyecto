CREATE OR REPLACE PROCEDURE ins_clase IS
BEGIN	
  INSERT INTO Clase (nombre) VALUES ('ECONOMICA');
  INSERT INTO Clase (nombre) VALUES ('EJECUTIVA');
  INSERT INTO Clase (nombre) VALUES ('PRIMERA_CLASE');
END;
/