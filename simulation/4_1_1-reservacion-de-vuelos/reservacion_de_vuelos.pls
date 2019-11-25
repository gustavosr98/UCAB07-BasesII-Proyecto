CREATE OR REPLACE PROCEDURE sim_reservacion_de_vuelos (fb PERIODO)
IS
	cant_users_a_reservar INTEGER;
	cant_users INTEGER;

	min_user_id INTEGER;
	max_user_id INTEGER;

	user_id INTEGER;
	v_usuario USUARIO%ROWTYPE;
	--
	min_cliente_id INTEGER;
	max_cliente_id INTEGER;

	TYPE acompanantes IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
	cant_estimada_acompanantes INTEGER;
	lista_acompanantes ACOMPANANTES;
	acompanante_id INTEGER;
BEGIN

	SELECT COUNT(id) INTO cant_users FROM Usuario;
	SELECT MIN(id) INTO min_user_id FROM Usuario;
	SELECT MAX(id) INTO max_user_id FROM Usuario;
	SELECT MIN(id) INTO min_cliente_id FROM Cliente;
	SELECT MAX(id) INTO max_cliente_id FROM Cliente;

	cant_users_a_reservar := TRUNC( DBMS_RANDOM.VALUE(1,cant_users) );
	
	WHILE ( cant_users_a_reservar > 0 ) LOOP
		user_id := TRUNC( DBMS_RANDOM.VALUE(min_user_id,max_user_id) );
		SELECT * INTO v_usuario FROM Usuario WHERE id = user_id;
		-- OUT_(0,v_usuario.id);
		
		IF ( DBMS_RANDOM.VALUE(0,1) < 0.1 ) THEN
			cant_estimada_acompanantes := TRUNC( DBMS_RANDOM.VALUE(1,3) );
			WHILE ( cant_estimada_acompanantes > 0 ) LOOP
				acompanante_id := TRUNC( DBMS_RANDOM.VALUE(min_cliente_id,max_cliente_id) );
				IF ( acompanante_id != v_usuario.fk_cliente ) THEN
					lista_acompanantes(acompanante_id) := acompanante_id;
				END IF;
				cant_estimada_acompanantes := cant_estimada_acompanantes -1
			END LOOP;

		END IF;

		cant_users_a_reservar := cant_users_a_reservar -1;
	END LOOP;

END;
/

CREATE OR REPLACE PROCEDURE sim_reservacion_ruta_vuelo (
	fb PERIODO, origen_usuario INTEGER, destino_deseado INTEGER, x periodo
) IS
BEGIN

END;


-- EJECUTANDO
DECLARE
BEGIN
	sim_reservacion_de_vuelos(
			PERIODO(
			TIMESTAMP '19-09-19 11:24:50',
			TIMESTAMP '20-03-20 06:47:15'
	));
END;
/