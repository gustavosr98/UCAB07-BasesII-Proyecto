CREATE OR REPLACE PROCEDURE sim_reservacion_de_vuelos (fq PERIODO, fg PERIODO)
IS

		cant_users_a_reservar INTEGER;
		cant_users INTEGER;
		i_u INTEGER DEFAULT 1;

		user_id INTEGER;
		v_usuario USUARIO%ROWTYPE;
		v_cliente_usuario CLIENTE%ROWTYPE;
		CURSOR c_usuarios ( cant INTEGER ) IS
			SELECT * FROM (
				SELECT * FROM Usuario CLI 
				ORDER BY DBMS_RANDOM.VALUE
			) WHERE ROWNUM <= cant;

		cant_estimada_acompanantes INTEGER;
		cant_acompanantes_usuario INTEGER;
		CURSOR c_acompanantes (v_usuario USUARIO%ROWTYPE, cant INTEGER ) IS
			(
				SELECT * FROM Cliente CLI
				WHERE CLI.id = v_usuario.fk_cliente
			) UNION (
				SELECT * FROM (
					SELECT * FROM Cliente CLI 
					WHERE CLI.fk_cliente = v_usuario.fk_cliente
					ORDER BY DBMS_RANDOM.VALUE
				) WHERE ROWNUM <= cant
			);
		v_acompanante CLIENTE%ROWTYPE;

		origen LUGAR%ROWTYPE;
		destino LUGAR%ROWTYPE;
		es_ida_vuelta CHAR(1);

		fecha_reservacion TIMESTAMP;
		fecha_salida TIMESTAMP;
		fecha_viaje PERIODO;

		criterio_vuelo VARCHAR2(50);

	-- RUTA DE VIAJE
		c_vuelos SYS_REFCURSOR;
		
		origen1 LUGAR.NOMBRE%TYPE;
		v1id INTEGER; v1e VUELO.ESTATUS%TYPE; v1fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v1ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
		destino1 LUGAR.NOMBRE%TYPE;
		v2id INTEGER; v2e VUELO.ESTATUS%TYPE; v2fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v2ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
		destino2 LUGAR.NOMBRE%TYPE;
		v3id INTEGER; v3e VUELO.ESTATUS%TYPE; v3fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v3ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
		destino3 LUGAR.NOMBRE%TYPE;
		costo_total NUMBER;
		fecha_final VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;

		c_r_vuelos SYS_REFCURSOR;
		r_origen1 LUGAR.NOMBRE%TYPE;
		r_v1id INTEGER; r_v1e VUELO.ESTATUS%TYPE; r_v1fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; r_v1ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
		r_destino1 LUGAR.NOMBRE%TYPE;
		r_v2id INTEGER; r_v2e VUELO.ESTATUS%TYPE; r_v2fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; r_v2ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
		r_destino2 LUGAR.NOMBRE%TYPE;
		r_v3id INTEGER; r_v3e VUELO.ESTATUS%TYPE; r_v3fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; r_v3ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
		r_destino3 LUGAR.NOMBRE%TYPE;
		r_costo_total NUMBER;
		r_fecha_final VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;

		v_asiento ASIENTO%ROWTYPE;

		consegui BOOLEAN DEFAULT FALSE;

	-- RESERVACION
		reservacion_id INTEGER;
		reserva_padre_id INTEGER DEFAULT 0;
		clase_aletorio NUMBER;
		clase_de_asiento VARCHAR(50);
