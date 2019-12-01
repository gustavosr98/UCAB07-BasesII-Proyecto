CREATE OR REPLACE PROCEDURE ins_vehiculo
IS
	min_p_id INTEGER DEFAULT 1;
	max_p_id INTEGER;
	i_p INTEGER;

	min_m_id INTEGER DEFAULT 1;
	max_m_id INTEGER;
	i_m INTEGER;

	i_cv INTEGER;
	cantidad_vehiculos INTEGER;

	cant_total INTEGER DEFAULT 0;
BEGIN
	SELECT MIN(id) INTO min_p_id FROM proveedor_vehiculo;
	SELECT MAX(id) INTO max_p_id FROM proveedor_vehiculo;
	SELECT MIN(id) INTO min_m_id FROM modelo_vehiculo;
	SELECT MAX(id) INTO max_m_id FROM modelo_vehiculo;
	
	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INS_VEHICULO *********************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	OUT_(2,'proveedores: ' || min_p_id || '-' || max_p_id);
	OUT_(2,' modelo_vehiculos: ' || min_m_id || '-' || max_m_id);
	OUT_BREAK;

	FOR i_p IN min_p_id..max_p_id LOOP
		FOR i_m IN min_m_id..max_m_id LOOP
			IF( DBMS_RANDOM.VALUE > 0.3 ) THEN 
				cantidad_vehiculos := ROUND( DBMS_RANDOM.VALUE(10,20) );
				FOR i_cv IN 1..cantidad_vehiculos LOOP
					INSERT INTO VEHICULO (fk_modelo_vehiculo, fk_proveedor_vehiculo, esta_disponible,precio_por_dia) 
						VALUES (i_m, i_p,'T', UNIDAD('DIVISA','DOLAR',ROUND( DBMS_RANDOM.VALUE(10,50) ) ));
					cant_total := cant_total +1;
				END LOOP;  
			END IF;
		END LOOP;
	END LOOP;

	OUT_(1,'--> Total de Vehiculos generados: ' || cant_total);
END;


/* DECLARE
BEGIN

    ins_vehiculo;

END; */