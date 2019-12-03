CREATE OR REPLACE PROCEDURE main (p_fechas_base PERIODO DEFAULT NULL)
IS
	fb PERIODO;
	fq PERIODO;
BEGIN
	-- MAIN
		fb := p_fechas_base;
		fq := PERIODO(
			TIMESTAMP '2019-11-19 12:00:00',
			TIMESTAMP '2019-11-26 12:00:00'
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
		SIM_GENERACION_DE_VUELOS(fb);
		SIM_RESERVACION_DE_VUELOS(fq, fb);
		SIM_PAGO_DE_PAQUETES(fq);
		SIM_REPROGRAMACION_DE_VUELOS(fq);
		SIM_CERRAR_PERIODO_TRANSCURRIDO(fq);

END;

-- EJECUCION
BEGIN
	DBMS_OUTPUT.ENABLE(NULL);
	DELETE FROM RESERVA;
	DELETE FROM PAGO;
	DELETE FROM HISTORICO_MILLA;
	DELETE FROM RESERVACION;
	DELETE FROM VUELO;

	SIM_CONFIGURACION(
		reset => 0,
		cant_users_a_reservar => 10
	);
	MAIN(
		PERIODO(
			TIMESTAMP '2019-11-01 11:24:50',
			TIMESTAMP '2020-01-31 06:47:15'
		)
	);
END;