CREATE OR REPLACE PROCEDURE main (p_fechas_base PERIODO DEFAULT NULL)
IS
	fechas_base PERIODO;
BEGIN
	fechas_base := p_fechas_base;
	IF (fechas_base IS NULL) THEN
		fechas_base := PERIODO(
			TIEMPO_PKG.RANDOM(PERIODO( LOCALTIMESTAMP - INTERVAL '5' MONTH , LOCALTIMESTAMP - INTERVAL '4' MONTH )),
			TIEMPO_PKG.RANDOM(PERIODO( LOCALTIMESTAMP + INTERVAL '5' MONTH, LOCALTIMESTAMP + INTERVAL '4' MONTH ))
		);
	END IF;

	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'********************* SIMULATION: MAIN ************************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	OUT_(2,'Periodo de simulación: ' || fechas_base.fecha_inicio || ' <---> ' || fechas_base.fecha_fin);
	OUT_BREAK;

END;

-- EJECUCION
BEGIN
	main(PERIODO(
		TIMESTAMP '19-09-19 11:24:50',
		TIMESTAMP '20-03-20 06:47:15'
	));
END;