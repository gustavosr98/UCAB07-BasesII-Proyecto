
-- DE AEROPUERTOS
	-- USAR IDs PRIMARY KEY ENTRE 11.500 EN ADELANTE
	-- CHICAGO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11500,'CALLE','5700 S Cicero Ave, Chicago, IL 60638, Estados Unidos', 9901, geolocalizacion(41.785972, -87.752417)); 
		INSERT INTO Aeropuerto VALUES (1,11500,'Aeropuerto Internacional Midway','MDW');
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11501,'CALLE','10000 W O Hare Ave, Chicago, IL 60666, Estados Unidos', 9901, geolocalizacion(41.978603,-87.904842)); 
		INSERT INTO Aeropuerto VALUES (2,11501,'Aeropuerto Internacional O Hare','ORD');
	-- NUEVA YORK
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11502,'CALLE','Queens, NY 11430, Estados Unidos', 10240, geolocalizacion(40.639751,-73.778925)); 
		INSERT INTO Aeropuerto VALUES (3,11502,'Aeropuerto Internacional John F. Kennedy','JFK');
	-- CIUDAD DE PANAMA 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11503,'CALLE','Avenida Domingo Díaz, Panamá', 8453, geolocalizacion(9.071364,-79.383453)); 
		INSERT INTO Aeropuerto VALUES (4,11503,'Aeropuerto Internacional de Tocumen Panamá','PTY');
	-- CARACAS  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11504,'CALLE','Calle Zara, Maiquetía 1162, Vargas', 10542, geolocalizacion(10.603117,-66.990583)); 
		INSERT INTO Aeropuerto VALUES (5,11504,'Aeropuerto Internacional Simón Bolívar','CCS');
	-- PORLAMAR  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11505,'CALLE','6320, Nueva Esparta', 10559, geolocalizacion(10.912926,-63.967581)); 
		INSERT INTO Aeropuerto VALUES (6,11505,'Aeropuerto Int. Gral en Jefe Santiago Mariño','PMV');
	-- RIO DE JANEIRO 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11506,'CALLE','Av. Vinte de Janeiro - Ilha do Governador, Rio de Janeiro - RJ, 21941-900, Brasil', 5547, geolocalizacion(-22.808903,-43.243647)); 
		INSERT INTO Aeropuerto VALUES (7,11506,'Aeropuerto Internacional de Galeão','GIG');
	-- BUENOS AIRES 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11507,'CALLE','Av. Costanera Rafael Obligado, C1425 CABA, Argentina', 4855, geolocalizacion(-34.559175,-58.415606)); 
		INSERT INTO Aeropuerto VALUES (8,11507,'Aeroparque Internacional Jorge Newbery','AEP');
	-- TOKYO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11508,'CALLE','1-1 Furugome, Narita, Chiba 282-0004, Japón', 7507, geolocalizacion(35.764722,140.386389)); 
		INSERT INTO Aeropuerto VALUES (9,11508,'Aeropuerto Internacional de Narita','NRT');
	-- BEIJING  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11509,'CALLE','Shunyi, Beijing, China', 5944, geolocalizacion(40.080111,116.584556)); 
		INSERT INTO Aeropuerto VALUES (10,11509,'Aeropuerto Internacional de Pekín','PEK');
	-- SHANGHAI  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11510,'CALLE','S1 Yingbin Expy, Pudong, Shanghai, China', 6151, geolocalizacion(31.143378,121.805214)); 
		INSERT INTO Aeropuerto VALUES (11,11510,'Aeropuerto Internacional Pudong','PVG');
	-- NAIROBI  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11511,'CALLE','Airport N Rd, Embakasi, Nairobi, Kenia', 7632, geolocalizacion(-1.319167,36.9275)); 
		INSERT INTO Aeropuerto VALUES (12,11511,'Aeropuerto Internacional Jomo Kenyatta','NBO');
	-- JOHANNESBURGO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11512,'CALLE','1 Jones Rd, Kempton Park, Johannesburg, 1632, Sudáfrica', 10624, geolocalizacion(-26.139166,28.246)); 
		INSERT INTO Aeropuerto VALUES (13,11512,'Aeropuerto Internacional Oliver Reginald Tambo','JNB');
	-- EL CAIRO 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11513,'CALLE','Oruba, Road, El Nozha, Cairo Governorate, Egipto', 6639, geolocalizacion(30.121944,31.405556)); 
		INSERT INTO Aeropuerto VALUES (14,11513,'Aeropuerto Internacional de El Cairo','CAI');
	-- MADRID  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11514,'CALLE','Av de la Hispanidad, s/n, 28042 Madrid, España', 6688, geolocalizacion(40.493556,-3.566764)); 
		INSERT INTO Aeropuerto VALUES (15,11514,'Aeropuerto de Madrid Barajas Adolfo Suárez','MAD');
	-- BERLIN  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11515,'CALLE','Saatwinkler Damm, 13405 Berlin, Alemania', 6471, geolocalizacion(52.559686,13.287711)); 
		INSERT INTO Aeropuerto VALUES (16,11515,'Aeropuerto de Berlín Tegel','TXL');
	-- MOSCU  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11516,'CALLE','Khimki, Moscow Oblast, Rusia, 141400', 8923, geolocalizacion(55.972642,37.414589)); 
		INSERT INTO Aeropuerto VALUES (17,11516,'Aeropuerto Internacional de Moscú - Sheremétievo','SVO');
	-- ROMA  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11517,'CALLE','Via dell Aeroporto di Fiumicino, 00054 Fiumicino RM, Italia', 5151, geolocalizacion(41.804475,12.250797)); 
		INSERT INTO Aeropuerto VALUES (18,11517,'Aeropuerto de Roma - Fiumicino','FCO');
	-- PARIS  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11518,'CALLE','94390 Orly, Francia', 10726, geolocalizacion(48.725278,2.359444)); 
		INSERT INTO Aeropuerto VALUES (19,11518,'Aeropuerto de Paris - Orly','ORY');
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11519,'CALLE','95700 Roissy-en-France, Francia', 10726, geolocalizacion(49.012779,2.55)); 
		INSERT INTO Aeropuerto VALUES (20,11519,'Aeropuerto de París - Charles de Gaulle','CDG');
	-- AJACCIO  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11520,'CALLE','Route de Campo Dell Oro, 20090 Ajaccio, Francia', 6757, geolocalizacion(41.923637,8.802917)); 
		INSERT INTO Aeropuerto VALUES (21,11520,'Aeropuerto de Ajaccio - Napoleón Bonaparte','AJA');
	-- SYDNEY  
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11521,'CALLE','Sydney NSW 2020, Australia', 5165, geolocalizacion(-33.946111,151.177222)); 
		INSERT INTO Aeropuerto VALUES (22,11521,'Aeropuerto Internacional Kingsford Smith','SYD');
	-- MELBOURNE 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11522,'CALLE','Departure Dr, Melbourne Airport VIC 3045, Australia', 10726, geolocalizacion(-37.673333,144.843333)); 
		INSERT INTO Aeropuerto VALUES (23,11522,'Aeropuerto Internacional de Melbourne','MEL');
	-- WELLINGTON 
		INSERT INTO Lugar(id,tipo,nombre,fk_lugar,localizacion) VALUES (11523,'CALLE','Stewart Duff Drive, Rongotai, Wellington 6022, Nueva Zelanda', 8392, geolocalizacion(-41.327221,174.805278)); 
		INSERT INTO Aeropuerto VALUES (24,11523,'Aeropuerto Internacional de Wellington','WLG');