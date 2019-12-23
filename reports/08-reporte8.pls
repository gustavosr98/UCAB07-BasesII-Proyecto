CREATE OR REPLACE PROCEDURE reporte8 (cursor8 OUT SYS_REFCURSOR, fechaInicio IN VARCHAR2, fechaFin IN VARCHAR2, lugarOrigen IN VARCHAR2, lugarDestino IN VARCHAR2)
IS
    logo BLOB;
    fecha VARCHAR2(100);
    lOrigen VARCHAR2(50);
    lDestino VARCHAR2(50);
    cantidad INTEGER;
BEGIN

    OPEN cursor8 FOR
    
    SELECT ae.logo, tabla.fechas, tabla.origen, tabla.destino, tabla.cant
        INTO logo, fecha, lOrigen, lDestino, cantidad
    FROM (
        SELECT ae.id as aerolinea, TIEMPO_PKG.PRINT(fechaInicio, 'FECHA_MM') || ' - ' || TIEMPO_PKG.PRINT(fechaFin, 'FECHA_MM') as fechas,
            getLugar(lOrigen.fk_lugar, 'CIUDAD') as origen, getLugar(lDestino.fk_lugar, 'CIUDAD') as destino, COUNT(*) as cant
        FROM Reservacion r, Reserva s, Vuelo v, Trayecto t, Lugar lOrigen, 
            Lugar lDestino, Aeropuerto aOrigen, Aeropuerto aDestino, Aerolinea ae, Avion av
        WHERE ae.id = av.fk_aerolinea
            AND v.fk_avion = av.id
            AND r.id = s.fk_reservacion
            AND r.v_fk_vuelo = v.id
            AND v.fk_trayecto = t.id
            AND t.fk_aeropuerto_origen = aOrigen.id
            AND aOrigen.fk_lugar = lOrigen.id
            AND t.fk_aeropuerto_destino = aDestino.id
            AND aDestino.fk_lugar = lDestino.id
            AND lOrigen.id != lDestino.id
            AND TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'FECHA_MM') >= TIEMPO_PKG.PRINT(fechaInicio,'FECHA_MM')
            AND TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_fin,'FECHA_MM') <= TIEMPO_PKG.PRINT(fechaFin,'FECHA_MM')
            AND getLugar(lOrigen.fk_lugar, 'CIUDAD') LIKE origen
            AND getLugar(lDestino.fk_lugar, 'CIUDAD') LIKE 'Rio de Janeiro'
            AND ROWNUM <= 5
        GROUP BY ae.id, TIEMPO_PKG.PRINT(fechaInicio, 'FECHA_MM') || ' - ' || TIEMPO_PKG.PRINT(fechaFin, 'FECHA_MM'),
            getLugar(lOrigen.fk_lugar, 'CIUDAD'), getLugar(lDestino.fk_lugar, 'CIUDAD')
        ) tabla, Aerolinea ae
    WHERE ae.id = tabla.aerolinea
    ORDER BY tabla.cant DESC;
    
END;