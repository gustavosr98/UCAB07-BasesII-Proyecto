INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	1,
    'Juan',
    'Alejandro',
    'Rodriguez',
    'Hernandez',
    'M',
    '04142002345',    
    TO_DATE('20/06/1991', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	2,
    'Jose',
    'Angel',
    'Gomez',
    'Gomez',
    'M',
    '04164329956',    
    TO_DATE('17/03/1960', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	3,
    'Francisco',
    'Luis',
    'Lopez',
    'Bermudez',
    'M',
    '04123789666',    
    TO_DATE('10/01/1990', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento,fk_cliente) 
VALUES (
	4,
    'Maria',
    'Luisa',
    'Lopez',
    'Diaz',
    'F',
    '04123789666',    
    TO_DATE('02/02/2008', 'dd/mm/yyyy'),
    3
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	5,
    'Ana',
    'García',
    'F',
    '04126678998',    
    TO_DATE('13/04/1987', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,sexo,fecha_nacimiento,fk_cliente) 
VALUES (
	6,
    'Sebastián',
    'Jorge',
    'García',
    'M',
    TO_DATE('22/12/2009', 'dd/mm/yyyy'),
    5
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	7,
    'Gabriela',
    'Sosa',
    'Romero',
    'F',
    '04122998345',    
    TO_DATE('17/04/1991', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	8,
    'Isabella',
    'Sánchez',
    'Espino',
    'F',
    '04124567392',    
    TO_DATE('04/03/1980', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento,fk_cliente) 
VALUES (
	9,
    'Fernando',
    'Luis',
    'Sánchez',
    'Diaz',
    'M',
    '04247778354',   
    TO_DATE('01/11/1953', 'dd/mm/yyyy'),
    8
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	10,
    'Pedro',
    'Alberto',
    'Miranda',
    'M',
    '04145778624',    
    TO_DATE('02/04/1984', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	11,
    'Sara',
    'Rosa',
    'Lopez',
    'Ruiz',
    'F',
    '04122267943',    
    TO_DATE('25/10/1999', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento,fk_cliente) 
VALUES (
	12,
    'Luis',
    'Lopez',
    'Ruiz',
    'M',
    '04147764545',
    TO_DATE('30/01/2001', 'dd/mm/yyyy'),
    11
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	13,
    'Silvia',
    'Fernanda',
    'Martínez',
    'Blanco',
    'F',
    '04124678331',    
    TO_DATE('22/05/1973', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	14,
    'Rosa',
    'Pérez',
    'Torres',
    'F',
    '04124347659',    
    TO_DATE('09/09/1998', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	15,
    'Gerardo',
    'Sergio',
    'Suarez',
    'Gutiérrez',
    'M',
    '04123789666',    
    TO_DATE('07/06/1963', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	16,
    'Raquel',
    'Maria',
    'Muñoz',
    'Ortiz',
    'F',
    '04125566782',    
    TO_DATE('11/08/1990', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,fecha_nacimiento,fk_cliente) 
VALUES (
	17,
    'David',
    'Gabriel',
    'Muñoz',
    'Ortiz',
    'M',
    TO_DATE('11/08/2009', 'dd/mm/yyyy'),
    16
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	18,
    'Miguel',
    'Angel',
    'Andrade',
    'Mendez',
    'M',
    '04145319835',    
    TO_DATE('11/11/1997', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	19,
    'Mario',
    'Felix',
    'González',
    'Mendoza',
    'M',
    '04121258861',    
    TO_DATE('01/06/1970', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento,fk_cliente) 
VALUES (
	20,
    'Maria',
    'José',
    'Hernandez',
    'Avarez',
    'F',
    '04141147865',  
    TO_DATE('18/04/1972', 'dd/mm/yyyy'),
    19
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento,fk_cliente) 
VALUES (
	21,
    'Bianca',
    'González',
    'Hernandez',
    'F',
    '04243978542',    
    TO_DATE('09/10/2008', 'dd/mm/yyyy'),
    19
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento,fk_cliente) 
VALUES (
	22,
    'Felix',
    'González',
    'Acosta',
    'M',
    '04164784465', 
    TO_DATE('24/03/1950', 'dd/mm/yyyy'),
    19
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	23,
    'Sofia',
    'Amelia',
    'Figueroa',
    'Torres',
    'F',
    '04145683496',    
    TO_DATE('20/05/1980', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	24,
    'Santiago',
    'Matías',
    'Alvarado',
    'Blanco',
    'M',
    '04123578976',    
    TO_DATE('20/09/1997', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	25,
    'Hernando',
    'Castillo',
    'M',
    '04124561199',    
    TO_DATE('23/10/1990', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,sexo,fecha_nacimiento,fk_cliente) 
VALUES (
	26,
    'Lucia',
    'Ana',
    'Castillo',
    'F',
    TO_DATE('03/06/2010', 'dd/mm/yyyy'),
    25
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,sexo,fecha_nacimiento,fk_cliente) 
VALUES (
	27,
    'Valentina',
    'Camila',
    'Castillo',
    'F',
    TO_DATE('07/08/2012', 'dd/mm/yyyy'),
    25
);

INSERT INTO Cliente (
	id,primer_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	28,
    'Valeria',
    'Herrera',
    'Infante',
    'F',
    '04126329166',    
    TO_DATE('12/12/1996', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,telefono,fecha_nacimiento) 
VALUES (
	29,
    'Angel',
    'Lucas',
    'Jímenez',
    'León',
    'M',
    '04145523867',    
    TO_DATE('27/02/1984', 'dd/mm/yyyy')
);

INSERT INTO Cliente (
	id,primer_nombre,segundo_nombre,primer_apellido,segundo_apellido,sexo,fecha_nacimiento,fk_cliente) 
VALUES (
	30,
    'Ivan',
    'Oliver',
    'Jímenez',
    'León',
    'M',
    TO_DATE('23/12/2007', 'dd/mm/yyyy'),
    29
);