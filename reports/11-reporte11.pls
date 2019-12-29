CREATE OR REPLACE PROCEDURE reporte11 (cursor11 OUT SYS_REFCURSOR, correoUsuario IN VARCHAR2 DEFAULT '', fechaInicio IN VARCHAR2, fechaFin IN VARCHAR2)
IS
    foto BLOB;
    marcaModelo VARCHAR2(50);
    proveedor BLOB;
    correo VARCHAR2(50);
    direccionI VARCHAR2(100);
    direccionF VARCHAR2(100);
    fechaI VARCHAR2(100);
    fechaF VARCHAR2(100);
    precioDia VARCHAR2(50);
    precioTotal VARCHAR2(50);
BEGIN

    OPEN cursor11 FOR
    
    SELECT mv.foto, mv.marca || ' ' || mv.nombre, pv.logo, u.correo, getLugar(lOrigen.fk_lugar, 'COMPLETO'),
        getLugar(lLlegada.fk_lugar, 'COMPLETO'), TIEMPO_PKG.PRINT(r.a_periodo.fecha_inicio,'HUMANO'),
        TIEMPO_PKG.PRINT(r.a_periodo.fecha_fin,'HUMANO'), ROUND(v.precio_por_dia.cantidad, 2) || ' ' || getMoneda(v.precio_por_dia.nombre),
        ROUND(r.precio_total.cantidad, 2) || ' ' || getMoneda(r.precio_total.nombre)
        INTO foto, marcaModelo, proveedor, correo, direccionI, direccionF, fechaI, fechaF, precioDia, precioTotal
    FROM Vehiculo v, Reservacion r, Reserva s, Cliente cl, Usuario u, Modelo_Vehiculo mv, Proveedor_Vehiculo pv, 
        Sucursal sOrigen, Sucursal sLlegada, Lugar lOrigen, Lugar lLlegada
    WHERE u.fk_cliente = cl.id
        AND cl.id = s.fk_cliente
        AND r.id = s.fk_reservacion
        AND r.c_fk_vehiculo = v.id
        AND v.fk_modelo_vehiculo = mv.id
        AND v.fk_proveedor_vehiculo = pv.id
        AND r.c_fk_sucursal_inicio = sOrigen.id
        AND sOrigen.fk_lugar = lOrigen.id
        AND r.c_fk_sucursal_fin = sLlegada.id
        AND sLlegada.fk_lugar = lLlegada.id
        AND u.correo LIKE '%' || correoUsuario || '%'
        AND TIEMPO_PKG.PRINT(r.c_periodo.fecha_inicio,'FECHA_MM') = TIEMPO_PKG.PRINT(fechaInicio,'FECHA_MM')
        AND TIEMPO_PKG.PRINT(r.c_periodo.fecha_fin,'FECHA_MM') = TIEMPO_PKG.PRINT(fechaFin,'FECHA_MM');

END;