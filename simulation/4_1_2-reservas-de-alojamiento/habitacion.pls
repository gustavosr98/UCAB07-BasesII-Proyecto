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