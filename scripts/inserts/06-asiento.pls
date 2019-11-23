CREATE OR REPLACE PROCEDURE ins_asiento ( row_tipo_avion TIPO_AVION%ROWTYPE, avion_id INTEGER, cantidad INTEGER, clase_aerolinea_id INTEGER )
IS
	i_asientos INTEGER;
	v_asiento Asiento%ROWTYPE;
	v_fila INTEGER;
	v_columna INTEGER;
BEGIN		
	
	v_fila := 1;
	v_columna := 1;

	FOR i_asientos IN 1..cantidad LOOP
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

		INSERT INTO Asiento (fk_avion,fk_clase_aerolinea,fila,columna,es_ventana,es_pasillo,es_de_emergencia) 
			VALUES (avion_id,clase_aerolinea_id,TO_CHAR(v_fila),asiento_col_to_char(v_columna),
							v_asiento.es_ventana,v_asiento.es_pasillo,v_asiento.es_de_emergencia);
		
		-- AUMENTAR CONTADORES
		v_columna := v_columna + 1;
		IF (v_fila > row_tipo_avion.ancho_interior_cabina.cantidad ) THEN 
			v_columna := 1;
			v_fila := v_fila + 1;
		END IF;
	END LOOP; 
END;