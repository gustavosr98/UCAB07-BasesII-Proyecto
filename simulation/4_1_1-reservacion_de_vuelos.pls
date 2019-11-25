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
				acompanante_id := TRUNC( DBMS_RANDOM.VALUE(1,cant_users) );
				IF ( acompanante_id != user_id) THEN
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


-- QUERY PODEROSO

-- DIRECTO
SELECT  
	Origen1.nombre origen1, T1.id t1id ,Destino1.nombre destino1,
    0 t2id,'NULL' destino2 --,
	-- Destino2.nombre destino2, '|('|| T3.id ||')->' ,Destino3.nombre destino3
FROM 
	Trayecto T1, 
	Aeropuerto Origen1, Lugar L_Origen1, 
	Aeropuerto Destino1, Lugar L_Destino1
WHERE 
	T1.fk_aeropuerto_origen = Origen1.id AND
	T1.fk_aeropuerto_destino = Destino1.id AND
	Origen1.fk_lugar = L_Origen1.id AND
	Destino1.fk_lugar = L_Destino1.id AND
	L_Origen1.fk_lugar = 5547 AND L_Destino1.fk_lugar = 10240
    
UNION

-- UNA ESCALA
SELECT  
	Origen1.nombre origen1, T1.id t1id ,Destino1.nombre destino1,
	T2.id t2id ,Destino2.nombre destino2
FROM 
	Trayecto T1, 
	Aeropuerto Origen1, Lugar L_Origen1, 
	Aeropuerto Destino1, Lugar L_Destino1,
	Trayecto T2, 
	Aeropuerto Destino2, Lugar L_Destino2
WHERE 
	T1.fk_aeropuerto_origen = Origen1.id AND
	T1.fk_aeropuerto_destino = Destino1.id AND
	Origen1.fk_lugar = L_Origen1.id AND
	Destino1.fk_lugar = L_Destino1.id 
	AND
	T2.fk_aeropuerto_origen = Destino1.id AND
	T2.fk_aeropuerto_destino = Destino2.id AND
	Destino1.fk_lugar = L_Destino1.id AND
	Destino2.fk_lugar = L_Destino2.id AND
	L_Origen1.fk_lugar = 5547 AND L_Destino2.fk_lugar = 10240
ORDER BY t2id;


	-- DIRECTO
/* SELECT  
	Origen1.nombre origen1, '|('|| T1.id ||')->',Destino1.nombre destino1,
	-- Destino1.nombre destino1, '|('|| T2.id ||')->',Destino2.nombre destino2--,
	-- Destino2.nombre destino2, '|('|| T3.id ||')->' ,Destino3.nombre destino3
FROM 
	Trayecto T1, 
	Aeropuerto Origen1, Lugar L_Origen1, 
	Aeropuerto Destino1, Lugar L_Destino1,
	Trayecto T2, 
	Aeropuerto Destino2, Lugar L_Destino2,
	--Trayecto T3, Aeropuerto Destino3, Lugar L_Destino3
WHERE 
	T1.fk_aeropuerto_origen = Origen1.id AND
	T1.fk_aeropuerto_destino = Destino1.id AND
	Origen1.fk_lugar = L_Origen1.id AND
	Destino1.fk_lugar = L_Destino1.id 
	
	AND (
		
		L_Origen1.fk_lugar = 5547 AND L_Destino1.fk_lugar = 10240
		-- CON UNA ESCALA
		
		-- CON DOS ESCALAS
	);
 */

/* 
	- **USA** | Chicago (5547) - Nueva York (10240)
- **Panamá** | Ciudad de Panamá (8453)
- **Venezuela** | Caracas (10542) - Porlamar (10559)
- **Brasil** | Rio de Janeiro (5547)
- **Argentina** | Buenos Aires (4855) */
	--