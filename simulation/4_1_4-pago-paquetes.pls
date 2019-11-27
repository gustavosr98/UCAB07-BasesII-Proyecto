CREATE OR REPLACE PROCEDURE sim_cerrar_pago-paquetes(fechas_base IN PERIODO, idReservacion IN NUMBER)
IS
    costo NUMBER;
    metodo NUMBER;
BEGIN
    SELECT SUM(precio_total) INTO costo 
    FROM Reservacion
    WHERE id = idReservacion
        OR fk_reservacion = idReservacion;

    metodo := ROUND(DBMS_RANDOM.VALUE(1,4));

END;

