CREATE OR REPLACE PROCEDURE ins_sucursal
IS
    cant_total INTEGER DEFAULT 0;

    CURSOR c_prov IS SELECT * FROM Proveedor_Vehiculo;
    registro_prov Proveedor_Vehiculo%ROWTYPE;

    CURSOR c_l_calle IS 
        SELECT * FROM Lugar 
        WHERE (id BETWEEN 11000 AND 11099)
            OR (id >= 11500);
    registro_l_calle Lugar%ROWTYPE;

BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INS_SUCURSAL ******************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    OPEN c_l_calle;
    FETCH c_l_calle INTO registro_l_calle;

    OPEN c_prov;
    FETCH c_prov INTO registro_prov;
    
    WHILE c_l_calle%FOUND
        LOOP
            IF (c_prov%NOTFOUND) THEN
                CLOSE c_prov; 
                OPEN c_prov;
                FETCH c_prov INTO registro_prov;
            END IF;

            INSERT INTO Sucursal (fk_proveedor_vehiculo, fk_lugar)
                VALUES (
                    registro_prov.id,
                    registro_l_calle.id);

            FETCH c_prov INTO registro_prov;
            FETCH c_l_calle INTO registro_l_calle;

            cant_total := cant_total + 1;
        END LOOP;

    CLOSE c_prov; 
    CLOSE c_l_calle;

	OUT_(1,'--> Total de SUCURSALES generadas: ' || cant_total);
END;