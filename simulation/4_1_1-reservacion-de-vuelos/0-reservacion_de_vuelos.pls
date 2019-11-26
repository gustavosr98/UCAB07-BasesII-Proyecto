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
		SELECT * FROM (
			SELECT * FROM Cliente CLI 
			WHERE CLI.fk_cliente = v_usuario.fk_cliente
			ORDER BY DBMS_RANDOM.VALUE
		) WHERE ROWNUM <= cant;
	v_acompanante CLIENTE%ROWTYPE;

	origen LUGAR%ROWTYPE;
	destino LUGAR%ROWTYPE;
	es_ida_vuelta CHAR(1);
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

		-- Escoger origen y destino aleatorio
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

		-- Definir si es ida vuelta
		es_ida_vuelta := 'F';
		IF ( DBMS_RANDOM.VALUE > 0.5 ) THEN es_ida_vuelta := 'T'; END IF;

		FETCH c_acompanantes INTO v_acompanante;
		WHILE (NOT(c_acompanantes%NOTFOUND)) LOOP
			OUT_(3,'Acompanante ('||c_acompanantes%ROWCOUNT||') | ' || v_acompanante.primer_nombre || ' ' || v_acompanante.primer_apellido || ' (id: '|| v_acompanante.id ||')' );
			FETCH c_acompanantes INTO v_acompanante;
		END LOOP;
		CLOSE	c_acompanantes;

		OUT_(3,'Viaje Deseado: ' || origen.nombre || ' ---> ' || destino.nombre || ' | Regreso (' || es_ida_vuelta ||')');

		
		OUT_BREAK();
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
			TIMESTAMP '19-09-19 12:00:00',
			TIMESTAMP '19-09-26 12:00:00'
		),
		PERIODO(
			TIMESTAMP '19-09-19 11:24:50',
			TIMESTAMP '20-03-20 06:47:15'
		)
	);
END;
/