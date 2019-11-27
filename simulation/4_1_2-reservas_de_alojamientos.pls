CREATE OR REPLACE PROCEDURE sim_reservas_de_alojamientos
IS
    id_reservacion_vuelo NUMBER;
    cant_usuarios_con_reservaciones_de_vuelo NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;
    id_vuelo_no_iniciado NUMBER;

    cant_alojamientos NUMBER;
    tipo_alojamiento_a_reservar VARCHAR2(20);
    fecha_base TIMESTAMP;
    fecha_llegada_vuelo TIMESTAMP;
    fecha_reservacion_vuelo TIMESTAMP;
    criterio NUMBER;    
    alojamiento_a_reservar habitacion%ROWTYPE;

    id_habitacion NUMBER;
    precio_habitacion UNIDAD;

    ini_estadia TIMESTAMP;
    fin_estadia TIMESTAMP;
    estadia VARCHAR2(10);
    i INTEGER;
    p PERIODO;
    condi NUMBER;
    disp BOOLEAN;

    fecha_max TIMESTAMP;

BEGIN

    --  Usuarios que tienen reservaciones de vuelo no iniciado

        SELECT COUNT(*) INTO cant_usuarios_con_reservaciones_de_vuelo
        FROM usuario u, pago p, reservacion r, vuelo v
        WHERE p.fk_usuario = u.id
        AND p.fk_reservacion = r.id
        AND r.v_fk_vuelo = v.id
        AND v.estatus = 'NO_INICIADO'; 

    --  Random de usuarios a reservar

        cant_usuarios_a_reservar := ROUND(DBMS_RANDOM.VALUE(1,cant_usuarios_con_reservaciones_de_vuelo));

    --  Se reserva la cantidad indicada

        FOR i IN 1..cant_usuarios_a_reservar LOOP

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

           --  Se cuentan cuantos alojamientos hay

                SELECT COUNT(*) INTO cant_alojamientos
                FROM alojamiento;

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

            -- Se guarda la fecha de reservacion del vuelo

                SELECT FECHA_RESERVACION INTO fecha_reservacion_vuelo
                FROM reservacion r 
                WHERE id = id_reservacion_vuelo;

            -- Se elige el periodo de reserva del alojamiento

                fecha_base := TIEMPO_PKG.EXTRAER(fecha_llegada_vuelo,'DATE');
                estadia := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1,10)));

                ini_estadia := fecha_base + INTERVAL '13' HOUR;
                fin_estadia := fecha_base + numToDSInterval(estadia,'DAY');
                fin_estadia := fin_estadia + INTERVAL '11' HOUR;

                p := PERIODO(
                ini_estadia,
                fin_estadia
                );

            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

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
                            FROM (SELECT  h.id as idHab, h.precio_base_noche as precioHab
                                    FROM alojamiento a, lug_aloj la, habitacion h
                                    WHERE a.tipo = tipo_alojamiento_a_reservar
                                    AND la.fk_alojamiento = a.id
                                    AND h.fk_lug_aloj = la.id
                                    -- valida fecha
                                    AND NOT EXISTS (SELECT r.id 
                                                    FROM reservacion r
                                                    WHERE r.a_periodo.fecha_inicio < ini_estadia
                                                    AND r.a_periodo.fecha_fin > fin_estadia
                                                    AND r.a_fk_habitacion = h.id) 

                                    ORDER BY h.precio_base_noche.cantidad ASC, DBMS_RANDOM.VALUE ) tabla
                            WHERE ROWNUM = 1;

                        END IF;

                ELSIF criterio = 2 THEN  -- Más actual

                        SELECT COUNT(*) into condi FROM RESERVACION WHERE tipo = 'A';

                        if condi = 0 THEN

                            SELECT  MAX(alo.fecha_fundacion) into fecha_max 
                            FROM alojamiento alo, lug_aloj la, habitacion h
                            WHERE alo.tipo = tipo_alojamiento_a_reservar
                            AND la.fk_alojamiento = alo.id
                            AND h.fk_lug_aloj = la.id;

                            SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                            FROM (SELECT  h.id as idHab, h.precio_base_noche as precioHab 
                                                            FROM alojamiento alo, lug_aloj la, habitacion h
                                                            WHERE alo.tipo = tipo_alojamiento_a_reservar
                                                            AND la.fk_alojamiento = alo.id
                                                            AND h.fk_lug_aloj = la.id
                                                            AND alo.fecha_fundacion = fecha_max
                                                            ORDER BY DBMS_RANDOM.VALUE) tabla
                            WHERE ROWNUM =1;

                        ELSE 
                    
                            SELECT  MAX(alo.fecha_fundacion) into fecha_max 
                                FROM alojamiento alo, lug_aloj la, habitacion h
                                WHERE alo.tipo = tipo_alojamiento_a_reservar
                                AND la.fk_alojamiento = alo.id
                                AND h.fk_lug_aloj = la.id;

                                SELECT tabla.idHab, tabla.precioHab INTO  id_habitacion, precio_habitacion
                                FROM (SELECT  h.id as idHab, h.precio_base_noche as precioHab   
                                                                FROM alojamiento alo, lug_aloj la, habitacion h
                                                                WHERE alo.tipo = tipo_alojamiento_a_reservar
                                                                AND la.fk_alojamiento = alo.id
                                                                AND h.fk_lug_aloj = la.id
                                                                AND alo.fecha_fundacion = fecha_max

                                                                AND NOT EXISTS (SELECT r.id 
                                                                                FROM reservacion r
                                                                                WHERE r.a_periodo.fecha_inicio < ini_estadia
                                                                                AND r.a_periodo.fecha_fin > fin_estadia
                                                                                AND r.a_fk_habitacion = h.id)
                                                                
                                                                ORDER BY DBMS_RANDOM.VALUE) tabla
                                WHERE ROWNUM =1;

                        END IF;

                END IF;

                -- Se inserta la reservacion

                    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, a_fk_habitacion, a_periodo,fk_reservacion) 
                    VALUES('A',
                            get_precio_total(ini_estadia,fin_estadia,precio_habitacion),
                            'F',
                            fecha_reservacion_vuelo,
                            id_habitacion,
                            p,
                            id_reservacion_vuelo
                            );

        END LOOP;   
