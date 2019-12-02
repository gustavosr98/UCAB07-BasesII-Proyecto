CREATE OR REPLACE PROCEDURE sim_reprogramacion_de_vuelos (fechas_base IN PERIODO)
IS 
    cantidad INTEGER;
    i_c INTEGER;
    cantVuelos NUMBER;

    CURSOR cvuelo IS SELECT * FROM Vuelo WHERE estatus = 'NO_INICIADO' ORDER BY dbms_random.value;
    rvuelo Vuelo%ROWTYPE;

    CURSOR creservacion (idv Vuelo.id%TYPE) IS 
        SELECT r.*
        FROM Usuario u, Pago p, Reservacion r
        WHERE p.fk_usuario = u.id
            AND p.fk_reservacion = r.id
            AND r.v_fk_vuelo = idv;
    rreservacion Reservacion%ROWTYPE;

    vueloNuevo NUMBER;

    lOrigen NUMBER;
    lDestino NUMBER;
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 4.1.5 REPROGRAMZACION VUELOS *******');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    SELECT COUNT(*) INTO cantVuelos FROM Vuelo WHERE estatus = 'NO_INICIADO';
 
    cantidad := ROUND( DBMS_RANDOM.VALUE(cantVuelos*0.05,cantVuelos*0.1) );

    OPEN cvuelo;
    FETCH cvuelo INTO rvuelo;

    WHILE (cantidad > 0 AND cvuelo%FOUND)
        LOOP
            SELECT ae.fk_lugar INTO lOrigen FROM Aeropuerto ae, Trayecto t 
            WHERE t.id = rvuelo.fk_trayecto 
                AND ae.id = t.fk_aeropuerto_origen;
            SELECT ae.fk_lugar INTO lDestino FROM Aeropuerto ae, Trayecto t 
            WHERE t.id = rvuelo.fk_trayecto 
                AND ae.id = t.fk_aeropuerto_destino;

            OUT_(2, 'Vuelo a reprogramar: ' || rvuelo.id);
            OUT_(3, 'Origen: ' || getLugar(lOrigen, 'CIUDAD') || ' - Destino: ' || getLugar(lDestino, 'CIUDAD'));
            OUT_(3, 'Fecha Salida Vieja: ' || rvuelo.periodo_estimado.fecha_inicio || ' - Fecha Llegada Vieja: ' || rvuelo.periodo_estimado.fecha_fin);
            
            updateFechaNueva(fechas_base, rvuelo.periodo_estimado, rvuelo.fk_trayecto, rvuelo.id, rvuelo.fk_avion);
            
            OUT_BREAK;
            OUT_(0,'-----------------------------------------------------------------------');
            OUT_BREAK;

            OPEN creservacion(rvuelo.id);
            FETCH creservacion INTO rreservacion;

            WHILE creservacion%FOUND
                LOOP
                    OUT_(2, 'Reservacion afectada: ' || rreservacion.id);
                    
                    vueloNuevo := buscarVuelo(rvuelo.fk_trayecto, rvuelo.periodo_estimado);

                    UPDATE Reservacion 
                        SET v_fk_vuelo = vueloNuevo
                        WHERE id = rreservacion.id;

                    OUT_BREAK;
                    OUT_(0,'-----------------------------------------------------------------------');

                    FETCH creservacion INTO rreservacion;
                END LOOP;

            CLOSE creservacion;
            
            FETCH cvuelo INTO rvuelo;
            cantidad := cantidad - 1;
        END LOOP;

    CLOSE cvuelo;
END;

CREATE OR REPLACE PROCEDURE updateFechaNueva (fechas_base IN PERIODO, periodo_estimado IN PERIODO, idTrayecto IN NUMBER, idVuelo IN NUMBER, idAvion IN NUMBER)
IS 
    fecha_salida_estimada TIMESTAMP;
    fecha_llegada_estimada TIMESTAMP;
    segundos_estimados NUMBER;
    per PERIODO;
    tray Trayecto%ROWTYPE;
BEGIN
    SELECT * INTO tray FROM Trayecto WHERE id = idTrayecto;

    fecha_salida_estimada := TIEMPO_PKG.RANDOM(PERIODO(periodo_estimado.fecha_inicio,fechas_base.fecha_fin));
    per := selectFecha (fecha_salida_estimada, tray, idAvion);
    OUT_(3, 'Fecha Salida Nueva: ' || per.fecha_inicio || ' - Fecha Llegada Nueva: ' || per.fecha_fin);

    UPDATE Vuelo 
        SET periodo_estimado = per
        WHERE id = idVuelo;
END;

CREATE OR REPLACE FUNCTION buscarVuelo (trayecto IN NUMBER, periodo_base IN PERIODO) RETURN NUMBER
IS 
    vue NUMBER DEFAULT NULL;
    per PERIODO;
BEGIN
    SELECT id, periodo_estimado INTO vue, per FROM Vuelo v
    WHERE v.fk_trayecto = trayecto
        AND (v.periodo_estimado.fecha_inicio BETWEEN 
            periodo_base.fecha_inicio AND periodo_base.fecha_inicio + numToDSInterval( 2, 'DAY' ))
        AND ROWNUM = 1;

    IF (vue IS NULL) THEN 
        vue := insertVueloReprogramacion(trayecto, periodo_base);
    ELSE
        OUT_(3, 'Vuelo nuevo: ' || vue || ' - Fecha Salida: ' || per.fecha_inicio || ' - Fecha Llegada: ' || per.fecha_fin);
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

    precio := ROUND ( tray.distancia.cantidad / 8 )*DBMS_RANDOM.VALUE(0.8,1.3);

    fecha_salida_estimada := TIEMPO_PKG.RANDOM(PERIODO(periodo_base.fecha_inicio,periodo_base.fecha_inicio + numToDSInterval( 2, 'DAY' )));
    per := selectFecha (fecha_salida_estimada, tray, avion);

    SELECT tabla.idAvion INTO avion FROM
        (SELECT av.id idAvion FROM Avion av, Tipo_Avion ta
        WHERE av.fk_tipo_avion = ta.id
            AND ta.alcance_max.cantidad >= tray.distancia.cantidad
            AND av.id NOT IN (
                SELECT v.fk_avion FROM Vuelo v
                WHERE v.periodo_estimado.fecha_inicio BETWEEN 
                    (fecha_salida_estimada - numToDSInterval( 5, 'HOUR' )) AND (fecha_salida_estimada + numToDSInterval( 5, 'HOUR' ))
            )
        ORDER BY dbms_random.value) tabla
    WHERE rownum = 1;

    INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado)
        VALUES (
            avion,
            idTrayecto,
            'NO_INICIADO',
            UNIDAD('DIVISA','DOLAR',precio),
            per)
        RETURNING id INTO idVuelo;

    OUT_(3, 'Vuelo nuevo: ' || idVuelo || ' - Fecha Salida: ' || per.fecha_inicio || ' - Fecha Llegada: ' || per.fecha_fin);
   
    RETURN idVuelo;
END;

-- EJECUCION
BEGIN
	sim_reprogramacion_vuelo(PERIODO(
		TIMESTAMP '19-09-19 11:24:50',
		TIMESTAMP '20-03-20 06:47:15'
	));
END;