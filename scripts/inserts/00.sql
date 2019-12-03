CREATE DIRECTORY DIR_IMG_PROYECTO AS 'C:/ProyectoBD';

--Limpiar buffer para logs
SET serveroutput ON SIZE unlimited;

BEGIN
    DBMS_OUTPUT.ENABLE(NULL);
END;

ALTER TABLE RESERVACION ADD v_es_ida CHAR(1) CHECK (v_es_ida = 'T' OR v_es_ida = 'F');