INSERT INTO Tipo_Avion (
	id,nombre,modelo,foto,velocidad_max,
	alcance_max,altitud_max,evergadura,
	ancho_interior_cabina,altura_interior_cabina) 
VALUES (
	DEFAULT,'Boeing','717-200',DEFAULT,
	UNIDAD('VELOCIDAD','MACH',0.656787),
	UNIDAD('LONGITUD','KILOMETRO',3815),
	UNIDAD('LONGITUD','KILOMETRO',12.100),
	UNIDAD('LONGITUD','METRO',28.5),
	UNIDAD('LONGITUD','METRO',3.145),
	UNIDAD('LONGITUD','METRO',2.012)	
);
