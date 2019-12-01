CREATE OR REPLACE PACKAGE tiempo_pkg AS 
  FUNCTION random(rango PERIODO) RETURN TIMESTAMP; 
  FUNCTION diff(x TIMESTAMP, y TIMESTAMP, tipo VARCHAR2) RETURN NUMBER; 
  FUNCTION print(x TIMESTAMP, formato VARCHAR2) RETURN VARCHAR2; 
  FUNCTION extraer(x TIMESTAMP, tipo VARCHAR2) RETURN TIMESTAMP;
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

	-- TIEMPO.PRINT
		FUNCTION print(x TIMESTAMP, formato VARCHAR2) RETURN VARCHAR2
		IS
		BEGIN
			IF (formato = 'FECHA') THEN
				RETURN TO_CHAR(x, 'DD/MON/YYYY');
			ELSIF (formato = 'MUY_HUMANO') THEN
				RETURN TO_CHAR(x, 'DY DD/MON/YYYY');
			ELSIF (formato = 'HUMANO') THEN
				RETURN TO_CHAR(x, 'DY DD/MON/YYYY HH12:MI:SS AM');
			ELSIF (formato = 'JERARQUICO') THEN
				RETURN TO_CHAR(x, 'YYYY-MM-DD HH24:MI:SS');
			ELSIF (formato = 'HORA') THEN
				RETURN TO_CHAR(x, 'HH24:MI:SS');
			END IF;
		END print;

	-- TIEMPO.EXTRAER
		FUNCTION extraer(x TIMESTAMP, tipo VARCHAR2) RETURN TIMESTAMP
		IS
		BEGIN
			IF (tipo = 'DATE') THEN
				RETURN 
					TO_TIMESTAMP ( TO_CHAR(x,'YYYY-MM-DD') ,'YYYY-MM-DD');
			ELSIF (tipo = 'BORRAR_SEGUNDOS') THEN
				RETURN 
					TO_TIMESTAMP ( TO_CHAR(x,'YYYY-MM-DD HH24:MI')||':00' ,'YYYY-MM-DD HH24:MI:SS');
			END IF;
		END extraer; 

END tiempo_pkg;
/

-- EJECUTAR
	DECLARE
		x PERIODO;
		y PERIODO;
	BEGIN
		OUT_BREAK(2);
		OUT_(0,'***************************************************************');
		OUT_(0,'********************* PACKAGE: TIEMPO_PKG **********************');
		OUT_(0,'***************************************************************');
		OUT_BREAK;

		x := PERIODO(
			TIMESTAMP '2019-05-05 20:05:00',
			TIMESTAMP '2019-07-05 20:05:00'
		);

		OUT_(2,'TIEMPO_PKG.RANDOM(x) ---> ' || TO_CHAR(TIEMPO_PKG.RANDOM(x), 'YYYY-MM-DD HH24:MI:SS'));
		OUT_BREAK;
		
		OUT_(2,'TIEMPO_PKG.DIFF(x.fecha_inicio, x.fin, "DAY") ---> ' || TIEMPO_PKG.DIFF(x.fecha_inicio,x.fecha_fin,'DAY'));
		OUT_(2,'TIEMPO_PKG.DIFF(x.fecha_inicio, x.fin, "SECOND") ---> ' || TIEMPO_PKG.DIFF(x.fecha_inicio,x.fecha_fin,'SECOND'));
		OUT_BREAK;
		
		OUT_(2,'TIEMPO_PKG.PRINT(x.fecha_inicio, "FECHA") ---> ' || TIEMPO_PKG.PRINT(x.fecha_inicio, 'FECHA'));
		OUT_(2,'TIEMPO_PKG.PRINT(x.fecha_inicio, "MUY_HUMANO") ---> ' || TIEMPO_PKG.PRINT(x.fecha_inicio, 'MUY_HUMANO'));
		OUT_(2,'TIEMPO_PKG.PRINT(x.fecha_inicio, "HUMANO") ---> ' || TIEMPO_PKG.PRINT(x.fecha_inicio, 'HUMANO'));
		OUT_(2,'TIEMPO_PKG.PRINT(x.fecha_inicio, "JERARQUICO") ---> ' || TIEMPO_PKG.PRINT(x.fecha_inicio, 'JERARQUICO'));
		OUT_BREAK;
		

		y := PERIODO(
			TIMESTAMP '2019-05-05 02:15:37',
			TIMESTAMP '2019-05-05 20:40:09'
		);

		OUT_(2,'TIEMPO_PKG.EXTRAER(y.inicio, "DATE") ---> ' || TO_CHAR( TIEMPO_PKG.EXTRAER(y.fecha_inicio,'DATE') , 'YYYY-MM-DD HH24:MI:SS') );
		OUT_(5,'TIEMPO_PKG.EXTRAER(y.inicio, "BORRAR_SEGUNDOS") ---> ' || TO_CHAR( TIEMPO_PKG.EXTRAER(y.fecha_inicio,'BORRAR_SEGUNDOS') , 'YYYY-MM-DD HH24:MI:SS') );

		IF ( TIEMPO_PKG.EXTRAER(y.fecha_inicio,'DATE') = TIEMPO_PKG.EXTRAER(y.fecha_fin,'DATE') ) THEN
			OUT_(2,'TIEMPO_PKG.EXTRAER(y.inicio, "DATE") = TIEMPO_PKG.EXTRAER(y.inicio, "DATE") ---> TRUE');
		ELSE
			OUT_(2,'TIEMPO_PKG.EXTRAER(y.inicio, "DATE") = TIEMPO_PKG.EXTRAER(y.fin, "DATE") ---> FALSE');
		END IF;
	END;
	/