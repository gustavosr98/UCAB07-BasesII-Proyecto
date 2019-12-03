CREATE OR REPLACE PROCEDURE sim_cerrar_periodo_transcurrido (fechas_base IN PERIODO)
IS 
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 4.3 CERRAR PERIODO *****************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    fechasReales(fechas_base);
    --puntuar(fechas_baswe);
    --entregarVehicolo(fechas_base);
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

CREATE OR REPLACE PROCEDURE fechasReales (fechas_base IN PERIODO)
IS 
    CURSOR cvuelos (periodo PERIODO) IS 
        SELECT v.* FROM Vuelo v
        WHERE v.periodo_estimado.fecha_inicio < periodo.fecha_fin + numToDSInterval( 1, 'HOUR' ) AND
            v.periodo_estimado.fecha_inicio >= periodo.fecha_inicio AND
            v.estatus = 'NO_INICIADO';  
    rvuelo Vuelo%ROWTYPE;

    fecha_salida_real TIMESTAMP;
    fecha_llegada_real TIMESTAMP;

    retrasado INTEGER;
    est VARCHAR2(20);

    tray Trayecto%ROWTYPE;
    per PERIODO;
    cantR INTEGER;
BEGIN
    OPEN cvuelos(fechas_base);
    FETCH cvuelos INTO rvuelo;

    OUT_(2, 'Fecha Periodo Inicio: ' ||fechas_base.fecha_inicio || ' - Fecha Periodo Fin: ' ||fechas_base.fecha_fin);
    OUT_BREAK;
    OUT_(0,'-----------------------------------------------------------------------');
    OUT_BREAK;

    WHILE cvuelos%FOUND
        LOOP
            SELECT * INTO tray FROM Trayecto WHERE id = rvuelo.fk_trayecto;

            retrasado := ROUND( DBMS_RANDOM.VALUE(1,3) );

            IF (retrasado = 1) THEN
                fecha_salida_real := TIEMPO_PKG.RANDOM(PERIODO(rvuelo.periodo_estimado.fecha_inicio,rvuelo.periodo_estimado.fecha_inicio + numToDSInterval( 1, 'HOUR' )));
                est := 'RETRASADO';
            ELSE
                fecha_salida_real := rvuelo.periodo_estimado.fecha_inicio;
                est := 'NO_INICIADO';
            END IF;

            per := selectFecha (fecha_salida_real, tray, rvuelo.fk_avion);
            fecha_llegada_real := per.fecha_fin;

            IF (fecha_llegada_real < fechas_base.fecha_fin) THEN
                est := 'COMPLETADO';
            ELSIF (TIEMPO_PKG.DIFF(fecha_salida_real, fechas_base.fecha_fin, 'MINUTE') > 5 AND TIEMPO_PKG.DIFF(fecha_salida_real, fechas_base.fecha_fin, 'MINUTE') < 10) THEN
                est := 'EN_TRANSITO';
            ELSIF (fecha_salida_real < fechas_base.fecha_fin AND fecha_llegada_real > fechas_base.fecha_fin) THEN
                est := 'EN_VUELO';
                OUT_(2, 'Vuelo: ' || rvuelo.id || ' - Estatus: ' || est || ' - Cantidad Reservaciones: ' || cantR);
                OUT_(3, 'Fecha Salida Estimada: ' || rvuelo.periodo_estimado.fecha_inicio || ' - Fecha Llegada Estimada: ' || rvuelo.periodo_estimado.fecha_fin);
                OUT_(3, 'Fecha Salida Real: ' || per.fecha_inicio || ' - Fecha Llegada Real: ' || per.fecha_fin);
                OUT_BREAK;
                OUT_(0,'-----------------------------------------------------------------------');
                OUT_BREAK;
            END IF;
            
            UPDATE Vuelo
                SET periodo_real = per,
                    estatus = est 
                WHERE id = rvuelo.id;

            SELECT COUNT(*) INTO cantR 
            FROM Reservacion
            WHERE v_fk_vuelo = rvuelo.id;


            IF (est = 'COMPLETADO' AND cantR > 0) THEN
                OUT_(2, 'Vuelo: ' || rvuelo.id || ' - Estatus: ' || est || ' - Cantidad Reservaciones: ' || cantR);
                OUT_(3, 'Fecha Salida Estimada: ' || rvuelo.periodo_estimado.fecha_inicio || ' - Fecha Llegada Estimada: ' || rvuelo.periodo_estimado.fecha_fin);
                OUT_(3, 'Fecha Salida Real: ' || per.fecha_inicio || ' - Fecha Llegada Real: ' || per.fecha_fin);
                OUT_BREAK;
                OUT_(0,'-----------------------------------------------------------------------');
                OUT_BREAK;
                sumarMillas(rvuelo.id, rvuelo.fk_trayecto, fecha_llegada_real);
            END IF;

            FETCH cvuelos INTO rvuelo;
        END LOOP;

    CLOSE cvuelos;
END;

CREATE OR REPLACE PROCEDURE sumarMillas (idVuelo IN NUMBER, idTrayecto IN NUMBER, fechaFin IN TIMESTAMP)
IS 
    CURSOR creservacion (idv Vuelo.id%TYPE) IS 
        SELECT r.*
        FROM Reservacion r
        WHERE r.v_fk_vuelo = idv;
    rreservacion Reservacion%ROWTYPE;

    dist NUMBER;
BEGIN
	OPEN creservacion(idVuelo);
	FETCH creservacion INTO rreservacion;

	SELECT ROUND(t.distancia.cantidad * 0.621371) INTO dist FROM Trayecto t
	WHERE t.id = idTrayecto;

	WHILE creservacion%FOUND LOOP
		INSERT INTO Historico_Milla (fk_reservacion_vuelo,cantidad,fecha)
				VALUES (
						rreservacion.id,
						dist,
						fechaFin
				);

		OUT_(2, 'Reservacion: ' || rreservacion.id || ' - Millas: ' || dist);
		OUT_BREAK;

		FETCH creservacion INTO rreservacion;
	END LOOP;

	OUT_(0,'-----------------------------------------------------------------------');
	OUT_BREAK;

	CLOSE creservacion;
END;