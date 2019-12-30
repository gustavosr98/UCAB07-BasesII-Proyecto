CREATE OR REPLACE PROCEDURE reporte12 (cursor12 OUT SYS_REFCURSOR, fecha IN TIMESTAMP)
IS
    fechaVuelo VARCHAR2(100);
    lOrigen VARCHAR2(50);
    lDestino VARCHAR2(50);
    logo BLOB;
    estado VARCHAR2(50);
    llegada VARCHAR2(100);
BEGIN

    OPEN cursor12 FOR
    
    SELECT TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'HUMANO'), getLugar(lOrigen.fk_lugar, 'COMPLETO'), getLugar(lDestino.fk_lugar, 'COMPLETO'), 
        ae.logo, v.estatus, getFechaLlegada(v.estatus, v.periodo_estimado.fecha_fin)
        INTO fechaVuelo, lOrigen, lDestino, logo, estado, llegada
    FROM Aerolinea ae, Avion av, Vuelo v, Trayecto t, Lugar lOrigen, Lugar lDestino, Aeropuerto aOrigen, Aeropuerto aDestino
    WHERE ae.id = av.fk_aerolinea
        AND v.fk_avion = av.id
        AND v.fk_trayecto = t.id
        AND t.fk_aeropuerto_origen = aOrigen.id
        AND aOrigen.fk_lugar = lOrigen.id
        AND t.fk_aeropuerto_destino = aDestino.id
        AND aDestino.fk_lugar = lDestino.id
        AND lOrigen.id != lDestino.id
        AND v.estatus NOT LIKE 'COMPLETADO'
        AND TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'FECHA') = TIEMPO_PKG.PRINT(fecha,'FECHA');

END;

CREATE OR REPLACE FUNCTION getFechaLlegada (estatus IN VARCHAR2, fechaFin IN TIMESTAMP) RETURN VARCHAR2
IS 
    fLlegada VARCHAR2(100);
BEGIN
    IF (estatus = 'EN_VUELO') THEN
        fLlegada := TIEMPO_PKG.PRINT(fechaFin,'HUMANO');
    ELSE
        fLlegada := 'Por Calcular';
    END IF;

    RETURN fLlegada;
END;
