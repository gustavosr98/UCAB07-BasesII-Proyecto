CREATE OR REPLACE PROCEDURE sim_cerrar_periodo_transcurrido (fechas_base IN PERIODO)
IS 
    

    
BEGIN
    fechasReales(fechas_base);

    
END;

CREATE OR REPLACE PROCEDURE sumarMillas (idVuelo IN NUMBER)
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
            OPEN creservacion(idVuelo);
            FETCH creservacion INTO rreservacion;

            SELECT t.distancia.cantidad INTO dist FROM Trayectoria t, Vuelo v
            WHERE v.id = rvuelo.id
                AND t.id = rvuelo.fk_trayectoria;

            WHILE creservacion%FOUND    
                LOOP
                    UPDATE Historico_Milla
                    SET cantidad = dist * 0,621371
                    WHERE fk_reservacion_vuelo = rreservacion.id;
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

            UPDATE Vuelo
                SET periodo_real = PERIODO(fecha_salida_real,fecha_llegada_real),
                    estatus = estatus 
                WHERE id = rvuelo.id;

            FETCH cvuelos INTO rvuelo;
        END LOOP;

    CLOSE cvuelos;
END;