END;

BEGIN

    sim_reservas_de_alojamientos();

END;

CREATE OR REPLACE FUNCTION get_precio_total(ini TIMESTAMP, fin TIMESTAMP, precio_noche UNIDAD)
RETURN UNIDAD
IS
    total NUMBER;
    uni UNIDAD;

BEGIN

    total := TIEMPO_PKG.DIFF(ini,fin,'DAY') * precio_noche.cantidad;

    uni := UNIDAD(
			'DIVISA',
            'DOLAR',
            total
		);    

    return uni;
END;


-- HABITACIONES

CREATE OR REPLACE FUNCTION habitacion()
RETURN habitacion%ROWTYPE
IS
    hab NUMBER;
    CURSOR cvalores is SELECT * FROM habitacion;
    registro_tabla habitacion%ROWTYPE;

BEGIN
    open cvalores;
    fetch cvalores into registro_tabla;
    
    while cvalores%found
        LOOP

            if hab_esta_disponible(registro_tabla.id) THEN

                RETURN registro_tabla;

            ELSE

                fetch cvalores into registro_tabla;

            END IF;
        END LOOP;
        close cvalores;
    RETURN null;
END;

CREATE OR REPLACE FUNCTION hab_esta_disponible(id NUMBER)
RETURN BOOLEAN
IS
    io BOOLEAN := TRUE;
    CURSOR cvalores is SELECT * FROM reservacion WHERE tipo = 'A';
    registro_tabla reservacion%ROWTYPE;
BEGIN

    open cvalores;
    fetch cvalores into registro_tabla;

    WHILE cvalores%found
        LOOP

            if registro_tabla.v_fk_asiento = id THEN 

                io := FALSE;

            END IF;

            fetch cvalores into registro_tabla;

        END LOOP;
    
    RETURN io;
END;    


--  INSERTS DE PRUEBA

    -- INSERTS DE RESERVACION VUELOS

    -- ASIENTOS CON AVION Y VUELO

        SELECT asi.id idA, av.id idAV, v.id idV
        FROM asiento asi, avion av, vuelo v
        WHERE asi.fk_avion = av.id
        AND v.fk_avion = av.id;

    -- USUARIOS Y VUELOS

        SELECT u.id idU, v.id idV, v.estatus
        FROM usuario u, pago p, reservacion r, vuelo v
        WHERE p.fk_usuario = u.id
        AND p.fk_reservacion = r.id
        AND r.v_fk_vuelo = v.id
        AND v.estatus = 'NO_INICIADO'; 

    --  ALOJAMIENTOS 

        SELECT * FROM (SELECT h.id, h.precio_base_noche.cantidad, al.tipo
        FROM alojamiento al, lug_aloj la, habitacion h, reservacion r
        WHERE al.tipo = 'HOTEL'
        AND la.fk_alojamiento = al.id
        AND h.fk_lug_aloj = la.id
        ORDER BY DBMS_RANDOM.VALUE)
        WHERE ROWNUM = 1;

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,1,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),1,1);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,4,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),2,2);
    
    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,41,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),3,3);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',2,1,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),4,4);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',2,4,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),5,5);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,1,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),6,6);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',108,50,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),7,7);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',110,47,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),8,8);

    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES('V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',110,48,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),9,9);
 
    DELETE FROM PAGO WHERE FK_USUARIO = 7;

    SELECT * FROM alojamiento

    SELECT ID FROM HABITACION

--  ASIENTOS


CREATE OR REPLACE FUNCTION asiento()
RETURN NUMBER
IS
    spot NUMBER;
    CURSOR cvalores is SELECT * FROM asiento;
    registro_tabla asiento%ROWTYPE;

BEGIN
    open cvalores;
    fetch cvalores into registro_tabla;
    
    while cvalores%found
        LOOP

            if vehi_esta_disponible(registro_tabla.id) THEN

                RETURN registro_tabla.id;

            ELSE

                fetch cvalores into registro_tabla;

            END IF;
        END LOOP;
        close cvalores;
    RETURN null;
END;

CREATE OR REPLACE FUNCTION vehi_esta_diponible(id NUMBER)
RETURN BOOLEAN
IS
    io BOOLEAN := TRUE;
    CURSOR cvalores is SELECT * FROM reservacion WHERE tipo = 'V';
    registro_tabla reservacion%ROWTYPE;
BEGIN

    open cvalores;
    fetch cvalores into registro_tabla;

    WHILE cvalores%found
        LOOP

            if registro_tabla.fk_asiento = id THEN 

                io := FALSE;

            END IF;

            fetch cvalores into registro_tabla;

        END LOOP;
    
    RETURN io;
END;    



