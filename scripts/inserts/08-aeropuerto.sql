
-- DE AEROPUERTOS
	-- USAR IDs PRIMARY KEY ENTRE 11.500 EN ADELANTE
	-- CHICAGO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11500,'CALLE','5700 S Cicero Ave, Chicago, IL 60638, Estados Unidos', 9901, geolocalizacion(41.785972, -87.752417)); 
		INSERT INTO Aeropuerto (1,11500,'Aeropuerto Internacional Midway','MDW');
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11501,'CALLE','10000 W O Hare Ave, Chicago, IL 60666, Estados Unidos', 9901, geolocalizacion(41.978603,-87.904842)); 
		INSERT INTO Aeropuerto (2,11501,'Aeropuerto Internacional O Hare','ORD');
	-- NUEVA YORK
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11502,'CALLE','Queens, NY 11430, Estados Unidos', 10240, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (3,11502,'Aeropuerto Internacional John F. Kennedy','JFK');
	-- CIUDAD DE PANAMA 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11503,'CALLE','Avenida Domingo Díaz, Panamá', 8453, geolocalizacion(9.071364,-79.383453)); 
		INSERT INTO Aeropuerto (4,11503,'Aeropuerto Internacional de Tocumen Panamá','PTY');
	-- CARACAS  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11504,'CALLE','Calle Zara, Maiquetía 1162, Vargas', 10542, geolocalizacion(10.603117,-66.990583)); 
		INSERT INTO Aeropuerto (5,11504,'Aeropuerto Internacional Simón Bolívar','CCS');
	-- PORLAMAR  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11505,'CALLE','6320, Nueva Esparta', 10559, geolocalizacion(10.912926,-63.967581)); 
		INSERT INTO Aeropuerto (6,11505,'Aeropuerto Internacional General en Jefe Santiago Mariño','PMV');
	-- RIO DE JANEIRO 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11506,'CALLE','Av. Vinte de Janeiro - Ilha do Governador, Rio de Janeiro - RJ, 21941-900, Brasil', 5547, geolocalizacion(-22.808903,-43.243647)); 
		INSERT INTO Aeropuerto (7,11506,'Aeropuerto Internacional de Galeão','GIG');
	-- BUENOS AIRES 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11507,'CALLE','Av. Costanera Rafael Obligado, C1425 CABA, Argentina', 4855, geolocalizacion(-34.559175,-58.415606)); 
		INSERT INTO Aeropuerto (8,11507,'Aeroparque Internacional Jorge Newbery','AEP');
	-- TOKYO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11508,'CALLE','1-1 Furugome, Narita, Chiba 282-0004, Japón', 7507, geolocalizacion(35.764722,140.386389)); 
		INSERT INTO Aeropuerto (9,11508,'Aeropuerto Internacional de Narita','NRT');
	-- BEIJING  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11509,'CALLE','Shunyi, Beijing, China', 5944, geolocalizacion(40.080111,116.584556)); 
		INSERT INTO Aeropuerto (10,11509,'Aeropuerto Internacional de Pekín','PEK');
	-- SHANGHAI  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11510,'CALLE','', 6151, geolocalizacion(31.143378,121.805214)); 
		INSERT INTO Aeropuerto (11,11510,'Aeropuerto Internacional Pudong','PVG');
	-- NAIROBI  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11511,'CALLE','', 7632, geolocalizacion()); 
		INSERT INTO Aeropuerto (12,11511,'','JFK');
	-- JOHANNESBURGO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11512,'CALLE','', 10624, geolocalizacion()); 
		INSERT INTO Aeropuerto (13,11512,'','JFK');
	-- EL CAIRO 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11513,'CALLE','', 6639, geolocalizacion()); 
		INSERT INTO Aeropuerto (14,11513,'','JFK');
	-- MADRID  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11514,'CALLE','', 6688, geolocalizacion()); 
		INSERT INTO Aeropuerto (15,11514,'','JFK');
	-- BERLIN  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11515,'CALLE','', 6471, geolocalizacion()); 
		INSERT INTO Aeropuerto (16,11515,'','JFK');
	-- MOSCU  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11516,'CALLE','', 8923, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (17,11516,'','JFK');
	-- ROMA  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11517,'CALLE','', 5151, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (18,11517,'','JFK');
	-- PARIS  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11518,'CALLE','', 10726, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (19,11518,'','JFK');
	-- PARIS  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11519,'CALLE','', 10726, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (20,11519,'','JFK');
	-- AJACCIO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11520,'CALLE','', 6757, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (21,11520,'','JFK');
	-- SYDNEY  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11521,'CALLE','', 5165, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (22,11521,'','JFK');
	-- MELBOURNE 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11522,'CALLE','', 10726, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (23,11522,'','JFK');
	-- WELLINGTON 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11523,'CALLE','', 8392, geolocalizacion(  ,  )); 
		INSERT INTO Aeropuerto (24,11523,'','JFK');