BEGIN

	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 4.1.1 RESERVA VUELOS ***************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	SELECT COUNT(id) INTO cant_users FROM Usuario;

	-- RESERVACION DE VUELOS | PASO 1
	-- Se genera un número aleatorio para la cantidad de usuarios a reservar vuelos.
	
	SELECT valor_numerico INTO cant_users_a_reservar FROM CONFIGURACION WHERE nombre_variable = 'cant_users_a_reservar';
	IF ( cant_users_a_reservar IS NULL) THEN
		cant_users_a_reservar := TRUNC( DBMS_RANDOM.VALUE(1,cant_users) );
	END IF;

	OUT_(2, 'Cant. usuarios a reservar vuelos: ' || cant_users_a_reservar);
	OUT_BREAK;
	OUT_(0,'-----------------------------------------------------------------------');

	
	-- RESERVACION DE VUELOS | PASO 2
	-- Se inicia con un usuario elegido aleatoriamente.
	OPEN c_usuarios(cant_users_a_reservar);
	FETCH c_usuarios INTO v_usuario;
	WHILE ( cant_users_a_reservar > 0 ) LOOP

		SELECT * INTO v_cliente_usuario FROM Cliente WHERE id = v_usuario.fk_cliente; 

		OUT_(2,'USUARIO ('|| i_u ||') | ' || v_cliente_usuario.primer_nombre || ' ' || v_cliente_usuario.primer_apellido || ' (id: '|| v_usuario.id ||')');

		SELECT COUNT(CLI.id) INTO cant_acompanantes_usuario -- Los familiares
		FROM Cliente CLI WHERE CLI.fk_cliente = v_usuario.fk_cliente;

		-- RESERVACION DE VUELOS | PASO 3
		-- Se genera un número aleatorio para la cantidad estimada de acompañantes en el viaje.
		cant_estimada_acompanantes := TRUNC( DBMS_RANDOM.VALUE(0,cant_acompanantes_usuario) );

		-- RESERVACION DE VUELOS | PASO 4
		-- Se eligen aleatoriamente los posibles acompañantes.
		OPEN c_acompanantes(v_usuario, cant_acompanantes_usuario);
		consegui := FALSE;
		WHILE (NOT consegui) LOOP 
			-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 1
			-- Inicia conociéndose el origen del usuario y el destino deseado, así como la fecha de salida y en caso de que desee retornar, la fecha de regreso en que desea viajar. 
			origen := GET_DESTINO;  
			destino := GET_DESTINO(origen.id);
			
			-- ! FALTA: FECHAS CHOCANDO
			fecha_reservacion := TIEMPO_PKG.RANDOM(fq);
			fecha_salida := TIEMPO_PKG.RANDOM(PERIODO(
				fecha_reservacion, fg.fecha_fin
			));
			fecha_viaje := PERIODO( 
				fecha_salida, 
				TIEMPO_PKG.RANDOM(PERIODO(fecha_salida, fg.fecha_fin)) 
			);

			es_ida_vuelta := 'T';
			IF ( DBMS_RANDOM.VALUE > 0.5 ) 
				THEN es_ida_vuelta := 'F';
				fecha_viaje.fecha_fin := NULL;
			END IF;

			-- fecha_viaje := generar_fecha_viaje(v_usuario, fecha_reservacion, fg );

			-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 2
			-- Se elige aleatoriamente uno de los criterios de selección de ruta de vuelo. Se toma en cuenta la cantidad de acompañantes.
			IF ( DBMS_RANDOM.VALUE > 0.5 ) THEN 
				criterio_vuelo := 'MAS_BARATA';
				clase_de_asiento := 'ECONOMICA'; 
			ELSE 
				criterio_vuelo := 'LLEGADA_MAS_TEMPRANA'; 
				clase_aletorio := DBMS_RANDOM.VALUE;
				IF ( clase_aletorio < 0.333) THEN
					clase_de_asiento := 'ECONOMICA'; 
				ELSIF ( clase_aletorio >= 0.333 AND clase_aletorio <= 0.667 ) THEN
					clase_de_asiento := 'EJECUTIVA'; 
				ELSE 
					clase_de_asiento := 'PRIMERA_CLASE'; 
				END IF;
			END IF;

			-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 3
			-- Se consultan los vuelos disponibles para las fecha indicadas con las diferentes posibilidades de viajes directos o con escala.
			ruta_viaje (
				mi_cursor => c_vuelos,
				ciudad_origen_id => origen.id,
				ciudad_destino_id => destino.id,
				orden_por => criterio_vuelo,
				fecha_deseada => fecha_viaje.fecha_inicio,
				dias_max_volando => 1,
				rango_dias_aceptable => 1,
				limite_rows => 1
			);		
	
			-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 4
			-- Se reserva el o los vuelos en función del criterio de selección de ruta de vuelo al usuario y los acompañantes.
			FETCH c_vuelos INTO 
				origen1,
				v1id, v1e, v1fi, v1ff,
				destino1,
				v2id, v2e, v2fi, v2ff,
				destino2,
				v3id, v3e, v3fi, v3ff,
				destino3,
				costo_total,
				fecha_final
			;

			IF ( es_ida_vuelta = 'T' ) THEN
				ruta_viaje (
					mi_cursor => c_r_vuelos,
					ciudad_origen_id => destino.id,
					ciudad_destino_id => origen.id,
					orden_por => criterio_vuelo,
					fecha_deseada => fecha_viaje.fecha_fin,
					dias_max_volando => 1,
					rango_dias_aceptable => 1,
					limite_rows => 1
				);		

				FETCH c_r_vuelos INTO 
					r_origen1,
					r_v1id, r_v1e, r_v1fi, r_v1ff,
					r_destino1,
					r_v2id, r_v2e, r_v2fi, r_v2ff,
					r_destino2,
					r_v3id, r_v3e, r_v3fi, r_v3ff,
					r_destino3,
					r_costo_total,
					r_fecha_final
				;
			ElSE
				r_v1id := NULL;
				r_v2id := NULL;
				r_v3id := NULL;
			END IF;

			IF (v1id IS NOT NULL AND 
				(
					(r_v1id IS NULL AND es_ida_vuelta = 'F') OR
					(r_v1id IS NOT NULL AND es_ida_vuelta = 'T')
				)
			) THEN
				consegui := TRUE;

				WHILE (c_vuelos%FOUND) LOOP

					FETCH c_acompanantes INTO v_acompanante;
					WHILE (c_acompanantes%FOUND) LOOP
						-- PRINT ACOMPANANTES
							IF (c_acompanantes%ROWCOUNT > 1) THEN
								OUT_(3,'Acompanante ('||TO_CHAR(c_acompanantes%ROWCOUNT-1)||') | ' || v_acompanante.primer_nombre || ' ' || v_acompanante.primer_apellido || ' (id: '|| v_acompanante.id ||')' );
							END IF;

							IF (c_acompanantes%ROWCOUNT = 1) THEN
								-- RESERVACION PADRE
								reserva_padre_id := NULL;

								v_asiento := ASIENTO_RESERVAR(v1id,clase_de_asiento);
								INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida_vuelta,v_es_ida) 
									VALUES (DEFAULT, 'V', PRECIO_VUELO(v1id, clase_de_asiento, 1), 'F', fecha_reservacion, v1id, v_asiento.id, 
										reserva_padre_id, es_ida_vuelta, 'T'
									) RETURNING id INTO reservacion_id;
								OUT_(4,'Asiento vuelo 1: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
								INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);
							
								reserva_padre_id := reservacion_id;
							ELSE 
								v_asiento := ASIENTO_RESERVAR(v1id,clase_de_asiento);
								INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida) 
									VALUES (DEFAULT, 'V', PRECIO_VUELO(v1id, clase_de_asiento, 1), 'F', fecha_reservacion, v1id, v_asiento.id, 
										reserva_padre_id, 'T'
									) RETURNING id INTO reservacion_id;
								OUT_(4,'Asiento vuelo 1: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
								INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);
							END IF;

							IF ( v2id IS NOT NULL ) THEN
								v_asiento := ASIENTO_RESERVAR(v2id,clase_de_asiento);
								INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida) 
								VALUES (DEFAULT, 'V', PRECIO_VUELO(v2id, clase_de_asiento, 1), 'F', fecha_reservacion, v2id, v_asiento.id, reserva_padre_id, 'T' ) RETURNING id INTO reservacion_id;
								OUT_(4,'Asiento vuelo 2: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
								INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);

								IF ( v3id IS NOT NULL ) THEN
									v_asiento := ASIENTO_RESERVAR(v3id,clase_de_asiento);
									INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida) 
									VALUES (DEFAULT, 'V', PRECIO_VUELO(v3id, clase_de_asiento, 1), 'F', fecha_reservacion, v3id, v_asiento.id, reserva_padre_id,  'T' ) RETURNING id INTO reservacion_id;
									OUT_(4,'Asiento vuelo 3: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
									INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);

								END IF;

							END IF;
						
						-- RESERVACIONES REGRESO
							IF (es_ida_vuelta = 'T') THEN
								v_asiento := ASIENTO_RESERVAR(r_v1id,clase_de_asiento);
								INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida) 
									VALUES (DEFAULT, 'V', PRECIO_VUELO(r_v1id, clase_de_asiento, 1), 'F', fecha_reservacion, r_v1id, v_asiento.id, 
										reserva_padre_id, 'F'
									) RETURNING id INTO reservacion_id;
								OUT_(4,'Asiento vuelo R_1: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
								INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);
							
								IF ( r_v2id IS NOT NULL ) THEN
									v_asiento := ASIENTO_RESERVAR(r_v2id,clase_de_asiento);
									INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida) 
										VALUES (DEFAULT, 'V', PRECIO_VUELO(v2id, clase_de_asiento, 1), 'F', fecha_reservacion, r_v2id, v_asiento.id, 
										reserva_padre_id, 'F'
									) RETURNING id INTO reservacion_id;
									OUT_(4,'Asiento vuelo R_2: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
									INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);

									IF ( r_v3id IS NOT NULL ) THEN
										v_asiento := ASIENTO_RESERVAR(r_v3id,clase_de_asiento);
										INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento, fk_reservacion, v_es_ida) 
											VALUES (DEFAULT, 'V', PRECIO_VUELO(v3id, clase_de_asiento, 1), 'F', fecha_reservacion, r_v3id, v_asiento.id, 
											reserva_padre_id , 'F'
										) RETURNING id INTO reservacion_id;
										OUT_(4,'Asiento vuelo R_3: ' || SUBSTR(clase_de_asiento,0,3) ||'-' || v_asiento.fila || v_asiento.columna);
										INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);

									END IF;
								END IF;
							END IF;

						FETCH c_acompanantes INTO v_acompanante;
					END LOOP;

					-- PRINT IDA
						OUT_(3, 'TRAYECTO IDA');
						OUT_(4, 'Costo Total: ' || costo_total || ' | Fecha llegada final: ' || fecha_final );
						OUT_(4, 'VUELO 1:');
						OUT_(5,
							origen1 || ' - ' ||
							v1id || ' - ' || v1fi || ' - ' || v1ff || ' - ' ||
							destino1
						);

						IF ( v2id IS NOT NULL ) THEN
							OUT_(4, 'VUELO 2:');
							OUT_(5,
								destino1 || ' - ' ||
								v2id || ' - ' || v2fi || ' - ' || v2ff || ' - ' ||
								destino2
							);
							IF ( v3id IS NOT NULL ) THEN
								OUT_(4,'VUELO 3:');
								OUT_(5,
									destino2 || ' - ' ||
									v3id || ' - ' || v3fi || ' - ' || v3ff || ' - ' ||
									destino3
								);
							END IF;
						END IF;

					-- PRINT REGRESO
						IF (es_ida_vuelta = 'T') THEN
							OUT_(3, 'TRAYECTO REGRESO');
							OUT_(4, 'Costo Total: ' || r_costo_total || ' | Fecha llegada final: ' || r_fecha_final );
							OUT_(4, 'VUELO R_1:');
							OUT_(5,
								r_origen1 || ' - ' ||
								r_v1id || ' - ' || r_v1fi || ' - ' || r_v1ff || ' - ' ||
								r_destino1
							);

							IF ( r_v2id IS NOT NULL ) THEN
								OUT_(4, 'VUELO R_2:');
								OUT_(5,
									r_destino1 || ' - ' ||
									r_v2id || ' - ' || r_v2fi || ' - ' || r_v2ff || ' - ' ||
									r_destino2
								);
								IF ( r_v3id IS NOT NULL ) THEN
									OUT_(4,'VUELO R_3:');
									OUT_(5,
										r_destino2 || ' - ' ||
										r_v3id || ' - ' || r_v3fi || ' - ' || r_v3ff || ' - ' ||
										r_destino3
									);
								END IF;
							END IF;
						END IF;

					-- LIMPIAR VARIABLES
						v1id := NULL;
						v2id := NULL;
						v3id := NULL;

						r_v1id := NULL;
						r_v2id := NULL;
						r_v3id := NULL;

						FETCH c_vuelos INTO 
							origen1,
							v1id, v1e, v1fi, v1ff,
							destino1,
							v2id, v2e, v2fi, v2ff,
							destino2,
							v3id, v3e, v3fi, v3ff,
							destino3,
							costo_total,
							fecha_final
						; 
				END LOOP;
			END IF;
			CLOSE c_vuelos;
			IF (es_ida_vuelta = 'T') THEN CLOSE c_r_vuelos; END IF;
			
		END LOOP;
		
		IF (consegui = TRUE) THEN
			FETCH c_usuarios INTO v_usuario;
			cant_users_a_reservar := cant_users_a_reservar -1;
			i_u := i_u +1;
			OUT_(3,'VIAJE DESEADO: ' || origen.nombre || ' ---> ' || destino.nombre || ' | Salida: ' || TIEMPO_PKG.PRINT(fecha_salida,'FECHA') ||
				( CASE WHEN es_ida_vuelta='T' THEN ' | Regreso: ' || TIEMPO_PKG.PRINT(fecha_viaje.fecha_fin,'FECHA') ELSE ' | Sin regreso' END ));
			OUT_(4,'Reservacion: '||
				TIEMPO_PKG.PRINT(fecha_reservacion,'FECHA')
			);
			OUT_(0,'-----------------------------------------------------------------------');
			OUT_BREAK;
			CLOSE	c_acompanantes;
		END IF;
	END LOOP;
		
	-- RESERVACION DE VUELOS | PASO 6
	-- Se repiten los pasos del 2 al 5 tantas veces como cantidad de usuarios a reservar vuelos.

	CLOSE c_usuarios;

END;
/

-- EJECUTANDO
DECLARE
BEGIN
	DBMS_OUTPUT.ENABLE(NULL);
	SIM_CONFIGURACION(
		reset => 0,
		cant_users_a_reservar => 5
	);
	SIM_RESERVACION_DE_VUELOS(
		PERIODO(
			TIMESTAMP '2019-05-19 12:00:00',
			TIMESTAMP '2019-05-26 12:00:00'
		),
		PERIODO(
				TIMESTAMP '2019-11-01 11:24:50',
			TIMESTAMP '2020-01-31 06:47:15'
		)
	);
END;
/