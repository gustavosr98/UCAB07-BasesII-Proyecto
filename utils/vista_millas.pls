CREATE VIEW Vista_Millas AS 
    SELECT u.id as id_usuario, (suma.cantidad - resta.cantidad) as millas_disponibles 
    FROM Usuario u, 
        (SELECT u.id idUsuario, SUM(hm.cantidad) cantidad
            FROM Usuario u, Pago p, Reservacion r, Historico_Milla hm 
            WHERE p.fk_usuario = u.id
                AND p.fk_reservacion = r.id
                AND hm.fk_reservacion = r.id
                AND r.tipo = 'V'
                AND r.fk_reservacion IS NULL
            GROUP BY idUsuario, cantidad) suma,
        (SELECT u.id idUsuario, SUM(hm.cantidad) cantidad
            FROM Usuario u, Pago p, Historico_Milla hm
            WHERE p.fk_usuario = u.id
                AND hm.fk_pago = p.id
            GROUP BY idUsuario, cantidad) resta
    WHERE  u.id = suma.idUsuario
        AND u.id = resta.idUsuario;

