CREATE OR REPLACE PROCEDURE reporte7 (cursor7 OUT SYS_REFCURSOR, fechaInicio IN VARCHAR2, fechaFin IN VARCHAR2)
IS
    fecha VARCHAR2(100);
    lOrigen VARCHAR2(50);
    lDestino VARCHAR2(50);
    cantidad INTEGER;
BEGIN

    OPEN cursor7 FOR
       
    SELECT TIEMPO_PKG.PRINT(fechaInicio, 'FECHA_MM') || ' - ' || TIEMPO_PKG.PRINT(fechaFin, 'FECHA_MM'),
        getLugar(lOrigen.fk_lugar, 'CIUDAD'), getLugar(lDestino.fk_lugar, 'CIUDAD'), COUNT(*)
        INTO fecha, lOrigen, lDestino, cantidad
    FROM Reservacion r, Reserva s, Vuelo v, Trayecto t, Lugar lOrigen, 
        Lugar lDestino, Aeropuerto aOrigen, Aeropuerto aDestino
    WHERE r.id = s.fk_reservacion
        AND r.v_fk_vuelo = v.id
        AND v.fk_trayecto = t.id
        AND t.fk_aeropuerto_origen = aOrigen.id
        AND aOrigen.fk_lugar = lOrigen.id
        AND t.fk_aeropuerto_destino = aDestino.id
        AND aDestino.fk_lugar = lDestino.id
        AND lOrigen.id != lDestino.id
        AND TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'FECHA_MM') >= TIEMPO_PKG.PRINT(fechaInicio,'FECHA_MM')
        AND TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_fin,'FECHA_MM') <= TIEMPO_PKG.PRINT(fechaFin,'FECHA_MM')
        AND ROWNUM <= 10
    GROUP BY TIEMPO_PKG.PRINT(fechaInicio, 'FECHA_MM') || ' - ' || TIEMPO_PKG.PRINT(fechaFin, 'FECHA_MM'),
        getLugar(lOrigen.fk_lugar, 'CIUDAD'), getLugar(lDestino.fk_lugar, 'CIUDAD')
    ORDER BY COUNT(*) DESC;

END;