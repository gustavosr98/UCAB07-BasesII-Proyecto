--system_admin

GRANT CREATE SESSION TO system_admin;

--CRUD

GRANT SELECT ON AEROLINEA TO system_admin;
GRANT SELECT ON AVION TO system_admin;
GRANT SELECT ON TIPO_AVION TO system_admin;
GRANT SELECT ON ASIENTO TO system_admin;
GRANT SELECT ON CLASE_AEROLINEA TO system_admin;
GRANT SELECT ON CLASE TO system_admin;
GRANT SELECT ON TRAYECTO TO system_admin;
GRANT SELECT ON VUELO TO system_admin;
GRANT SELECT ON AEROPUERTO TO system_admin;
GRANT SELECT ON ASEGURADORA TO system_admin;
GRANT SELECT ON SEGURO TO system_admin;
GRANT SELECT ON LUGAR TO system_admin;
GRANT SELECT ON CLIENTE TO system_admin;
GRANT SELECT ON USUARIO TO system_admin;
GRANT SELECT ON PAGO TO system_admin;
GRANT SELECT ON HISTORICO_MILLA TO system_admin;
GRANT SELECT ON TARJETA TO system_admin;
GRANT SELECT ON RESERVACION TO system_admin;
GRANT SELECT ON VEHICULO TO system_admin;
GRANT SELECT ON PROVEEDOR_VEHICULO TO system_admin;
GRANT SELECT ON SUCURSAL TO system_admin;
GRANT SELECT ON HABITACION TO system_admin;
GRANT SELECT ON MODELO_VEHICULO TO system_admin;
GRANT SELECT ON ALOJAMIENTO TO system_admin;
GRANT SELECT ON LUG_ALOJ TO system_admin;

GRANT INSERT,UPDATE,DELETE ON AEROLINEA TO system_admin;
GRANT INSERT,UPDATE,DELETE ON AVION TO system_admin;
GRANT INSERT,UPDATE,DELETE ON TIPO_AVION TO system_admin;
GRANT INSERT,UPDATE,DELETE ON ASIENTO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON CLASE_AEROLINEA TO system_admin;
GRANT INSERT,UPDATE,DELETE ON CLASE TO system_admin;
GRANT INSERT,UPDATE,DELETE ON TRAYECTO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON VUELO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON AEROPUERTO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON ASEGURADORA TO system_admin;
GRANT INSERT,UPDATE,DELETE ON SEGURO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON LUGAR TO system_admin;
GRANT INSERT,UPDATE,DELETE ON CLIENTE TO system_admin;
GRANT INSERT,UPDATE,DELETE ON USUARIO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON PAGO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON HISTORICO_MILLA TO system_admin;
GRANT INSERT,UPDATE,DELETE ON TARJETA TO system_admin;
GRANT INSERT,UPDATE,DELETE ON RESERVACION TO system_admin;
GRANT INSERT,UPDATE,DELETE ON VEHICULO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON PROVEEDOR_VEHICULO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON SUCURSAL TO system_admin;
GRANT INSERT,UPDATE,DELETE ON HABITACION TO system_admin;
GRANT INSERT,UPDATE,DELETE ON MODELO_VEHICULO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON ALOJAMIENTO TO system_admin;
GRANT INSERT,UPDATE,DELETE ON LUG_ALOJ TO system_admin;

--ALTER

GRANT ALTER ON AEROLINEA TO system_admin;
GRANT ALTER ON AVION TO system_admin;
GRANT ALTER ON TIPO_AVION TO system_admin;
GRANT ALTER ON ASIENTO TO system_admin;
GRANT ALTER ON CLASE_AEROLINEA TO system_admin;
GRANT ALTER ON CLASE TO system_admin;
GRANT ALTER ON TRAYECTO TO system_admin;
GRANT ALTER ON VUELO TO system_admin;
GRANT ALTER ON AEROPUERTO TO system_admin;
GRANT ALTER ON ASEGURADORA TO system_admin;
GRANT ALTER ON SEGURO TO system_admin;
GRANT ALTER ON LUGAR TO system_admin;
GRANT ALTER ON CLIENTE TO system_admin;
GRANT ALTER ON USUARIO TO system_admin;
GRANT ALTER ON PAGO TO system_admin;
GRANT ALTER ON HISTORICO_MILLA TO system_admin;
GRANT ALTER ON TARJETA TO system_admin;
GRANT ALTER ON RESERVACION TO system_admin;
GRANT ALTER ON VEHICULO TO system_admin;
GRANT ALTER ON PROVEEDOR_VEHICULO TO system_admin;
GRANT ALTER ON SUCURSAL TO system_admin;
GRANT ALTER ON HABITACION TO system_admin;
GRANT ALTER ON MODELO_VEHICULO TO system_admin;
GRANT ALTER ON ALOJAMIENTO TO system_admin;
GRANT ALTER ON LUG_ALOJ TO system_admin;

--DROP

GRANT DROP ON AEROLINEA TO system_admin;
GRANT DROP ON AVION TO system_admin;
GRANT DROP ON TIPO_AVION TO system_admin;
GRANT DROP ON ASIENTO TO system_admin;
GRANT DROP ON CLASE_AEROLINEA TO system_admin;
GRANT DROP ON CLASE TO system_admin;
GRANT DROP ON TRAYECTO TO system_admin;
GRANT DROP ON VUELO TO system_admin;
GRANT DROP ON AEROPUERTO TO system_admin;
GRANT DROP ON ASEGURADORA TO system_admin;
GRANT DROP ON SEGURO TO system_admin;
GRANT DROP ON LUGAR TO system_admin;
GRANT DROP ON CLIENTE TO system_admin;
GRANT DROP ON USUARIO TO system_admin;
GRANT DROP ON PAGO TO system_admin;
GRANT DROP ON HISTORICO_MILLA TO system_admin;
GRANT DROP ON TARJETA TO system_admin;
GRANT DROP ON RESERVACION TO system_admin;
GRANT DROP ON VEHICULO TO system_admin;
GRANT DROP ON PROVEEDOR_VEHICULO TO system_admin;
GRANT DROP ON SUCURSAL TO system_admin;
GRANT DROP ON HABITACION TO system_admin;
GRANT DROP ON MODELO_VEHICULO TO system_admin;
GRANT DROP ON ALOJAMIENTO TO system_admin;
GRANT DROP ON LUG_ALOJ TO system_admin;

--GENERAL

GRANT CREATE TABLE TO system_admin;
GRANT CREATE ROLE TO system_admin;
GRANT CREATE USER TO system_admin;
GRANT DROP USER TO system_admin;
GRANT CREATE PROCEDURE TO system_admin;
GRANT CREATE TRIGGER TO system_admin;
GRANT CREATE VIEW TO system_admin;
GRANT CREATE SEQUENCE TO system_admin;