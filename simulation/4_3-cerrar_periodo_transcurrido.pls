CREATE OR REPLACE PROCEDURE sim_cerrar_periodo_transcurrido (fechas_base IN PERIODO)
IS 
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 4.3 CERRAR PERIODO *****************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    fechasReales(fechas_base);
    sumarMillas();
    puntuar(fechas_base);
    entregarVehicolo(fechas_base);
END;

CREATE OR REPLACE PROCEDURE entregarVehicolo (fechas_base IN PERIODO)
IS
    CURSOR creservacion (periodo PERIODO) IS 
        SELECT *
        FROM Reservacion r
        WHERE tipo = 'C'
            AND r.c_periodo.fecha_fin < periodo.fecha_fin;
    rreservacion Reservacion%ROWTYPE;

    lCiudad Lugar%ROWTYPE;
    sDestino Sucursal%ROWTYPE;
BEGIN
    OPEN creservacion(fechas_base);
    FETCH creservacion INTO rreservacion;

    WHILE creservacion%FOUND 
        LOOP
            SELECT lci.* INTO lCiudad
            FROM Sucursal s, Lugar lca, Lugar lci
            WHERE s.id = rreservacion.c_fk_sucursal_inicio
                AND lca.id = s.fk_lugar
                AND lci.id = lca.fk_lugar;

            SELECT s.* INTO sDestino 
            FROM Sucursal s, Lugar lca
            WHERE s.fk_lugar = lca.id
                AND lca.fk_lugar = lCiudad.id
                AND ROWNUM = 1
            ORDER BY DBMS_RANDOM.VALUE;

            UPDATE Reservacion
            SET c_fk_sucursal_fin = sDestino.id
            WHERE id = rreservacion.id; 

            UPDATE Vehiculo
            SET localizacion = lCiudad.localizacion
            WHERE id = rreservacion.c_fk_vehiculo;

            OUT_(2, 'Reservacion: ' || rreservacion.id);
            OUT_(3, 'Ciudad: ' || lCiudad.nombre || ' - Sucursal Origen: ' || rreservacion.c_fk_sucursal_inicio || ' - Sucursal Origen: ' || sDestino.id);
            OUT_BREAK;
            OUT_(0,'-----------------------------------------------------------------------');
            OUT_BREAK;
        END LOOP;

    CLOSE creservacion;
END;

CREATE OR REPLACE PROCEDURE puntuar (fechas_base IN PERIODO)
IS 
    CURSOR chabitacion (periodo PERIODO) IS 
        SELECT * FROM Reservacion r
        WHERE r.tipo = 'A'
            AND r.a_periodo.fecha_fin < periodo.fecha_fin;
    rhabitacion Reservacion%ROWTYPE;

    puntua INTEGER;
    puntuacion INTEGER;
BEGIN
    OPEN chabitacion(fechas_base);
    FETCH chabitacion INTO rhabitacion;
    
    WHILE chabitacion%FOUND
        LOOP
            puntua := ROUND(DBMS_RANDOM.VALUE(1,2));

            IF (puntua = 1) THEN
                puntuacion := ROUND(DBMS_RANDOM.VALUE(1,10));

                UPDATE Reservacion
                SET a_puntuacion = puntuacion
                WHERE id = rhabitacion.id;

                OUT_(2, 'Reservacion: ' || rhabitacion.id || ' - Puntuación: ' || puntuacion);
                OUT_BREAK;
                OUT_(0,'-----------------------------------------------------------------------');
                OUT_BREAK;
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
        WHERE v_fk_vuelo = idv;
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

            dist := dist * 0.621371;

            WHILE creservacion%FOUND    
                LOOP
                    INSERT INTO Historico_Milla (fk_reservacion_vuelo,cantidad,fecha)
                        VALUES (
                            rreservacion.id,
                            dist,
                            rvuelo.periodo_real.fecha_fin);
                END LOOP;

                OUT_(2, 'Reservacion: ' || rreservacion.id || ' - Millas: ' || dist);
                OUT_BREAK;
                OUT_(0,'-----------------------------------------------------------------------');
                OUT_BREAK;

            CLOSE creservacion;
        END LOOP;

    CLOSE cvuelos; 
END;

CREATE OR REPLACE PROCEDURE fechasReales (fechas_base IN PERIODO)
IS 
    CURSOR cvuelos (periodo PERIODO) IS 
        SELECT v.* FROM Vuelo v
        WHERE TIEMPO_PKG.DIFF(v.periodo_estimado.fecha_inicio,periodo.fecha_fin, 'MINUTE') < 10;
    rvuelo Vuelo%ROWTYPE;

    fecha_salida_real TIMESTAMP;
    fecha_llegada_real TIMESTAMP;

    retrasado INTEGER;
    estatus VARCHAR2(30);

    tray Trayecto%ROWTYPE;
    per PERIODO;
BEGIN
    OPEN cvuelos(fechas_base);
    FETCH cvuelos INTO rvuelo;

    WHILE cvuelos%FOUND
        LOOP
            SELECT * INTO tray FROM Trayecto WHERE id = rvuelo.fk_trayecto;

            retrasado := ROUND( DBMS_RANDOM.VALUE(1,3) );

            IF (retrasado = 1) THEN
                fecha_salida_real := TIEMPO_PKG.RANDOM(PERIODO(rvuelo.periodo_estimado.fecha_inicio,rvuelo.periodo_estimado.fecha_inicio + numToDSInterval( 1, 'HOUR' )));
                estatus := 'RETRASADO';
            ELSE
                fecha_salida_real := rvuelo.periodo_estimado.fecha_inicio;
                estatus := 'NO_INICIADO';
            END IF;

            per := selectFecha (fecha_salida_real, tray, rvuelo.fk_avion);
            fecha_llegada_real := per.fecha_fin;

            IF (fecha_llegada_real < fechas_base.fecha_fin) THEN
                estatus := 'COMPLETADO';
            ELSIF (TIEMPO_PKG.DIFF(fecha_salida_real, fechas_base.fecha_fin, 'MINUTE') > 5 AND TIEMPO_PKG.DIFF(fecha_salida_real, fechas_base.fecha_fin, 'MINUTE') < 10) THEN
                estatus := 'EN_TRANSITO';
            ELSIF (fecha_salida_real < fechas_base.fecha_fin AND fecha_llegada_real > fechas_base.fecha_fin) THEN
                estatus := 'EN_VUELO';
            END IF;
            
            UPDATE Vuelo
                SET periodo_real = per,
                    estatus = estatus 
                WHERE id = rvuelo.id;

            OUT_(2, 'Vuelo: ' || rvuelo.id || ' - Estatus: ' || estatus);
            OUT_(3, 'Fecha Salida Real: ' || per.fecha_inicio || ' - Fecha Llegada Real: ' || per.fecha_fin);
            OUT_BREAK;
            OUT_(0,'-----------------------------------------------------------------------');
            OUT_BREAK;

            FETCH cvuelos INTO rvuelo;
        END LOOP;

    CLOSE cvuelos;
END;