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

    -- VUELO

    SELECT V.ID ID_V, ASI.ID ID_ASI, A.ID ID_AVI
    FROM VUELO V, ASIENTO ASI, AVION A
    WHERE V.FK_AVION = A.ID
    AND ASI.FK_AVION = A.ID;

    SELECT COUNT(*) FROM VUELO 

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(1,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,138,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),1,1);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(2,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,73,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),2,2);
    
    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(3,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',1,163,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),3,3);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(4,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',129,199,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),4,4);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(5,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',131,202,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),5,5);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(6,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',132,100,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),6,6);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(7,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',133,162,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),7,7);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(8,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',137,114,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),8,8);

    INSERT INTO RESERVACION(ID,tipo,precio_total,esta_cancelada,fecha_reservacion, v_fk_asiento, v_fk_vuelo, v_es_ida_vuelta)
                VALUES(9,'V',UNIDAD('DIVISA','DOLAR',2000),'F',TIMESTAMP '19-02-03 12:00:00',139,129,'F');
    INSERT INTO PAGO(pagado,FK_USUARIO,FK_RESERVACION) VALUES(UNIDAD('DIVISA','DOLAR',2000),9,9);
 
    DELETE FROM RESERVACION WHERE TIPO = 'V' AND ID = 29

    DELETE FROM PAGO WHERE FK_USUARIO = 7;

    SELECT * FROM alojamiento

    SELECT ID FROM HABITACION