CREATE OR REPLACE PROCEDURE ins_proveedor_vehiculo IS
BEGIN
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Hertz',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/01-hertz.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Carrent',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/02-carrent.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('CarRental',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/03-carrental.jpg'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Budget',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/04-budget.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Avis',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/05-avis.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Amigos CarRental',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/06-amigoscarrental.jpg'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('DG Automoviles',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/07-dgautomoviles.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('TakeCar',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/08-takecar.jpg'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('RentaFacil',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/09-rentafacil.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Alamo',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/10-alamo.jpg'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Europcar',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/11-europcar.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('GoldCar',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/12-goldcar.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Vaya',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/13-vayacarrental.jpg'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('Payless',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/14-payless.png'));
    INSERT INTO proveedor_vehiculo(nombre,logo) VALUES('FireFly',BFILENAME('DIR_IMG_PROYECTO','/Proveedor_Vehiculo/15-firefly.jpg'));
END;