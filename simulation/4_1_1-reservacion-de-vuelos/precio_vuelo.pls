CREATE OR REPLACE FUNCTION precio_vuelo ( vuelo_id INTEGER, clase VARCHAR, cantidad INTEGER ) RETURN UNIDAD
IS
	avion_id INTEGER;
	clase_aero_id INTEGER;

	precio_total UNIDAD;
	porcentaje_extra NUMBER;

	ocupados INTEGER DEFAULT 0;
	capacidad INTEGER DEFAULT 0;
BEGIN
	
	SELECT Av.id, V.precio_base INTO avion_id, precio_total
	FROM Avion Av, Vuelo V
	WHERE V.fk_avion = Av.id 
		AND
		V.id = vuelo_id;
	
	SELECT CA.id, CA.porcentaje_extra INTO clase_aero_id, porcentaje_extra
	FROM Avion Av, Aerolinea AE, Clase_Aerolinea CA, Clase CL 
	WHERE 
		Av.fk_aerolinea = AE.id AND
		CA.fk_aerolinea = AE.id AND
		CA.fk_clase = Cl.id AND
		CL.nombre = clase
		AND
		Av.id = avion_id;

	precio_total.cantidad := ROUND( precio_total.cantidad * porcentaje_extra* cantidad, 2);
	RETURN precio_total;
END;
/

-- PROBANDO
	BEGIN
		OUT_(0, precio_vuelo(300000, 'ECONOMICA', 1).cantidad || ' ' || precio_vuelo(300000, 'ECONOMICA', 1).nombre );
		OUT_(0, precio_vuelo(300000, 'ECONOMICA', 2).cantidad || ' ' || precio_vuelo(300000, 'ECONOMICA', 2).nombre );
		OUT_(0, precio_vuelo(300000, 'EJECUTIVA', 1).cantidad || ' ' || precio_vuelo(300000, 'EJECUTIVA', 1).nombre );
		OUT_(0, precio_vuelo(300000, 'EJECUTIVA', 2).cantidad || ' ' || precio_vuelo(300000, 'EJECUTIVA', 2).nombre );
		OUT_(0, precio_vuelo(300000, 'PRIMERA_CLASE', 1).cantidad || ' ' || precio_vuelo(300000, 'PRIMERA_CLASE', 1).nombre );
		OUT_(0, precio_vuelo(300000, 'PRIMERA_CLASE', 4).cantidad || ' ' || precio_vuelo(300000, 'PRIMERA_CLASE', 4).nombre );
	END;
	/