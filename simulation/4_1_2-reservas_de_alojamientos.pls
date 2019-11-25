CREATE OR REPLACE PROCEDURE sim_reservas_de_alojamientos()
IS
    cant_usuarios_con_reservaciones_de_vuelo NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;

    cant_alojamientos NUMBER;
    tipo_alojamiento_a_reservar VARCHAR2(20);
    criterio NUMBER;    
    id_alojamiento_a_reservar NUMBER;

BEGIN

    --  Usuarios que tienen reservaciones de vuelo no iniciado

        SELECT COUNT(*) INTO cant_usuarios_con_reservaciones_de_vuelo
        FROM Usuario u, Cliente c, Reserva rva, Reservacion ron, Vuelo v
        WHERE u.fk_cliente = c.id
        AND rva.fk_cliente = c.id
        AND rva.fk_reservacion = ron.id
        AND ron.tipo = 'V'
        AND ron.fk_vuelo = v.id
        AND v.estatus = 'NO_INICIADO';

    --  Random de usuarios a reservar

        cant_usuarios_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios_con_reservaciones_de_vuelo));

        BEGIN
        
            DBMS_OUTPUT.PUT_LINE(ROUND(DBMS_RANDOM.VALUE(1,2)));

        END;

    --  Se reserva la cantidad indicada

        FOR cant_usuarios_a_reservar IN 1..cant_usuarios_a_reservar LOOP

            --  Se elige un usuario random

                id_usuario_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios_con_reservaciones_de_vuelo));

            --  Se cuentan cuantos alojamientos hay

                SELECT COUNT(*) INTO cant_alojamientos
                FROM alojamientos;

            -- Se elige TIPO de alojamiento random

                if ROUND(DBMS_RANDOM.VALUE(1,2)) = 1 THEN

                    tipo_alojamiento_a_reservar := 'HOTEL';

                ELSE

                    tipo_alojamiento_a_reservar := 'APARTAMENTO';

                END IF;           

            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

                CASE [criterio]

                    WHEN criterio = 1 THEN

                    WHEN criterio = 2 THEN

                END;

        END LOOP;

    
END;

select count(*) from vehiculo