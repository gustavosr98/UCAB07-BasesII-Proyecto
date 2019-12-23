CREATE OR REPLACE PROCEDURE reporte9 (cursor9 OUT SYS_REFCURSOR, correoUsuario IN VARCHAR2, fechaInicio IN VARCHAR2, fechaFin IN VARCHAR2)
IS
    foto BLOB;
    nombre VARCHAR2(50);
    correo VARCHAR2(50);
    fechaEntrada VARCHAR2(100);
    fechaSalida VARCHAR2(100);
    huesped VARCHAR2(50);
    descripcion VARCHAR2(100);
    direccion VARCHAR2(100);
    puntuacion VARCHAR2(50);
    precio VARCHAR2(50);
BEGIN

    OPEN cursor9 FOR
    
    SELECT al.foto, al.nombre, u.correo, TIEMPO_PKG.PRINT(r.a_periodo.fecha_inicio,'HUMANO'),
        TIEMPO_PKG.PRINT(r.a_periodo.fecha_fin,'MUY_HUMANO'), h.capacidad || ' ' || 'persona(s)', 
        h.descripcion, getLugar(l.fk_lugar, 'COMPLETO'), r.a_puntuacion || '/10', 
        ROUND(r.precio_total.cantidad, 2) || ' ' || getMoneda(r.precio_total.nombre)
        INTO foto, nombre, correo, fechaEntrada, fechaSalida, huesped, descripcion, direccion, puntuacion, precio
    FROM Habitacion h, Reservacion r, Reserva s, Cliente cl, Usuario u, Alojamiento al, Lug_Aloj la, Lugar l
    WHERE u.fk_cliente = cl.id
        AND cl.id = s.fk_cliente
        AND r.id = s.fk_reservacion
        AND r.a_fk_habitacion = h.id
        AND h.fk_lug_aloj = la.id
        AND la.fk_alojamiento = al.id
        AND la.fk_lugar = l.id
        AND u.correo = correoUsuario
        AND TIEMPO_PKG.PRINT(r.a_periodo.fecha_inicio,'FECHA_MM') = TIEMPO_PKG.PRINT(fechaInicio,'FECHA_MM')
        AND TIEMPO_PKG.PRINT(r.a_periodo.fecha_fin,'FECHA_MM') = TIEMPO_PKG.PRINT(fechaFin,'FECHA_MM')

END;