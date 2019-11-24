CREATE OR REPLACE PROCEDURE reporte4 (cursor4 OUT SYS_REFCURSOR)
IS
    correo VARCHAR2(50);
    foto BLOB;
    nombre VARCHAR2(50);
    apellido VARCHAR2(50);
    telefono VARCHAR2(50);
BEGIN

    OPEN cursor4 FOR

    SELECT u.correo, u.foto, cl.primer_nombre || ' ' || cl.segundo_nombre, 
        cl.primer_apellido || ' ' || cl.segundo_apellido, cl.telefono
        INTO correo, foto, nombre, apellido, telefono
    FROM Usuario u, Cliente cl
    WHERE cl.id = u.fk_cliente;

END;
