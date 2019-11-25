CREATE OR REPLACE PROCEDURE ins_habitacion (fk_lug_aloj IN NUMBER, cantidad IN INTEGER, tipo IN VARCHAR2)
IS
    TYPE descripArray IS VARRAY(20) OF VARCHAR2(100);
    descripcion descripArray;
    nd NUMBER;

    capacidad INTEGER;
    precio NUMBER;

    i INTEGER;
    cant INTEGER;
    i_t INTEGER;
BEGIN
OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INS_HABITACION ****************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    descripcion := descripArray(
        'Acceso a cocina. Excelente vista.',
        'Chimenea interior. Jacuzzi.',
        'Gran ubicación. Terraza.',
        'Lavadora. WiFi.',
        'Estacionamiento. Ascensor.',
        'Servicio a la habitación. Limpieza.',
        'Cocina. Nevera en habitación.',
        'Restaurant. Piscina.',
        'Se permiten animales. WiFi.',
        'Bar. Ascensor.'
    );

    FOR i IN 1..cantidad LOOP
        IF (tipo = 'APARTAMENTO') THEN
            nd := ROUND( DBMS_RANDOM.VALUE(1,5) );
            capacidad := ROUND( DBMS_RANDOM.VALUE(1,3) );
            precio := ROUND( DBMS_RANDOM.VALUE(50,100) );
            INSERT INTO Habitacion (fk_lug_aloj,descripcion,capacidad,precio_base_noche,esta_disponible)
            VALUES (
                fk_lug_aloj,
                descripcion(nd),
                capacidad,
                UNIDAD('DIVISA','DOLAR',precio),
                'T'); 
        ELSE
            nd := ROUND( DBMS_RANDOM.VALUE(6,10) );
            capacidad := ROUND( DBMS_RANDOM.VALUE(1,4) );
            precio := ROUND( DBMS_RANDOM.VALUE(50,100) );
            INSERT INTO Habitacion (fk_lug_aloj,descripcion,capacidad,precio_base_noche,esta_disponible)
            VALUES (
                fk_lug_aloj,
                descripcion(nd),
                capacidad,
                UNIDAD('DIVISA','DOLAR',precio),
                'T'); 
        END IF;
    END LOOP;
END;