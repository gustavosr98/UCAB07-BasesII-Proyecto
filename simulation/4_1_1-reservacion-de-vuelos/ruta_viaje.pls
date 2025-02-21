CREATE OR REPLACE PROCEDURE ruta_viaje(
	mi_cursor OUT SYS_REFCURSOR, 
	orden_por VARCHAR2, 
	limite_rows INTEGER DEFAULT 0,
	--
	rango_dias_aceptable INTEGER DEFAULT 5,
	dias_max_volando INTEGER DEFAULT 2,
	--
	ciudad_origen_id INTEGER, 
	ciudad_destino_id INTEGER, 
	--
	fecha_deseada TIMESTAMP DEFAULT NULL,
	clase_asiento VARCHAR DEFAULT NULL
) 
AS  
	col_order_by VARCHAR(50);
	limitante VARCHAR(50) DEFAULT ' ';
BEGIN
	IF (orden_por ='LLEGADA_MAS_TEMPRANA') THEN
		col_order_by := ' ORDER BY fecha_final';
	ELSIF (orden_por ='MAS_BARATA') THEN
		col_order_by := ' ORDER BY costo_total ';
	END IF;

	IF ( limite_rows != 0 ) THEN
		limitante := ' WHERE ROWNUM <= ' || TO_CHAR(limite_rows) || ' ';
	END IF;

	OPEN mi_cursor FOR '
	SELECT * FROM
	(
		SELECT  
			LC_Origen1.nombre || '' ('' || Origen1.codigo_iata || '')'' origen1,
			V1.id v1id, V1.estatus v1e, V1.periodo_estimado.fecha_inicio v1fi, V1.periodo_estimado.fecha_fin v1ff,
			LC_Destino1.nombre || '' ('' || Destino1.codigo_iata || '')'' destino1,
			NULL v2id, NULL v2e, NULL v2fi, NULL v2ff,
			NULL destino2,
			NULL v3id, NULL v3e, NULL v3fi, NULL v3ff,
			NULL destino3,
			ROUND( precio_vuelo(V1.id, '''||clase_asiento||''', 1).cantidad ,2) costo_total,
			V1.periodo_estimado.fecha_fin fecha_final

		FROM 
			Trayecto T1, 
			Aeropuerto Origen1, Lugar L_Origen1, Lugar LC_Origen1, 
			Aeropuerto Destino1, Lugar L_Destino1, Lugar LC_Destino1,
			
			Vuelo V1
		WHERE 
			T1.fk_aeropuerto_origen = Origen1.id AND
			T1.fk_aeropuerto_destino = Destino1.id AND
			Origen1.fk_lugar = L_Origen1.id AND
			L_Origen1.fk_lugar = LC_Origen1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino1.fk_lugar = LC_Destino1.id 
			AND
			L_Origen1.fk_lugar = ' ||ciudad_origen_id||' AND L_Destino1.fk_lugar = ' ||ciudad_destino_id||'
			AND
			Origen1.id != Destino1.id
			AND
			V1.fk_trayecto = T1.id
			AND
			EXTRACT (
				DAY FROM (
					TIEMPO_PKG.EXTRAER(V1.periodo_estimado.fecha_inicio, ''DATE'') 
					- TIEMPO_PKG.EXTRAER( :fecha_deseada , ''DATE'')
			)) > -'|| rango_dias_aceptable ||' AND
			EXTRACT (
				DAY FROM (
					TIEMPO_PKG.EXTRAER(V1.periodo_estimado.fecha_inicio, ''DATE'') 
					- TIEMPO_PKG.EXTRAER( :fecha_deseada , ''DATE'')
			)) < '|| rango_dias_aceptable ||'

	UNION

	-- UNA ESCALA 
		SELECT  
			LC_Origen1.nombre || '' ('' || Origen1.codigo_iata || '')'' origen1,
			V1.id v1id, V1.estatus v1e, V1.periodo_estimado.fecha_inicio v1fi, V1.periodo_estimado.fecha_fin v1ff,
			LC_Destino1.nombre || '' ('' || Destino1.codigo_iata || '')'' destino1,
			V2.id v2id, V2.estatus v2e, V2.periodo_estimado.fecha_inicio v2fi, V2.periodo_estimado.fecha_fin v2ff,
			LC_Destino2.nombre || '' ('' || Destino2.codigo_iata || '')'' destino2,
			NULL v3id, NULL v3e, NULL v3fi, NULL v3ff,
			NULL destino3,
			ROUND( 
				precio_vuelo(V1.id, '''||clase_asiento||''', 1).cantidad +
				precio_vuelo(V2.id, '''||clase_asiento||''', 1).cantidad
				,2
			) costo_total,
			V2.periodo_estimado.fecha_fin fecha_final
		FROM 
			Trayecto T1, 
			Aeropuerto Origen1, Lugar L_Origen1, Lugar LC_Origen1, 
			Aeropuerto Destino1, Lugar L_Destino1, Lugar LC_Destino1,
			Trayecto T2, 
			Aeropuerto Destino2, Lugar L_Destino2, Lugar LC_Destino2,

			Vuelo V1, Vuelo V2
		WHERE 
			T1.fk_aeropuerto_origen = Origen1.id AND
			T1.fk_aeropuerto_destino = Destino1.id AND
			Origen1.fk_lugar = L_Origen1.id AND
			L_Origen1.fk_lugar = LC_Origen1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino1.fk_lugar = LC_Destino1.id 
			AND
			T2.fk_aeropuerto_origen = Destino1.id AND
			T2.fk_aeropuerto_destino = Destino2.id AND
			L_Destino1.fk_lugar = LC_Destino1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino2.fk_lugar = LC_Destino2.id AND
			Destino2.fk_lugar = L_Destino2.id 
			AND
			L_Origen1.fk_lugar = ' ||ciudad_origen_id||' AND L_Destino2.fk_lugar = ' ||ciudad_destino_id||'
			AND
			Origen1.id NOT IN (Destino1.id, Destino2.id) AND
			Destino1.id NOT IN (Origen1.id, Destino2.id) AND
			Destino2.id NOT IN (Destino1.id, Origen1.id)
			AND
			V1.fk_trayecto = T1.id AND
			V2.fk_trayecto = T2.id
			AND
			V1.periodo_estimado.fecha_fin + INTERVAL ''2'' HOUR < V2.periodo_estimado.fecha_inicio
			AND
			EXTRACT (
				DAY FROM (
					TIEMPO_PKG.EXTRAER(V1.periodo_estimado.fecha_inicio, ''DATE'') 
					- TIEMPO_PKG.EXTRAER( :fecha_deseada , ''DATE'')
			)) > -'|| rango_dias_aceptable ||' AND
			EXTRACT (
				DAY FROM (
					TIEMPO_PKG.EXTRAER(V1.periodo_estimado.fecha_inicio, ''DATE'') 
					- TIEMPO_PKG.EXTRAER( :fecha_deseada , ''DATE'')
			)) < '|| rango_dias_aceptable ||' AND
			EXTRACT (DAY FROM (V2.periodo_estimado.fecha_fin - V1.periodo_estimado.fecha_inicio)) < ' || dias_max_volando || '
	UNION

	-- DOS PARADAS
		SELECT  
			LC_Origen1.nombre || '' ('' || Origen1.codigo_iata || '')'' origen1,
			V1.id v1id, V1.estatus v1e, V1.periodo_estimado.fecha_inicio v1fi, V1.periodo_estimado.fecha_fin v1ff,
			LC_Destino1.nombre || '' ('' || Destino1.codigo_iata || '')'' destino1,
			V2.id v2id, V2.estatus v2e, V2.periodo_estimado.fecha_inicio v2fi, V2.periodo_estimado.fecha_fin v2ff,
			LC_Destino2.nombre || '' ('' || Destino2.codigo_iata || '')'' destino2,
			V3.id v3id, V3.estatus v3e, V3.periodo_estimado.fecha_inicio v3fi, V3.periodo_estimado.fecha_fin v3ff,
			LC_Destino3.nombre || '' ('' || Destino3.codigo_iata || '')'' destino3,
			ROUND( 
				precio_vuelo(V1.id, '''||clase_asiento||''', 1).cantidad
				+ precio_vuelo(V2.id, '''||clase_asiento||''', 1).cantidad 
				+ precio_vuelo(V3.id, '''||clase_asiento||''', 1).cantidad 
				,2
			) costo_total,
			V3.periodo_estimado.fecha_fin fecha_final

		FROM 
			Trayecto T1, 
			Aeropuerto Origen1, Lugar L_Origen1, Lugar LC_Origen1, 
			Aeropuerto Destino1, Lugar L_Destino1, Lugar LC_Destino1,
			Trayecto T2, 
			Aeropuerto Destino2, Lugar L_Destino2, Lugar LC_Destino2,
			Trayecto T3,
			Aeropuerto Destino3, Lugar L_Destino3, Lugar LC_Destino3,

			Vuelo V1, Vuelo V2, Vuelo V3
		WHERE 
			T1.fk_aeropuerto_origen = Origen1.id AND
			T1.fk_aeropuerto_destino = Destino1.id AND
			Origen1.fk_lugar = L_Origen1.id AND
			L_Origen1.fk_lugar = LC_Origen1.id AND
			L_Destino1.fk_lugar = LC_Destino1.id AND
			Destino1.fk_lugar = L_Destino1.id 
			AND
			T2.fk_aeropuerto_origen = Destino1.id AND
			T2.fk_aeropuerto_destino = Destino2.id AND
			L_Destino1.fk_lugar = LC_Destino1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino2.fk_lugar = LC_Destino2.id AND
			Destino2.fk_lugar = L_Destino2.id 
			AND
			T3.fk_aeropuerto_origen = Destino2.id AND
			T3.fk_aeropuerto_destino = Destino3.id AND
			L_Destino2.fk_lugar = LC_Destino2.id AND
			Destino2.fk_lugar = L_Destino2.id AND
			L_Destino3.fk_lugar = LC_Destino3.id AND
			Destino3.fk_lugar = L_Destino3.id 
			AND
			L_Origen1.fk_lugar = ' ||ciudad_origen_id||' AND L_Destino3.fk_lugar = ' ||ciudad_destino_id||'
			AND
			Origen1.id NOT IN (Destino1.id, Destino2.id, Destino3.id) AND
			Destino1.id NOT IN (Origen1.id, Destino2.id, Destino3.id) AND
			Destino2.id NOT IN (Destino1.id, Origen1.id, Destino3.id) AND
			Destino3.id NOT IN (Origen1.id, Destino2.id, Destino1.id)
			AND
			V1.fk_trayecto = T1.id AND
			V2.fk_trayecto = T2.id AND
			V3.fk_trayecto = T3.id
			AND
			V1.periodo_estimado.fecha_fin + INTERVAL ''2'' HOUR < V2.periodo_estimado.fecha_inicio AND
			V2.periodo_estimado.fecha_fin + INTERVAL ''2'' HOUR < V3.periodo_estimado.fecha_inicio
			AND
			EXTRACT (
				DAY FROM (
					TIEMPO_PKG.EXTRAER(V1.periodo_estimado.fecha_inicio, ''DATE'') 
					- TIEMPO_PKG.EXTRAER( :fecha_deseada , ''DATE'')
			)) > -'|| rango_dias_aceptable ||' AND	
			EXTRACT (
				DAY FROM (
					TIEMPO_PKG.EXTRAER(V1.periodo_estimado.fecha_inicio, ''DATE'') 
					- TIEMPO_PKG.EXTRAER( :fecha_deseada , ''DATE'')
			)) < '|| rango_dias_aceptable ||' AND
			EXTRACT (DAY FROM (V3.periodo_estimado.fecha_fin - V1.periodo_estimado.fecha_inicio)) < ' || dias_max_volando || '
		) TABLITA ' 
		|| limitante || ' '
		|| col_order_by 
		|| ' ' USING fecha_deseada,fecha_deseada,fecha_deseada,fecha_deseada,fecha_deseada,fecha_deseada;
	
