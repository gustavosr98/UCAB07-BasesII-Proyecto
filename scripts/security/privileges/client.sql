--client

GRANT CREATE SESSION TO client;

GRANT SELECT ON AEROLINEA TO client;
GRANT SELECT ON AVION TO client;
GRANT SELECT ON TIPO_AVION TO client;
GRANT SELECT ON ASIENTO TO client;
GRANT SELECT ON CLASE_AEROLINEA TO client;
GRANT SELECT ON CLASE TO client;
GRANT SELECT ON TRAYECTO TO client;
GRANT SELECT ON VUELO TO client;
GRANT SELECT ON AEROPUERTO TO client;
GRANT SELECT ON ASEGURADORA TO client;
GRANT SELECT ON SEGURO TO client;
GRANT SELECT ON LUGAR TO client;
GRANT SELECT ON CLIENTE TO client;
GRANT SELECT ON USUARIO TO client;
GRANT SELECT ON PAGO TO client;
GRANT SELECT ON HISTORICO_MILLA TO client;
GRANT SELECT ON TARJETA TO client;
GRANT SELECT ON RESERVACION TO client;
GRANT SELECT ON VEHICULO TO client;
GRANT SELECT ON PROVEEDOR_VEHICULO TO client;
GRANT SELECT ON SUCURSAL TO client;
GRANT SELECT ON HABITACION TO client;
GRANT SELECT ON MODELO_VEHICULO TO client;
GRANT SELECT ON ALOJAMIENTO TO client;
GRANT SELECT ON LUG_ALOJ TO client;

GRANT INSERT,UPDATE,DELETE ON CLASE_AEROLINEA TO client;
GRANT INSERT,UPDATE,DELETE ON CLIENTE TO client;
GRANT INSERT,UPDATE,DELETE ON USUARIO TO client;
GRANT INSERT ON PAGO TO client;
GRANT INSERT ON HISTORICO_MILLA TO client;
GRANT INSERT,UPDATE,DELETE ON TARJETA TO client;
GRANT INSERT,UPDATE ON RESERVACION TO client;