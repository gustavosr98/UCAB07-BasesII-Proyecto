CREATE OR REPLACE PROCEDURE ins_clase_aerolinea
	IS
		cant_aerolineas INTEGER;
		i_a NUMBER;
		cant_clases INTEGER;
		i_c NUMBER;
		ultimo_porcentaje NUMBER := 1;
	BEGIN
		SELECT COUNT(*) INTO cant_aerolineas FROM Aerolinea; 
		SELECT COUNT(*) INTO cant_clases FROM Clase;
 		
		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.NEW_LINE;
		DBMS_OUTPUT.PUT_LINE('***************************************************************');
		DBMS_OUTPUT.PUT_LINE('************** PROCEDURE: INS_CLASE_AEROLINEA *****************');
		DBMS_OUTPUT.PUT_LINE('***************************************************************');
		DBMS_OUTPUT.NEW_LINE;

		IMPRIMIR_L(2,'cant_aerolineas: ' || cant_aerolineas);
		IMPRIMIR_L(2,'cant_clases: ' || cant_clases);
		DBMS_OUTPUT.NEW_LINE;

		FOR i_a IN 1..cant_aerolineas LOOP
			DBMS_OUTPUT.PUT_LINE(i_a);
		END LOOP;

	END;