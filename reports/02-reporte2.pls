CREATE OR REPLACE PROCEDURE reporte2 (cursor2 OUT SYS_REFCURSOR, nombreAerolinea IN VARCHAR2 DEFAULT '')
IS
    logo_aerolinea blob;
    nombre_avion varchar2(30);
    foto_avion blob;
    modelo_avion varchar2(30);
    cant_aviones number;
    asientos_por_clase CLOB;
BEGIN

    OPEN cursor2 FOR

    SELECT ae.logo, tabla.Nombre_TA, ta.foto ,tabla.Modelo_TA, tabla.Cant_Aviones, DBMS_LOB.SUBSTR(getAsientos(ae.id,ta.id),DBMS_LOB.GETLENGTH(getAsientos(ae.id,ta.id)),1) ASIENTOS
    INTO logo_aerolinea, nombre_avion, foto_avion, modelo_avion, cant_aviones, asientos_por_clase
    FROM  AEROLINEA ae, TIPO_AVION ta, (SELECT DISTINCT ae.id as ID_AEROLINEA, ta.id as ID_TIPO_AVION, ae.nombre, ta.nombre as Nombre_TA, ta.modelo as Modelo_TA, getCantAviones(ta.id,ae.id) AS Cant_Aviones
                                                FROM AEROLINEA ae, TIPO_AVION ta, AVION av
                                                WHERE av.fk_aerolinea = ae.id
                                                AND av.fk_tipo_avion = ta.id) tabla
    WHERE ae.id = tabla.ID_AEROLINEA
        AND ta.id = tabla.ID_TIPO_AVION
        AND ae.nombre LIKE '%' || nombreAerolinea || '%'

END;

CREATE OR REPLACE FUNCTION getCantAviones(id_tipo_avion NUMBER, id_aerolinea NUMBER)
RETURN NUMBER

IS

    cantidad NUMBER;

BEGIN

    SELECT COUNT(av.id) INTO cantidad
    FROM Avion av, Tipo_avion ta, Aerolinea ae
    WHERE av.fk_aerolinea = ae.id
    AND av.fk_tipo_avion = ta.id
    AND ta.id = id_tipo_avion
    AND ae.id = id_aerolinea;

    RETURN cantidad;
END;


CREATE OR REPLACE FUNCTION getAsientos(id_aerolinea NUMBER, id_tipo_avion NUMBER)
RETURN CLOB
IS
    asientos CLOB;
    num_clases NUMBER;
    cont NUMBER;
    nombre_clase VARCHAR2(30);

BEGIN

    SELECT COUNT(*) INTO num_clases
    from clase;

    FOR cont IN 1..num_clases LOOP

        select nombre INTO nombre_clase 
        from clase 
        where id = cont;

        asientos := asientos || chr(7) || ' ' || TO_CHAR(NumDeAsientos(id_tipo_avion, id_aerolinea,cont)) || ' asientos en la clase ' || nombre_clase;

        if cont < num_clases then 
        
            asientos := asientos || chr(13) || chr(10);
        
        END IF;

    END LOOP;

    RETURN asientos;
END; 

CREATE OR REPLACE FUNCTION numDeAsientos(id_tipo_avion NUMBER, id_aerolinea NUMBER, id_clase NUMBER)
RETURN NUMBER
IS

    num_asientos NUMBER;

BEGIN

    SELECT count(asi.id) INTO num_asientos
    FROM asiento asi, tipo_avion ta, avion av, clase_aerolinea ca, aerolinea ae, clase cl
    WHERE asi.fk_avion = av.id
    AND av.fk_tipo_avion = ta.id
    AND asi.fk_clase_aerolinea = ca.id
    AND ca.fk_aerolinea = ae.id
    AND ca.fk_clase = cl.id
    
    AND ae.id = id_aerolinea
    AND ta.id = id_tipo_avion
    AND cl.id = id_clase
    ;

    RETURN num_asientos;
END;

-- Comprobaciones

    -- Cantidad de aviones en una aerolinea

        SELECT count(av.id)
        FROM Avion av, Tipo_avion ta, Aerolinea ae
        WHERE av.fk_tipo_avion = ta.id
        AND av.fk_aerolinea = ae.id
        AND ta.nombre = 'Boeing'
        AND ta.modelo = '717-200'
        AND ae.nombre = 'Laser Airlines';
    
    -- Cantidad de asientos de una clase en un avion de una aerolinea

        SELECT count(asi.id)
        FROM asiento asi, tipo_avion ta, avion av, clase_aerolinea ca, aerolinea ae, clase cl
        WHERE asi.fk_avion = av.id
        AND av.fk_tipo_avion = ta.id
        AND asi.fk_clase_aerolinea = ca.id
        AND ca.fk_aerolinea = ae.id
        AND ca.fk_clase = cl.id
        
        AND ae.nombre = 'Laser Airlines'
        AND ta.modelo = '717-200'
        AND cl.id = 3
        ;
