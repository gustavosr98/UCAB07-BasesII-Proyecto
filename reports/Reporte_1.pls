CREATE OR REPLACE PROCEDURE reporte1 (cursorAvion out SYS_REFCURSOR)
IS 
    logo_aerolinea blob;
    tipo_aerolinea VARCHAR2(30);
    flota_aerolinea CLOB;
   
BEGIN

    open cursorAvion for

    SELECT ae.logo , ae.tipo, DBMS_LOB.SUBSTR(getFlota(ae.id),DBMS_LOB.GETLENGTH(getFlota(ae.id)),1) as flota into logo_aerolinea, tipo_aerolinea, flota_aerolinea
    FROM aerolinea ae;

END;

CREATE OR REPLACE FUNCTION getFlota(id_aerolinea NUMBER)
RETURN CLOB
IS
    flota CLOB;

BEGIN

    SELECT LISTAGG(lista.AVION, ' - ') into flota
    FROM (SELECT distinct (ta.nombre || ' ' || ta.MODELO) as AVION 
          FROM TIPO_AVION ta, AVION av, AEROLINEA ae
          WHERE av.fk_tipo_avion = ta.id
          AND av.fk_aerolinea = ae.id
          AND ae.id = id_aerolinea) lista;

    RETURN flota;

END; 

