
-- TDAs
	-- TODO ??? Hacemos un TDA para BOOLEAN (no existe en Oracle) para que sea 0 o 1
	-- PERIODO
		CREATE OR REPLACE TYPE Periodo AS OBJECT (
			-- ! NOT NULL sin funcionar
			fecha_inicio TIMESTAMP,
			fecha_fin TIMESTAMP,
			
			STATIC FUNCTION validar_periodo( fecha_inicio TIMESTAMP, fecha_fin TIMESTAMP ) RETURN NUMBER, -- DEVUELVE 1 o 0
			MEMBER FUNCTION tiempo_promedio_trayecto( trayecto_id NUMBER ) RETURN NUMBER,
			MEMBER FUNCTION diferencia_de_tiempo RETURN NUMBER
		);

		CREATE OR REPLACE TYPE BODY Periodo AS
			STATIC FUNCTION validar_periodo( fecha_inicio TIMESTAMP, fecha_fin TIMESTAMP ) RETURN NUMBER IS
				var_temporal NUMBER;	
			BEGIN
				RETURN 1;
			END;

			MEMBER FUNCTION tiempo_promedio_trayecto( trayecto_id NUMBER ) RETURN NUMBER IS
				var_temporal NUMBER;	
			BEGIN
				RETURN 1;
			END;

			MEMBER FUNCTION diferencia_de_tiempo RETURN NUMBER IS
			BEGIN
				RETURN 1;
			END;
		END;

	-- UNIDAD
		CREATE OR REPLACE TYPE Unidad AS OBJECT (
			tipo VARCHAR2(50),
			-- ! CHECK ( tipo = 'LONGITUD' OR tipo = 'AREA' OR tipo = 'DIVISA' OR tipo = 'TIEMPO' OR tipo = 'VELOCIDAD'),
			nombre VARCHAR2(50),
			cantidad NUMBER,
			
			STATIC FUNCTION convertir( tipo VARCHAR2, cantidad_a NUMBER, unid_a VARCHAR2 , unid_b VARCHAR2 ) RETURN NUMBER
		);

		CREATE OR REPLACE TYPE BODY Unidad AS
			STATIC FUNCTION convertir( tipo VARCHAR2, cantidad_a NUMBER, unid_a VARCHAR2 , unid_b VARCHAR2 ) RETURN NUMBER IS
				var_temporal NUMBER;	
			BEGIN
				RETURN 1;
			END;
		END;

	-- GEOLOCALIZACION
		CREATE OR REPLACE TYPE Geolocalizacion AS OBJECT (
			latitud NUMBER,
			longitud NUMBER,
			
			MEMBER FUNCTION calcular_distancia( x GEOLOCALIZACION ) RETURN NUMBER
		);

		CREATE OR REPLACE TYPE BODY Geolocalizacion AS
			MEMBER FUNCTION calcular_distancia( x GEOLOCALIZACION ) RETURN NUMBER IS
				R CONSTANT NUMBER := 6371; -- RADIO DE TIERRA EN KM
				PI CONSTANT NUMBER := 3.141592654; 

				fi_1 NUMBER;
				fi_2 NUMBER;
				delta_fi NUMBER;
				delta_alfa NUMBER;

				var_a NUMBER;
				var_c NUMBER;
				var_d NUMBER;
			BEGIN
				fi_1 := (latitud)*(PI/180);
				fi_2 := (x.latitud)*(PI/180);
				delta_fi := (x.latitud-latitud)*(PI/180);
				delta_alfa := (x.longitud-longitud)*(PI/180);

				var_a := SIN(delta_fi/2) * SIN(delta_fi/2) + COS(fi_1) * COS(fi_2) * SIN(delta_alfa/2) * SIN(delta_alfa/2);
				var_c := 2 * ATAN2(SQRT(var_a), SQRT(1-var_a));

				var_d := R * var_c;
				-- DISTANCIA EN KM
				RETURN var_d;
			END;
		END;


