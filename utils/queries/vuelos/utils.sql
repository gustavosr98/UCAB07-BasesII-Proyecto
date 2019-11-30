-- 001 Cantidad de vuelos 
	SELECT COUNT(*) FROM VUELO;

-- 002 Cantidad de vuelos por trayecto 
	SELECT COUNT(*) FROM VUELO GROUP BY fk_trayecto;

-- 003 Cantidad de trayectos
	SELECT COUNT(*) FROM TRAYECTO;

-- 004 Cantidad de trayectos con vuelos 
	SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM VUELO GROUP BY fk_trayecto );

-- 005 Ciudades Origenes de Trayectos
	SELECT DISTINCT L2.id, L2.nombre FROM LUGAR L1, LUGAR L2, AEROPUERTO A, TRAYECTO T
	WHERE
		T.fk_aeropuerto_origen = A.id AND
		A.fk_lugar = L1.id AND
		L1.fk_lugar = L2.id

-- 006 Ciudades Destino con trayecto desde un Origen
SELECT DISTINCT LC2.id, LC2.nombre FROM LUGAR L1, AEROPUERTO A1, AEROPUERTO A2, LUGAR L2, LUGAR LC2, TRAYECTO T
	WHERE
		T.fk_aeropuerto_origen = A1.id AND
		A1.fk_lugar = L1.id  AND
		L1.fk_lugar = 10542
		AND
		T.fk_aeropuerto_destino = A2.id AND
		A2.fk_lugar = L2.id AND
		L2.fk_lugar = LC2.id

-- 007 Direccion de Aeropuertos
	SELECT C.nombre, A.*  FROM AEROPUERTO A, LUGAR C
    WHERE A.fk_lugar = C.id