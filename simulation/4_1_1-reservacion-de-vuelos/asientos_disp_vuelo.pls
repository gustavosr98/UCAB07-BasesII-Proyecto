CREATE OR REPLACE FUNCTION asientos_disp_vuelo ( vuelo_id INTEGER, clase VARCHAR DEFAULT NULL ) RETURN INTEGER
IS
	avion_id INTEGER;
	clase_aero_id INTEGER;

	ocupados INTEGER DEFAULT 0;
	capacidad INTEGER DEFAULT 0;
BEGIN
	
	SELECT Av.id INTO avion_id 
	FROM Avion Av, Vuelo V
	WHERE V.fk_avion = Av.id 
		AND
		V.id = vuelo_id;

	IF (clase IS NOT NULL) THEN
		SELECT CA.id INTO clase_aero_id 
		FROM Avion Av, Aerolinea AE, Clase_Aerolinea CA, Clase CL 
		WHERE 
			Av.fk_aerolinea = AE.id AND
			CA.fk_aerolinea = AE.id AND
			CA.fk_clase = Cl.id AND
			CL.nombre = clase
			AND
			Av.id = avion_id;
		
		SELECT COUNT(Asi.id) INTO capacidad 
		FROM Asiento Asi
		WHERE  
			Asi.fk_clase_aerolinea = clase_aero_id AND
			Asi.fk_avion = avion_id;

		SELECT COUNT(Asi.id) INTO ocupados 
		FROM Asiento Asi, Reservacion RV
		WHERE 
			RV.v_fk_asiento = Asi.id  
			AND
			Asi.fk_clase_aerolinea = clase_aero_id AND
			Asi.fk_avion = avion_id AND
			RV.v_fk_vuelo = vuelo_id;
	ELSE
		SELECT COUNT(Asi.id) INTO capacidad 
		FROM Asiento Asi
		WHERE Asi.fk_avion = avion_id;

		SELECT COUNT(Asi.id) INTO ocupados 
		FROM Asiento Asi, Reservacion RV
		WHERE 
			RV.v_fk_asiento = Asi.id  
			AND
			Asi.fk_avion = avion_id AND
			RV.v_fk_vuelo = vuelo_id;
	END IF;
	 
	RETURN capacidad -ocupados;
END;
/

-- PROBANDO
	BEGIN
		OUT_(0, asientos_disp_vuelo(291941, 'ECONOMICA') );
		OUT_(0, asientos_disp_vuelo(291941, 'EJECUTIVA') );
		OUT_(0, asientos_disp_vuelo(291941, 'PRIMERA_CLASE') );
		OUT_(0, asientos_disp_vuelo(vuelo_id => 291941) );
	END;
	/