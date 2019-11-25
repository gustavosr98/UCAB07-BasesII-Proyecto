CREATE OR REPLACE PROCEDURE ins_lug_aloj
IS
    cant_total INTEGER DEFAULT 0;
    cant_total_h INTEGER DEFAULT 0;
    cont INTEGER DEFAULT 1;

    CURSOR c_a_hotel IS SELECT * FROM Alojamiento WHERE tipo = 'HOTEL';
    registro_hotel Alojamiento%ROWTYPE;

    CURSOR c_a_apartamento IS SELECT * FROM Alojamiento WHERE tipo = 'APARTAMENTO';
    registro_apartamento Alojamiento%ROWTYPE;

    CURSOR c_l_calle IS SELECT * FROM Lugar WHERE id BETWEEN 11100 AND 11499;
    registro_l_calle Lugar%ROWTYPE;

    TYPE inArray IS VARRAY(10) OF INTEGER;
    hora_check_in inArray;
    TYPE outArray IS VARRAY(10) OF INTEGER;
    hora_check_out outArray;

    fk_lug_aloj Lug_Aloj.id%TYPE;
    cant INTEGER;
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INS_LUG_ALOJ ******************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    hora_check_in := inArray(13,14,15,16,17,13,14,15,16,17);

    hora_check_out := outArray(8,9,10,11,12,8,9,10,11,12);

    OPEN c_l_calle;
    FETCH c_l_calle INTO registro_l_calle;

    OPEN c_a_apartamento;
    FETCH c_a_apartamento INTO registro_apartamento;

    WHILE c_a_apartamento%FOUND
        LOOP
            INSERT INTO Lug_Aloj (fk_alojamiento, fk_lugar, hora_check_in, hora_check_out)
                VALUES (
                    registro_apartamento.id,
                    registro_l_calle.id,
                    hora_check_in(cont),
                    hora_check_out(cont))
                RETURNING id INTO fk_lug_aloj;

            cant := ROUND( DBMS_RANDOM.VALUE(1,4) );
            ins_habitacion(fk_lug_aloj, cant, 'APARTAMENTO');

            FETCH c_a_apartamento INTO registro_apartamento;
            FETCH c_l_calle INTO registro_l_calle;

            cont := cont + 1;
            cant_total := cant_total + 1;
            cant_total_h := cant_total_h + cant;
        END LOOP;

    CLOSE c_a_apartamento;

    OPEN c_a_hotel;
    FETCH c_a_hotel INTO registro_hotel;
    
    cont := 1;
    
    WHILE c_l_calle%FOUND
        LOOP
            IF (c_a_hotel%NOTFOUND) THEN
                CLOSE c_a_hotel; 
                OPEN c_a_hotel;
                FETCH c_a_hotel INTO registro_hotel;
                cont := 1;
            END IF;

            INSERT INTO Lug_Aloj (fk_alojamiento, fk_lugar, hora_check_in, hora_check_out)
                VALUES (
                    registro_hotel.id,
                    registro_l_calle.id,
                    hora_check_in(cont),
                    hora_check_out(cont))
                RETURNING id INTO fk_lug_aloj;

            cant := ROUND( DBMS_RANDOM.VALUE(1,4) );
            ins_habitacion(fk_lug_aloj, cant, 'HOTEL');

            FETCH c_a_hotel INTO registro_hotel;
            FETCH c_l_calle INTO registro_l_calle;

            cont := cont + 1;
            cant_total := cant_total + 1;
            cant_total_h := cant_total_h + cant;
        END LOOP;

    CLOSE c_a_hotel; 
    CLOSE c_l_calle;

	OUT_(1,'--> Total de LUG_ALOJ generados: ' || cant_total);
	OUT_(1,'--> Total de HABITACIONES generadas: ' || cant_total_h);
END;

BEGIN

    ins_lug_aloj;

END;