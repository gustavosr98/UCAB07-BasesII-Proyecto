CREATE OR REPLACE PROCEDURE reporte3 (cursor3 OUT SYS_REFCURSOR, avionNombre IN VARCHAR2, avionModelo IN VARCHAR2)
IS
    logo BLOB;
    nombre VARCHAR2(50);
    foto BLOB;
    modelo VARCHAR2(50);
    velocidad NUMBER;
    alcance NUMBER;
    altitud NUMBER;
    envergadura NUMBER;
    ancho NUMBER;
    altura NUMBER;
BEGIN

    OPEN cursor3 FOR
    SELECT ae.logo, ta.nombre, ta.foto, ta.modelo, ta.velocidad_max.cantidad, ta.alcance_max.cantidad, 
        ta.altitud_max.cantidad, ta.envergadura.cantidad, ta.ancho_interior_cabina.cantidad, 
        ta.altura_interior_cabina.cantidad
        INTO logo, nombre, foto, modelo, velocidad, alcance, altitud, envergadura, ancho, altura
    FROM Tipo_Avion ta, Aerolinea ae, 
        (SELECT DISTINCT ae.id idAerolinea, ta.id idTipoAvion
        FROM Tipo_Avion ta, Aerolinea ae, Avion av
        WHERE ta.id = av.fk_tipo_avion
            AND ae.id = av.fk_aerolinea
            AND ta.nombre = avionNombre
            AND ta.modelo = avionModelo) x
    WHERE ta.id = x.idTipoAvion
        AND ae.id = x.idAerolinea;

END;