CREATE OR REPLACE PROCEDURE sim_reservas_de_alojamientos
IS
    id_reservacion_vuelo NUMBER;
    id_reservacion_alojamiento NUMBER;
    cant_usuarios_con_reservaciones_de_vuelo NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;
    id_vuelo_no_iniciado NUMBER;
    id_cliente NUMBER;
    id_trayecto_vuelo NUMBER;
    ciudad_llegada NUMBER;
    pais_llegada NUMBER;
    id_ciudad_destino NUMBER;

    cant_alojamientos NUMBER;
    tipo_alojamiento_a_reservar VARCHAR2(20);
    fecha_base TIMESTAMP;
    fecha_llegada_vuelo TIMESTAMP;
    fecha_regreso TIMESTAMP;
    fecha_reservacion_vuelo TIMESTAMP;
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

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Usuarios que tienen reservaciones de vuelo no iniciado

			SELECT COUNT(*) INTO cant_usuarios_con_reservaciones_de_vuelo
			FROM usuario u, reserva res, cliente cl, reservacion r, vuelo v
			WHERE 
				r.v_fk_vuelo = v.id
				AND res.fk_reservacion = r.id
				AND res.fk_cliente = cl.id
				AND u.fk_cliente = cl.id
				AND v.estatus = 'NO_INICIADO'; 

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Random de usuarios a reservar

        cant_usuarios_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios_con_reservaciones_de_vuelo));

    --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 1
    --  Se reserva la cantidad indicada

        FOR i IN 1..cant_usuarios_a_reservar LOOP

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 2
            --  Se elige un usuario random

                SELECT tabla.idcl, tabla.idu, tabla.idv, tabla.idr 
					INTO id_cliente, id_usuario_a_reservar, id_vuelo_no_iniciado, id_reservacion_vuelo
                FROM (
                    SELECT cl.id idcl, u.id idu, v.id idv, r.id idr
                    FROM usuario u, reserva res, cliente cl, reservacion r, vuelo v
                    WHERE 
                        res.fk_reservacion = r.id
                        AND res.fk_cliente = cl.id
                        AND u.fk_cliente = cl.id
                        AND r.v_fk_vuelo = v.id
                        AND r.fk_reservacion is NULL
                        AND v.estatus = 'NO_INICIADO'
                    ORDER BY DBMS_RANDOM.VALUE
								) tabla
                WHERE ROWNUM = 1;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 2
            --  Se cuentan cuantos alojamientos hay

                SELECT COUNT(*) INTO cant_alojamientos
                FROM alojamiento;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            -- Se elige TIPO de alojamiento random

                SELECT * INTO tipo_alojamiento_a_reservar
                FROM (
									SELECT a.tipo
                  FROM alojamiento a
                  ORDER BY DBMS_RANDOM.VALUE)
                WHERE ROWNUM = 1;
                
            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            --  Se guarda la fecha de llegada del vuelo

                SELECT v.periodo_estimado.fecha_fin, v.fk_trayecto INTO fecha_llegada_vuelo, id_trayecto_vuelo
                FROM vuelo v
                WHERE v.id = id_vuelo_no_iniciado;

                IF hay_escala(id_vuelo_no_iniciado) THEN 

                    SELECT v.periodo_estimado.fecha_fin, v.fk_trayecto INTO fecha_llegada_vuelo, id_trayecto_vuelo
                    FROM Vuelo V, Reservacion RV
                    WHERE RV.v_fk_vuelo = V.id 
                    --AND RV.tipo = 'V' 
                    AND RV.fk_reservacion = id_reservacion_vuelo 
                    AND RV.v_es_ida = 'T';
                    
                END IF;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            --  Se guarda el lugar de llegada del vuelo

                SELECT lci.id INTO ciudad_llegada
                FROM Trayecto t, Aeropuerto ae, Lugar lca, Lugar lci, Lugar les
                WHERE t.id = id_trayecto_vuelo
                    AND ae.id = t.fk_aeropuerto_destino
                    AND lca.id = ae.fk_lugar
                    AND lci.id = lca.fk_lugar
                    AND les.id = lci.fk_lugar;

                SELECT FK_LUGAR INTO id_ciudad_destino FROM LUGAR WHERE ID = ciudad_llegada;

                SELECT FK_LUGAR INTO pais_llegada 
                FROM LUGAR 
                WHERE ID = ciudad_llegada;

                out_(1, 'CIUDAD LLEGADA: ' || ciudad_llegada || 'CIUDAD DESTINO' || id_ciudad_destino);
                OUT_BREAK;
				
            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            --  Si hay viaje de regreso, se guarda la fecha 

                out_(1,'hay regreso?   ');
                dbms_output.put_line(sys.diutil.bool_to_int(hay_regreso(id_reservacion_vuelo))); 
                OUT_BREAK;
                OUT_BREAK;
                OUT_BREAK;
                OUT_BREAK;

                if hay_regreso(id_reservacion_vuelo) = TRUE THEN 

                    SELECT MAX(V.periodo_estimado.fecha_fin) INTO fecha_regreso
                    FROM Vuelo V, Reservacion RV
                    WHERE RV.v_fk_vuelo = V.id 
                    --AND RV.tipo = 'V' 
                    AND RV.fk_reservacion = id_reservacion_vuelo
                    AND RV.v_es_ida = 'F';

                    out_(1,'se agarro la fecha_regreso:  ' || TO_CHAR(fecha_regreso));
                    dbms_output.put_line(sys.diutil.bool_to_int(hay_regreso(id_reservacion_vuelo))); 
                    OUT_BREAK;
                    OUT_BREAK;
                    OUT_BREAK;
                    OUT_BREAK;

                END IF;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            -- Se guarda la fecha de reservacion del vuelo

                SELECT FECHA_RESERVACION INTO fecha_reservacion_vuelo
                FROM reservacion r 
                WHERE id = id_reservacion_vuelo;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            -- Se elige el periodo de reserva del alojamiento

                fecha_base := TIEMPO_PKG.EXTRAER(fecha_llegada_vuelo,'DATE');
                fecha_regreso := TIEMPO_PKG.EXTRAER(fecha_regreso,'DATE');

                estadia := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1,10)));

                --si hay vuelo de regreso se hace la estadia en base a la cantidad de dias
                if fecha_regreso is not null THEN

                    dif_dias := TIEMPO_PKG.DIFF(fecha_base, fecha_regreso, 'DAY');
                    estadia := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1,dif_dias)));

                END IF;

                OUT_BREAK;
                DBMS_OUTPUT.PUT_LINE('id reservacion: ' || id_reservacion_vuelo || ' id vuelo: ' || id_vuelo_no_iniciado || ' fecha base: ' || fecha_base || ' fecha regreso: ' || fecha_regreso || ' dif_dias: ' || dif_dias || ' estadia: ' || estadia);
                OUT_BREAK;
                OUT_BREAK;

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
                                FROM (SELECT  h.id as idHab, la.FK_LUGAR, h.precio_base_noche as precioHab
                                    FROM alojamiento al, lug_aloj la, habitacion h
                                    WHERE al.tipo = tipo_alojamiento_a_reservar
                                    AND la.fk_alojamiento = al.id
                                    AND h.fk_lug_aloj = la.id
                                    
                                    AND (SELECT FK_LUGAR FROM LUGAR WHERE ID = (SELECT FK_LUGAR FROM LUGAR WHERE ID = la.fk_lugar)) = pais_llegada --la.fk_lugar IN (SELECT ID FROM LUGAR WHERE FK_LUGAR = ciudad_llegada)

                                    ORDER BY DBMS_RANDOM.VALUE) tabla
                                    WHERE ROWNUM = 1;

                                disp := hab_esta_disponible(id_habitacion);
                            END LOOP;

                        ELSE

                            SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                            FROM (
                                    SELECT  h.id as idHab, h.precio_base_noche as precioHab
                                    FROM alojamiento a, lug_aloj la, habitacion h
                                    WHERE a.tipo = tipo_alojamiento_a_reservar
                                        AND la.fk_alojamiento = a.id
                                        AND h.fk_lug_aloj = la.id

                                        -- AND (SELECT FK_LUGAR FROM LUGAR WHERE ID = (SELECT FK_LUGAR FROM LUGAR WHERE ID = la.fk_lugar)) = pais_llegada --la.fk_lugar IN (SELECT ID FROM LUGAR WHERE FK_LUGAR = ciudad_llegada)

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
                            AND h.fk_lug_aloj = la.id
                            AND (SELECT FK_LUGAR FROM LUGAR WHERE ID = (SELECT FK_LUGAR FROM LUGAR WHERE ID = la.fk_lugar)) = pais_llegada; --la.fk_lugar IN (SELECT ID FROM LUGAR WHERE FK_LUGAR = ciudad_llegada)

                            SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                            FROM (
															SELECT  h.id as idHab, h.precio_base_noche as precioHab 
															FROM alojamiento alo, lug_aloj la, habitacion h
															WHERE alo.tipo = tipo_alojamiento_a_reservar
																AND la.fk_alojamiento = alo.id
																AND h.fk_lug_aloj = la.id
																AND alo.fecha_fundacion = fecha_max
                                                                AND la.fk_lugar IN (SELECT ID FROM LUGAR WHERE FK_LUGAR = ciudad_llegada)
																ORDER BY DBMS_RANDOM.VALUE
														) tabla
                            WHERE ROWNUM =1;

                        ELSE 

                                SELECT h.id, h.precio_base_noche into id_habitacion, precio_habitacion 
                                FROM alojamiento alo, lug_aloj la, habitacion h
                                WHERE alo.tipo = tipo_alojamiento_a_reservar
                                AND la.fk_alojamiento = alo.id
                                AND h.fk_lug_aloj = la.id
                                -- AND (SELECT FK_LUGAR FROM LUGAR WHERE ID = (SELECT FK_LUGAR FROM LUGAR WHERE ID = la.fk_lugar)) = pais_llegada --la.fk_lugar IN (SELECT ID FROM LUGAR WHERE FK_LUGAR = ciudad_llegada)

                                AND NOT EXISTS (
                                	SELECT r.id 
                                	FROM reservacion r
                                	WHERE r.a_periodo.fecha_inicio < ini_estadia
                                		AND r.a_periodo.fecha_fin > fin_estadia
                                		AND r.a_fk_habitacion = h.id
                                )

                                AND ROWNUM = 1
                                order by alo.fecha_fundacion DESC;

                        END IF;

                END IF;

                --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 6
                -- Se inserta la reservacion

                    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, a_fk_habitacion, a_periodo,fk_reservacion) 
                    VALUES('A',
                            get_precio_total(ini_estadia,fin_estadia,precio_habitacion),
                            'F',
                            fecha_reservacion_vuelo,
                            id_habitacion,
                            p,
                            id_reservacion_vuelo
                            ) RETURNING id INTO id_reservacion_alojamiento;

                    OUT_BREAK;
                    OUT_(1,id_reservacion_alojamiento || ' <- reservacion alojamiento , cliente-> ' || id_cliente);
                    OUT_BREAK;
                    OUT_BREAK;


                    INSERT INTO RESERVA(fk_reservacion,fk_cliente)
                    VALUES(id_reservacion_alojamiento,id_cliente);

        END LOOP;   
END;    


-- EJECUCION
BEGIN
    DBMS_OUTPUT.ENABLE(null);
    sim_reservas_de_alojamientos();
END;