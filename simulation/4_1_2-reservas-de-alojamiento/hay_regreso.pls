CREATE OR REPLACE FUNCTION hay_regreso(id_reservacion_vuelo NUMBER)
RETURN BOOLEAN
IS 
    booly BOOLEAN := FALSE;
    num NUMBER;
BEGIN

    SELECT V.id INTO num 
    FROM Vuelo V, Reservacion RV
    WHERE RV.v_fk_vuelo = V.id 
    AND RV.v_fk_vuelo = id_reservacion_vuelo 
    AND RV.v_es_ida = 'F'
    AND ROWNUM = 1;

    if num is not null THEN

        booly := TRUE;

    END IF;

    RETURN booly;

END;