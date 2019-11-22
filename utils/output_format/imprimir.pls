CREATE OR REPLACE PROCEDURE out_ (texto VARCHAR2)
	IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE( texto );
	END;

CREATE OR REPLACE PROCEDURE out_break (tamano INTEGER DEFAULT 1)
	IS
		i INTEGER;
	BEGIN
		FOR i IN 1..tamano LOOP
			DBMS_OUTPUT.NEW_LINE;
		END LOOP;
	END;

CREATE OR REPLACE PROCEDURE out_left (pad SMALLINT, texto VARCHAR2)
	IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE( LPAD( texto, pad ) );
	END;

CREATE OR REPLACE PROCEDURE out_right (pad SMALLINT, texto VARCHAR2)
	IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE( RPAD( texto, pad ) );
	END;

CREATE OR REPLACE FUNCTION out_space (pad SMALLINT) RETURN VARCHAR2
	IS
		resultado VARCHAR2(80)
	BEGIN
		resultado := RPAD( resultado, pad, ' ');
		RETURN resultado;
	END;