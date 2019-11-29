CREATE OR REPLACE PROCEDURE sim_reservas_de_vehiculos
IS
    cant_usuarios_con_reservaciones_de_vuelo NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;
    id_vuelo_no_iniciado NUMBER;
    id_reservacion_vuelo NUMBER;
    fecha_llegada_vuelo TIMESTAMP;
    fecha_reservacion_vuelo TIMESTAMP;
    fecha_base TIMESTAMP;

    alquiler varchar2(10);
    id_vehiculo NUMBER;
    precio_vehiculo NUMBER;
    condi NUMBER;
    fecha_max TIMESTAMP;

    id_calle_destino TIMESTAMP;
    id_ciudad_destino TIMESTAMP;
    id_estado_destino TIMESTAMP;
    id_pais_destino TIMESTAMP;

BEGIN
   
    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Usuarios que tienen reservaciones de vuelo no iniciado

        SELECT COUNT(*) INTO cant_usuarios_con_reservaciones_de_vuelo
        FROM usuario u, pago p, reservacion r, vuelo v
        WHERE p.fk_usuario = u.id
        AND p.fk_reservacion = r.id
        AND r.v_fk_vuelo = v.id
        AND v.estatus = 'NO_INICIADO'; 

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Random de usuarios a reservar

        cant_usuarios_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios_con_reservaciones_de_vuelo));

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Se reserva la cantidad indicada

        FOR i IN 1..cant_usuarios_a_reservar LOOP

                --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 2
                --  Se elige un usuario random

            SELECT tabla.idu, tabla.idv, tabla.idr INTO id_usuario_a_reservar, id_vuelo_no_iniciado, id_reservacion_vuelo
            FROM (SELECT u.id idu, v.id idv, r.id idr
                    FROM usuario u, pago p, reservacion r, vuelo v
                    WHERE p.fk_usuario = u.id
                    AND p.fk_reservacion = r.id
                    AND r.v_fk_vuelo = v.id
                    AND v.estatus = 'NO_INICIADO'
                    ORDER BY DBMS_RANDOM.VALUE) tabla
            WHERE ROWNUM = 1;

            --  Se guarda la fecha de llegada del vuelo

                SELECT v.periodo_estimado.fecha_fin INTO fecha_llegada_vuelo
                FROM vuelo v
                WHERE v.id = id_vuelo_no_iniciado;

            -- Se guarda la fecha de reservacion del vuelo

                SELECT FECHA_RESERVACION INTO fecha_reservacion_vuelo
                FROM reservacion r 
                WHERE id = id_reservacion_vuelo;

            -- Se elige el periodo de reserva del vehiculo

                fecha_base := TIEMPO_PKG.EXTRAER(fecha_llegada_vuelo,'DATE');
                alquiler := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1,10)));

                ini_alquiler := fecha_base + INTERVAL '13' HOUR;
                fin_alquiler := fecha_base + numToDSInterval(alquiler,'DAY');
                fin_alquiler := fin_estadia + INTERVAL '11' HOUR;

                p := PERIODO(
                ini_alquiler,
                fin_alquiler
                );

            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

            -- Se elige un vehiculo en función del criterio elegido

                if criterio = 1 THEN  -- Más barato

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'V';

                        if condi = 0 THEN

                            SELECT tabla.idVeh, tabla.precioVeh INTO id_vehiculo, precio_vehiculo
                            FROM (SELECT  v.id as idVeh, v.precio_por_dia as precioVeh
                                FROM vehiculo v
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                                WHERE ROWNUM = 1;

                        ELSE

                            SELECT tabla.idVeh, tabla.precioVeh INTO id_vehiculo, precio_vehiculo
                            FROM (SELECT  v.id as idVeh, v.precio_por_dia as precioVeh
                                    FROM vehiculo v
                                    -- valida fecha
                                    AND NOT EXISTS (SELECT r.id 
                                                    FROM reservacion r
                                                    WHERE r.c_periodo.fecha_inicio < ini_alquiler
                                                    AND r.c_periodo.fecha_fin > fin_alquiler
                                                    AND r.c_fk_vehiculo = v.id) 

                                    ORDER BY v.precio_por_dia.cantidad ASC, DBMS_RANDOM.VALUE ) tabla
                            WHERE ROWNUM = 1;

                        END IF;

                ELSIF criterio = 2 THEN  -- Más actual

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'V';

                        if condi = 0 THEN

                            SELECT MAX(mv.año) into fecha_max 
                            FROM vehiculo v, modelo_vehiculo mv
                            WHERE v.fk_modelo_vehiculo = mv.id;

                            SELECT tabla.idVeh, tabla.precioVeh INTO id_vehiculo, precio_vehiculo
                            FROM (SELECT  v.id as idVeh, v.precio_por_dia as precioVeh
                                FROM vehiculo v, modelo_vehiculo mv
                                WHERE v.fk_modelo_vehiculo = mv.id
                                AND mv.año= fecha_max
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                            WHERE ROWNUM = 1;

                        ELSE 
                    
                            SELECT MAX(mv.año) into fecha_max 
                            FROM vehiculo v, modelo_vehiculo mv
                            WHERE v.fk_modelo_vehiculo = mv.id;

                            SELECT tabla.idVeh, tabla.precioVeh INTO id_vehiculo, precio_vehiculo
                            FROM (SELECT  v.id as idVeh, v.precio_por_dia as precioVeh
                                FROM vehiculo v, modelo_vehiculo mv
                                WHERE v.fk_modelo_vehiculo = mv.id
                                AND mv.año= fecha_max

                                AND NOT EXISTS (SELECT r.id 
                                                FROM reservacion r
                                                WHERE r.c_periodo.fecha_inicio < ini_alquiler
                                                AND r.c_periodo.fecha_fin > fin_alquiler
                                                AND r.c_fk_habitacion = v.id)
                                
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                            WHERE ROWNUM =1;

                        END IF;

                END IF;

                -- Se guarda el lugar de destino

                    -- calle
                
                        SELECT a.fk_lugar, l.nombre INTO id_calle_destino
                        FROM trayecto t, aeropuerto a, vuelo v, lugar l
                        WHERE v.fk_trayecto = t.id
                        AND t.FK_AEROPUERTO_DESTINO = a.id
                        AND a.fk_lugar = l.id
                        AND v.id = 20;

                    -- ciudad

                        SELECT FK_LUGAR INTO id_ciudad_destino
                        FROM LUGAR 
                        WHERE ID = id_calle_destino;

                    -- estado

                        SELECT FK_LUGAR INTO id_estado_destino
                        FROM LUGAR 
                        WHERE ID = 2;

                    -- pais

                        SELECT FK_LUGAR INTO id_pais_destino
                        FROM LUGAR 
                        WHERE ID = id_estado_destino;

                -- Se guarda el id de la sucursal de inicio

                    SELECT * FROM (SELECT id            --hay que hacer que la calle de la sucursal pertenezca al pais de destino 
                                    FROM sucursal
                                    WHERE fk_lugar = )

                -- Se guarda el id de la sucursal de fin



                --  AGREGACION DE RESERVAS DE VEHICULOS | PASO 6
                -- Se inserta la reservacion

                    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, c_fk_vehiculo, c_fk_sucursal_inicio,c_fk_sucursal_fin,c_periodo) 
                    VALUES('V',
                            get_precio_total(ini_alquiler,fin_alquiler,precio_vehiculo),
                            'F',
                            fecha_reservacion_vuelo,
                            id_vehiculo,
                            id_reservacion_vuelo,
                            p
                            );

        END LOOP;

END;

SELECT ID,FK_AEROPUERTO_ORIGEN,FK_AEROPUERTO_DESTINO FROM TRAYECTO