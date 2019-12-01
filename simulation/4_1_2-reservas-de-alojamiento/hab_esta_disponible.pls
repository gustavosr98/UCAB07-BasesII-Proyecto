CREATE OR REPLACE FUNCTION hab_esta_disponible(id NUMBER)
RETURN BOOLEAN
IS
    io BOOLEAN := TRUE;
    CURSOR cvalores is SELECT * FROM reservacion WHERE tipo = 'A';
    registro_tabla reservacion%ROWTYPE;
BEGIN

    open cvalores;
    fetch cvalores into registro_tabla;

    WHILE cvalores%found
        LOOP

            if registro_tabla.v_fk_asiento = id THEN 

                io := FALSE;

            END IF;

            fetch cvalores into registro_tabla;

        END LOOP;
    
    RETURN io;
END;   