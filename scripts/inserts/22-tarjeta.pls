CREATE OR REPLACE PROCEDURE insertar_tarjeta
IS
    cant_user INTEGER DEFAULT 0;
    i_u INTEGER;

    cantid_tarj INTEGER DEFAULT 0;
    i_t INTEGER;

    TYPE tipoArray IS VARRAY(2) OF VARCHAR2(10);
    tipo tipoArray;
    TYPE bancoArray IS VARRAY(10) OF VARCHAR2(50);
    banco bancoArray;
    TYPE compañiaArray IS VARRAY(2) OF VARCHAR2(50);
    compañia compañiaArray;
    numero VARCHAR2(50);

    nbanco INTEGER;
    ntipo INTEGER;
    ncompañia INTEGER;

    cant_total INTEGER DEFAULT 0;
BEGIN
    OUT_BREAK(2);
	OUT_(0,'***************************************************************');
	OUT_(0,'******************** PROCEDURE: INSERTAR_TARJETA **************');
	OUT_(0,'***************************************************************');
	OUT_BREAK;

    tipo := tipoArray(
        'CREDITO',
        'DEBITO'
    );

    banco := bancoArray(
        'Banesco',
        'Banco Mercantil',
        'Banco Provincial',
        'Banco Venezolano de Crédito',
        'Banco de Venezuela',
        'Banco Exterior',
        'Bank of America',
        'JP Morgan Chase',
        'Banco Santander',
        'ICBC'
    );

    compañia := compañiaArray(
        'Visa',
        'MasterCard'
    );

    SELECT COUNT(id) INTO cant_user FROM Usuario;

    FOR i_u IN 1..cant_user LOOP
        cantid_tarj := ROUND( DBMS_RANDOM.VALUE(1,3) );
        FOR i_t IN 1..cantid_tarj LOOP
            ntipo := ROUND( DBMS_RANDOM.VALUE(1,2) );
            nbanco := ROUND( DBMS_RANDOM.VALUE(1,10) );
            ncompañia := ROUND( DBMS_RANDOM.VALUE(1,2) );
            numero := TO_CHAR( ROUND ( DBMS_RANDOM.VALUE(10000000000000000000,99999999999999999999) ), '99999999999999999999');
            INSERT INTO Tarjeta (fk_usuario, tipo, banco, compañia, numero)
                VALUES (
                    i_u,
                    tipo(ntipo),
                    banco(nbanco),
                    compañia(ncompañia),
                    numero);
            cant_total := cant_total + 1;
        END LOOP;
    END LOOP;

	OUT_(1,'--> Total de TARJETAS generadas: ' || cant_total);
END;