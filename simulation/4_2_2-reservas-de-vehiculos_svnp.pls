CREATE OR REPLACE PROCEDURE sim_reservas_de_vehiculos_svnp(rango PERIODO)
IS
    cant_usuarios NUMBER;
    cant_usuarios_a_reservar NUMBER;
    id_usuario_a_reservar NUMBER;

    tipo_alojamiento_a_reservar VARCHAR2(20);
    fecha_base TIMESTAMP;
    fecha_regreso TIMESTAMP;
    fecha_reservacion TIMESTAMP;
    criterio NUMBER;    
    alojamiento_a_reservar habitacion%ROWTYPE;

    id_cliente NUMBER;
    id_reservacion_vehiculo NUMBER;
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
    ini_alquiler TIMESTAMP;
    fin_alquiler TIMESTAMP;
    alquiler VARCHAR2(10);
    dif_dias NUMBER;
    i INTEGER;
    p PERIODO;
    disp BOOLEAN;

    fecha_max TIMESTAMP;

        nombre_cliente VARCHAR2(150);


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

                SELECT tabla.idu, tabla.idcl
					INTO id_usuario_a_reservar, id_cliente
                FROM (
                    SELECT u.id idu, cl.id idcl
                    FROM usuario u, cliente cl
                    where u.fk_cliente = cl.id
                    ORDER BY DBMS_RANDOM.VALUE
								) tabla
                WHERE ROWNUM = 1;

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 3
            -- Se elige el periodo de reserva del alojamiento

                fecha_reservacion := TIEMPO_PKG.random(rango);

                fecha_base := TIMESTAMP '1000-01-01 00:00:00';

                while fecha_base < fecha_reservacion LOOP
                    fecha_base := TIEMPO_PKG.random(rango);

                END LOOP;

                fecha_regreso := TIMESTAMP '1000-01-01 00:00:00';

                while fecha_regreso < fecha_base LOOP
                   
                    fecha_regreso := TIEMPO_PKG.random(rango);

                END LOOP;

                fecha_regreso := TIEMPO_PKG.EXTRAER(fecha_regreso,'DATE');

                dif_dias := TIEMPO_PKG.DIFF(rango.fecha_inicio,rango.fecha_fin,'DAY')/2;

                alquiler := TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1,dif_dias)));

                ini_alquiler := fecha_base + INTERVAL '13' HOUR;
                fin_alquiler := fecha_base + numToDSInterval(alquiler,'DAY');
                fin_alquiler := fin_alquiler + INTERVAL '11' HOUR;

                p := PERIODO(
                    ini_alquiler,
                    fin_alquiler
                );

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 4
            --  Se elige un criterio random

                criterio := ROUND(DBMS_RANDOM.VALUE(1,2));

            --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 5
            -- Se elige un alojamiento en función del criterio elegido

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

                -- Se guarda el id de la sucursal de inicio

                        SELECT tabla.id INTO id_sucursal_ini
                        FROM (SELECT s.id       
                                FROM sucursal s
                                ORDER BY DBMS_RANDOM.VALUE) tabla
                        WHERE ROWNUM = 1;

                --  AGREGACION DE RESERVAS DE ALOJAMIENTOS | PASO 6
                -- Se inserta la reservacion

                    INSERT INTO RESERVACION(tipo,precio_total,esta_cancelada,fecha_reservacion, c_fk_vehiculo, c_fk_sucursal_inicio,c_periodo) 
                    VALUES('C',
                            get_precio_total(ini_alquiler,fin_alquiler,precio_vehiculo),
                            'F',
                            fecha_reservacion,
                            id_vehiculo,
                            id_sucursal_ini,
                            p
                            ) RETURNING id INTO id_reservacion_vehiculo;


                    SELECT id || ': ' || primer_nombre || ' ' || primer_apellido INTO nombre_cliente FROM CLIENTE WHERE id = id_cliente;
                    OUT_(1,'RESERVA VEHICULO (ID: '||id_reservacion_vehiculo ||')');
                    OUT_(3,'Cliente: ' || nombre_cliente);
                    OUT_(3,'ID vehiculo: ' || id_vehiculo);
                    OUT_(3,'Reservó el ' || fecha_reservacion || ' para ' || p.fecha_inicio || ' hasta ' || p.fecha_fin);

                    INSERT INTO RESERVA(fk_reservacion,fk_cliente)
                    VALUES(id_reservacion_vehiculo,id_cliente);
	                OUT_(0,'-----------------------------------------------------------------------');                            

        END LOOP;   

END;

BEGIN

    sim_reservas_de_vehiculos_svnp(PERIODO(
        TIMESTAMP '2019-05-19 11:24:50',
        TIMESTAMP '2020-05-26 06:47:15'
    ));
    --DBMS_OUTPUT.PUT_LINE(sys.diutil.bool_to_int(es_mismo_pais(11000,232)));

END;


