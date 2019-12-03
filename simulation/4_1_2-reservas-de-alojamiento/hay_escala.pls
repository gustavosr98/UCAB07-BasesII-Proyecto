CREATE OR REPLACE FUNCTION hay_escala(id_reservacion_vuelo NUMBER)
RETURN BOOLEAN
IS 
    booly BOOLEAN := FALSE;
    num NUMBER;
BEGIN

    SELECT COUNT(*) INTO num 
    FROM Vuelo V, Reservacion RV
    WHERE RV.v_fk_vuelo = V.id 
    AND RV.fk_reservacion = id_reservacion_vuelo
    AND RV.v_es_ida = 'T'
    AND ROWNUM = 1;

    if num != 0 THEN

        booly := TRUE;

    END IF;

    RETURN booly;

END;

BEGIN

    dbms_output.put_line(sys.diutil.bool_to_int(hay_escala(1))); 

END;