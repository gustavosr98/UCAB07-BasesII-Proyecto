CREATE DIRECTORY DIR_IMG_PROYECTO AS 'C:/ProyectoBD';

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Boeing','717-200',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.656787),
	UNIDAD('LONGITUD','KILOMETRO',3815),
	UNIDAD('LONGITUD','KILOMETRO',12.100),
	UNIDAD('LONGITUD','METRO',28.5),
	UNIDAD('LONGITUD','METRO',3.145),
	UNIDAD('LONGITUD','METRO',2.012)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Airbus A340','-200',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.86),
	UNIDAD('LONGITUD','KILOMETRO',14100),
	UNIDAD('LONGITUD','KILOMETRO',12.500),
	UNIDAD('LONGITUD','METRO',60.3),
	UNIDAD('LONGITUD','METRO',4.217),
	UNIDAD('LONGITUD','METRO',2.201)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'McDonnell Douglas','MD-80',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.8),
	UNIDAD('LONGITUD','KILOMETRO',3300),
	UNIDAD('LONGITUD','KILOMETRO',11.7),
	UNIDAD('LONGITUD','METRO',54.6),
	UNIDAD('LONGITUD','METRO',3.112),
	UNIDAD('LONGITUD','METRO',2.1)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Embraer E-Jet','E170',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.82),
	UNIDAD('LONGITUD','KILOMETRO',3982),
	UNIDAD('LONGITUD','KILOMETRO',12.3),
	UNIDAD('LONGITUD','METRO',26),
	UNIDAD('LONGITUD','METRO',2.74),
	UNIDAD('LONGITUD','METRO',2)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Boeing','747-8',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.86),
	UNIDAD('LONGITUD','KILOMETRO',5462),
	UNIDAD('LONGITUD','KILOMETRO',11.3),
	UNIDAD('LONGITUD','METRO',68.4),
	UNIDAD('LONGITUD','METRO',6.1),
	UNIDAD('LONGITUD','METRO',2.01)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Boeing','VC-25A',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.92),
	UNIDAD('LONGITUD','KILOMETRO',13000),
	UNIDAD('LONGITUD','KILOMETRO',13),
	UNIDAD('LONGITUD','METRO',59.6),
	UNIDAD('LONGITUD','METRO',4.37),
	UNIDAD('LONGITUD','METRO',2.07)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Embraer','Phenom 100',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.7),
	UNIDAD('LONGITUD','KILOMETRO',2182),
	UNIDAD('LONGITUD','KILOMETRO',12.497),
	UNIDAD('LONGITUD','METRO',12.3),
	UNIDAD('LONGITUD','METRO',3.35),
	UNIDAD('LONGITUD','METRO',1.5)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'ICON','A5',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.142533),
	UNIDAD('LONGITUD','KILOMETRO',791),
	UNIDAD('LONGITUD','KILOMETRO',6),
	UNIDAD('LONGITUD','METRO',12.3),
	UNIDAD('LONGITUD','METRO',1.8),
	UNIDAD('LONGITUD','METRO',1.2)	
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Bombardier','CRJ200',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.81),
	UNIDAD('LONGITUD','KILOMETRO',3056),
	UNIDAD('LONGITUD','KILOMETRO',12.496),
	UNIDAD('LONGITUD','METRO',21.21),
	UNIDAD('LONGITUD','METRO',2.53),
	UNIDAD('LONGITUD','METRO',1.85)
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Ilyushin','Il-96',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.84),
	UNIDAD('LONGITUD','KILOMETRO',13500),
	UNIDAD('LONGITUD','KILOMETRO',13.1),
	UNIDAD('LONGITUD','METRO',60.11),
	UNIDAD('LONGITUD','METRO',5.7),
	UNIDAD('LONGITUD','METRO',1.99)
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Tupolev','Tu-204',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.728863),
	UNIDAD('LONGITUD','KILOMETRO',4300),
	UNIDAD('LONGITUD','KILOMETRO',12.1),
	UNIDAD('LONGITUD','METRO',41.8),
	UNIDAD('LONGITUD','METRO',3.57),
	UNIDAD('LONGITUD','METRO',2.16)
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Tupolev','Tu-214',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.733),
	UNIDAD('LONGITUD','KILOMETRO',4340),
	UNIDAD('LONGITUD','KILOMETRO',12.1),
	UNIDAD('LONGITUD','METRO',41.8),
	UNIDAD('LONGITUD','METRO',3.57),
	UNIDAD('LONGITUD','METRO',2.16)
);

INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Tupolev','Tu-204SM',
	BFILENAME('DIR_IMG_PROYECTO','Tipo_Avion/01-Boeing-717-200.jpg'),
	UNIDAD('VELOCIDAD','MACH',0.743),
	UNIDAD('LONGITUD','KILOMETRO',5800),
	UNIDAD('LONGITUD','KILOMETRO',12.2),
	UNIDAD('LONGITUD','METRO',41.8),
	UNIDAD('LONGITUD','METRO',3.57),
	UNIDAD('LONGITUD','METRO',2.16)
);

SELECT TA.id,TA.nombre,TA.modelo,TA.foto,TA.velocidad_max.cantidad,TA.
	alcance_max.cantidad,TA.altitud_max.cantidad,TA.evergadura.cantidad,TA.
	ancho_interior_cabina.cantidad,TA.altura_interior_cabina.cantidad 
FROM TIPO_AVION TA;