CREATE OR REPLACE PROCEDURE sim_reservas_de_alojamientos()
IS
    cant_usuarios_con_reservaciones_de_vuelo NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;
    id_vuelo_no_iniciado NUMBER;

    cant_alojamientos NUMBER;
    tipo_alojamiento_a_reservar VARCHAR2(20);
    fecha_llegada_vuelo TIMESTAMP;
    criterio NUMBER;    
    alojamiento_a_reservar habitacion%ROWTYPE;

BEGIN

    --  Usuarios que tienen reservaciones de vuelo no iniciado

        SELECT COUNT(*) --INTO cant_usuarios_con_reservaciones_de_vuelo
        FROM Usuario u, Cliente c, Reserva rva, Reservacion ron, Vuelo v
        WHERE u.fk_cliente = c.id
        AND rva.fk_cliente = c.id
        AND rva.fk_reservacion = ron.id
        AND ron.tipo = 'V'
        AND ron.v_fk_vuelo = v.id
        AND v.estatus = 'NO_INICIADO';

    --  Random de usuarios a reservar

        cant_usuarios_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios_con_reservaciones_de_vuelo));

        BEGIN
        
            DBMS_OUTPUT.PUT_LINE(ROUND(DBMS_RANDOM.VALUE(1,2)));

        END;

    --  Se reserva la cantidad indicada

        FOR cant_usuarios_a_reservar IN 1..cant_usuarios_a_reservar LOOP

            --  Se elige un usuario random

                SELECT * INTO id_usuario_a_reservar
                FROM (SELECT u.id 
                        FROM Usuario u, Cliente c, Reserva rva, Reservacion ron, Vuelo v
                        WHERE u.fk_cliente = c.id
                        AND rva.fk_cliente = c.id
                        AND rva.fk_reservacion = ron.id
                        AND ron.tipo = 'V'
                        AND ron.v_fk_vuelo = v.id
                        AND v.estatus = 'NO_INICIADO'
                        ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;

            -- Se elige un vuelo random

                SELECT * INTO id_vuelo_no_iniciado
                FROM (SELECT v.id 
                        FROM Usuario u, Cliente c, Reserva rva, Reservacion ron, Vuelo v
                        WHERE u.fk_cliente = c.id
                        AND rva.fk_cliente = c.id
                        AND rva.fk_reservacion = ron.id
                        AND ron.tipo = 'V'
                        AND ron.v_fk_vuelo = v.id
                        AND v.estatus = 'NO_INICIADO'
                        ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;

           --  Se cuentan cuantos alojamientos hay

                SELECT COUNT(*) INTO cant_alojamientos
                FROM alojamientos;

            -- Se elige TIPO de alojamiento random

                SELECT * INTO tipo_alojamiento_a_reservar
                FROM (SELECT a.tipo
                        FROM alojamiento a
                        ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;
                
            --  Se guarda la fecha de llegada del vuelo

                SELECT v.periodo_estimado.fecha_fin INTO fecha_llegada_vuelo
                FROM vuelo v
                WHERE v.id = id_vuelo_no_iniciado;

            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

                CASE [criterio]

                    WHEN criterio = 1 THEN  -- Más barato

                        SELECT * INTO alojamiento_a_reservar 
                        FROM (SELECT h.id, h.precio_base_noche.cantidad
                                FROM alojamiento a, lug_aloj la, habitacion h, reservacion r
                                WHERE a.tipo = tipo_alojamiento_a_reservar
                                AND la.fk_alojamiento = a.id
                                AND h.fk_lug_aloj = la.id
                                AND r.a_fk_habitacion = h.id
                                -- valida fecha
                                AND NOT EXISTS (SELECT r.id 
                                                FROM reservacion r
                                                WHERE r.a_periodo.fecha_inicio < fecha_llegada_vuelo
                                                AND r.a_periodo.fecha_fin > fecha_llegada_vuelo)

                                ORDER BY h.precio_base_noche.cantidad ASC)
                        WHERE ROWNUM = 1;

                        DBMS_OUTPUT.PUT_LINE(alojamiento_a_reservar.id);

                    WHEN criterio = 2 THEN  -- Más actual

                        SELECT * INTO alojamiento_a_reservar 
                        FROM (SELECT TO_CHAR(a.fecha_fundacion, 'DD-MM-YYYY'), h.id, h.precio_base_noche.cantidad
                                FROM alojamiento a, lug_aloj la, habitacion h
                                WHERE a.tipo = tipo_alojamiento_a_reservar
                                AND la.fk_alojamiento = a.id
                                AND h.fk_lug_aloj = la.id
                                ORDER BY a.fecha_fundacion DESC)
                        WHERE ROWNUM = 1;

                END;

                -- Se inserta la reservacion

        END LOOP;

    
END;