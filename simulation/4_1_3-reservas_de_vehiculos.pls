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

    ini_alquiler TIMESTAMP;
    fin_alquiler TIMESTAMP;
    criterio NUMBER;

    alquiler varchar2(10);
    id_vehiculo NUMBER;
    precio_vehiculo UNIDAD;
    condi NUMBER;
    año_mas_reciente NUMBER;

    id_calle_destino NUMBER;
    id_ciudad_destino NUMBER;
    id_estado_destino NUMBER;
    id_pais_destino NUMBER;

    id_sucursal_ini NUMBER;
    fk_lugar_sucu_ini NUMBER;
    id_sucursal_fin NUMBER;
    fk_lugar_sucu_fin NUMBER;
    booly BOOLEAN;

    p PERIODO;

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
                fin_alquiler := fin_alquiler + INTERVAL '11' HOUR;

                p := PERIODO(
                ini_alquiler,
                fin_alquiler
                );

            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

            -- Se elige un vehiculo en función del criterio elegido

                if criterio = 1 THEN  -- Más barato

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'C';

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
                                    WHERE NOT EXISTS (SELECT r.id 
                                                    FROM reservacion r
                                                    WHERE r.c_periodo.fecha_inicio < ini_alquiler
                                                    AND r.c_periodo.fecha_fin > fin_alquiler
                                                    AND r.c_fk_vehiculo = v.id) 

                                    ORDER BY v.precio_por_dia.cantidad ASC, DBMS_RANDOM.VALUE ) tabla
                            WHERE ROWNUM = 1;

                        END IF;

                ELSIF criterio = 2 THEN  -- Más actual

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'C';

                        if condi = 0 THEN

                            SELECT MAX(mv.año) into año_mas_reciente 
                            FROM vehiculo v, modelo_vehiculo mv
                            WHERE v.fk_modelo_vehiculo = mv.id;

                            SELECT tabla.idVeh, tabla.precioVeh INTO id_vehiculo, precio_vehiculo
                            FROM (SELECT  v.id as idVeh, v.precio_por_dia as precioVeh
                                FROM vehiculo v, modelo_vehiculo mv
                                WHERE v.fk_modelo_vehiculo = mv.id
                                AND mv.año= año_mas_reciente
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                            WHERE ROWNUM = 1;

                        ELSE 
                    
                            SELECT MAX(mv.año) into año_mas_reciente 
                            FROM vehiculo v, modelo_vehiculo mv
                            WHERE v.fk_modelo_vehiculo = mv.id;

                            SELECT tabla.idVeh, tabla.precioVeh INTO id_vehiculo, precio_vehiculo
                            FROM (SELECT  v.id as idVeh, v.precio_por_dia as precioVeh
                                FROM vehiculo v, modelo_vehiculo mv
                                WHERE v.fk_modelo_vehiculo = mv.id
                                AND mv.año= año_mas_reciente

                                AND NOT EXISTS (SELECT r.id 
                                                FROM reservacion r
                                                WHERE r.c_periodo.fecha_inicio < ini_alquiler
                                                AND r.c_periodo.fecha_fin > fin_alquiler
                                                AND r.c_fk_vehiculo = v.id)
                                
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                            WHERE ROWNUM =1;

                        END IF;

                END IF;

                -- Se guarda el lugar de destino

                    -- calle
                
                        SELECT a.fk_lugar INTO id_calle_destino
                        FROM trayecto t, aeropuerto a, vuelo v, lugar l
                        WHERE v.fk_trayecto = t.id
                        AND t.FK_AEROPUERTO_DESTINO = a.id
                        AND a.fk_lugar = l.id
                        AND v.id = id_vuelo_no_iniciado;   

                    -- ciudad

                        SELECT FK_LUGAR INTO id_ciudad_destino
                        FROM LUGAR 
                        WHERE ID = id_calle_destino;

                    -- estado

                        SELECT FK_LUGAR INTO id_estado_destino
                        FROM LUGAR 
                        WHERE ID = id_ciudad_destino;

                    -- pais

                        SELECT FK_LUGAR INTO id_pais_destino
                        FROM LUGAR 
                        WHERE ID = id_estado_destino;

                -- Se guarda el id de la sucursal de inicio

                    booly := FALSE;

                    WHILE booly = FALSE
                    LOOP
                    
                        SELECT tabla.id, tabla.fk_lugar INTO id_sucursal_ini, fk_lugar_sucu_ini  
                        FROM (SELECT s.id, s.fk_lugar           --hay que hacer que la calle de la sucursal pertenezca al pais de destino 
                                FROM sucursal s, lugar l
                                WHERE s.fk_lugar = l.id
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                        WHERE ROWNUM = 1;

                        booly := es_mismo_pais(fk_lugar_sucu_ini,id_pais_destino);

                    END LOOP;

                -- Se guarda el id de la sucursal de fin

                    booly := FALSE;

                    WHILE booly = FALSE
                    LOOP
                    
                        SELECT tabla.id, tabla.fk_lugar INTO id_sucursal_fin, fk_lugar_sucu_fin  
                        FROM (SELECT s.id, s.fk_lugar           --hay que hacer que la calle de la sucursal pertenezca al pais de destino 
                                FROM sucursal s, lugar l
                                WHERE s.fk_lugar = l.id
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                        WHERE ROWNUM = 1;

                        booly := es_mismo_pais(fk_lugar_sucu_fin,id_pais_destino);

                    END LOOP;                    

                --  AGREGACION DE RESERVAS DE VEHICULOS | PASO 6
                -- Se inserta la reservacion

                    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion,FK_RESERVACION, c_fk_vehiculo, c_fk_sucursal_inicio,c_fk_sucursal_fin,c_periodo) 
                    VALUES('C',
                            get_precio_total(ini_alquiler,fin_alquiler,precio_vehiculo),
                            'F',
                            fecha_reservacion_vuelo,
                            id_reservacion_vuelo,
                            id_vehiculo,
                            id_sucursal_ini,
                            id_sucursal_fin,
                            p
                            );

        END LOOP;

END;

CREATE OR REPLACE FUNCTION es_mismo_pais(id_calle NUMBER, id_pais NUMBER )
RETURN BOOLEAN
IS

    booly BOOLEAN := FALSE;
    fk NUMBER;

BEGIN

-- ciudad

    SELECT FK_LUGAR INTO fk
    FROM LUGAR 
    WHERE ID = id_calle;

-- estado

    SELECT FK_LUGAR INTO fk
    FROM LUGAR 
    WHERE ID = fk;

-- pais

    SELECT FK_LUGAR INTO fk
    FROM LUGAR 
    WHERE ID = fk;

    IF fk = id_pais THEN
        booly := TRUE;
    END IF;
    
    RETURN booly;

END;

SELECT ID,FK_AEROPUERTO_ORIGEN,FK_AEROPUERTO_DESTINO FROM TRAYECTO

SELECT id,nombre, fk_lugar,tipo FROM LUGAR WHERE TIPO = 'CALLE';
SELECT id,nombre, fk_lugar,tipo FROM LUGAR WHERE TIPO = 'CIUDAD' AND ID = 9901;
SELECT id,nombre, fk_lugar,tipo FROM LUGAR WHERE TIPO = 'ESTADO' AND ID = 4527;
SELECT id,nombre, fk_lugar,tipo FROM LUGAR WHERE TIPO = 'PAIS' AND ID = 232;

BEGIN

    sim_reservas_de_vehiculos;
    --DBMS_OUTPUT.PUT_LINE(sys.diutil.bool_to_int(es_mismo_pais(11000,232)));

END;

SELECT ID FROM RESERVACION WHERE TIPO = 'C'

SELECT V.ID
FROM VUELO V, TRAYECTO T, AEROPUERTO A, LUGAR L
WHERE V.FK_TRAYECTO = T.ID 
AND T.FK_AEROPUERTO_ORIGEN = A.ID
AND T.FK_AEROPUERTO_DESTINO = A.ID
AND A.FK_LUGAR = L.ID
AND ID = 47;

DELETE FROM SUCURSAL;