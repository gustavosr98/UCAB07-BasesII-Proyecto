SELECT V.id vuelo, Av.id Avion, V.estatus, T.id trayecto,
		V.periodo_estimado.fecha_inicio salida_est,  V.periodo_estimado.fecha_fin llegada_est
FROM vuelo V, trayecto T, avion Av
WHERE V.fk_trayecto = T.id AND
	V.fk_avion = Av.id 
;
 