CREATE OR REPLACE PROCEDURE ins_aseguradora IS
BEGIN
	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		1,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/01-Mapfre_Seguros.png'),
		'Mapfre Seguros'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		2,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/02-Banesco_Seguros.jpg'),
		'Banesco Seguros'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		3,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/03-Mercantil_Seguros.jpg'),
		'Mercantil Seguros'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		4,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/04-Seguros_La_Previsora.png'),
		'Seguros La Previsora'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		5,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/05-Seguros_Caracas_de_Liberty_Mutual.jpg'),
		'Seguros Caracas de Liberty Mutual'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		DEFAULT,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/06-Seguros_Horizonte.jpg'),
		'Seguros Horizonte'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		6,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/07-Seguros_Universitas.png'),
		'Seguros Universitas'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		7,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/08-Seguros_Qualitas.png'),
		'Seguros Qualitas'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		9,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/09-Seguros_La_Occidental.jpg'),
		'Seguros La Occidental'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		10,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/10-Seguros_Piramide.png'),
		'Seguros Pirámide'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		11,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/11-Seguros_Altamira.png'),
		'Seguros Altamira'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		12,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/12-Multinacional_de_Seguros.jpg'),
		'Multinacional de Seguros'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		13,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/13-Seguros_Constitucion.png'),
		'Seguros Constitución'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		14,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/14-Zurich_Insurance_Group.jpg'),
		'Zurich Insurance Group'
	);

	INSERT INTO Aseguradora (
		id,logo,nombre) 
	VALUES (
		15,
		BFILENAME('DIR_IMG_PROYECTO','aseguradora/15-MetLife.png'),
		'MetLife'
	);
END;