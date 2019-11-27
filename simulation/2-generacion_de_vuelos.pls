CREATE OR REPLACE PROCEDURE sim_generacion_de_vuelos (fechas_base IN PERIODO)
IS
    fecha_salida_estimada TIMESTAMP;
    periodo_estimado PERIODO;
    precio NUMBER;
    avion NUMBER DEFAULT 0;

    CURSOR ctray IS SELECT * FROM Trayecto;
    tray Trayecto%ROWTYPE;

    llenado NUMBER;
    cantidad_vuelos_por_trayecto NUMBER;
BEGIN
    OPEN ctray;
    FETCH ctray INTO tray;

    WHILE ctray%FOUND 
        LOOP
            --llenado := DBMS_RANDOM.VALUE(0.1, 1);
            --cantidad_vuelos_por_trayecto := TRUNC(
            --    DBMS_RANDOM.VALUE(
            --        TIEMPO_PKG.DIFF( fechas_base.fecha_inicio, fechas_base.fecha_fin, 'DAY' )*llenado,
            --        TIEMPO_PKG.DIFF( fechas_base.fecha_inicio, fechas_base.fecha_fin, 'DAY' )
            --    ));
            cantidad_vuelos_por_trayecto := DBMS_RANDOM.VALUE(3, 5);

            precio := ROUND ( tray.distancia.cantidad / 8 );
            fecha_salida_estimada := TIEMPO_PKG.RANDOM(PERIODO(fechas_base.fecha_inicio,fechas_base.fecha_fin - numToDSInterval( 70, 'HOUR' )));

            avion := selectAvion(tray.distancia.cantidad,fecha_salida_estimada);
            WHILE cantidad_vuelos_por_trayecto > 0
                LOOP
                    periodo_estimado := selectFecha(fecha_salida_estimada, tray, avion);

                    INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado)
                        VALUES (
                            avion,
                            tray.id,
                            'NO_INICIADO',
                            UNIDAD('DIVISA','DOLAR',precio),
                            periodo_estimado);
                    
                    fecha_salida_estimada := fecha_salida_estimada + numToDSInterval( 15, 'HOUR' );
                    cantidad_vuelos_por_trayecto := cantidad_vuelos_por_trayecto - 1;
                END LOOP;

            FETCH ctray INTO tray;
        END LOOP;
    
    CLOSE ctray;
END;   

CREATE OR REPLACE FUNCTION selectFecha (fecha_salida_estimada IN TIMESTAMP, trayecto IN Trayecto%ROWTYPE, avion IN NUMBER) RETURN PERIODO
IS 
    fecha_llegada_estimada TIMESTAMP;
    per PERIODO;
    velocidad NUMBER;
    tiempo NUMBER DEFAULT 0;
BEGIN
    SELECT ta.velocidad_max.cantidad INTO velocidad
    FROM Tipo_Avion ta, Avion av
    WHERE av.id = avion
        AND ta.id = av.fk_tipo_avion;

    tiempo := promedioTiempo(trayecto.id);

    IF (tiempo = 0) THEN 
        tiempo := ( trayecto.distancia.cantidad * 3600 ) / ( 1234.8 * velocidad * 0.98 );
    END IF;

    fecha_llegada_estimada := fecha_salida_estimada + numToDSInterval( tiempo, 'SECOND' );

    per := PERIODO(fecha_salida_estimada, fecha_llegada_estimada);
    RETURN per;
END;

CREATE OR REPLACE FUNCTION selectAvion (distancia IN NUMBER,fecha_salida_estimada IN TIMESTAMP) RETURN NUMBER
IS
    minId NUMBER;
    maxId NUMBER;

    avion NUMBER;
    tipo_avion NUMBER;
BEGIN
    SELECT tabla.idAvion INTO avion FROM
        (SELECT av.id idAvion FROM Avion av, Tipo_Avion ta
        WHERE av.fk_tipo_avion = ta.id
            AND ta.alcance_max.cantidad >= distancia
            AND av.id NOT IN (
                SELECT v.fk_avion FROM Vuelo v
                WHERE v.periodo_estimado.fecha_inicio BETWEEN 
                    (fecha_salida_estimada - numToDSInterval( 5, 'HOUR' )) AND (fecha_salida_estimada + numToDSInterval( 5, 'HOUR' ))
            )
        ORDER BY dbms_random.value) tabla
    WHERE rownum = 1;

    RETURN avion;
END;

CREATE OR REPLACE FUNCTION promedioTiempo (trayecto IN NUMBER) RETURN NUMBER
IS
    promedio NUMBER DEFAULT 0;
BEGIN
    SELECT AVG(TIEMPO_PKG.DIFF(v.periodo_real.fecha_inicio,v.periodo_real.fecha_fin,'SECOND')) INTO promedio
    FROM Vuelo v
    WHERE periodo_real IS NOT NULL 
        AND fk_trayecto = trayecto;

    RETURN promedio;
END;

-- EJECUCION
BEGIN
	sim_generacion_de_vuelos(PERIODO(
		TIMESTAMP '2019-09-19 11:24:50',
		TIMESTAMP '2020-10-26 06:47:15'
	));
END;
/
SELECT COUNT(*) FROM VUELO;
SELECT COUNT(*) FROM TRAYECTO;
SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM VUELO GROUP BY fk_trayecto );
SELECT COUNT(*) FROM VUELO GROUP BY fk_trayecto;

SELECT id, estatus, PRECIO_BASE.cantidad, PERIODO_ESTIMADO.fecha_inicio, PERIODO_ESTIMADO.fecha_fin, FK_AVION, FK_TRAYECTO FROM vuelo;

--Inserts de prueba
INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado,periodo_real)
    VALUES (
        1,
        1,
        'COMPLETADO',
        UNIDAD('DIVISA','DOLAR',2),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:06:00'
        ),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:05:20'
        ));

INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado,periodo_real)
    VALUES (
        2,
        1,
        'COMPLETADO',
        UNIDAD('DIVISA','DOLAR',3),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:06:00'
        ),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:05:40'
        ));

INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado,periodo_real)
    VALUES (
        3,
        1,
        'COMPLETADO',
        UNIDAD('DIVISA','DOLAR',4),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:06:00'
        ),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:05:10'
        ));

INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado,periodo_real)
    VALUES (
        1,
        1,
        'COMPLETADO',
        UNIDAD('DIVISA','DOLAR',5),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:06:00'
        ),
        PERIODO(
            TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:05:20'
        ));

