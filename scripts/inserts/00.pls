CREATE DIRECTORY DIR_IMG_PROYECTO AS 'C:/ProyectoBD';


--Limpiar buffer para logs
SET serveroutput ON SIZE unlimited;

BEGIN
    DBMS_OUTPUT.ENABLE(NULL);
END;


ALTER TABLE RESERVACION ADD v_es_ida CHAR(1) CHECK (v_es_ida = 'T' OR v_es_ida = 'F');


BEGIN
 -- DELETES
    DELETE FROM Conversion;
    DELETE FROM Historico_Milla;
    DELETE FROM Pago;
    DELETE FROM Reserva;
    DELETE FROM Reservacion;
    DELETE FROM Tarjeta;
    DELETE FROM Usuario;
    DELETE FROM Cliente;
    DELETE FROM Seguro;
    DELETE FROM Aseguradora;
    DELETE FROM Sucursal;
    DELETE FROM Vehiculo;
    DELETE FROM Proveedor_Vehiculo;
    DELETE FROM Modelo_Vehiculo;
    DELETE FROM Habitacion;
    DELETE FROM Lug_Aloj;
    DELETE FROM Alojamiento;
    DELETE FROM Vuelo;
    DELETE FROM Trayecto;
    DELETE FROM Aeropuerto;
    DELETE FROM Lugar;
    DELETE FROM Asiento;
    DELETE FROM Clase_Aerolinea;
    DELETE FROM Clase;
    DELETE FROM Avion;
    DELETE FROM Aerolinea;
    DELETE FROM Tipo_Avion;
END;

BEGIN
  INS_CLIENTE;
  INS_ASEGURADORA;
  INS_USUARIO;
END;

BEGIN
  -- INSERTS
    INS_TIPO_AVION;
    INS_AEROLINEA;

    INS_CLASE;
    INS_CLASE_AEROLINEA;
    -- INS_ASIENTO;
    INS_AVION;
END;


BEGIN
    INS_CONTINENTE;
    INS_PAIS;
    INS_ESTADO;
    INS_CIUDAD;
    INS_CALLE;
END;

BEGIN
    INS_AEROPUERTO;
    INS_TRAYECTO;
    INS_ALOJAMIENTO;
    INS_LUG_ALOJ;
END;

BEGIN
    INS_MODELO_VEHICULO;
    INS_PROVEEDOR_VEHICULO;
    INS_VEHICULO;
    INS_SUCURSAL;
END;

BEGIN
    INS_SEGURO;
END;

BEGIN
    INS_TARJETA;
    
    -- INS_RESERVACION;
    -- INS_RESERVA;
    -- INS_PAGO;
    -- INS_HISTORICO_MILLA;
END;


SELECT * FROM AEROLINEA;
