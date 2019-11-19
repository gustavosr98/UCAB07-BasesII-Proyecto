-- CREAR DIRECTORIO PARA INSERTAR BLOBS

CREATE DIRECTORY DIR_IMG as 'C:/blobs2';

select * from all_directories;

-- STORED PROCEDURES QUE INSERTAN

CREATE OR REPLACE PROCEDURE insertarAerolinea(nombre_p VARCHAR2, tipo_p VARCHAR2,imagen VARCHAR2)

IS

    v_blob blob;
    v_bfile bfile;

BEGIN

    insert into Aerolinea(nombre,tipo,logo) values(nombre_p,tipo_p,empty_blob()) returning logo into v_blob;
    v_bfile := bfilename('DIR_IMG',imagen);
    DBMS_LOB.OPEN(v_bfile,DBMS_LOB.LOB_READONLY);
    DBMS_LOB.LOADFROMFILE(v_blob,v_bfile,SYS.DBMS_LOB.GETLENGTH(v_bfile));
    DBMS_LOB.CLOSE(v_bfile);
    commit;

END;

-- INSERCIONES

    begin

        -- AEROLINEA

        insertarAerolinea('Aeropostal','REGIONAL','aeropostal.png');
        insertarAerolinea('Aerotuy','REGIONAL','aerotuy.png');
        insertarAerolinea('Aserca Airlines','REGIONAL','aserca.jpg');
        insertarAerolinea('Venezolana','REGIONAL','venezolana.png');
        insertarAerolinea('Albatros','REGIONAL','albatros.jpg');
        insertarAerolinea('Conviasa','RED','conviasa.jpg');
        insertarAerolinea('Laser Airlines','RED','laser.jpg');
        insertarAerolinea('Avior Airlines','RED','avior.jpg');
        insertarAerolinea('Rutaca Airlines','RED','rutaca.png');
        insertarAerolinea('Estelar','RED','estelar.jpg');
        insertarAerolinea('Copa Airlines','GRAN_ESCALA','copa.jpg');
        insertarAerolinea('American Airlines','GRAN_ESCALA','american.jpg');
        insertarAerolinea('Avianca','GRAN_ESCALA','avianca.jpg');
        insertarAerolinea('Wingo','GRAN_ESCALA','wingo.jpg');
        insertarAerolinea('Air Europa','GRAN_ESCALA','aireuropa.jpg');   

    end;

    select * from aerolinea
drop table aerolinea




            