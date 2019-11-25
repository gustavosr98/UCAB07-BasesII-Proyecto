CREATE OR REPLACE PROCEDURE ruta_viaje( mi_cursor OUT SYS_REFCURSOR, ciudad_origen_id INTEGER, ciudad_destino_id INTEGER, orden_por VARCHAR2, limite INTEGER DEFAULT 0 ) 
AS  
	col_order_by VARCHAR(50);
	limitante VARCHAR(50) DEFAULT ' ';
BEGIN
	IF (orden_por ='MENOR_DISTANCIA') THEN
		col_order_by := 'distancia_total';
	ELSIF (orden_por ='MENOS_PARADAS') THEN
		col_order_by := 't3id, t2id, t1id';
	END IF;

	IF ( limite != 0 ) THEN
		limitante := ' WHERE ROWNUM <= ' || TO_CHAR(limite) || ' ';
	END IF;

	OPEN mi_cursor FOR '
	SELECT * FROM
	(
	-- DIRECTO
		SELECT  
			LC_Origen1.nombre || '' ('' || Origen1.codigo_iata || '')'' origen1, T1.id t1id ,LC_Destino1.nombre || '' ('' || Destino1.codigo_iata || '')'' destino1,
				0 t2id,''NULL'' destino2,
				0 t3id,''NULL'' destino3,
				ROUND( T1.distancia.cantidad) distancia_total
		FROM 
			Trayecto T1, 
			Aeropuerto Origen1, Lugar L_Origen1, Lugar LC_Origen1, 
			Aeropuerto Destino1, Lugar L_Destino1, Lugar LC_Destino1
		WHERE 
			T1.fk_aeropuerto_origen = Origen1.id AND
			T1.fk_aeropuerto_destino = Destino1.id AND
			Origen1.fk_lugar = L_Origen1.id AND
			L_Origen1.fk_lugar = LC_Origen1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino1.fk_lugar = LC_Destino1.id 
			AND
			L_Origen1.fk_lugar = 5547 AND L_Destino1.fk_lugar = 10240
			
	UNION

	-- UNA ESCALA
		SELECT  
			LC_Origen1.nombre || '' ('' || Origen1.codigo_iata || '')'' origen1, T1.id t1id ,LC_Destino1.nombre || '' ('' || Destino1.codigo_iata || '')'' destino1,
			T2.id t2id, LC_Destino2.nombre || '' ('' || Destino2.codigo_iata || '')'' destino2,
			0 t3id,''NULL'' destino3,
			ROUND( T1.distancia.cantidad + T2.distancia.cantidad) distancia_total

		FROM 
			Trayecto T1, 
			Aeropuerto Origen1, Lugar L_Origen1, Lugar LC_Origen1, 
			Aeropuerto Destino1, Lugar L_Destino1, Lugar LC_Destino1,
			Trayecto T2, 
			Aeropuerto Destino2, Lugar L_Destino2, Lugar LC_Destino2
		WHERE 
			T1.fk_aeropuerto_origen = Origen1.id AND
			T1.fk_aeropuerto_destino = Destino1.id AND
			Origen1.fk_lugar = L_Origen1.id AND
			L_Origen1.fk_lugar = LC_Origen1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino1.fk_lugar = LC_Destino1.id 
			AND
			T2.fk_aeropuerto_origen = Destino1.id AND
			T2.fk_aeropuerto_destino = Destino2.id AND
			L_Destino1.fk_lugar = LC_Destino1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino2.fk_lugar = LC_Destino2.id AND
			Destino2.fk_lugar = L_Destino2.id 
			AND
			L_Origen1.fk_lugar = 5547 AND L_Destino2.fk_lugar = 10240

	UNION

	-- DOS PARADAS
		SELECT  
			LC_Origen1.nombre || '' ('' || Origen1.codigo_iata || '')'' origen1, T1.id t1id ,LC_Destino1.nombre || '' ('' || Destino1.codigo_iata || '')'' destino1,
			T2.id t2id, LC_Destino2.nombre || '' ('' || Destino2.codigo_iata || '')'' destino2,
			T3.id t3id, LC_Destino3.nombre || '' ('' || Destino3.codigo_iata || '')'' destino3,
			ROUND( T1.distancia.cantidad + T2.distancia.cantidad + T3.distancia.cantidad) distancia_total

		FROM 
			Trayecto T1, 
			Aeropuerto Origen1, Lugar L_Origen1, Lugar LC_Origen1, 
			Aeropuerto Destino1, Lugar L_Destino1, Lugar LC_Destino1,
			Trayecto T2, 
			Aeropuerto Destino2, Lugar L_Destino2, Lugar LC_Destino2,
			Trayecto T3,
			Aeropuerto Destino3, Lugar L_Destino3, Lugar LC_Destino3
		WHERE 
			T1.fk_aeropuerto_origen = Origen1.id AND
			T1.fk_aeropuerto_destino = Destino1.id AND
			Origen1.fk_lugar = L_Origen1.id AND
			L_Origen1.fk_lugar = LC_Origen1.id AND
			L_Destino1.fk_lugar = LC_Destino1.id AND
			Destino1.fk_lugar = L_Destino1.id 
			AND
			T2.fk_aeropuerto_origen = Destino1.id AND
			T2.fk_aeropuerto_destino = Destino2.id AND
			L_Destino1.fk_lugar = LC_Destino1.id AND
			Destino1.fk_lugar = L_Destino1.id AND
			L_Destino2.fk_lugar = LC_Destino2.id AND
			Destino2.fk_lugar = L_Destino2.id 
			AND
			T3.fk_aeropuerto_origen = Destino2.id AND
			T3.fk_aeropuerto_destino = Destino3.id AND
			L_Destino2.fk_lugar = LC_Destino2.id AND
			Destino2.fk_lugar = L_Destino2.id AND
			L_Destino3.fk_lugar = LC_Destino3.id AND
			Destino3.fk_lugar = L_Destino3.id 
			AND
			L_Origen1.fk_lugar = 5547 AND L_Destino3.fk_lugar = 10240
	) TABLITA ' 
	|| limitante
	|| ' ORDER BY ' || col_order_by;
END;



-- PROBANDO

DECLARE
  mi_cursor SYS_REFCURSOR;
  origen1 VARCHAR(100);
	t1id INTEGER;
	destino1 VARCHAR(100);
	t2id INTEGER;
	destino2 VARCHAR(100);
	t3id INTEGER;
	destino3 VARCHAR(100);
	distancia_total INTEGER;
BEGIN
  ruta_viaje (
		mi_cursor => mi_cursor,
		ciudad_origen_id => 0,
    ciudad_destino_id => 0,
		orden_por => 'MENOR_DISTANCIA',
		limite => 3
	);
  LOOP 
    FETCH mi_cursor INTO  
			origen1,
			t1id,
			destino1,
			t2id,
			destino2,
			t3id,
			destino3,
			distancia_total
		;

  	EXIT WHEN mi_cursor%NOTFOUND;
    OUT_(5,
			origen1 || ' | ' ||
			t1id || ' | ' ||
			destino1 || ' | ' ||
			t2id || ' | ' ||
			destino2 || ' | ' ||
			t3id || ' | ' ||
			destino3 || ' | ' ||
			distancia_total
		);
  END LOOP;
  CLOSE mi_cursor;
END;
