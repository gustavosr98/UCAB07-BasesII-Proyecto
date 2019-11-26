SELECT * FROM
	(
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1,
			V1.id v1id, V1.estatus, V1.periodo_estimado.fecha_inicio, V1.periodo_estimado.fecha_fin,
			LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			0 v2id,
			'NULL' destino2,
			0 v3id,'NULL'
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
			L_Origen1.fk_lugar = 10240 AND L_Destino1.fk_lugar = 6688
			AND
			V1.fk_trayecto = T1.id
			
	UNION

	-- UNA ESCALA
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1,
			V1.id v1id, V1.estatus, V1.periodo_estimado.fecha_inicio, V1.periodo_estimado.fecha_fin,
			LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			V2.id v2id,
			 LC_Destino2.nombre || ' (' || Destino2.codigo_iata || ')' destino2,
			0 v3id,'NULL'
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
			L_Origen1.fk_lugar = 10240 AND L_Destino2.fk_lugar = 6688
			AND
			V1.fk_trayecto = T1.id AND
			V2.fk_trayecto = T2.id
			
	UNION

	-- DOS PARADAS
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1,
			V1.id v1id, V1.estatus, V1.periodo_estimado.fecha_inicio, V1.periodo_estimado.fecha_fin,
			LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			V2.id v2id,
			LC_Destino2.nombre || ' (' || Destino2.codigo_iata || ')' destino2,
			V3.id v3id, LC_Destino3.nombre || ' (' || Destino3.codigo_iata || ')'
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
			L_Origen1.fk_lugar = 10240 AND L_Destino3.fk_lugar = 6688
			AND
			V1.fk_trayecto = T1.id AND
			V2.fk_trayecto = T2.id AND
			V3.fk_trayecto = T3.id
		) TABLITA ORDER BY DBMS_RANDOM.VALUE