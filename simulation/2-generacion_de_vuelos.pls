CREATE OR REPLACE PROCEDURE sim_generacion_de_vuelos (fechas_base IN PERIODO)
IS
    cantidad INTEGER;
    cantidad2 INTEGER;
    fecha_salida_estimada TIMESTAMP;
    periodo_estimado PERIODO;
    precio NUMBER;
    avion NUMBER;
    tray Trayecto%ROWTYPE;
BEGIN
    cantidad := ROUND( DBMS_RANDOM.VALUE(1000,3000) );

    WHILE cantidad > 0 
        LOOP
            precio := DBMS_RANDOM.VALUE(100,700);
            tray := selectTrayecto();
            fecha_salida_estimada := TIEMPO_PKG.RANDOM(fechas_base);
            avion := selectAvion(tray.distancia.cantidad,fecha_salida_estimada);

            cantidad2 := ROUND( DBMS_RANDOM.VALUE(5,8) );

            WHILE cantidad2 > 0
                LOOP
                    periodo_estimado := selectFecha(fecha_salida_estimada, tray.id);
                    insertarVuelo(avion, tray.id, precio, periodo_estimado);
                    
                    fecha_salida_estimada := fecha_salida_estimada + numToDSInterval( 1, 'DAY' );
                    cantidad2 := cantidad2 - 1;
                END LOOP;

            cantidad := cantidad - 1;
        END LOOP;
END;   

CREATE OR REPLACE PROCEDURE insertarVuelo (avion IN NUMBER, trayecto IN NUMBER, precio IN NUMBER, periodo_estimado IN PERIODO)
IS
    tipo_avion NUMBER;
    alcance NUMBER;
    distancia NUMBER;
BEGIN
    INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado)
        VALUES (
            avion,
            trayecto,
            'NO_INICIADO',
            UNIDAD('DIVISA','DOLAR',precio),
            periodo_estimado);
END;

CREATE OR REPLACE FUNCTION selectFecha (fecha_salida_estimada IN TIMESTAMP, trayecto IN NUMBER) RETURN PERIODO
IS 
    fecha_llegada_estimada TIMESTAMP;
    segundos_estimados NUMBER;
    per PERIODO;
BEGIN
    segundos_estimados := promedioTiempo(trayecto);

    IF (segundos_estimados > 0) THEN 
        fecha_llegada_estimada := fecha_salida_estimada + numToDSInterval( segundos_estimados, 'SECOND' );
    ELSE
        fecha_llegada_estimada := TIEMPO_PKG.RANDOM(PERIODO(fecha_salida_estimada + numToDSInterval( 1, 'HOUR' ), fecha_salida_estimada + numToDSInterval( 15, 'HOUR' )));
    END IF;

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
                    (fecha_salida_estimada - numToDSInterval( 1, 'DAY' )) AND (fecha_salida_estimada + numToDSInterval( 10, 'DAY' ))
            )
        ORDER BY dbms_random.value) tabla
    WHERE rownum = 1;

    RETURN avion;
END;

CREATE OR REPLACE FUNCTION selectTrayecto RETURN Trayecto%ROWTYPE
IS
    minId NUMBER;
    maxId NUMBER;

    idTrayecto NUMBER;

    rowTrayecto Trayecto%ROWTYPE;
BEGIN
    SELECT MIN(id), MAX(id) INTO minId, maxId
    FROM Trayecto;

    idTrayecto := ROUND( DBMS_RANDOM.VALUE(minId,maxId) );

    SELECT * INTO rowTrayecto FROM Trayecto WHERE id = idTrayecto;

    RETURN rowTrayecto;
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
		TIMESTAMP '19-09-19 11:24:50',
		TIMESTAMP '20-03-20 06:47:15'
	));
END;

SELECT * FROM vuelo;

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

