CREATE OR REPLACE FUNCTION get_destino (origen_id INTEGER DEFAULT 0) RETURN LUGAR%ROWTYPE
IS
  place LUGAR%ROWTYPE;
BEGIN
  SELECT * INTO place FROM ( 
			SELECT * FROM LUGAR
			WHERE id IN ( -- Ciudades que se decidieron para la simulacion
				SELECT DISTINCT L2.id FROM LUGAR L1, LUGAR L2, AEROPUERTO A, TRAYECTO T
				WHERE
					T.fk_aeropuerto_origen = A.id AND
					A.fk_lugar = L1.id AND
					L1.fk_lugar = L2.id AND
					L2.id != origen_id
			) ORDER BY DBMS_RANDOM.VALUE
		) WHERE ROWNUM = 1; 

    RETURN place;
END;
/