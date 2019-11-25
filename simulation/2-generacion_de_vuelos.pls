CREATE OR REPLACE PROCEDURE sim_generacion_de_vuelos (fechas_base IN PERIODO)
IS
    cantidad INTEGER;
    periodo_estimado PERIODO;
    precio NUMBER;
    avion NUMBER;
    trayecto NUMBER;
BEGIN
    cantidad := ROUND( DBMS_RANDOM.VALUE(100,500) );

    WHILE cantidad > 0 
        LOOP
            precio := DBMS_RANDOM.VALUE(100,700);
            avion := selectAvion();
            trayecto := selectTrayecto();
            periodo_estimado := selectFecha(fechas_base, trayecto);
            insertarVuelo(avion, trayecto, precio, periodo_estimado);
            cantidad := cantidad - 1;
        END LOOP;
END;    

CREATE OR REPLACE PROCEDURE insertarVuelo (avion IN NUMBER, trayecto IN NUMBER, precio IN NUMBER, periodo_estimado IN PERIODO)
IS
    tipo_avion NUMBER;
    alcance NUMBER;
    distancia NUMBER;
BEGIN
    SELECT fk_tipo_avion INTO tipo_avion FROM Avion WHERE id = avion;

    SELECT t.alcance_max.cantidad INTO alcance FROM Tipo_Avion t WHERE id = tipo_avion;
    SELECT t.distancia.cantidad INTO distancia FROM Trayecto t WHERE id = trayecto;

    IF (alcance >= distancia) THEN
        INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado)
            VALUES (
                avion,
                trayecto,
                'NO_INICIADO',
                UNIDAD('DIVISA','DOLAR',precio),
                periodo_estimado);
    END IF;
END;

CREATE OR REPLACE FUNCTION selectFecha (fechas_base IN PERIODO, trayecto IN NUMBER) RETURN PERIODO
IS 
    fecha_salida_estimada TIMESTAMP;
    fecha_llegada_estimada TIMESTAMP;
    segundos_estimados NUMBER;
    per PERIODO;
BEGIN
    fecha_salida_estimada := TIEMPO_PKG.RANDOM(fechas_base);
    segundos_estimados := promedioTiempo(trayecto);

    IF (segundos_estimados > 0) THEN 
        fecha_llegada_estimada := fecha_salida_estimada + numToDSInterval( segundos_estimados, 'SECOND' );
    ELSE
        fecha_llegada_estimada := TIEMPO_PKG.RANDOM(PERIODO(fecha_salida_estimada + numToDSInterval( 1, 'HOUR' ), fecha_salida_estimada + numToDSInterval( 15, 'HOUR' )));
    END IF;

    per := PERIODO(fecha_salida_estimada, fecha_llegada_estimada);
    RETURN per;
END;

CREATE OR REPLACE FUNCTION selectAvion RETURN NUMBER
IS
    minId NUMBER;
    maxId NUMBER;

    avion NUMBER;
    tipo_avion NUMBER;
BEGIN
    SELECT MIN(id), MAX(id) INTO minId, maxId
    FROM Avion;

    avion := ROUND( DBMS_RANDOM.VALUE(minId,maxId) );

    RETURN avion;
END;

CREATE OR REPLACE FUNCTION selectTrayecto RETURN NUMBER
IS
    minId NUMBER;
    maxId NUMBER;

    trayecto NUMBER;
BEGIN
    SELECT MIN(id), MAX(id) INTO minId, maxId
    FROM Trayecto;

    trayecto := ROUND( DBMS_RANDOM.VALUE(minId,maxId) );

    RETURN trayecto;
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

