CREATE OR REPLACE FUNCTION generar_fecha_viaje ( v_usuario USUARIO%ROWTYPE, fecha_reservacion TIMESTAMP, fg PERIODO) RETURN PERIODO
IS
  cantidad_reservaciones INTEGER;
  fecha_inicio TIMESTAMP;
  fecha_fin TIMESTAMP;
  fecha_viaje PERIODO;

  vuelo_x RESERVACION%ROWTYPE;
  vuelo_y RESERVACION%ROWTYPE;
BEGIN
  SELECT COUNT(*) INTO cantidad_reservaciones 
  FROM RESERVACION RV, Pago P 
  WHERE RV.id = Pago.fk_reservacion AND 
    Pago.fk_usuario = v_usuario.id AND
    tipo = 'V';

  IF ( cantidad_reservaciones = 0 ) THEN
    fecha_salida := TIEMPO_PKG.RANDOM(PERIODO(
			fecha_reservacion, fg.fecha_fin
		));
		fecha_viaje := PERIODO( 
			fecha_salida, 
			TIEMPO_PKG.RANDOM(PERIODO(fecha_salida, fg.fecha_fin)) 
		);
  ELSE 
    SELECT * INTO vuelo_x FROM (
      SELECT V.* 
      FROM RESERVACION RV, VUELO V, Pago P 
      WHERE RV.v_fk_vuelo = V.id AND
        RV.id = P.fk_reservacion
        AND 
        RV.tipo = 'V';
        P.fk_usuario = v_usuario.id AND
        V.periodo_estimado.fecha_inicio > fecha_reservacion
    ) WHERE ROWNUM = 1
    ORDER BY DBMS_RANDOM.VALUE  

    SELECT V.* INTO vuelo_y 
    FROM RESERVACION RV, VUELO V, Pago P 
    WHERE RV.v_fk_vuelo = V.id AND
      RV.id = P.fk_reservacion
      AND 
      RV.tipo = 'V';
      P.fk_usuario = v_usuario.id AND
      V.periodo_estimado.fecha_inicio > fecha_reservacion
      AND
      V.periodo_estimado.fecha_inicio

  ) WHERE ROWNUM = 1

    IF ( cantidad_reservaciones = 1 ) THEN

    ELSE

    END IF;

  END IF;

  

END;
/

	