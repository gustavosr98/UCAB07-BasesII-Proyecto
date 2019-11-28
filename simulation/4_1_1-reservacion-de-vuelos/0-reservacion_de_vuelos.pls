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
  mi_cursor SYS_REFCURSOR;
	
  origen1 LUGAR.NOMBRE%TYPE;
	v1id INTEGER; v1e VUELO.ESTATUS%TYPE; v1fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v1ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
	destino1 LUGAR.NOMBRE%TYPE;
	v2id INTEGER; v2e VUELO.ESTATUS%TYPE; v2fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v2ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
	destino2 LUGAR.NOMBRE%TYPE;
	v3id INTEGER; v3e VUELO.ESTATUS%TYPE; v3fi VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE; v3ff VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
	destino3 LUGAR.NOMBRE%TYPE;
	costo_total NUMBER;
	fecha_final VUELO.PERIODO_ESTIMADO.fecha_inicio%TYPE;
BEGIN

	OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'************** SIMULACION: 4.1.1 RESERVA VUELOS ***************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

	SELECT COUNT(id) INTO cant_users FROM Usuario;

	-- RESERVACION DE VUELOS | PASO 1
	-- Se genera un número aleatorio para la cantidad de usuarios a reservar vuelos.
	cant_users_a_reservar := TRUNC( DBMS_RANDOM.VALUE(1,cant_users) );
	OUT_(2, 'Cant. usuarios a reservar vuelos: ' || cant_users_a_reservar);
	OUT_BREAK;
	
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
				9901,10240,8453,10542,10559,5547,4855,7507,5944,6151,7632,
				10624,6639,6688,6471,8923,5151,10726,6757,5165,5102,8392
			) ORDER BY DBMS_RANDOM.VALUE
		) WHERE ROWNUM = 1; 
		
		SELECT * INTO destino FROM ( 
			SELECT * FROM LUGAR
			WHERE id IN ( -- Ciudades que se decidieron para la simulacion
				9901,10240,8453,10542,10559,5547,4855,7507,5944,6151,7632,
				10624,6639,6688,6471,8923,5151,10726,6757,5165,5102,8392
			) AND id != origen.id
			ORDER BY DBMS_RANDOM.VALUE
		) WHERE ROWNUM = 1; 

		es_ida_vuelta := 'F';
		IF ( DBMS_RANDOM.VALUE > 0.5 ) THEN es_ida_vuelta := 'T'; END IF;
 
		fecha_reservacion := TIEMPO_PKG.RANDOM(fq); 
		fecha_salida := TIEMPO_PKG.RANDOM(PERIODO(
			fecha_reservacion, fg.fecha_fin
		));
		fecha_viaje := PERIODO( 
			fecha_salida, 
			TIEMPO_PKG.RANDOM(PERIODO(fecha_salida, fg.fecha_fin)) 
		);

		-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 2
		-- Se elige aleatoriamente uno de los criterios de selección de ruta de vuelo. Se toma en cuenta la cantidad de acompañantes.
		IF ( DBMS_RANDOM.VALUE > 0.5 ) THEN criterio_vuelo := 'MAS_BARATA'; ELSE criterio_vuelo := 'LLEGADA_MAS_TEMPRANA'; END IF;


		-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 3
		-- Se consultan los vuelos disponibles para las fecha indicadas con las diferentes posibilidades de viajes directos o con escala.
	/* 	ruta_viaje (
			mi_cursor => c_vuelos,
			ciudad_origen_id => origen.id,
			ciudad_destino_id => destino.id,
			orden_por => criterio_vuelo,
			fecha_deseada => fecha_salida, 
			dias_max_volando => 1000,
			rango_dias_aceptable => 1000,
			limite_rows => 1
		);		
 */
		-- RESERVACIÓN DE UNA RUTA DE VUELO | PASO 4
		-- Se reserva el o los vuelos en función del criterio de selección de ruta de vuelo al usuario y los acompañantes.
		/* FETCH c_vuelos INTO 
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
		WHILE (c_vuelos%FOUND) LOOP  */

			FETCH c_acompanantes INTO v_acompanante;
			WHILE (c_acompanantes%FOUND) LOOP
				IF (c_acompanantes%ROWCOUNT > 1) THEN
					OUT_(3,'Acompanante ('||c_acompanantes%ROWCOUNT||') | ' || v_acompanante.primer_nombre || ' ' || v_acompanante.primer_apellido || ' (id: '|| v_acompanante.id ||')' );
				END IF;
				FETCH c_acompanantes INTO v_acompanante;

					/* 	OUT_(5,
						costo_total || ' - ' ||
						fecha_final || ' - ' ||
						origen1 || ' - ' ||
						v1id || ' - ' || v1e || ' - ' || v1fi || ' - ' || v1ff || ' - ' ||
						destino1 || ' - ' ||
						v2id || ' - ' || v2e || ' - ' || v2fi || ' - ' || v2ff || ' - ' ||
						destino2 || ' - ' ||
						v3id || ' - ' || v3e || ' - ' || v3fi || ' - ' || v3ff || ' - ' ||
						destino3
					);
			END LOOP;

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
			; */
		END LOOP;
  	-- CLOSE c_vuelos;
		CLOSE	c_acompanantes;

		OUT_(3,'Viaje Deseado: ' || origen.nombre || ' ---> ' || destino.nombre || ' | Regreso (' || es_ida_vuelta ||')');
		OUT_(4,'Reservacion: '||
			TIEMPO_PKG.PRINT(fecha_reservacion,'FECHA') ||
			' | Salida: ' || TIEMPO_PKG.PRINT(fecha_salida,'FECHA') ||
			( CASE WHEN es_ida_vuelta='T' THEN ' | Regreso: ' || TIEMPO_PKG.PRINT(fecha_viaje.fecha_fin,'FECHA') ELSE ' | Sin regreso' END )
		);
		
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
	sim_reservacion_de_vuelos(
		PERIODO(
			TIMESTAMP '2019-09-19 12:00:00',
			TIMESTAMP '2019-09-26 12:00:00'
		),
		PERIODO(
			TIMESTAMP '2019-09-19 11:24:50',
			TIMESTAMP '2020-03-20 06:47:15'
		)
	);
END;
/