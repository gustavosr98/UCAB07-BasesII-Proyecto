CREATE OR REPLACE FUNCTION asientos_disp_vuelo ( vuelo_id INTEGER, clase VARCHAR ) RETURN INTEGER
IS
	ocupados INTEGER;
	capacidad INTEGER;
BEGIN
	SELECT COUNT(Asi.id) INTO ocupados
	FROM Asiento Asi, Reservacion RV, Vuelo V,
		Avion Av,Clase_Aerolinea CA, Clase Cl, Tipo_Avion TA
	WHERE 
		Asi.fk_avion = Av.id AND
		Asi.fk_clase_aerolinea = CA.id AND
		Av.fk_tipo_avion = TA.id AND
		V.fk_avion = Av.id AND
		RV.tipo = 'V' AND
		RV.v_fk_asiento = Asi.id AND
		RV.v_fk_vuelo = V.id
		AND
		Cl.nombre = clase AND
		V.id = vuelo_id;

	SELECT Cl.nombre, COUNT(Asi.id)
	FROM Asiento Asi, Vuelo V,
		Avion Av, Clase_Aerolinea CA, Clase Cl, Tipo_Avion TA
	WHERE 
		Asi.fk_avion = Av.id AND
		Asi.fk_clase_aerolinea = CA.id AND
		Av.fk_tipo_avion = TA.id AND
		V.fk_avion = Av.id 
		AND
		--Cl.nombre = 'ECONOMICA' AND
		V.id = 30
		GROUP BY Cl.nombre;
		
	RETURN capacidad -ocupados;
END;
/

-- PROBANDO
	BEGIN
		OUT_(0, asientos_disp_vuelo(62, 'ECONOMICA') );
	END;
	/