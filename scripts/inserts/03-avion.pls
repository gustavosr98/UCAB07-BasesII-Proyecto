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
	cantidad_aviones INTEGER;
	
	i_asientos INTEGER;
	v_asiento Asiento%ROWTYPE;
	v_fila INTEGER;
	v_columna INTEGER;

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

	WHILE(NOT(cursor_tipo_avion%NOTFOUND)) LOOP
		FETCH cursor_tipo_avion INTO row_tipo_avion;

		FOR i_a IN min_a_id..max_a_id LOOP
			IF( DBMS_RANDOM.VALUE > 0.3 ) THEN 
				cantidad_aviones := ROUND( DBMS_RANDOM.VALUE(10,100) );
				FOR i_ca IN 1..cantidad_aviones LOOP
					INSERT INTO AVION (fk_aerolinea, fk_tipo_avion) 
						VALUES (i_a, row_tipo_avion.id);
					
					v_fila := 1;
					v_columna := 1;
					FOR i_asientos IN 1..row_tipo_avion.capacidad LOOP
						 -- ES VENTANA O NO
						IF (v_columna = 1 OR 
							v_columna = ROUND(row_tipo_avion.ancho_interior_cabina.cantidad)
						) THEN
							v_asiento.es_ventana := 'T';
						ELSE v_asiento.es_ventana := 'F'; END IF;
						-- ES PASILLO O NO
						IF (v_columna = FLOOR(row_tipo_avion.ancho_interior_cabina.cantidad/2) OR
							v_columna = CEIL(row_tipo_avion.ancho_interior_cabina.cantidad/2) 
						)	THEN
							v_asiento.es_pasillo := 'T';
						ELSE v_asiento.es_pasillo := 'F'; END IF;
						
						IF (DBMS_RANDOM.VALUE < 0.05) THEN v_asiento.es_de_emergencia := 'T';
						ELSE v_asiento.es_de_emergencia := 'F'; END IF;

						INSERT INTO Asiento (fk_avion,fila,columna,es_ventana,es_pasillo,es_de_emergencia) 
							VALUES (i_a,TO_CHAR(v_fila),asiento_col_to_char(v_columna),
											v_asiento.es_ventana,v_asiento.es_pasillo,v_asiento.es_de_emergencia);
						
						-- AUMENTAR CONTADORES
						v_columna := v_columna + 1;
						IF (v_fila > row_tipo_avion.ancho_interior_cabina.cantidad ) THEN 
							v_columna := 1;
							v_fila := v_fila + 1;
						END IF;
					END LOOP; 

					cant_total := cant_total +1;
				END LOOP;  
			END IF;
		END LOOP;
	END LOOP;

	CLOSE cursor_tipo_avion;

	OUT_(1,'--> Total de AVIONes generados: ' || cant_total); 
END;



CREATE OR REPLACE FUNCTION asiento_col_to_char ( numero INTEGER ) RETURN CHAR
IS
BEGIN
	IF (numero = 1) THEN RETURN 'A';
	ELSIF (numero = 2) THEN RETURN 'B';
	ELSIF (numero = 3) THEN RETURN 'C';
	ELSIF (numero = 4) THEN RETURN 'D';
	ELSIF (numero = 5) THEN RETURN 'E';
	ELSIF (numero = 6) THEN RETURN 'F';
	ELSIF (numero = 7) THEN RETURN 'G';
	ELSE RETURN 'H';
	END IF;
END;