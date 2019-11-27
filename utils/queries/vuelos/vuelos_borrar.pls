DECLARE
vuelo_id INTEGER;
i INTEGER;
BEGIN
  FOR i IN 1..5000 LOOP
    SELECT * INTO vuelo_id FROM (
      SELECT id  FROM VUELO 
      ORDER BY DBMS_RANDOM.VALUE 
    ) WHERE ROWNUM = 1;
    DELETE FROM VUELO WHERE id = vuelo_id;
  END LOOP;
END;