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
    /* EMPLOYEE */    
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
    /* EMPLOYEE */
    /* SHOP */
    nombre_tienda ,
    encargado_tienda ,
    direccion_tienda ,
    codigo_postal_tienda ,
    ciudad_tienda ,
    pais_tienda , 
    /* END SHOP */
    tienda_pelicula ,  --X /* Ubicacion de la pelicula */
    nombre_pelicula , --X
    descripcion_pelicula , --X
    ano_lanzamiento , --X
    dias_renta , --X
    costo_renta , --X
    duracion , --X
    costo_por_dano , --X
    clasificacion , --X
    lenguaje_pelicula , --X
    categoria_pelicula , --X
    actor_pelicula 

);


/* COUNTRY */
SELECT pais_cliente 
FROM TEMPORARY
WHERE pais_cliente != '-'
GROUP BY pais_cliente; 

/* CITY */
SELECT ciudad_cliente, pais_cliente 
FROM TEMPORARY
WHERE ciudad_cliente != '-' and pais_cliente != '-'
GROUP BY ciudad_cliente, pais_cliente; 

/* ACTOR */
SELECT actor_pelicula 
FROM TEMPORARY
WHERE actor_pelicula != '-'
GROUP BY actor_pelicula;

/* CATEGORY */
SELECT categoria_pelicula 
FROM TEMPORARY
WHERE categoria_pelicula != '-'
GROUP BY categoria_pelicula;

/* LANGUAGE */
SELECT lenguaje_pelicula 
FROM TEMPORARY
WHERE lenguaje_pelicula != '-'
GROUP BY lenguaje_pelicula;

/* MOVIE */

SELECT nombre_pelicula, descripcion_pelicula, ano_lanzamiento,
duracion, dias_renta, costo_renta, costo_por_dano, clasificacion,
lenguaje_pelicula, categoria_pelicula 
FROM TEMPORARY
WHERE nombre_pelicula != '-'
GROUP BY nombre_pelicula, descripcion_pelicula, ano_lanzamiento,
duracion, dias_renta, costo_renta, costo_por_dano, clasificacion,
lenguaje_pelicula, categoria_pelicula ;


/* MOVIE ACTOR */
SELECT nombre_pelicula, actor_pelicula, descripcion_pelicula, ano_lanzamiento
FROM TEMPORARY 
WHERE nombre_pelicula != '-' and actor_pelicula != '-'
GROUP BY nombre_pelicula, descripcion_pelicula, ano_lanzamiento, actor_pelicula;

/* MOVIE LANGUAGE */
SELECT nombre_pelicula, lenguaje_pelicula, descripcion_pelicula, ano_lanzamiento
FROM TEMPORARY 
WHERE nombre_pelicula != '-' and actor_pelicula != '-'
GROUP BY nombre_pelicula, descripcion_pelicula, ano_lanzamiento, lenguaje_pelicula;

/* SHOP */
SELECT  nombre_tienda ,
        encargado_tienda ,
        direccion_tienda ,
        codigo_postal_tienda ,
        ciudad_tienda ,
        pais_tienda 
FROM TEMPORARY 
WHERE nombre_tienda != '-'
GROUP BY nombre_tienda ,
         encargado_tienda ,
         direccion_tienda ,
         codigo_postal_tienda ,
         ciudad_tienda ,
         pais_tienda;



/* INVENTARY */
-- tienda_pelicula ubicacion de la pelicula
SELECT COUNT(nombre_pelicula), tienda_pelicula, nombre_pelicula, lenguaje_pelicula, descripcion_pelicula, ano_lanzamiento
FROM TEMPORARY 
WHERE nombre_pelicula != '-' and tienda_pelicula != '-'
GROUP BY tienda_pelicula, nombre_pelicula, lenguaje_pelicula, descripcion_pelicula, ano_lanzamiento;



/*
-- for SQL*LOADER
LOAD DATA 
INFILE 'Data.csv'
INTO TABLE TEMPORARY
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
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
)
 

*/