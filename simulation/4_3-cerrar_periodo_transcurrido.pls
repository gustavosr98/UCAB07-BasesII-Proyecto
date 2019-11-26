CREATE OR REPLACE PROCEDURE sim_cerrar_periodo_transcurrido (fechas_base IN PERIODO)
IS 

BEGIN

END;

CREATE OR REPLACE PROCEDURE fechasReales (fechas_base IN PERIODO)
IS 
    CURSOR cvuelos IS SELECT * FROM Vuelo;
    rvuelo Vuelo%ROWTYPE;

    fecha_salida_real TIMESTAMP;
    fecha_llegada_real TIMESTAMP;

    retrasado INTEGER;
    estatus VARCHAR2(20);
BEGIN
    OPEN cvuelos;
    FETCH cvuelos INTO rvuelo;

    WHILE cvuelos%FOUND
        LOOP
            retrasado := ROUND( DBMS_RANDOM.VALUE(1,2) );

            IF (retrasado = 1) THEN
                fecha_salida_real := rvuelo.periodo_estimado.fecha_inicio;
                estatus := 'NO_INICIADO';
            ELSE
                fecha_salida_real := TIEMPO_PKG.RANDOM(PERIODO(rvuelo.periodo_estimado.fecha_inicio,fechas_base.fecha_fin));
                estatus := 'RETRASADO';
            END IF;
            fecha_llegada_real := TIEMPO_PKG.RANDOM(PERIODO(fecha_salida_real + numToDSInterval( 1, 'HOUR' ), fecha_salida_real + numToDSInterval( 15, 'HOUR' )));
            
            IF (fecha_llegada_real > LOCALTIMESTAMP) THEN
                estatus := 'COMPLETADO';
            ELSIF (TIEMPO_PKG.DIFF(fecha_salida_real, LOCALTIMESTAMP, 'MINUTE') > 5 AND TIEMPO_PKG.DIFF(fecha_salida_real, LOCALTIMESTAMP, 'MINUTE') < 10) THEN
                estatus := 'EN_TRANSITO';
            ELSIF (fecha_salida_real < LOCALTIMESTAMP AND fecha_llegada_real > LOCALTIMESTAMP) THEN
                estatus := 'EN_VUELO';
            END IF;

            UPDATE Vuelo
                SET periodo_real = PERIODO(fecha_salida_real,fecha_llegada_real),
                    estatus = estatus 
                WHERE id = rvuelo.id;

            FETCH cvuelos INTO rvuelo;
        END LOOP;

    CLOSE cvuelos;
END;