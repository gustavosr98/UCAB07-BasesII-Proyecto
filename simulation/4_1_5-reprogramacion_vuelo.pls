CREATE OR REPLACE PROCEDURE sim_reprogramacion_vuelo
IS 
    cantidad INTEGER;
    i_c INTEGER;

    CURSOR cvuelo IS SELECT id FROM Vuelo WHERE estatus = 'NO_INICIADO';
    idVuelo Vuelo.id%TYPE;

    CURSOR cusuario (idv Vuelo.id%TYPE) IS 
        SELECT u.id
        FROM Usuario u, Pago p, Reservacion r
        WHERE p.fk_usuario = u.id
            AND p.fk_reservacion = r.id
            AND r.tipo = 'V'    
            AND r.fk_vuelo = idv;
    idUsuario Usuario.id%TYPE;
BEGIN
    cantidad := ROUND( DBMS_RANDOM.VALUE(10,20) );

    OPEN cvuelo;
    FETCH cvuelo INTO idVuelo;

    FOR i_c IN 1..cantidad LOOP
        OPEN cusuario(idVuelo);
        FETCH cusuario INTO idUsuario;

        WHILE cusuario%FOUND
            LOOP
                
                FETCH cusuario INTO idUsuario;
            END LOOP;

        CLOSE cusuario;

        UPDATE Vuelo 
        SET estatus = 'RETRASADO', 
            periodo_estimado = PERIODO()
        WHERE id = idVuelo;

        FETCH cvuelo INTO idVuelo;
    END LOOP;

    CLOSE cvuelo;
END;