SELECT * FROM
	(
		SELECT  
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1, T1.id t1id,V1.id v1id,LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			0 t2id,0 v2id,'NULL' destino2,
			0 t3id,0 v3id,'NULL' destino3,
			ROUND( T1.distancia.cantidad) distancia_total
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
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1, T1.id t1id,V1.id v1id,LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			T2.id t2id, V2.id v2id, LC_Destino2.nombre || ' (' || Destino2.codigo_iata || ')' destino2,
			0 t3id,0 v3id,'NULL' destino3,
			ROUND( T1.distancia.cantidad + T2.distancia.cantidad) distancia_total
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
			LC_Origen1.nombre || ' (' || Origen1.codigo_iata || ')' origen1, T1.id t1id,V1.id v1id,LC_Destino1.nombre || ' (' || Destino1.codigo_iata || ')' destino1,
			T2.id t2id, V2.id v2id, LC_Destino2.nombre || ' (' || Destino2.codigo_iata || ')' destino2,
			T3.id t3id,V3.id v3id, LC_Destino3.nombre || ' (' || Destino3.codigo_iata || ')' destino3,
			ROUND( T1.distancia.cantidad + T2.distancia.cantidad + T3.distancia.cantidad) distancia_total
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
		) TABLITA