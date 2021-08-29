/* Author: Cristian Gomez 201801480 */
/* Carga de datos */

LOAD DATA 
INFILE 'C:\Users\crisg\Desktop\Semestre\Bases1\Proyecto1\BlockbusterData.csv'
INTO TABLE TEMPORARY
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
(
    nombre_cliente ,
    correo_cliente ,
    cliente_activo ,
    fecha_creacion ,
    tienda_preferida ,
    direccion_cliente ,
    codigo_postal_cliente ,
    ciudad_cliente ,
    pais_cliente , 
    fecha_renta , 
    fecha_retorno , 
    monto_a_pagar ,
    fecha_pago , 
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
);