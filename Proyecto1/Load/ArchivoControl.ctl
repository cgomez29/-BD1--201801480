OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'data\BlockbusterData.csv'
INTO TABLE TEMPORARY TRUNCATE
FIELDS TERMINATED BY ";"
TRAILING NULLCOLS(
    nombre_cliente ,
    correo_cliente ,
    cliente_activo ,
    fecha_creacion TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.FF',
    tienda_preferida ,
    direccion_cliente ,
    codigo_postal_cliente ,
    ciudad_cliente ,
    pais_cliente , 
    fecha_renta TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.FF', 
    fecha_retorno TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.FF', 
    monto_a_pagar ,
    fecha_pago TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.FF', 
    nombre_empleado ,
    correo_empleado ,
    empleado_activo ,
    tienda_empleado ,
    usuario_empleado ,
    password_empleado ,
    direccion_empleado ,
    codigo_postal_empleado ,
    ciudad_empleado ,
    pais_empleado ,
    nombre_tienda ,
    encargado_tienda ,
    direccion_tienda ,
    codigo_postal_tienda ,
    ciudad_tienda ,
    pais_tienda , 
    tienda_pelicula ,
    nombre_pelicula ,
    descripcion_pelicula ,
    ano_lanzamiento ,
    dias_renta , 
    costo_renta , 
    duracion , 
    costo_por_dano , 
    clasificacion , 
    lenguaje_pelicula , 
    categoria_pelicula , 
    actor_pelicula 
)