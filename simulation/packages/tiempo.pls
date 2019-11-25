CREATE OR REPLACE PACKAGE tiempo_pkg AS 
  FUNCTION random(rango PERIODO) RETURN TIMESTAMP; 
  FUNCTION diff(x TIMESTAMP, y TIMESTAMP, tipo VARCHAR2) RETURN NUMBER; 
END; 
/

CREATE OR REPLACE PACKAGE BODY tiempo_pkg AS
	-- TIEMPO.RANDOM 
		FUNCTION random(rango PERIODO) RETURN TIMESTAMP
		IS
			tiempo TIMESTAMP;
			diff INTEGER; 
			suma_o_resta NUMBER;
		BEGIN
			tiempo := TO_TIMESTAMP(
				TRUNC( DBMS_RANDOM.VALUE(
					TO_CHAR(rango.fecha_inicio,'J'),
					TO_CHAR(rango.fecha_fin,'J')
        )),'J'
      );
			diff := FLOOR(DBMS_RANDOM.VALUE(0, 43200)); 

			IF ( TO_CHAR(rango.fecha_fin,'J') - TO_CHAR(rango.fecha_inicio,'J') <= 1 ) THEN 
				tiempo := rango.fecha_inicio;
				suma_o_resta := 1;
				diff := FLOOR(DBMS_RANDOM.VALUE(
					0, 
					TIEMPO_PKG.DIFF( rango.fecha_inicio, rango.fecha_fin, 'SECOND')
				));
			ELSIF ( TO_CHAR(rango.fecha_inicio,'J') = TO_CHAR(tiempo,'J') ) THEN
				suma_o_resta := 1;
			ELSIF ( TO_CHAR(rango.fecha_fin,'J') = TO_CHAR(tiempo,'J')  ) THEN
				suma_o_resta := 0;
			ELSE 
				suma_o_resta := DBMS_RANDOM.VALUE(0,1);
			END IF;

			IF ( suma_o_resta > 0.5 ) THEN
				tiempo := tiempo + numToDSInterval( diff, 'SECOND' );
			ELSE
				tiempo := tiempo - numToDSInterval( diff, 'SECOND' );
			END IF;

			RETURN tiempo;
		END random;

	-- TIEMPO.DIFF
		FUNCTION diff(x TIMESTAMP, y TIMESTAMP, tipo VARCHAR2) RETURN NUMBER
		IS
		BEGIN
			IF (tipo = 'DAY') THEN
				RETURN TRUNC( 
					EXTRACT(day FROM (y-x)) 
				);
			ELSIF (tipo = 'HOUR') THEN
				RETURN TRUNC( 
					EXTRACT(day FROM (y-x))*24 
					+ EXTRACT(hour FROM (y-x)) 
				); 
			ELSIF (tipo = 'MINUTE') THEN
				RETURN TRUNC( 
					EXTRACT(day FROM (y-x))*24*60 
					+ EXTRACT(hour FROM (y-x))*60 
					+ EXTRACT(minute FROM (y-x))
				); 
			ELSE
				RETURN TRUNC( 
					EXTRACT(day FROM (y-x))*24*60*60 
					+ EXTRACT(hour FROM (y-x))*60*60 
					+ EXTRACT(minute FROM (y-x))*60 
					+ EXTRACT(second FROM (y-x))
				); 
			END IF;
		END diff; 

END tiempo_pkg;

-- EJECUTAR
	DECLARE
		x PERIODO;
	BEGIN
		OUT_BREAK(2);
		OUT_(0,'***************************************************************');
		OUT_(0,'********************* PACKAGE: TIEMPO_PKG **********************');
		OUT_(0,'***************************************************************');
		OUT_BREAK;

		x := PERIODO(
			TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-05-05 20:05:00'
		);
		
		OUT_(2,'TIEMPO_PKG.RANDOM(x) ---> ' || TO_CHAR(TIEMPO_PKG.RANDOM(x), 'YYYY-MM-DD HH24:MI:SS'));
		OUT_(2,'TIEMPO_PKG.DIFF(x.inicio, x.fin, "DAY") ---> ' || TIEMPO_PKG.DIFF(x.fecha_inicio,x.fecha_fin,'DAY'));
		OUT_(2,'TIEMPO_PKG.DIFF(x.inicio, x.fin, "SECOND") ---> ' || TIEMPO_PKG.DIFF(x.fecha_inicio,x.fecha_fin,'SECOND'));
	END;
	/