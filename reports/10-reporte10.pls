CREATE OR REPLACE PROCEDURE reporte10 (cursor10 OUT SYS_REFCURSOR, lug IN VARCHAR2 DEFAULT '', fechaInicio IN TIMESTAMP, fechaFin IN TIMESTAMP)
IS
    foto BLOB;
    nombre VARCHAR2(50);
    fechaEntrada VARCHAR2(100);
    fechaSalida VARCHAR2(100);
    cantidad NUMBER;
    puntuacion VARCHAR2(50);
BEGIN

    OPEN cursor10 FOR
    
    SELECT al.foto, al.nombre, tabla.fInicio, tabla.fFin, tabla.cant, tabla.punt
        INTO foto, nombre, fechaEntrada, fechaSalida, cantidad, puntuacion
    FROM (
        SELECT al.id as alojamiento, TIEMPO_PKG.PRINT(r.a_periodo.fecha_inicio,'HUMANO') as fInicio,
            TIEMPO_PKG.PRINT(r.a_periodo.fecha_fin,'MUY_HUMANO') as fFin, COUNT(*) as cant, 
            promedioPuntuaciones(al.id) || '/10' as punt
        FROM Habitacion h, Reservacion r, Reserva s, Alojamiento al, Lug_Aloj la
        WHERE r.id = s.fk_reservacion
            AND r.a_fk_habitacion = h.id
            AND h.fk_lug_aloj = la.id
            AND la.fk_alojamiento = al.id
            AND TIEMPO_PKG.PRINT(r.a_periodo.fecha_inicio,'FECHA_MM') = TIEMPO_PKG.PRINT(fechaInicio,'FECHA_MM')
            AND TIEMPO_PKG.PRINT(r.a_periodo.fecha_fin,'FECHA_MM') = TIEMPO_PKG.PRINT(fechaFin,'FECHA_MM')
            AND al.nombre LIKE '%' || lug || '%'
            AND ROWNUM <= 1
        GROUP BY al.id, TIEMPO_PKG.PRINT(r.a_periodo.fecha_inicio,'HUMANO'),
            TIEMPO_PKG.PRINT(r.a_periodo.fecha_fin,'MUY_HUMANO'), promedioPuntuaciones(al.id) || '/10'
        ) tabla, Alojamiento al
    WHERE al.id = tabla.alojamiento
    ORDER BY tabla.cant DESC;

END;

CREATE OR REPLACE FUNCTION promedioPuntuaciones (idAloj IN NUMBER) RETURN NUMBER
IS 
    punt NUMBER;
    cant NUMBER;
BEGIN
    SELECT SUM(r.a_puntuacion), COUNT(r.id) INTO punt, cant
    FROM Reservacion r, Habitacion h, Lug_Aloj la
    WHERE r.a_fk_habitacion = h.id
        AND h.fk_lug_aloj = la.id
        AND la.fk_alojamiento = idAloj;

    punt := ROUND(punt/cant, 2);

    RETURN punt;
END;