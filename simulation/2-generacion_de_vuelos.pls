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

    lOrigen NUMBER;
    lDestino NUMBER;
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 2 GENERA VUELOS ********************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    OPEN ctray;
    FETCH ctray INTO tray;

    WHILE ctray%FOUND LOOP
        -- IF (DBMS_RANDOM.VALUE > 0.5 ) THEN
            cantidad_vuelos_por_trayecto := TRUNC(
                DBMS_RANDOM.VALUE(
                    TIEMPO_PKG.DIFF( fechas_base.fecha_inicio, fechas_base.fecha_fin, 'DAY' )*1,
                    TIEMPO_PKG.DIFF( fechas_base.fecha_inicio, fechas_base.fecha_fin, 'DAY' )*2
            ));

            -- cantidad_vuelos_por_trayecto := TRUNC(
            --     DBMS_RANDOM.VALUE(
            --         TIEMPO_PKG.DIFF( fechas_base.fecha_inicio, fechas_base.fecha_fin, 'DAY' )*0.1,
            --         TIEMPO_PKG.DIFF( fechas_base.fecha_inicio, fechas_base.fecha_fin, 'DAY' )*0.3
            -- ));

            --cantidad_vuelos_por_trayecto := DBMS_RANDOM.VALUE(3, 5);
            SELECT fk_lugar INTO lOrigen FROM Aeropuerto WHERE id = tray.fk_aeropuerto_origen;
            SELECT fk_lugar INTO lDestino FROM Aeropuerto WHERE id = tray.fk_aeropuerto_destino;

            -- OUT_(2, 'TRAYECTO: ' || tray.id || ' - Distancia: ' || tray.distancia.cantidad || ' ' || tray.distancia.nombre || 'S');
            -- OUT_(3, 'Origen: ' || getLugar(lOrigen, 'CIUDAD') || ' - Destino: ' || getLugar(lDestino, 'CIUDAD'));
            -- OUT_(3, 'Cant. vuelos por trayecto: ' || cantidad_vuelos_por_trayecto);
            -- OUT_BREAK;
            -- OUT_(0,'-----------------------------------------------------------------------');

            WHILE cantidad_vuelos_por_trayecto > 0 LOOP
                precio := ROUND ( tray.distancia.cantidad / 8 )*DBMS_RANDOM.VALUE(0.8,1.3);
                fecha_salida_estimada := TIEMPO_PKG.RANDOM(PERIODO(fechas_base.fecha_inicio,fechas_base.fecha_fin));
                avion := selectAvion(tray.distancia.cantidad,fecha_salida_estimada);
                periodo_estimado := selectFecha(fecha_salida_estimada, tray, avion);

                INSERT INTO Vuelo (fk_avion,fk_trayecto,estatus,precio_base,periodo_estimado)
                    VALUES (
                        avion,
                        tray.id,
                        'NO_INICIADO',
                        UNIDAD('DIVISA','DOLAR',precio),
                        periodo_estimado);
                
                cantidad_vuelos_por_trayecto := cantidad_vuelos_por_trayecto - 1;

                -- OUT_(4, 'Avion: ' || avion || ' - Precio: ' || precio);
                -- OUT_(4, 'Fecha Salida: ' || periodo_estimado.fecha_inicio || ' - Fecha Llegada: ' || periodo_estimado.fecha_fin);
                -- OUT_BREAK;
                -- OUT_(0,'-----------------------------------------------------------------------');
                -- OUT_BREAK;
            END LOOP;

            FETCH ctray INTO tray;
        --END IF;    
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

    -- tiempo := promedioTiempo(trayecto.id);

    -- IF (tiempo = 0) THEN 
        tiempo := ( trayecto.distancia.cantidad * 3600 ) / ( 1234.8 * velocidad * 0.98 );
    -- END IF;

    fecha_llegada_estimada := fecha_salida_estimada + numToDSInterval( tiempo, 'SECOND' );

    per := PERIODO(
        TIEMPO_PKG.EXTRAER(fecha_salida_estimada, 'BORRAR_SEGUNDOS'), 
        TIEMPO_PKG.EXTRAER(fecha_llegada_estimada, 'BORRAR_SEGUNDOS')
    );
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
        TIMESTAMP '2019-05-19 11:24:50',
        TIMESTAMP '2020-05-26 06:47:15'
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

