CREATE OR REPLACE PROCEDURE reporte2 (cursor2 OUT SYS_REFCURSOR)
IS
    logo_aerolinea blob,
    nombre_avion varchar2(30);
    foto_avion blob;
    modelo_avion varchar2(30);
    cant_aviones number;
    asientos_por_clase CLOB;
BEGIN

    OPEN cursor2 FOR

    SELECT ae.logo, ta.nombre, ta.foto, ta.modelo, count(cant_av.id), BMS_LOB.SUBSTR(getAsientos(ae.id),DBMS_LOB.GETLENGTH(getAsientos(ae.id)),1) as -- terminar

END;
