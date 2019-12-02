CREATE OR REPLACE FUNCTION getMillasDisponibles (idU IN NUMBER) RETURN NUMBER
IS 
    millas_disponibles NUMBER;
BEGIN
    SELECT (suma.cantidad - resta.cantidad) INTO millas_disponibles 
    FROM Usuario u, 
        (SELECT u.id idUsuario, SUM(hm.cantidad) cantidad
            FROM Usuario u, Pago p, Reservacion r, Historico_Milla hm 
            WHERE p.fk_usuario = u.id
                AND p.fk_reservacion = r.id
                AND hm.fk_reservacion_vuelo = r.id
            GROUP BY u.id) suma,
        (SELECT u.id idUsuario, SUM(hm.cantidad) cantidad
            FROM Usuario u, Pago p, Historico_Milla hm
            WHERE p.fk_usuario = u.id
                AND hm.fk_pago = p.id
            GROUP BY u.id) resta
    WHERE  u.id = suma.idUsuario
        AND u.id = resta.idUsuario
        AND u.id = idU;

    RETURN millas_disponibles;
END; 

CREATE OR REPLACE VIEW Vista_Millas AS
    SELECT u.id as id_usuario, (suma.cantidad - resta.cantidad) as millas_disponibles 
    FROM Usuario u, 
        (SELECT u.id idUsuario, SUM(hm.cantidad) cantidad
            FROM Usuario u, Pago p, Reservacion r, Historico_Milla hm 
            WHERE p.fk_usuario = u.id
                AND p.fk_reservacion = r.id
                AND hm.fk_reservacion_vuelo = r.id
            GROUP BY u.id) suma,
        (SELECT u.id idUsuario, SUM(hm.cantidad) cantidad
            FROM Usuario u, Pago p, Historico_Milla hm
            WHERE p.fk_usuario = u.id
                AND hm.fk_pago = p.id
            GROUP BY u.id) resta
    WHERE  u.id = suma.idUsuario
        AND u.id = resta.idUsuario;
