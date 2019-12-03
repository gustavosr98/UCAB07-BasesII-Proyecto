
--  ASIENTOS
/* 

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


 */
