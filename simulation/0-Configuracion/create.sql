CREATE TABLE Configuracion (
  id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
  nombre_variable VARCHAR2(50) NOT NULL,
  valor_numerico NUMBER,
  valor_string VARCHAR2(200),
  valor_fecha TIMESTAMP,

  CONSTRAINT configuracion_pk PRIMARY KEY (id)
);