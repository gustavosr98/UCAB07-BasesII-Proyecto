SELECT * FROM
	(
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1,
			V1.id v1id, V1.estatus v1e, V1.periodo_estimado.fecha_inicio v1fi, V1.periodo_estimado.fecha_fin v1ff,
			LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			NULL v2id, NULL v2e, NULL v2fi, NULL v2ff,
			NULL destino2,
			NULL v3id, NULL v3e, NULL v3fi, NULL v3ff,
			NULL destino3,
			ROUND( V1.precio_base.cantidad ,2) costo_total,
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
			L_Origen1.fk_lugar = 10240 AND L_Destino1.fk_lugar = 6688
			AND
			V1.fk_trayecto = T1.id
	UNION

	-- UNA ESCALA 
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1,
			V1.id v1id, V1.estatus v1e, V1.periodo_estimado.fecha_inicio v1fi, V1.periodo_estimado.fecha_fin v1ff,
			LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			V2.id v2id, V2.estatus v2e, V2.periodo_estimado.fecha_inicio v2fi, V2.periodo_estimado.fecha_fin v2ff,
			LC_Destino2.nombre || ' (' || Destino2.codigo_iata || ')' destino2,
			NULL v3id, NULL v3e, NULL v3fi, NULL v3ff,
			NULL destino3,
			ROUND( 
				V1.precio_base.cantidad + V2.precio_base.cantidad
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
			L_Origen1.fk_lugar = 10240 AND L_Destino2.fk_lugar = 6688
			AND
			V1.fk_trayecto = T1.id AND
			V2.fk_trayecto = T2.id
			AND
			V1.periodo_estimado.fecha_fin + INTERVAL '2' HOUR < V2.periodo_estimado.fecha_inicio
	UNION

	-- DOS PARADAS
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1,
			V1.id v1id, V1.estatus v1e, V1.periodo_estimado.fecha_inicio v1fi, V1.periodo_estimado.fecha_fin v1ff,
			LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			V2.id v2id, V2.estatus v2e, V2.periodo_estimado.fecha_inicio v2fi, V2.periodo_estimado.fecha_fin v2ff,
			LC_Destino2.nombre || ' (' || Destino2.codigo_iata || ')' destino2,
			V3.id v3id, V3.estatus v3e, V3.periodo_estimado.fecha_inicio v3fi, V3.periodo_estimado.fecha_fin v3ff,
			LC_Destino3.nombre || ' (' || Destino3.codigo_iata || ')' destino3,
			ROUND( 
				V1.precio_base.cantidad + V2.precio_base.cantidad + V3.precio_base.cantidad
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
			L_Origen1.fk_lugar = 10240 AND L_Destino3.fk_lugar = 6688
			AND
			V1.fk_trayecto = T1.id AND
			V2.fk_trayecto = T2.id AND
			V3.fk_trayecto = T3.id
			AND
			V1.periodo_estimado.fecha_fin + INTERVAL '2' HOUR < V2.periodo_estimado.fecha_inicio AND
			V2.periodo_estimado.fecha_fin + INTERVAL '2' HOUR < V3.periodo_estimado.fecha_inicio
		) TABLITA ORDER BY fecha_final ASC --costo_total ASC