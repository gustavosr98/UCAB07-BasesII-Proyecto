CREATE OR REPLACE PROCEDURE ins_clase_aerolinea
IS
	min_a_id INTEGER DEFAULT 1;
	max_a_id INTEGER;
	i_a INTEGER;

	min_c_id INTEGER DEFAULT 1;
	max_c_id INTEGER;
	i_c INTEGER;

	ultimo_porcentaje NUMBER := 1;
BEGIN
	SELECT MIN(id) INTO min_a_id FROM Aerolinea;
	SELECT MAX(id) INTO max_a_id FROM Aerolinea;
	SELECT MIN(id) INTO min_c_id FROM Clase;
	SELECT MAX(id) INTO max_c_id FROM Clase;
	
	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** PROCEDURE: INS_CLASE_AEROLINEA *****************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	OUT_(1,'aerolineas: ' || min_a_id || '-' || max_a_id);
	OUT_(1,'clases: ' || min_c_id || '-' || max_c_id);
	OUT_BREAK;

	FOR i_a IN min_a_id..max_a_id LOOP
		ultimo_porcentaje := 1;
		FOR i_c IN min_c_id..max_c_id LOOP
			INSERT INTO Clase_Aerolinea (fk_aerolinea, fk_clase, porcentaje_extra) 
				VALUES (i_a, i_c, ultimo_porcentaje);
			ultimo_porcentaje := ROUND( DBMS_RANDOM.VALUE( CEIL(ultimo_porcentaje) , CEIL(ultimo_porcentaje)*5), 2);
		END LOOP;
	END LOOP;

END;

-- EJECUTANDO
BEGIN	
	INS_CLASE_AEROLINEA;
END;
/