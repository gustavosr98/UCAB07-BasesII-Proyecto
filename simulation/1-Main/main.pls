CREATE OR REPLACE PROCEDURE main (p_fechas_base PERIODO DEFAULT NULL)
IS
	fb PERIODO;
	fq PERIODO;
BEGIN
	-- MAIN
		fb := p_fechas_base;
		fq := PERIODO(
			TIMESTAMP '2019-05-19 12:00:00',
			TIMESTAMP '2019-05-26 12:00:00'
		);

		IF (fb IS NULL) THEN
			fb := PERIODO(
				TIEMPO_PKG.RANDOM(PERIODO( LOCALTIMESTAMP - INTERVAL '5' MONTH , LOCALTIMESTAMP - INTERVAL '4' MONTH )),
				TIEMPO_PKG.RANDOM(PERIODO( LOCALTIMESTAMP + INTERVAL '5' MONTH, LOCALTIMESTAMP + INTERVAL '4' MONTH ))
			);
		END IF;

		OUT_BREAK(2);
		OUT_(0,'***************************************************************');
		OUT_(0,'********************* SIMULATION: MAIN ************************');
		OUT_(0,'***************************************************************');
		OUT_BREAK;

		OUT_(2,'Periodo de simulación: ' || fb.fecha_inicio || ' <---> ' || fb.fecha_fin);
		OUT_BREAK;

	-- COMPONENTES
		-- SIM_GENERACION_DE_VUELOS(fb);
		SIM_RESERVACION_DE_VUELOS(fq, fb);

END;

-- EJECUCION
BEGIN
	MAIN(
		PERIODO(
			TIMESTAMP '2019-11-01 11:24:50',
			TIMESTAMP '2020-01-31 06:47:15'
		)
	);
END;