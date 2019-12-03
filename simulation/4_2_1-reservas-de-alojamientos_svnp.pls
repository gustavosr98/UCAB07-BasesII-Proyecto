CREATE OR REPLACE PROCEDURE sim_reservas_de_alojamientos_svnp(rango PERIODO)
IS
    id_reservacion_vuelo NUMBER;
    cant_usuarios NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;
    id_vuelo_no_iniciado NUMBER;

    cant_alojamientos NUMBER;
    tipo_alojamiento_a_reservar VARCHAR2(20);
    fecha_base TIMESTAMP;
    fecha_llegada_vuelo TIMESTAMP;
    fecha_regreso TIMESTAMP;
    fecha_reservacion TIMESTAMP;
    criterio NUMBER;    
    alojamiento_a_reservar habitacion%ROWTYPE;

    id_habitacion NUMBER;
    precio_habitacion UNIDAD;

    ini_estadia TIMESTAMP;
    fin_estadia TIMESTAMP;
    estadia VARCHAR2(10);
    dif_dias NUMBER;
    i INTEGER;
    p PERIODO;
    condi NUMBER;
    disp BOOLEAN;

    fecha_max TIMESTAMP;

BEGIN

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS SVNP| PASO 1
    --  Cantidad de usuarios

			SELECT COUNT(*) INTO cant_usuarios
			FROM usuario u;

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS SVNP| PASO 1
    --  Random de usuarios a reservar

        cant_usuarios_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios));
    
    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Se reserva la cantidad indicada

        FOR i IN 1..cant_usuarios_a_reservar LOOP

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 2
            --  Se elige un usuario random

                SELECT tabla.idu
					INTO id_usuario_a_reservar
                FROM (
                    SELECT u.id idu
                    FROM usuario u
                    ORDER BY DBMS_RANDOM.VALUE
								) tabla
                WHERE ROWNUM = 1;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            -- Se elige TIPO de alojamiento random

                SELECT * INTO tipo_alojamiento_a_reservar
                FROM (
									SELECT a.tipo
                  FROM alojamiento a
                  ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;
                
            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            -- Se elige el periodo de reserva del alojamiento

                fecha_reservacion := TIEMPO_PKG.random(rango);

                fecha_base := TIMESTAMP '1000-01-01 00:00:00';

                while fecha_base < fecha_reservacion LOOP
                    OUT_(1,'while 1');
                    fecha_base := TIEMPO_PKG.random(rango);

                END LOOP;

                fecha_regreso := TIMESTAMP '1000-01-01 00:00:00';

                while fecha_regreso < fecha_base LOOP
                   
                    OUT_(1,'while 2');
                    fecha_regreso := TIEMPO_PKG.random(rango);

                END LOOP;

                fecha_regreso := TIEMPO_PKG.EXTRAER(fecha_regreso,'DATE');

                dif_dias := TIEMPO_PKG.DIFF(rango.fecha_inicio,rango.fecha_fin,'DAY')/2;

                estadia := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1,dif_dias)));

                ini_estadia := fecha_base + INTERVAL '13' HOUR;
                fin_estadia := fecha_base + numToDSInterval(estadia,'DAY');
                fin_estadia := fin_estadia + INTERVAL '11' HOUR;

                p := PERIODO(
                    ini_estadia,
                    fin_estadia
                );

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 4
            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 5
            -- Se elige un alojamiento en función del criterio elegido

                if criterio = 1 THEN  -- Más barato

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'A';

                        if condi = 0 THEN

                            disp := FALSE;

                            while disp = FALSE
                            LOOP
                                SELECT tabla.idHab, tabla.precioHab INTO id_habitacion, precio_habitacion
                                FROM (SELECT  h.id as idHab, h.precio_base_noche as precioHab
                                    FROM alojamiento al, lug_aloj la, habitacion h
                                    WHERE al.tipo = tipo_alojamiento_a_reservar
                                    AND la.fk_alojamiento = al.id
                                    AND h.fk_lug_aloj = la.id
                                    ORDER BY DBMS_RANDOM.VALUE) tabla
                                    WHERE ROWNUM = 1;

                                disp := hab_esta_disponible(alojamiento_a_reservar.id);
                            END LOOP;

                        ELSE

                            SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                            FROM (
															SELECT  h.id as idHab, h.precio_base_noche as precioHab
															FROM alojamiento a, lug_aloj la, habitacion h
															WHERE a.tipo = tipo_alojamiento_a_reservar
																AND la.fk_alojamiento = a.id
																AND h.fk_lug_aloj = la.id
																-- valida fecha
																AND NOT EXISTS (
																	SELECT r.id 
																	FROM reservacion r
																	WHERE r.a_periodo.fecha_inicio < ini_estadia
																		AND r.a_periodo.fecha_fin > fin_estadia
																		AND r.a_fk_habitacion = h.id
																) 
															ORDER BY h.precio_base_noche.cantidad ASC, DBMS_RANDOM.VALUE ) tabla
                            WHERE ROWNUM = 1;

                        END IF;

                ELSIF criterio = 2 THEN  -- Más actual

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'A';

                        IF condi = 0 THEN

                            SELECT  MAX(alo.fecha_fundacion) into fecha_max 
                            FROM alojamiento alo, lug_aloj la, habitacion h
                            WHERE alo.tipo = tipo_alojamiento_a_reservar
                            AND la.fk_alojamiento = alo.id
                            AND h.fk_lug_aloj = la.id;

                            SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                            FROM (
															SELECT  h.id as idHab, h.precio_base_noche as precioHab 
															FROM alojamiento alo, lug_aloj la, habitacion h
															WHERE alo.tipo = tipo_alojamiento_a_reservar
																AND la.fk_alojamiento = alo.id
																AND h.fk_lug_aloj = la.id
																AND alo.fecha_fundacion = fecha_max
																ORDER BY DBMS_RANDOM.VALUE
														) tabla
                            WHERE ROWNUM =1;

                        ELSE 
                    
                            SELECT  MAX(alo.fecha_fundacion) into fecha_max 
                                FROM alojamiento alo, lug_aloj la, habitacion h
                                WHERE alo.tipo = tipo_alojamiento_a_reservar
                                AND la.fk_alojamiento = alo.id
                                AND h.fk_lug_aloj = la.id;

                                SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                                FROM (
																	SELECT  h.id as idHab, h.precio_base_noche as precioHab   
																	FROM alojamiento alo, lug_aloj la, habitacion h
																	WHERE alo.tipo = tipo_alojamiento_a_reservar
																		AND la.fk_alojamiento = alo.id
																		AND h.fk_lug_aloj = la.id
																		AND alo.fecha_fundacion = fecha_max
																		AND NOT EXISTS (
																			SELECT r.id 
																			FROM reservacion r
																			WHERE r.a_periodo.fecha_inicio < ini_estadia
																				AND r.a_periodo.fecha_fin > fin_estadia
																				AND r.a_fk_habitacion = h.id
																		)
																	ORDER BY DBMS_RANDOM.VALUE) tabla
                                WHERE ROWNUM =1;

                        END IF;

                END IF;

                --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 6
                -- Se inserta la reservacion

                    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, a_fk_habitacion, a_periodo,fk_reservacion) 
                    VALUES('A',
                            get_precio_total(ini_estadia,fin_estadia,precio_habitacion),
                            'F',
                            fecha_reservacion,
                            id_habitacion,
                            p,
                            id_reservacion_vuelo
                            );

        END LOOP;   

END;

-- EJECUCION
BEGIN
    sim_reservas_de_alojamientos_svnp(PERIODO(
        TIMESTAMP '2019-05-19 11:24:50',
        TIMESTAMP '2020-05-26 06:47:15'
    ));
END;

-- prueba
DECLARE
    fechi TIMESTAMP;
    fech TIMESTAMP;
BEGIN

    fechi := TIMESTAMP '2015-01-01 12:00:00';
    fech := TIMESTAMP '1000-01-01 00:00:00';

    while fech < fechi LOOP
        OUT_(1,'while 1');
        fech := TIEMPO_PKG.random(PERIODO(
        TIMESTAMP '2014-05-19 11:24:50',
        TIMESTAMP '2016-05-26 06:47:15'
    ));

    out_(1,fech);
    OUT_BREAK;

    END LOOP;

END;