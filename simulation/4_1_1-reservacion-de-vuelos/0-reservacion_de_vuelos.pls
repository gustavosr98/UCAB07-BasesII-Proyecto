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

	v_asiento ASIENTO%ROWTYPE;

	-- RESERVACION
	reservacion_id INTEGER;
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

		-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 1
		-- Inicia conociéndose el origen del usuario y el destino deseado, así como la fecha de salida y en caso de que desee retornar, la fecha de regreso en que desea viajar. 
		SELECT * INTO origen FROM ( 
			SELECT * FROM LUGAR 
			WHERE id IN ( -- Ciudades que se decidieron para la simulacion
				SELECT DISTINCT L2.id FROM LUGAR L1, LUGAR L2, AEROPUERTO A, TRAYECTO T
				WHERE
					T.fk_aeropuerto_origen = A.id AND
					A.fk_lugar = L1.id AND
					L1.fk_lugar = L2.id
			) ORDER BY DBMS_RANDOM.VALUE
		) WHERE ROWNUM = 1; 
		
		SELECT * INTO destino FROM ( 
			SELECT * FROM LUGAR
			WHERE id IN ( -- Ciudades que se decidieron para la simulacion
				SELECT DISTINCT LC2.id FROM LUGAR L1, AEROPUERTO A1, AEROPUERTO A2, LUGAR L2, LUGAR LC2, TRAYECTO T
				WHERE
					T.fk_aeropuerto_origen = A1.id AND
					A1.fk_lugar = L1.id  AND
					L1.fk_lugar = origen.id
					AND
					T.fk_aeropuerto_destino = A2.id AND
					A2.fk_lugar = L2.id AND
					L2.fk_lugar = LC2.id
			) ORDER BY DBMS_RANDOM.VALUE
		) WHERE ROWNUM = 1; 

		es_ida_vuelta := 'F';
		IF ( DBMS_RANDOM.VALUE > 0.5 ) THEN es_ida_vuelta := 'T'; END IF;

		-- ! FALTA: FECHAS CHOCANDO
		fecha_reservacion := TIEMPO_PKG.RANDOM(fq);
		fecha_salida := TIEMPO_PKG.RANDOM(PERIODO(
			fecha_reservacion, fg.fecha_fin
		));
		fecha_viaje := PERIODO( 
			fecha_salida, 
			TIEMPO_PKG.RANDOM(PERIODO(fecha_salida, fg.fecha_fin)) 
		);
		-- fecha_viaje := generar_fecha_viaje(v_usuario, fecha_reservacion, fg );

		-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 2
		-- Se elige aleatoriamente uno de los criterios de selección de ruta de vuelo. Se toma en cuenta la cantidad de acompañantes.
		IF ( DBMS_RANDOM.VALUE > 0.5 ) THEN criterio_vuelo := 'MAS_BARATA'; ELSE criterio_vuelo := 'LLEGADA_MAS_TEMPRANA'; END IF;

		OUT_(3,'VIAJE DESEADO: ' || origen.nombre || ' ---> ' || destino.nombre || ' | Salida: ' || TIEMPO_PKG.PRINT(fecha_salida,'FECHA') ||
			( CASE WHEN es_ida_vuelta='T' THEN ' | Regreso: ' || TIEMPO_PKG.PRINT(fecha_viaje.fecha_fin,'FECHA') ELSE ' | Sin regreso' END ));
		OUT_(4,'Reservacion: '||
			TIEMPO_PKG.PRINT(fecha_reservacion,'FECHA')
		);

		-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 3
		-- Se consultan los vuelos disponibles para las fecha indicadas con las diferentes posibilidades de viajes directos o con escala.
		ruta_viaje (
			mi_cursor => c_vuelos,
			ciudad_origen_id => origen.id,
			ciudad_destino_id => destino.id,
			orden_por => criterio_vuelo,
			fecha_deseada => fecha_salida, 
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
		IF ( c_vuelos%NOTFOUND ) THEN
			WHILE (c_acompanantes%FOUND) LOOP
				IF (c_acompanantes%ROWCOUNT > 1) THEN
					OUT_(3,'Acompanante ('||c_acompanantes%ROWCOUNT||') | ' || v_acompanante.primer_nombre || ' ' || v_acompanante.primer_apellido || ' (id: '|| v_acompanante.id ||')' );
				END IF;
			END LOOP;
			OUT_(3,'No se encontraron vuelos disponibles');
		ELSE WHILE (c_vuelos%FOUND) LOOP

			FETCH c_acompanantes INTO v_acompanante;
			WHILE (c_acompanantes%FOUND) LOOP
				IF (c_acompanantes%ROWCOUNT > 1) THEN
					OUT_(3,'Acompanante ('||c_acompanantes%ROWCOUNT||') | ' || v_acompanante.primer_nombre || ' ' || v_acompanante.primer_apellido || ' (id: '|| v_acompanante.id ||')' );
				END IF;

				-- ! FALTA: REVISAR ANTES QUE HAYAN SUFICIENTES ASIENTOS
				v_asiento := ASIENTO_RESERVAR(v1id,'ECONOMICA'); -- ! FALTA OBTENER CLASE
				INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento) VALUES (DEFAULT, 'V', PRECIO_VUELO(v1id, 'ECONOMICA', 1), 'F', fecha_reservacion, v1id, v_asiento.id) RETURNING id INTO reservacion_id;
				OUT_(4,'Asiento vuelo 1: ' || 'E-' || v_asiento.fila || v_asiento.columna); -- ! PONERLE INICIAL DE CLASE
				INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);
				
				IF ( v2id IS NOT NULL ) THEN
					v_asiento := ASIENTO_RESERVAR(v2id,'ECONOMICA'); -- ! FALTA OBTENER CLASE
					INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento) VALUES (DEFAULT, 'V', PRECIO_VUELO(v2id, 'ECONOMICA', 1), 'F', fecha_reservacion, v2id, v_asiento.id) RETURNING id INTO reservacion_id;
					OUT_(4,'Asiento vuelo 2: ' || 'E-' || v_asiento.fila || v_asiento.columna); -- ! PONERLE INICIAL DE CLASE
					INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);

					IF ( v3id IS NOT NULL ) THEN
						v_asiento := ASIENTO_RESERVAR(v3id,'ECONOMICA'); -- ! FALTA OBTENER CLASE
						INSERT INTO RESERVACION (id,tipo, precio_total, esta_cancelada, fecha_reservacion, v_fk_vuelo, v_fk_asiento) VALUES (DEFAULT, 'V', PRECIO_VUELO(v3id, 'ECONOMICA', 1), 'F', fecha_reservacion, v3id, v_asiento.id) RETURNING id INTO reservacion_id;
						OUT_(4,'Asiento vuelo 3: ' || 'E-' || v_asiento.fila || v_asiento.columna); -- ! PONERLE INICIAL DE CLASE
						INSERT INTO RESERVA (id,fk_cliente,fk_reservacion) VALUES (DEFAULT, v_acompanante.id ,reservacion_id);

					END IF;

				END IF;

				FETCH c_acompanantes INTO v_acompanante;
			END LOOP;

			OUT_(3, 'TRAYECTO');
			OUT_(4, 'Costo Total: ' || costo_total || ' | Fecha llegada final: ' || fecha_final );
			OUT_(4, 'VUELO 1:');
			OUT_(5,
				origen1 || ' - ' ||
				v1id || ' - ' || v1e || ' - ' || v1fi || ' - ' || v1ff || ' - ' ||
				destino1
			);

      IF ( v2id IS NOT NULL ) THEN
        OUT_(4, 'VUELO 2:');
        OUT_(5,
          destino1 || ' - ' ||
          v2id || ' - ' || v2e || ' - ' || v2fi || ' - ' || v2ff || ' - ' ||
          destino2
        );
        IF ( v3id IS NOT NULL ) THEN
					OUT_(4,'VUELO 3:');
					OUT_(5,
						destino2 || ' - ' ||
						v3id || ' - ' || v3e || ' - ' || v3fi || ' - ' || v3ff || ' - ' ||
						destino3
					);
        END IF;
      END IF;


      v2id := NULL;
      v3id := NULL;
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
		END LOOP; END IF;
  	CLOSE c_vuelos;
		CLOSE	c_acompanantes;

		
		OUT_(0,'-----------------------------------------------------------------------');
		OUT_BREAK;
		FETCH c_usuarios INTO v_usuario;
		cant_users_a_reservar := cant_users_a_reservar -1;
		i_u := i_u +1;
	END LOOP;
	-- RESERVACION DE VUELOS | PASO 6
	-- Se repiten los pasos del 2 al 5 tantas veces como cantidad de usuarios a reservar vuelos.

	CLOSE c_usuarios;

END;
/

-- EJECUTANDO
DECLARE
BEGIN
	SIM_CONFIGURACION(
		reset => 1
		--cant_users_a_reservar => 8
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