CREATE OR REPLACE FUNCTION get_precio_total(ini TIMESTAMP, fin TIMESTAMP, precio_noche UNIDAD)
RETURN UNIDAD
IS
    total NUMBER;
    uni UNIDAD;

BEGIN

    total := TIEMPO_PKG.DIFF(ini,fin,'DAY') * precio_noche.cantidad;

    uni := UNIDAD(
			'DIVISA',
            'DOLAR',
            total
		);    

    return uni;
END;