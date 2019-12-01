CREATE OR REPLACE PROCEDURE reporte5 (cursor5 OUT SYS_REFCURSOR, correoUsuario IN VARCHAR2, fSalida IN TIMESTAMP, fRegreso IN TIMESTAMP)
IS
    logo BLOB;
    correo VARCHAR2(50);
    vuelo VARCHAR2(100);
    fechaSalida VARCHAR2(30);
    fechaRegreso VARCHAR2(30);
    salida VARCHAR2(30);
    llegada VARCHAR2(30);
    duracion VARCHAR2(10);
    precio VARCHAR2(10);
BEGIN

    OPEN cursor5 FOR

    SELECT ae.logo, u.correo, getLugar(lOrigen.fk_lugar, 'COMPLETO') || ' - ' || getLugar(lDestino.fk_lugar, 'COMPLETO') || 
        ' - ' || TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'MUY_HUMANO'), 
        TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'FECHA'), getRegreso(r.id), 
        TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'HORA') || ' - ' || getLugar(lOrigen.fk_lugar, 'CIUDAD'),
        TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_fin,'HORA') || ' - ' || getLugar(lDestino.fk_lugar, 'CIUDAD'),
        TIEMPO_PKG.DIFF(v.periodo_estimado.fecha_inicio, v.periodo_estimado.fecha_fin, 'HOUR') || 'h ' ||
        TIEMPO_PKG.DIFF(v.periodo_estimado.fecha_inicio, v.periodo_estimado.fecha_fin, 'MINUTE') || 'm',
        v.precio_base.cantidad || ' ' || v.precio_base.nombre
        INTO logo, correo, vuelo, fechaSalida, fechaRegreso, salida, llegada, duracion, precio
    FROM Aerolinea ae, Avion av, Usuario u, Cliente cl, Reservacion r, Reserva s, Vuelo v, Trayecto t, Lugar lOrigen, 
        Lugar lDestino, Aeropuerto aOrigen, Aeropuerto aDestino
    WHERE ae.id = av.fk_aerolinea
        AND v.fk_avion = av.id
        AND v.fk_trayecto = t.id
        AND r.v_fk_vuelo = v.id
        AND r.id = s.fk_reservacion
        AND cl.id = s.fk_cliente
        AND u.fk_cliente = cl.id
        AND t.fk_aeropuerto_origen = aOrigen.id
        AND aOrigen.fk_lugar = lOrigen.id
        AND t.fk_aeropuerto_destino = aDestino.id
        AND aDestino.fk_lugar = lDestino.id
        AND lOrigen.id != lDestino.id
        AND u.correo = correoUsuario
        AND TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'FECHA') = TIEMPO_PKG.PRINT(fSalida,'FECHA')
        AND getRegreso(r.id) = TIEMPO_PKG.PRINT(fRegreso,'FECHA');

END;

CREATE OR REPLACE FUNCTION getMoneda (nombre IN VARCHAR2) RETURN VARCHAR2
IS 
    signo VARCHAR2(10)
BEGIN
    IF (nombre = 'DOLAR') THEN

    ELSIF (nombre = 'BOLIVAR') THEN
        
    END IF;

    RETURN lugarCompleto;
END;


CREATE OR REPLACE FUNCTION getRegreso (idRVuelo IN NUMBER) RETURN VARCHAR2
IS 
    vueloRegreso VARCHAR2(50);
    rvuelo Reservacion%ROWTYPE;
BEGIN
    SELECT * INTO rvuelo FROM Reservacion WHERE id = idRVuelo;

    IF (rvuelo.v_es_ida_vuelta = 'T') THEN
        SELECT TIEMPO_PKG.PRINT(tabla.rvueloRegreso,'FECHA') INTO vueloRegreso
        FROM (SELECT MAX(v.periodo_estimado.fecha_fin) AS rvueloRegreso --MIN O MAX???
                FROM Reservacion r, Vuelo v
                WHERE r.v_fk_vuelo = v.id
                    AND r.fk_reservacion = rvuelo.id) tabla
        WHERE ROWNUM = 1;
    ELSE
        vueloRegreso := 'Sin Regreso';
    END IF;

    RETURN vueloRegreso;
END;

CREATE OR REPLACE FUNCTION getLugar (idCiudad IN NUMBER, tipo IN VARCHAR2) RETURN VARCHAR2
IS 
    lugarCompleto VARCHAR2(200);
BEGIN
    IF (tipo = 'COMPLETO') THEN

        SELECT lCiudad.nombre || ', ' || lEstado.nombre || ', ' || lPais.nombre
            INTO lugarCompleto
        FROM Lugar lPais, Lugar lEstado, Lugar lCiudad
        WHERE lCiudad.id = idCiudad
            AND lEstado.id = lCiudad.fk_lugar
            AND lPais.id = lEstado.fk_lugar;
            
    ELSIF (tipo = 'CIUDAD') THEN
        SELECT lCiudad.nombre
            INTO lugarCompleto
        FROM Lugar lCiudad
        WHERE lCiudad.id = idCiudad;
    END IF;

    RETURN lugarCompleto;
END;
