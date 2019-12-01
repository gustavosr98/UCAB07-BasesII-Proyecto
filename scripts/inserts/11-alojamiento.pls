CREATE OR REPLACE PROCEDURE ins_alojamiento
IS
BEGIN
    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Hilton Hotels & Resorts',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/01-Hilton_Hotels_&_Resorts.jpg'),
        TO_DATE('31/05/1919', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Eurobuilding',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/02-Eurobuilding.jpg'),
        TO_DATE('10/04/1990', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'InterContinental Hotels Group',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/03-InterContinental_Hotels_Group.jpg'),
        TO_DATE('15/04/2003', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'AccorHotels',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/04-AccorHotels.jpg'),
        TO_DATE('21/05/1967', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Meliá Hotels International',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/05-Melia_Hotels_International.jpg'),
        TO_DATE('03/08/1956', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'TUI Hotels & Resorts',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/06-TUI_Hotels_Resorts.png'),
        TO_DATE('09/10/1923', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Best Western International',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/07-Best_Western_International.jpg'),
        TO_DATE('15/07/1946', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Marriott International',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/08-Marriott_International.jpg'),
        TO_DATE('20/05/1927', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Barceló Hotels & Resorts',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/09-Barcelo_Hotels_Resorts.jpg'),
        TO_DATE('10/07/1931', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Iberostar Hotels & Resorts',
        'HOTEL',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/10-Iberostar_Hotels_Resorts.jpg'),
        TO_DATE('23/02/1956', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Suite de Lujo',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/11-Suite_de_Lujo.jpg'),
        TO_DATE('15/06/2016', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Loft de Lujo',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/12-Loft_de_Lujo.jpg'),
        TO_DATE('27/05/2012', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Apartamento en el Centro',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/13-Apartamento_Centro.jpg'),
        TO_DATE('04/01/2014', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Piso Tipo Estudio',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/14-Piso_Tipo_Estudio.jpg'),
        TO_DATE('15/12/2012', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Penthouse en el Centro',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/15-Penthouse_Centro.jpg'),
        TO_DATE('30/05/2011', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Loft con Terraza en el Centro',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/16-Loft_Terraza_Centro.jpg'),
        TO_DATE('24/03/2014', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Apartamento Espacioso y Exótico',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/17-Apartamento_Espacioso_Exotico.jpg'),
        TO_DATE('29/07/2009', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Estudio con Impresionante Vista',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/18-Estudio_Vista.jpg'),
        TO_DATE('22/09/2013', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Estudio en el Centro',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/19-Estudio_Centro.jpg'),
        TO_DATE('20/08/2010', 'dd/mm/yyyy')
    );

    INSERT INTO Alojamiento (
        id,nombre,tipo,foto,fecha_fundacion) 
    VALUES (
        DEFAULT,
        'Loft Espacioso con Escaleras',
        'APARTAMENTO',
        BFILENAME('DIR_IMG_PROYECTO','alojamiento/20-Loft_Escaleras.jpg'),
        TO_DATE('17/06/2012', 'dd/mm/yyyy')
    );
END;
/