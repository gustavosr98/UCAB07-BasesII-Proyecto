CREATE OR REPLACE PROCEDURE ins_avion
IS
	min_ta_id INTEGER DEFAULT 1;
	max_ta_id INTEGER;

	row_tipo_avion Tipo_Avion%ROWTYPE;
	CURSOR cursor_tipo_avion IS 
		SELECT * FROM Tipo_Avion; 

	min_a_id INTEGER DEFAULT 1;
	max_a_id INTEGER;
	i_a INTEGER;

	i_ca INTEGER;
	avion_id INTEGER;
	cantidad_aviones INTEGER;

	CURSOR cursor_clase_aerolinea_id (aerolinea_id INTEGER) IS 
		SELECT id FROM Clase_Aerolinea WHERE fk_aerolinea = aerolinea_id;
	clase_aerolinea_id INTEGER;
	cant_asientos INTEGER;

	cant_total INTEGER DEFAULT 0;
BEGIN
	SELECT MIN(id) INTO min_ta_id FROM Tipo_Avion;
	SELECT MAX(id) INTO max_ta_id FROM Tipo_Avion;
	SELECT MIN(id) INTO min_a_id FROM Aerolinea;
	SELECT MAX(id) INTO max_a_id FROM Aerolinea;
	
	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INS_AVION *********************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	OUT_(2,'tipo_aivones: ' || min_ta_id || '-' || max_ta_id);
	OUT_(2,'aerolineas: ' || min_a_id || '-' || max_a_id);
	OUT_BREAK;

	OPEN cursor_tipo_avion;
	FETCH cursor_tipo_avion INTO row_tipo_avion;

	WHILE(NOT(cursor_tipo_avion%NOTFOUND)) LOOP
		
		FOR i_a IN min_a_id..max_a_id LOOP
			IF( DBMS_RANDOM.VALUE > 0.3 ) THEN 
				cantidad_aviones := ROUND( DBMS_RANDOM.VALUE(1,3) );
				FOR i_ca IN 1..cantidad_aviones LOOP
					INSERT INTO AVION (fk_aerolinea, fk_tipo_avion) 
						VALUES (i_a, row_tipo_avion.id) RETURNING id INTO avion_id;
					
					-- ASIENTOS POR CLASES
					OPEN cursor_clase_aerolinea_id(i_a);
					FETCH cursor_clase_aerolinea_id INTO clase_aerolinea_id;
					WHILE(NOT(cursor_clase_aerolinea_id%NOTFOUND)) LOOP
						IF (cursor_clase_aerolinea_id%ROWCOUNT = 1) THEN
							OUT_(0,'AAAAAAA');
							INS_ASIENTO(
								row_tipo_avion, avion_id, 
								ROUND(row_tipo_avion.capacidad*0.1),
								clase_aerolinea_id
							);
						ELSIF (cursor_clase_aerolinea_id%ROWCOUNT = 2) THEN
							INS_ASIENTO(
								row_tipo_avion, avion_id, 
								ROUND(row_tipo_avion.capacidad*0.2),
								clase_aerolinea_id
							);
						ELSE
							INS_ASIENTO(
								row_tipo_avion, avion_id, 
								row_tipo_avion.capacidad -ROUND(row_tipo_avion.capacidad*0.1) - ROUND(row_tipo_avion.capacidad*0.2),
								clase_aerolinea_id
							);
						END IF;
						FETCH cursor_clase_aerolinea_id INTO clase_aerolinea_id;
					END LOOP;
					CLOSE cursor_clase_aerolinea_id;
					
					cant_total := cant_total +1;
				END LOOP;  
			END IF;
		END LOOP;
		FETCH cursor_tipo_avion INTO row_tipo_avion;
	END LOOP;

	CLOSE cursor_tipo_avion;

	OUT_(1,'--> Total de AVIONes generados: ' || cant_total); 
END;