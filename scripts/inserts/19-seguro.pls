CREATE OR REPLACE PROCEDURE ins_seguro
IS
    cant_aseg INTEGER DEFAULT 0;
    i_ca INTEGER;

    cantid_seg INTEGER;
    i_cs INTEGER;

    TYPE descripArray IS VARRAY(10) OF VARCHAR2(250);
    descripcion descripArray;
    numero INTEGER;
    valor NUMBER;
    precio NUMBER;

    cant_total INTEGER DEFAULT 0;
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INS_SEGURO ********************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    descripcion := descripArray(
        'Asistencia médica 24 horas.',
        'Cobertura de equipaje.',
        'Asegura tu transporte.',
        'Cobertura de boleto.',
        'Cobertura de accidentes en el hotel.',
        'Cobertura de accidentes en el viaje.',
        'Cobertura de accidentes durante el transporte en vehículo.',
        'Asistencia médica a familiares.',
        'Cobertura en caso de hospitalización',
        'Cobertura de accidentes de tráfico.'
    );

    SELECT COUNT(id) INTO cant_aseg FROM Aseguradora;

    FOR i_ca IN 1..cant_aseg LOOP
        cantid_seg := ROUND( DBMS_RANDOM.VALUE(1,3) );
        FOR i_cs IN 1..cantid_seg LOOP
            numero := ROUND( DBMS_RANDOM.VALUE(1,10) );
            valor := ROUND( DBMS_RANDOM.VALUE(500,5000), -2 );
            precio := ROUND( DBMS_RANDOM.VALUE(50,100) );
            INSERT INTO Seguro (fk_aseguradora, descripcion, valor_asegurado, precio_por_dia)
                VALUES (
                    i_ca,
                    descripcion(numero),
                    valor,
                    UNIDAD('DIVISA','DOLAR',precio));
            cant_total := cant_total + 1;
        END LOOP;
    END LOOP;

	OUT_(1,'--> Total de SEGUROS generados: ' || cant_total);
END;