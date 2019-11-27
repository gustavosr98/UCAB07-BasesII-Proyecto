CREATE OR REPLACE PROCEDURE sim_reprogramacion_vuelo (fechas_base IN PERIODO)
IS 
    cantidad INTEGER;
    i_c INTEGER;

    CURSOR cvuelo IS SELECT * FROM Vuelo WHERE estatus = 'NO_INICIADO';
    rvuelo Vuelo%ROWTYPE;

    CURSOR creservacion (idv Vuelo.id%TYPE) IS 
        SELECT r.*
        FROM Usuario u, Pago p, Reservacion r
        WHERE p.fk_usuario = u.id
            AND p.fk_reservacion = r.id
            AND r.tipo = 'V'    
            AND r.v_fk_vuelo = idv;
    rreservacion Reservacion%ROWTYPE;

    vueloNuevo NUMBER;
BEGIN
    cantidad := ROUND( DBMS_RANDOM.VALUE(10,20) );

    OPEN cvuelo;
    FETCH cvuelo INTO rvuelo;

    WHILE (cantidad > 0 AND cvuelo%FOUND)
        LOOP
            OPEN creservacion(rvuelo.id);
            FETCH creservacion INTO rreservacion;

            WHILE creservacion%FOUND
                LOOP
                    vueloNuevo := buscarVuelo(rvuelo.fk_trayecto, rvuelo.periodo_estimado);

                    UPDATE Reservacion 
                        SET v_fk_vuelo = vueloNuevo
                        WHERE id = rreservacion.id;

                    FETCH creservacion INTO rreservacion;
                END LOOP;

            CLOSE creservacion;

            updateFechaNueva(fechas_base, rvuelo.periodo_estimado, rvuelo.fk_trayecto, rvuelo.id);

            FETCH cvuelo INTO rvuelo;
            cantidad := cantidad - 1;
        END LOOP;

    CLOSE cvuelo;
END;

CREATE OR REPLACE PROCEDURE updateFechaNueva (fechas_base IN PERIODO, periodo_estimado IN PERIODO, trayecto IN NUMBER, idVuelo IN NUMBER)
IS 
    fecha_salida_estimada TIMESTAMP;
    fecha_llegada_estimada TIMESTAMP;
    segundos_estimados NUMBER;
    per PERIODO;
BEGIN
    fecha_salida_estimada := TIEMPO_PKG.RANDOM(PERIODO(periodo_estimado.fecha_inicio,fechas_base.fecha_fin));
    segundos_estimados := promedioTiempo(trayecto);

    IF (segundos_estimados > 0) THEN 
        fecha_llegada_estimada := fecha_salida_estimada + numToDSInterval( segundos_estimados, 'SECOND' );
    ELSE
        fecha_llegada_estimada := TIEMPO_PKG.RANDOM(PERIODO(fecha_salida_estimada + numToDSInterval( 1, 'HOUR' ), fecha_salida_estimada + numToDSInterval( 15, 'HOUR' )));
    END IF;

    per := PERIODO(fecha_salida_estimada, fecha_llegada_estimada);

    UPDATE Vuelo 
        SET periodo_estimado = per
        WHERE id = idVuelo;
END;

CREATE OR REPLACE FUNCTION buscarVuelo (trayecto IN NUMBER, periodo_base IN PERIODO) RETURN NUMBER
IS 
    vue NUMBER DEFAULT 0;
BEGIN
    SELECT id INTO vue FROM Vuelo v
    WHERE v.fk_trayecto = trayecto
        AND (v.periodo_estimado.fecha_inicio BETWEEN 
            periodo_base.fecha_inicio AND periodo_base.fecha_inicio + numToDSInterval( 2, 'DAY' ))
        AND ROWNUM = 1;

    IF (vue = 0) THEN 
        vue := insertVueloReprogramacion(trayecto, periodo_base);
    END IF;

    RETURN vue;
END;

CREATE OR REPLACE FUNCTION insertVueloReprogramacion (idTrayecto IN NUMBER, periodo_base IN PERIODO) RETURN NUMBER
IS 
    avion NUMBER;
    precio NUMBER;
    tray Trayecto%ROWTYPE;

    fecha_salida_estimada TIMESTAMP;
    per PERIODO;

    idVuelo Vuelo.id%TYPE;
BEGIN
    SELECT * INTO tray FROM Trayecto t
    WHERE id = idTrayecto;

    precio := ROUND ( tray.distancia.cantidad / 8 );

    SELECT av.id INTO avion FROM Avion av, Tipo_Avion t 
    WHERE av.fk_tipo_avion = t.id
        AND t.alcance_max.cantidad >= tray.distancia.cantidad
        AND av.id NOT IN (
                SELECT v.fk_avion FROM Vuelo v
                WHERE v.periodo_estimado.fecha_inicio BETWEEN 
                    (fecha_salida_estimada - numToDSInterval( 5, 'HOUR' )) AND (fecha_salida_estimada + numToDSInterval( 5, 'HOUR' ))
            );



    fecha_salida_estimada := TIEMPO_PKG.RANDOM(PERIODO(periodo_base.fecha_inicio,periodo_base.fecha_inicio + numToDSInterval( 2, 'DAY' )));
    per := selectFecha (fecha_salida_estimada, tray, avion);

    INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado)
        VALUES (
            avion,
            idTrayecto,
            'NO_INICIADO',
            UNIDAD('DIVISA','DOLAR',precio),
            per)
        RETURNING id INTO idVuelo;

    RETURN idVuelo;
END;

-- EJECUCION
BEGIN
	sim_reprogramacion_vuelo(PERIODO(
		TIMESTAMP '19-09-19 11:24:50',
		TIMESTAMP '20-03-20 06:47:15'
	));
END;