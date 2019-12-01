CREATE OR REPLACE PROCEDURE reporte6 (cursor6 OUT SYS_REFCURSOR, idReserva IN NUMBER)
IS
    logo BLOB;
    correo VARCHAR2(50);
    vuelo VARCHAR2(100);
    fechaSalida VARCHAR2(30);
    fechaRegreso VARCHAR2(30);
    precio VARCHAR2(10);
    forma VARCHAR2(30);
    monto VARCHAR2(10);
BEGIN

    OPEN cursor6 FOR

    SELECT ae.logo, u.correo, getLugar(lOrigen.fk_lugar, 'COMPLETO') || ' - ' || getLugar(lDestino.fk_lugar, 'COMPLETO') || 
        ' - ' || TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'MUY_HUMANO'), 
        TIEMPO_PKG.PRINT(v.periodo_estimado.fecha_inicio,'FECHA'), getRegreso(r.id), 
        v.precio_base.cantidad || ' ' || getMoneda(v.precio_base.nombre), getFormaPago(p.id, u.id), getMonto(p.id)
        INTO logo, correo, vuelo, fechaSalida, fechaRegreso, precio, forma, monto
    FROM Aerolinea ae, Avion av, Usuario u, Cliente cl, Reservacion r, Reserva s, Vuelo v, Trayecto t, Lugar lOrigen, 
        Lugar lDestino, Aeropuerto aOrigen, Aeropuerto aDestino, Pago p
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
        AND p.fk_usuario = u.id
        AND p.fk_reservacion = r.id
        AND r.id = idReserva;

END;

CREATE OR REPLACE FUNCTION getFormaPago (idPago IN NUMBER, idUsuario IN NUMBER) RETURN VARCHAR2
IS 
    pag Pago%ROWTYPE;

    forma VARCHAR2(100);
BEGIN
    SELECT * INTO pag FROM Pago WHERE id = idPago;

    IF (pag.fk_tarjeta IS NOT NULL) THEN
        SELECT tipo || ' - ' || compañia || ' - ' SUBSTR(numero, LENGTH(numero) - 3, 4) INTO forma
        FROM Tarjeta WHERE id = pag.fk_tarjeta;
    ELSE
        forma := 'Millas - ' || getMillasDisponibles(idUsuario) || ' Millas restantes'
    END IF;

    RETURN forma;
END;

CREATE OR REPLACE FUNCTION getMonto (idPago IN NUMBER) RETURN VARCHAR2
IS 
    pag Pago%ROWTYPE;

    monto VARCHAR2(50);
BEGIN
    SELECT * INTO pag FROM Pago WHERE id = idPago;

    monto := TO_CHAR(pag.pagado.cantidad) || ' ' || getMoneda(pag.pagado.nombre);
    
    RETURN monto;
END;