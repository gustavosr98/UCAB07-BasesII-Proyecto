CREATE OR REPLACE PROCEDURE sim_configuracion (
  reset INTEGER DEFAULT 0,
  -- 4.1.1 RESERVACION DE VUELO
    cant_users_a_reservar INTEGER DEFAULT 0
)
IS
BEGIN
  IF (reset = 1) THEN
    UPDATE CONFIGURACION 
    SET valor_numerico = NULL,
      valor_string = NULL,
      valor_fecha = NULL;
  END IF;

  IF (cant_users_a_reservar != 0) THEN
    UPDATE CONFIGURACION 
    SET valor_numerico = cant_users_a_reservar
    WHERE nombre_variable = 'cant_users_a_reservar';
  END IF;
END;
/