CREATE OR REPLACE PROCEDURE sim_cerrar_periodo_transcurrido (fechas_base IN PERIODO)
IS 
BEGIN
    fechasReales(fechas_base);
    sumarMillas();
    puntuar();
    entregarVehicolo();
END;

CREATE OR REPLACE PROCEDURE entregarVehicolo --FALTA HACERLO BIEN
IS
    CURSOR creservacion IS 
        SELECT *
        FROM Reservacion 
        WHERE tipo = 'C';
    rreservacion Reservacion%ROWTYPE;

    locInicial GEOLOCALIZACION;
    locFinal GEOLOCALIZACION;
    locVehiculo GEOLOCALIZACION;
BEGIN
    OPEN creservacion;
    FETCH creservacion INTO rreservacion;

    WHILE creservacion%FOUND 
        LOOP
            IF (rreservacion.c_periodo.fecha_fin < LOCALTIMESTAMP) THEN
                SELECT l.localizacion INTO locInicial FROM Sucursal s, Lugar l
                WHERE s.id = rreservacion.c_fk_sucursal_inicio
                    AND l.id = s.fk_lugar;

                SELECT l.localizacion INTO locFinal FROM Sucursal s, Lugar l
                WHERE s.id = rreservacion.c_fk_sucursal_fin
                    AND l.id = s.fk_lugar;

                SELECT v.localizacion INTO locVehiculo FROM Vehiculo v
                WHERE v.id = rreservacion.c_fk_vehiculo;


            END IF;
        END LOOP;

    CLOSE creservacion;
END;

CREATE OR REPLACE PROCEDURE puntuar 
IS 
    CURSOR chabitacion IS 
        SELECT * FROM Reservacion r
        WHERE r.tipo = 'A'
            AND r.c_periodo.fecha_fin < LOCALTIMESTAMP;
    rhabitacion Reservacion%ROWTYPE;

    puntua INTEGER;
    puntuacion INTEGER;
BEGIN
    OPEN chabitacion;
    FETCH chabitacion INTO rhabitacion;
    
    WHILE chabitacion%FOUND
        LOOP
            puntua := ROUND(DBMS_RANDOM.VALUE(1,2));

            IF (puntua = 1) THEN
                puntuacion := ROUND(DBMS_RANDOM.VALUE(1,10));

                UPDATE Reservacion
                SET a_puntuacion = puntuacion
                WHERE id = rhabitacion.id;
            END IF;

            FETCH chabitacion INTO rhabitacion;
        END LOOP;

    CLOSE chabitacion;
END;

CREATE OR REPLACE PROCEDURE sumarMillas
IS 
    CURSOR cvuelos IS SELECT * FROM Vuelo WHERE estatus = 'COMPLETADO';
    rvuelo Vuelo%ROWTYPE; 

    CURSOR creservacion (idv Vuelo.id%TYPE) IS 
        SELECT *
        FROM Reservacion 
        WHERE tipo = 'V'    
            AND v_fk_vuelo = idv;
    rreservacion Reservacion%ROWTYPE;

    dist NUMBER;
BEGIN
    OPEN cvuelos;
    FETCH cvuelos INTO rvuelo;

    WHILE cvuelos%FOUND
        LOOP
            OPEN creservacion(rvuelo.id);
            FETCH creservacion INTO rreservacion;

            SELECT t.distancia.cantidad INTO dist FROM Trayecto t, Vuelo v
            WHERE v.id = rvuelo.id
                AND t.id = rvuelo.fk_trayecto;

            WHILE creservacion%FOUND    
                LOOP
                    INSERT INTO Historico_Milla (fk_reservacion_vuelo,cantidad,fecha)
                        VALUES (
                            rreservacion.id,
                            dist * 0.621371,
                            rvuelo.periodo_real.fecha_fin);
                END LOOP;

            CLOSE creservacion;
        END LOOP;

    CLOSE cvuelos; 
END;

CREATE OR REPLACE PROCEDURE fechasReales (fechas_base IN PERIODO)
IS 
    CURSOR cvuelos IS SELECT * FROM Vuelo;
    rvuelo Vuelo%ROWTYPE;

    fecha_salida_real TIMESTAMP;
    fecha_llegada_real TIMESTAMP;

    retrasado INTEGER;
    estatus VARCHAR2(20);
BEGIN
    OPEN cvuelos;
    FETCH cvuelos INTO rvuelo;

    WHILE cvuelos%FOUND
        LOOP
            retrasado := ROUND( DBMS_RANDOM.VALUE(1,2) );

            IF (retrasado = 1) THEN
                fecha_salida_real := rvuelo.periodo_estimado.fecha_inicio;
                estatus := 'NO_INICIADO';
            ELSE
                fecha_salida_real := TIEMPO_PKG.RANDOM(PERIODO(rvuelo.periodo_estimado.fecha_inicio,fechas_base.fecha_fin));
                estatus := 'RETRASADO';
            END IF;
            fecha_llegada_real := TIEMPO_PKG.RANDOM(PERIODO(fecha_salida_real + numToDSInterval( 1, 'HOUR' ), fecha_salida_real + numToDSInterval( 15, 'HOUR' )));
            
            IF (fecha_llegada_real < LOCALTIMESTAMP) THEN
                estatus := 'COMPLETADO';
            ELSIF (TIEMPO_PKG.DIFF(fecha_salida_real, LOCALTIMESTAMP, 'MINUTE') > 5 AND TIEMPO_PKG.DIFF(fecha_salida_real, LOCALTIMESTAMP, 'MINUTE') < 10) THEN
                estatus := 'EN_TRANSITO';
            ELSIF (fecha_salida_real < LOCALTIMESTAMP AND fecha_llegada_real > LOCALTIMESTAMP) THEN
                estatus := 'EN_VUELO';
            END IF;
            
            IF (rvuelo.periodo_estimado.fecha_inicio < LOCALTIMESTAMP + numToDSInterval( 10, 'MINUTE' )) THEN
                UPDATE Vuelo
                    SET periodo_real = PERIODO(fecha_salida_real,fecha_llegada_real),
                        estatus = estatus 
                    WHERE id = rvuelo.id;
            END IF;

            FETCH cvuelos INTO rvuelo;
        END LOOP;

    CLOSE cvuelos;
END;