CREATE OR REPLACE PROCEDURE ins_avion
IS
	min_ta_id INTEGER DEFAULT 1;
	max_ta_id INTEGER;
	i_ta INTEGER;

	min_a_id INTEGER DEFAULT 1;
	max_a_id INTEGER;
	i_a INTEGER;

	i_ca INTEGER;
	cantidad_aviones INTEGER;

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

	FOR i_ta IN min_ta_id..max_ta_id LOOP
		FOR i_a IN min_a_id..max_a_id LOOP
			IF( DBMS_RANDOM.VALUE > 0.3 ) THEN 
				cantidad_aviones := ROUND( DBMS_RANDOM.VALUE(10,100) );
				FOR i_ca IN 1..cantidad_aviones LOOP
					INSERT INTO AVION (fk_aerolinea, fk_tipo_avion) 
						VALUES (i_a, i_ta);
					cant_total := cant_total +1;
				END LOOP;  
			END IF;
		END LOOP;
	END LOOP;

	OUT_(1,'--> Total de AVIONes generados: ' || cant_total);
END;