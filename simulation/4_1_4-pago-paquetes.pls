CREATE OR REPLACE PROCEDURE sim_pago_de_paquetes(fechas_base IN PERIODO)
IS
    costo NUMBER;
    opciones INTEGER DEFAULT 3;
    metodo NUMBER;

    tarjC Tarjeta%ROWTYPE;
    tarjD Tarjeta%ROWTYPE;
    costoC NUMBER;
    costoD NUMBER;
    porcentaje NUMBER; 

    idPago NUMBER;
    cantMillas NUMBER;
    idUsuario NUMBER;

    CURSOR creservacion IS 
        SELECT r.* FROM Reservacion r
        WHERE r.fk_reservacion IS NULL    
            AND r.fecha_reservacion < fechas_base.fecha_fin
            AND r.id NOT IN (SELECT p.fk_reservacion FROM Pago p);
    rreservacion Reservacion%ROWTYPE;

    CURSOR ccliente (idr Reserva.id%TYPE) IS 
        SELECT cl.* 
        FROM Cliente cl, Reserva r 
        WHERE r.fk_reservacion = idr
            AND r.fk_cliente = cl.id
            AND cl.fk_cliente IS NULL;
    rcliente Cliente%ROWTYPE;
BEGIN 
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 4.1.4 PAGO PAQUETES ****************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    OPEN creservacion;
    FETCH creservacion INTO rreservacion;

    WHILE creservacion%FOUND
        LOOP
            SELECT SUM(r.precio_total.cantidad) INTO costo 
            FROM Reservacion r
            WHERE r.id = rreservacion.id
                OR r.fk_reservacion = rreservacion.id;

            OPEN ccliente(rreservacion.id);
            FETCH ccliente INTO rcliente;

            OUT_(2, 'RESERVACIÓN: ' || rreservacion.id || ' - Costo Total: ' || costo);
            OUT_BREAK;

            WHILE ccliente%FOUND
                LOOP
                    SELECT id INTO idUsuario 
                    FROM Usuario 
                    WHERE fk_cliente = rcliente.id;

                    OUT_(3, 'Usuario: ' || idUsuario || ' - Cliente: ' || rcliente.primer_nombre || ' ' || rcliente.primer_apellido);
                    OUT_BREAK;

                    SELECT SUM(m.cantidad) into cantMillas
                    FROM Historico_Milla m, Usuario u, Reservacion r, Pago p
                    WHERE u.id = p.fk_usuario
                        AND r.id = p.fk_reservacion
                        AND m.fk_reservacion_vuelo = r.id;

                    IF (cantMillas >= costo) THEN
                        opciones := 4;
                    END IF;

                    metodo := ROUND(DBMS_RANDOM.VALUE(1,opciones));

                    CASE (metodo)
                        WHEN 1 THEN
                            tarjC := buscarTarjeta('CREDITO',idUsuario);

                            idPago := insertPago(costo, idUsuario, tarjC.id, rreservacion.id);

                            OUT_(4, 'Método de pago: CREDITO - Pagado (dólares): ' || costo);
                            OUT_BREAK;
                            OUT_(0,'-----------------------------------------------------------------------');
                            OUT_BREAK;

                        WHEN 2 THEN
                            tarjD := buscarTarjeta('DEBITO',idUsuario);
                            
                            idPago := insertPago(costo, idUsuario, tarjD.id, rreservacion.id);

                            OUT_(4, 'Método de pago: DEBITO - Pagado (dólares): ' || costo);
                            OUT_BREAK;
                            OUT_(0,'-----------------------------------------------------------------------');
                            OUT_BREAK;

                        WHEN 3 THEN
                            tarjC := buscarTarjeta('CREDITO',idUsuario);
                            tarjD := buscarTarjeta('DEBITO',idUsuario);

                            porcentaje := DBMS_RANDOM.VALUE(0.1,0.9);
                            costoC := ROUND(costo * porcentaje, 2);
                            costoD := costo - costoC;

                            idPago := insertPago(costoC, idUsuario, tarjC.id, rreservacion.id);
                            idPago := insertPago(costoD, idUsuario, tarjD.id, rreservacion.id);

                            OUT_(4, 'Método de pago: CREDITO - Pagado (dólares): ' || costoC);
                            OUT_(4, 'Método de pago: DEBITO - Pagado (dólares): ' || costoD);
                            OUT_BREAK;
                            OUT_(0,'-----------------------------------------------------------------------');
                            OUT_BREAK;

                        WHEN 4 THEN
                            idPago := insertPago(costo, idUsuario, NULL, rreservacion.id);

                            INSERT INTO Historico_Milla (fk_pago,cantidad,fecha)
                                VALUES (
                                    idPago,
                                    costo,
                                    rreservacion.fecha_reservacion);

                            OUT_(4, 'Método de pago: Millas - Pagado (millas): ' || costoC);
                            OUT_BREAK;
                            OUT_(0,'-----------------------------------------------------------------------');
                            OUT_BREAK;

                    END CASE;

                    FETCH ccliente INTO rcliente;
                END LOOP;

            CLOSE ccliente;
            FETCH creservacion INTO rreservacion;
        END LOOP;

    CLOSE creservacion;
END;

CREATE OR REPLACE FUNCTION insertPago (costo IN NUMBER, idUsuario IN NUMBER, idTarjeta IN NUMBER, idReservacion IN NUMBER) RETURN NUMBER
IS 
    idPago NUMBER;
BEGIN
    INSERT INTO Pago (pagado,fk_usuario,fk_tarjeta,fk_reservacion)
        VALUES (
            UNIDAD('DIVISA', 'DOLAR', costo),
            idUsuario,
            idTarjeta,
            idReservacion)
        RETURNING id INTO idPago;
    
    RETURN idPago;
END;

CREATE OR REPLACE FUNCTION buscarTarjeta (tipoTarjeta IN VARCHAR2, idUsuario IN NUMBER) RETURN Tarjeta%ROWTYPE
IS 
    tarj Tarjeta%ROWTYPE;
BEGIN
    SELECT * INTO tarj FROM Tarjeta 
    WHERE tipo = tipoTarjeta
        AND fk_usuario = idUsuario;

    RETURN tarj;
END;