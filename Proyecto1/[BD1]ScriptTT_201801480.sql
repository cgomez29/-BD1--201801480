/* Author: Cristian Gomez - 201801480 */
-- Borrado y creado de la tabla temporal 

DROP TABLE TEMPORARY;

SELECT COUNT(*) FROM TEMPORARY;

CREATE TABLE TEMPORARY(
    nombre_cliente          VARCHAR2(100),
    correo_cliente          VARCHAR2(100),
    cliente_activo          VARCHAR2(10),
    fecha_creacion          VARCHAR2(100),
    tienda_preferida        VARCHAR2(100),
    direccion_cliente       VARCHAR2(100),
    codigo_postal_cliente   VARCHAR2(100),
    ciudad_cliente          VARCHAR2(100),
    pais_cliente            VARCHAR2(100), 
    fecha_renta             VARCHAR2(100), 
    fecha_retorno           VARCHAR2(100), 
    monto_a_pagar           VARCHAR2(50),
    fecha_pago              VARCHAR2(100), 
    nombre_empleado         VARCHAR2(100),
    correo_empleado         VARCHAR2(100),
    empleado_activo         VARCHAR2(10),
    tienda_empleado         VARCHAR2(100),
    usuario_empleado        VARCHAR2(100),
    password_empleado       VARCHAR2(255),
    direccion_empleado      VARCHAR2(100),
    codigo_postal_empleado  VARCHAR2(100),
    ciudad_empleado         VARCHAR2(100),
    pais_empleado           VARCHAR2(100),
    nombre_tienda           VARCHAR2(100),
    encargado_tienda        VARCHAR2(100),
    direccion_tienda        VARCHAR2(100),
    codigo_postal_tienda    VARCHAR2(100),
    ciudad_tienda           VARCHAR2(100),
    pais_tienda             VARCHAR2(100),
    tienda_pelicula         VARCHAR2(100),
    nombre_pelicula         VARCHAR2(100),
    descripcion_pelicula    VARCHAR2(255),
    ano_lanzamiento         VARCHAR2(100),
    dias_renta              VARCHAR2(10),
    costo_renta             VARCHAR2(15),
    duracion                VARCHAR2(100),
    costo_por_dano          VARCHAR2(15),
    clasificacion           VARCHAR2(10),
    lenguaje_pelicula       VARCHAR2(100),
    categoria_pelicula      VARCHAR2(100),
    actor_pelicula          VARCHAR2(100)
);