END;



-- PROBANDO

DECLARE	
  mi_cursor SYS_REFCURSOR;
	
  origen1 LUGAR.NOMBRE%TYPE;
	v1id INTEGER; v1e VUELO.ESTATUS%TYPE; v1fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v1ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
	destino1 LUGAR.NOMBRE%TYPE;
	v2id INTEGER; v2e VUELO.ESTATUS%TYPE; v2fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v2ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
	destino2 LUGAR.NOMBRE%TYPE;
	v3id INTEGER; v3e VUELO.ESTATUS%TYPE; v3fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v3ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
	destino3 LUGAR.NOMBRE%TYPE;
	costo_total NUMBER;
	fecha_final VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;

BEGIN
	DBMS_OUTPUT.ENABLE(NULL);

  ruta_viaje (
		mi_cursor => mi_cursor,
		ciudad_origen_id => 10726,
    ciudad_destino_id => 4855,
		orden_por => 'MAS_BARATA',
		fecha_deseada => TIEMPO_PKG.RANDOM(PERIODO(
			TIMESTAMP '2019-11-01 11:24:50',
			TIMESTAMP '2020-01-31 06:47:15'
		)), 
		dias_max_volando => 1,
		rango_dias_aceptable => 10,
		limite_rows => 5
	);
  LOOP 
    FETCH mi_cursor INTO 
			origen1,
			v1id, v1e, v1fi, v1ff,
			destino1,
			v2id, v2e, v2fi, v2ff,
			destino2,
			v3id, v3e, v3fi, v3ff,
			destino3,
			costo_total,
			fecha_final
		;

  	EXIT WHEN mi_cursor%NOTFOUND;
    OUT_(2,
			costo_total || ' - ' ||
			fecha_final
		);
		OUT_(3,
			origen1 || ' - ' ||
			v1id || ' - ' || v1e || ' - ' || v1fi || ' - ' || v1ff || ' - ' ||
			destino1
		);
		OUT_(3,
			destino1 || ' - ' ||
			v2id || ' - ' || v2e || ' - ' || v2fi || ' - ' || v2ff || ' - ' ||
			destino2
		);
		OUT_(3,
			destino2 || ' - ' ||
			v3id || ' - ' || v3e || ' - ' || v3fi || ' - ' || v3ff || ' - ' ||
			destino3
		);
  END LOOP;
  CLOSE mi_cursor;
END;
