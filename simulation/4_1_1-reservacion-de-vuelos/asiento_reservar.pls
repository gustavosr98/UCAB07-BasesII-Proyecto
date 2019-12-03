CREATE OR REPLACE FUNCTION asiento_reservar ( vuelo_id INTEGER, clase VARCHAR ) RETURN ASIENTO%ROWTYPE
IS
	avion_id INTEGER;
	clase_aero_id INTEGER;

	v_asiento ASIENTO%ROWTYPE;
BEGIN
	
	SELECT Av.id INTO avion_id 
	FROM Avion Av, Vuelo V
	WHERE V.fk_avion = Av.id 
		AND
		V.id = vuelo_id;
	
	SELECT CA.id INTO clase_aero_id 
	FROM Avion Av, Aerolinea AE, Clase_Aerolinea CA, Clase CL 
	WHERE 
		Av.fk_aerolinea = AE.id AND
		CA.fk_aerolinea = AE.id AND
		CA.fk_clase = Cl.id AND
		CL.nombre = clase
		AND
		Av.id = avion_id;

  SELECT * INTO v_asiento FROM ((
    SELECT Asi.* -- ESTOS SON TODOS 
    FROM Asiento Asi
    WHERE 
      Asi.fk_clase_aerolinea = clase_aero_id AND
      Asi.fk_avion = avion_id
  ) MINUS ( -- MENOS
    SELECT Asi.* -- LOS OCUPADOS 
    FROM Asiento Asi, Reservacion RV
    WHERE 
      RV.v_fk_asiento = Asi.id  
      AND
      Asi.fk_clase_aerolinea = clase_aero_id AND
      Asi.fk_avion = avion_id AND
      RV.v_fk_vuelo = vuelo_id
  )) TABLITA WHERE ROWNUM = 1
    ORDER BY fila, columna
  ;

	RETURN v_asiento;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    SELECT * INTO v_asiento FROM ((
      SELECT Asi.* -- ESTOS SON TODOS 
      FROM Asiento Asi
      WHERE 
        Asi.fk_avion = avion_id
    ) MINUS ( -- MENOS
      SELECT Asi.* -- LOS OCUPADOS 
      FROM Asiento Asi, Reservacion RV
      WHERE 
        RV.v_fk_asiento = Asi.id  
        AND
        Asi.fk_avion = avion_id AND
        RV.v_fk_vuelo = vuelo_id
    )) TABLITA WHERE ROWNUM = 1
      ORDER BY fila, columna
    ;
    RETURN v_asiento;

END;
/