-- TABLAS
	-- AVIONES
		-- TIPO_AVION
			CREATE TABLE Tipo_Avion (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,

				nombre VARCHAR2(50) NOT NULL,
				modelo VARCHAR2(50) NOT NULL,
				capacidad INTEGER NOT NULL,
				-- TODO Pendiente por cambiar a NOT NULL foto
				foto BLOB DEFAULT EMPTY_BLOB(),
				velocidad_max UNIDAD NOT NULL,
				alcance_max UNIDAD NOT NULL,
				altitud_max UNIDAD NOT NULL,
				envergadura UNIDAD NOT NULL,
				ancho_interior_cabina UNIDAD NOT NULL,
				altura_interior_cabina UNIDAD NOT NULL,

				CONSTRAINT tipo_avion_pk PRIMARY KEY (id)
			);

		-- AEROLINEA
			CREATE TABLE Aerolinea (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,

				nombre VARCHAR2(50) NOT NULL,
				tipo VARCHAR2(50) NOT NULL CHECK ( tipo = 'REGIONAL' OR tipo = 'RED' OR tipo = 'GRAN_ESCALA'),
				logo BLOB DEFAULT EMPTY_BLOB(),

				CONSTRAINT aerolinea_pk PRIMARY KEY (id)
			);
		
		-- AVION
			CREATE TABLE Avion (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_aerolinea NUMBER NOT NULL,
				fk_tipo_avion NUMBER NOT NULL,

				CONSTRAINT avion_pk PRIMARY KEY (id),
				CONSTRAINT avion_fk_aerolinea FOREIGN KEY (fk_aerolinea) REFERENCES Aerolinea(id),
				CONSTRAINT avion_fk_tipo_avion FOREIGN KEY (fk_tipo_avion) REFERENCES Tipo_Avion(id)
			);

		-- CLASE
			CREATE TABLE Clase (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				nombre VARCHAR2(50) NOT NULL,

				CONSTRAINT clase_pk PRIMARY KEY (id)
			);

		-- CLASE_AEROLINEA
			CREATE TABLE Clase_Aerolinea (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_aerolinea NUMBER NOT NULL,
				fk_clase NUMBER NOT NULL,

				porcentaje_extra NUMBER NOT NULL CHECK (porcentaje_extra >= 1),

				CONSTRAINT clase_aerolinea_pk PRIMARY KEY (id),
				CONSTRAINT clase_aerolinea_fk_aerolinea FOREIGN KEY (fk_aerolinea) REFERENCES Aerolinea(id),
				CONSTRAINT clase_aerolinea_fk_clase FOREIGN KEY (fk_clase) REFERENCES Clase(id),
				CONSTRAINT clase_aerolinea_unique UNIQUE (fk_aerolinea, fk_clase)
			);

		-- ASIENTO
			CREATE TABLE Asiento (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_avion NUMBER NOT NULL,
				fk_clase_aerolinea NUMBER NOT NULL,

				fila VARCHAR2(5) NOT NULL,
				columna VARCHAR2(5) NOT NULL,
				es_ventana CHAR(1) NOT NULL CHECK( es_ventana = 'T' OR es_ventana = 'F'),
				es_pasillo CHAR(1) NOT NULL CHECK( es_pasillo = 'T' OR es_pasillo = 'F'),
				es_de_emergencia CHAR(1) NOT NULL CHECK( es_de_emergencia = 'T' OR es_de_emergencia = 'F'),

				CONSTRAINT asiento_pk PRIMARY KEY (id),
				CONSTRAINT asiento_fk_avion FOREIGN KEY (fk_avion) REFERENCES Avion(id),
				CONSTRAINT asiento_fk_clase_aerolinea FOREIGN KEY (fk_clase_aerolinea) REFERENCES Clase_Aerolinea(id)
			);
		
	-- VUELOS
		-- LUGAR
			CREATE TABLE Lugar (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_lugar NUMBER,

				tipo VARCHAR2(50) NOT NULL CHECK( tipo = 'CALLE' OR tipo = 'CIUDAD' OR tipo = 'ESTADO' OR tipo = 'PAIS' OR tipo = 'CONTINENTE' ),
				-- ! TRIGGER para jerarquia 
				nombre VARCHAR2(150) NOT NULL,
				localizacion GEOLOCALIZACION,

				CONSTRAINT lugar_pk PRIMARY KEY (id),
				CONSTRAINT lugar_fk_lugar FOREIGN KEY (fk_lugar) REFERENCES Lugar(id)
			);

		-- AEROPUERTO
			CREATE TABLE Aeropuerto (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_lugar NUMBER NOT NULL UNIQUE,
				-- TODO: Aeropuerto va con calle 

				nombre VARCHAR2(50) NOT NULL,
				codigo_iata CHAR(3) NOT NULL UNIQUE,

				CONSTRAINT aeropuerto_pk PRIMARY KEY (id),
				CONSTRAINT aeropuerto_fk_lugar FOREIGN KEY (fk_lugar) REFERENCES Lugar(id)
			);
		
		-- TRAYECTO
			CREATE TABLE Trayecto (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_aeropuerto_origen NUMBER NOT NULL,
				fk_aeropuerto_destino NUMBER NOT NULL,

				distancia UNIDAD NOT NULL,

				CONSTRAINT trayecto_pk PRIMARY KEY (id),
				CONSTRAINT trayecto_fk_aeropuerto_origen FOREIGN KEY (fk_aeropuerto_origen) REFERENCES Aeropuerto(id),
				CONSTRAINT trayecto_fk_aeropuerto_destino FOREIGN KEY (fk_aeropuerto_destino) REFERENCES Aeropuerto(id)
			);

		-- VUELO
			CREATE TABLE Vuelo (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_avion NUMBER NOT NULL,
				fk_trayecto NUMBER NOT NULL,

				estatus VARCHAR2(20) NOT NULL CHECK ( estatus = 'NO_INICIADO' OR estatus = 'EN_TRANSITO' OR estatus = 'RETRASADO' OR estatus = 'EN_VUELO' OR estatus = 'COMPLETADO' ),
				precio_base UNIDAD NOT NULL,
				periodo_estimado PERIODO NOT NULL,
				periodo_real PERIODO,

				CONSTRAINT vuelo_pk PRIMARY KEY (id),
				CONSTRAINT vuelo_fk_avion FOREIGN KEY (fk_avion) REFERENCES Avion(id),
				CONSTRAINT vuelo_fk_trayecto FOREIGN KEY (fk_trayecto) REFERENCES Trayecto(id)
			);
	
	-- HABITACIONES
		-- ALOJAMIENTO
			CREATE TABLE Alojamiento (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,

				nombre VARCHAR2(50) NOT NULL,
				tipo VARCHAR2(20) NOT NULL CHECK ( tipo = 'HOTEL' OR tipo = 'APARTAMENTO' ),
				foto BLOB DEFAULT EMPTY_BLOB(),
				-- ! Trigger para (fecha_fundacion <= SYSDATE)
				fecha_fundacion DATE NOT NULL,
				
				CONSTRAINT alojamiento_pk PRIMARY KEY (id)
			);

		-- LUG_ALOJ
			CREATE TABLE Lug_Aloj (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_lugar NUMBER NOT NULL,
				-- ! Lugar debe ser calle
				fk_alojamiento NUMBER NOT NULL,

				-- ! Trigger para (hora_check_in > hora_check_out)
				hora_check_in INTEGER CHECK ( hora_check_in >= 0 AND hora_check_in < 24 ),
				hora_check_out INTEGER CHECK ( hora_check_out >= 0 AND hora_check_out < 24 ),

				CONSTRAINT lug_aloj_pk PRIMARY KEY (id),
				CONSTRAINT lug_aloj_fk_lugar FOREIGN KEY (fk_lugar) REFERENCES Lugar(id),
				CONSTRAINT lug_aloj_fk_alojamiento FOREIGN KEY (fk_alojamiento) REFERENCES Alojamiento(id)
			);

		-- HABITACION
			CREATE TABLE Habitacion (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				-- ! No estoy claro de las relacione debiles
				fk_lug_aloj NUMBER NOT NULL,

				-- TODO ??? Descripcion opcional
				descripcion VARCHAR2(250) NOT NULL,
				capacidad INTEGER NOT NULL CHECK (capacidad > 0),
				precio_base_noche UNIDAD,
				esta_disponible CHAR(1) NOT NULL CHECK ( esta_disponible = 'T' OR esta_disponible = 'F' ), 

				CONSTRAINT habitacion_pk PRIMARY KEY (id),
				CONSTRAINT habitacion_fk_lug_aloj FOREIGN KEY (fk_lug_aloj) REFERENCES Lug_Aloj(id)
			);

	-- VEHICULOS
		-- MODELO_VEHICULO
			CREATE TABLE Modelo_Vehiculo (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				
				foto BLOB DEFAULT EMPTY_BLOB(),
				tipo VARCHAR2(50) NOT NULL CHECK ( tipo = 'CAMIONETA' OR tipo = 'CARRO' OR tipo = 'VAN'),
				marca VARCHAR2(50) NOT NULL,
				nombre VARCHAR2(50) NOT NULL,
				-- ! Falta trigger año <= NOW()
				año INTEGER NOT NULL CHECK ( año > 1900 ),
				cantidad_personas INTEGER NOT NULL CHECK (cantidad_personas > 0),
				cantidad_puertas INTEGER NOT NULL CHECK (cantidad_puertas > 0 AND cantidad_puertas <= 6),
				capacidad_maleta INTEGER NOT NULL CHECK (capacidad_maleta > 0),
				es_automatico CHAR(1) NOT NULL CHECK ( es_automatico = 'T' OR es_automatico = 'F' ), 

				CONSTRAINT modelo_vehiculo_pk PRIMARY KEY (id)
			);
		
		-- PROVEEDOR_VEHICULO
			CREATE TABLE Proveedor_Vehiculo (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				
				nombre VARCHAR2(50) NOT NULL,
				logo BLOB DEFAULT EMPTY_BLOB(),

				CONSTRAINT proveedor_vehiculo_pk PRIMARY KEY (id)
			);

		-- VEHICULO
			CREATE TABLE Vehiculo (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_modelo_vehiculo NUMBER NOT NULL,
				fk_proveedor_vehiculo NUMBER NOT NULL,
				
				esta_disponible CHAR(1) NOT NULL CHECK ( esta_disponible = 'T' OR esta_disponible = 'F' ), 
				precio_por_dia UNIDAD NOT NULL,
				-- TODO ??? Ir pensando en como usar eso
				localizacion GEOLOCALIZACION,

				CONSTRAINT vehiculo_pk PRIMARY KEY (id),
				CONSTRAINT vehiculo_fk_modelo_vehiculo FOREIGN KEY (fk_modelo_vehiculo) REFERENCES Modelo_Vehiculo(id),
				CONSTRAINT vehiculo_fk_proveedor_vehiculo FOREIGN KEY (fk_proveedor_vehiculo) REFERENCES Proveedor_Vehiculo(id)
			);

		-- SUCURSAL
			CREATE TABLE Sucursal (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_lugar NUMBER,
				-- ! Lugar debe ser calle
				fk_proveedor_vehiculo NUMBER,

				CONSTRAINT sucursal_pk PRIMARY KEY (id),
				CONSTRAINT sucursal_fk_lugar FOREIGN KEY (fk_lugar) REFERENCES Lugar(id),
				CONSTRAINT sucursal_fk_proveedor_vehiculo FOREIGN KEY (fk_proveedor_vehiculo) REFERENCES Proveedor_Vehiculo(id)
			);
		
	-- SEGUROS
		-- ASEGURADORA
			CREATE TABLE Aseguradora (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				
				logo BLOB DEFAULT EMPTY_BLOB(),
				nombre VARCHAR2(50) NOT NULL,

				CONSTRAINT aseguradora_pk PRIMARY KEY (id)
			);
		
		-- SEGURO
			CREATE TABLE Seguro (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_aseguradora NUMBER,
				
				descripcion VARCHAR2(250) NOT NULL,
				valor_asegurado NUMBER NOT NULL,
				precio_por_dia UNIDAD NOT NULL,

				CONSTRAINT seguro_pk PRIMARY KEY (id),
				CONSTRAINT seguro_fk_aseguradora FOREIGN KEY (fk_aseguradora) REFERENCES Aseguradora(id)
			);

	-- CLIENTES
		-- CLIENTE
			CREATE TABLE Cliente (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_cliente NUMBER,
				
				primer_nombre VARCHAR2(50) NOT NULL,
				segundo_nombre VARCHAR2(50),
				primer_apellido VARCHAR2(50) NOT NULL,
				segundo_apellido VARCHAR2(50),
				sexo CHAR(1) NOT NULL CHECK (sexo = 'M' OR sexo = 'F'),
				telefono VARCHAR2(50),
				fecha_nacimiento DATE NOT NULL,

				CONSTRAINT cliente_pk PRIMARY KEY (id),
				CONSTRAINT cliente_fk_cliente FOREIGN KEY (fk_cliente) REFERENCES Cliente(id)
			);

		-- USUARIO
			CREATE TABLE Usuario (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_cliente NUMBER NOT NULL UNIQUE,
				
				foto BLOB DEFAULT EMPTY_BLOB(),
				correo VARCHAR2(50) NOT NULL UNIQUE,
				contraseña VARCHAR2(50) NOT NULL,

				CONSTRAINT usuario_pk PRIMARY KEY (id),
				CONSTRAINT usuario_fk_cliente FOREIGN KEY (fk_cliente) REFERENCES Cliente(id)
			);
		
		-- TARJETA
			CREATE TABLE Tarjeta  (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_usuario NUMBER NOT NULL,
				
				tipo VARCHAR2(10) NOT NULL CHECK (tipo = 'CREDITO' OR tipo = 'DEBITO'),
				banco VARCHAR2(50) NOT NULL,
				compañia VARCHAR2(50) NOT NULL,
				numero VARCHAR2(50) NOT NULL,

				CONSTRAINT tarjeta_pk PRIMARY KEY (id),
				CONSTRAINT tarjeta_fk_usuario FOREIGN KEY (fk_usuario) REFERENCES Usuario(id)
			);
			
	-- RESERVACIONES
		-- RESERVACION
			CREATE TABLE Reservacion  (
				-- GENERAL
					id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
					fk_reservacion NUMBER,

					tipo CHAR(1) CHECK (tipo = 'V' OR tipo = 'A' OR tipo = 'S' OR tipo = 'C'),
					-- V para vuelo y C para carro

					precio_total UNIDAD NOT NULL,
					esta_cancelada CHAR(1) NOT NULL CHECK( esta_cancelada = 'T' OR esta_cancelada = 'F' ),
					fecha_reservacion TIMESTAMP NOT NULL,

					CONSTRAINT reservacion_pk PRIMARY KEY (id),
					CONSTRAINT reservacion_fk_reservacion FOREIGN KEY (fk_reservacion) REFERENCES Reservacion(id),

				-- DE VUELO
					v_fk_asiento NUMBER,
					v_fk_vuelo NUMBER,

					v_es_ida CHAR(1) CHECK (v_es_ida = 'T' OR v_es_ida = 'F'),
					v_es_ida_vuelta CHAR(1) CHECK ( v_es_ida_vuelta = 'T' OR  v_es_ida_vuelta = 'F' ),

					CONSTRAINT reservacion_v_fk_asiento FOREIGN KEY (v_fk_asiento) REFERENCES Asiento(id),
					CONSTRAINT reservacion_v_fk_vuelo FOREIGN KEY (v_fk_vuelo) REFERENCES Vuelo(id),

				-- DE ALOJAMIENTO
					a_fk_habitacion NUMBER,

					a_puntuacion INTEGER CHECK ( a_puntuacion >= 1 AND a_puntuacion <= 10 ),
					a_periodo PERIODO,

					CONSTRAINT reservacion_a_fk_habitacion FOREIGN KEY (a_fk_habitacion) REFERENCES Habitacion(id),

				-- DE SEGURO
					s_fk_seguro NUMBER,

					s_periodo PERIODO,

					CONSTRAINT reservacion_s_fk_seguro FOREIGN KEY (s_fk_seguro) REFERENCES Seguro(id),
					
				-- DE VEHICULO
					c_fk_vehiculo NUMBER,
					c_fk_sucursal_inicio NUMBER,
					c_fk_sucursal_fin NUMBER,

					c_periodo PERIODO,

					CONSTRAINT reservacion_c_fk_vehiculo FOREIGN KEY (c_fk_vehiculo) REFERENCES Vehiculo(id),
					CONSTRAINT reservacion_c_fk_sucursal_inicio FOREIGN KEY (c_fk_sucursal_inicio) REFERENCES Sucursal(id),
					CONSTRAINT reservacion_c_fk_sucursal_fin FOREIGN KEY (c_fk_sucursal_fin) REFERENCES Sucursal(id)
			);
		
		-- RESERVA
			CREATE TABLE Reserva (
					id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
					fk_reservacion NUMBER NOT NULL,
					fk_cliente NUMBER NOT NULL,

					CONSTRAINT reserva_pk PRIMARY KEY (id),
					CONSTRAINT reserva_fk_reservacion FOREIGN KEY (fk_reservacion) REFERENCES Reservacion(id),
					CONSTRAINT reserva_fk_cliente FOREIGN KEY (fk_cliente) REFERENCES Cliente(id)
			);
			
	-- PAGOS
		-- PAGO
			CREATE TABLE Pago (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_reservacion NUMBER NOT NULL,
				fk_usuario NUMBER NOT NULL,
				fk_tarjeta NUMBER,

				pagado UNIDAD NOT NULL,

				CONSTRAINT pago_pk PRIMARY KEY (id),
				CONSTRAINT pago_fk_reservacion FOREIGN KEY (fk_reservacion) REFERENCES Reservacion(id),
				CONSTRAINT pago_fk_usuario FOREIGN KEY (fk_usuario) REFERENCES Usuario(id),
				CONSTRAINT pago_fk_tarjeta FOREIGN KEY (fk_tarjeta) REFERENCES Tarjeta(id)
			);

		-- HISTORICO_MILLA
			CREATE TABLE Historico_Milla (
				id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
				fk_pago NUMBER,
				fk_reservacion_vuelo NUMBER,

				cantidad NUMBER NOT NULL,
				fecha TIMESTAMP NOT NULL,

				CONSTRAINT historico_milla_pk PRIMARY KEY (id),
				CONSTRAINT historico_milla_fk_reservacion_vuelo FOREIGN KEY (fk_reservacion_vuelo) REFERENCES Reservacion(id),
				CONSTRAINT historico_milla_fk_pago FOREIGN KEY (fk_pago) REFERENCES Pago(id)
			);

-- VISTAS Y OTROS	
	-- VISTA_MILLAS
		-- ! Falta por hacer

	-- CONVERSION
		CREATE TABLE Conversion (
			id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,

			unidad_a VARCHAR2(50) NOT NULL,
			unidad_b VARCHAR2(50) NOT NULL,
			un_a_es_tantos_b NUMBER NOT NULL,
			tipo VARCHAR2(20) NOT NULL CHECK ( tipo = 'LONGITUD' OR tipo = 'AREA' OR tipo = 'DIVISA' OR tipo = 'TIEMPO' OR tipo = 'VELOCIDAD'),

			CONSTRAINT conversion_pk PRIMARY KEY (id)
		);