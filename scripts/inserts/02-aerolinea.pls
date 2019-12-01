CREATE OR REPLACE PROCEDURE ins_aerolinea IS
BEGIN	
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Aeropostal','REGIONAL',BFILENAME('DIR_IMG_PROYECTO','aerolinea/aeropostal.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Aerotuy','REGIONAL',BFILENAME('DIR_IMG_PROYECTO','aerolinea/aerotuy.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Aserca Airlines','REGIONAL',BFILENAME('DIR_IMG_PROYECTO','aerolinea/aserca.jpeg'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Venezolana','REGIONAL',BFILENAME('DIR_IMG_PROYECTO','aerolinea/venezolana.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Albatros','REGIONAL',BFILENAME('DIR_IMG_PROYECTO','aerolinea/albatros.jpeg'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Conviasa','RED',BFILENAME('DIR_IMG_PROYECTO','aerolinea/conviasa.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Laser Airlines','RED',BFILENAME('DIR_IMG_PROYECTO','aerolinea/laser.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Avior Airlines','RED',BFILENAME('DIR_IMG_PROYECTO','aerolinea/avior.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Rutaca Airlines','RED',BFILENAME('DIR_IMG_PROYECTO','aerolinea/rutaca.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Estelar','RED',BFILENAME('DIR_IMG_PROYECTO','aerolinea/estelar.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Copa Airlines','GRAN_ESCALA',BFILENAME('DIR_IMG_PROYECTO','aerolinea/copa.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('American Airlines','GRAN_ESCALA',BFILENAME('DIR_IMG_PROYECTO','aerolinea/american.jpeg'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Avianca','GRAN_ESCALA',BFILENAME('DIR_IMG_PROYECTO','aerolinea/avianca.png'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Wingo','GRAN_ESCALA',BFILENAME('DIR_IMG_PROYECTO','aerolinea/wingo.jpg'));
	INSERT INTO Aerolinea(nombre,tipo,logo) 
		VALUES('Air Europa','GRAN_ESCALA',BFILENAME('DIR_IMG_PROYECTO','aerolinea/aireuropa.png'));
END;
/