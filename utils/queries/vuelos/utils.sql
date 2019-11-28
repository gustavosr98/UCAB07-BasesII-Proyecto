-- 001 Cantidad de vuelos 
	SELECT COUNT(*) FROM VUELO;

-- 002 Cantidad de vuelos por trayecto 
	SELECT COUNT(*) FROM VUELO GROUP BY fk_trayecto;

-- 003 Cantidad de trayectos
	SELECT COUNT(*) FROM TRAYECTO;

-- 004 Cantidad de trayectos con vuelos 
	SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM VUELO GROUP BY fk_trayecto );