CREATE OR REPLACE PROCEDURE ins_trayecto_auto IS
BEGIN
	CURSOR cursor_aeropuerto_origen IS
		SELECT Aer.id, L.localizacion 
		FROM Aeropuerto Aer, Lugar L
		WHERE Aer.fk_lugar = L.id
	;
	origen_id INTEGER;
	origen_geo GEOLOCALIZACION;

	CURSOR cursor_aeropuerto_destino IS
		SELECT Aer.id, L.localizacion 
		FROM Aeropuerto Aer, Lugar L
		WHERE Aer.fk_lugar = L.id
	;
	destino_id INTEGER;
	destino_geo GEOLOCALIZACION;

	alc_min NUMBER;
	alc_max NUMBER;
	cant_total INTEGER;
	var_distancia NUMBER;
BEGIN
	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'***************** PROCEDURE: INS_TRAYECTO *********************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	SELECT MIN(TA.alcance_max.cantidad), MAX(TA.alcance_max.cantidad) INTO alc_min, alc_max 
		FROM Tipo_Avion TA;
	
	SELECT COUNT(*) INTO cant_total FROM Aeropuerto;

	OUT_(2,'alcance de aviones: ' || alc_min || '-' || alc_max || ' (Kilometros)');
	OUT_(2,'cantidad de aeropuertos: ' || cant_total);
	cant_total:=0;
	OUT_BREAK;

	OPEN cursor_aeropuerto_origen;
	FETCH cursor_aeropuerto_origen INTO origen_id, origen_geo;

	WHILE(NOT(cursor_aeropuerto_origen%NOTFOUND)) LOOP
		OPEN cursor_aeropuerto_destino;
		FETCH cursor_aeropuerto_destino INTO destino_id, destino_geo;
		WHILE(NOT(cursor_aeropuerto_destino%NOTFOUND)) LOOP
			
			var_distancia := origen_geo.calcular_distancia( destino_geo );

			IF (var_distancia <= alc_max AND origen_id != destino_id) THEN
				INSERT INTO TRAYECTO VALUES (
					DEFAULT, origen_id, destino_id,
					UNIDAD('LONGITUD','KILOMETRO',var_distancia)
				);
				cant_total := cant_total +1;
			END IF;

			FETCH cursor_aeropuerto_destino INTO destino_id, destino_geo;
		END LOOP;
		CLOSE cursor_aeropuerto_destino;
		FETCH cursor_aeropuerto_origen INTO origen_id, origen_geo;
	END LOOP;

	CLOSE cursor_aeropuerto_origen;

	OUT_(1,'--> Total de TRAYECTOs generados: ' || cant_total); 
END;

-- EJECUTANDO
BEGIN
	INS_TRAYECTO;	
END;

-- CONSULTA
SELECT T.id, Origen.nombre origen,'-->',Destino.nombre destino, 
		ROUND( T.distancia.cantidad ) || ' Kilometros' distancia
FROM Trayecto T, Aeropuerto Origen, Lugar L_Origen,
		Aeropuerto Destino, Lugar L_Destino
WHERE T.fk_aeropuerto_origen = Origen.id AND
		T.fk_aeropuerto_destino = Destino.id AND
		Origen.fk_lugar = L_Origen.id AND
		Destino.fk_lugar = L_Destino.id 
;