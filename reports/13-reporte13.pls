CREATE OR REPLACE PROCEDURE reporte13 (cursor13 OUT SYS_REFCURSOR, fechaInicio IN TIMESTAMP, fechaFin IN TIMESTAMP)
IS
    foto BLOB;
    fecha VARCHAR2(100);
    lugarOrigen VARCHAR2(50);
    lugarDestino VARCHAR2(50);
    cantidad NUMBER;
BEGIN

    OPEN cursor13 FOR
    
    SELECT aseg.logo, TIEMPO_PKG.PRINT(fechaInicio, 'FECHA_MM') || ' - ' || TIEMPO_PKG.PRINT(fechaFin, 'FECHA_MM'), 
        tabla.lugOrigen, tabla.lugDestino, tabla.cant
        INTO foto, fecha, lugarOrigen, lugarDestino, cantidad
    FROM (
        SELECT aseg.id as aseguradora, getLugar(lOrigen.fk_lugar, 'CIUDAD') as lugOrigen,
            getLugar(lDestino.fk_lugar, 'CIUDAD') as lugDestino, COUNT(*) as cant
        FROM Seguro s, Reservacion r, Aseguradora aseg, Reservacion r2, Vuelo v, Trayecto t, Lugar lOrigen, 
            Lugar lDestino, Aeropuerto aOrigen, Aeropuerto aDestino
        WHERE r.s_fk_seguro = s.id
            AND s.fk_aseguradora = aseg.id
            AND r.fk_reservacion = r2.id
            AND r2.v_fk_vuelo = v.id
            AND v.fk_trayecto = t.id
            AND t.fk_aeropuerto_origen = aOrigen.id
            AND aOrigen.fk_lugar = lOrigen.id
            AND t.fk_aeropuerto_destino = aDestino.id
            AND aDestino.fk_lugar = lDestino.id
            AND lOrigen.id != lDestino.id
            AND TIEMPO_PKG.PRINT(r.s_periodo.fecha_inicio,'FECHA_MM') >= TIEMPO_PKG.PRINT(fechaInicio,'FECHA_MM')
            AND TIEMPO_PKG.PRINT(r.s_periodo.fecha_fin,'FECHA_MM') <= TIEMPO_PKG.PRINT(fechaFin,'FECHA_MM')
            AND ROWNUM <= 1
        GROUP BY aseg.id, getLugar(lOrigen.fk_lugar, 'CIUDAD'), getLugar(lDestino.fk_lugar, 'CIUDAD')
        ) tabla, Aseguradora aseg
    WHERE aseg.id = tabla.aseguradora
    ORDER BY tabla.cant DESC;

END;



--El lugar destino ????
CREATE OR REPLACE FUNCTION getLugarRegreso (idRVuelo IN NUMBER) RETURN VARCHAR2
IS 
    vueloRegreso VARCHAR2(50);
    rvuelo Reservacion%ROWTYPE;
BEGIN
    SELECT * INTO rvuelo FROM Reservacion WHERE id = idRVuelo;

    IF (rvuelo.v_es_ida_vuelta = 'T') THEN
        SELECT getLugar(lug, 'CIUDAD') INTO vueloRegreso
        FROM (SELECT MAX(v.periodo_estimado.fecha_fin) as rvueloRegreso, lDestino.fk_lugar as lug --MIN O MAX??? 
                FROM Reservacion r, Vuelo v, Trayecto t, Lugar lDestino, Aeropuerto aDestino
                WHERE r.v_fk_vuelo = v.id
                    AND r.fk_reservacion = rvuelo.id
                    AND v.fk_trayecto = t.id
                    AND t.fk_aeropuerto_destino = aDestino.id
                    AND aDestino.fk_lugar = lDestino.id
                GROUP BY lDestino.fk_lugar) tabla
        WHERE ROWNUM = 1;
    ELSE
        vueloRegreso := 'Sin Regreso';
    END IF;

    RETURN vueloRegreso;
END;