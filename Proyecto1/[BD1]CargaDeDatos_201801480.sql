/* Author: Cristian Gomez - 201801480 */
-- data upload

/*
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
    --  EMPLOYEE    
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
    -- EMPLOYEE
    -- SHOP
    nombre_tienda ,
    encargado_tienda ,
    direccion_tienda ,
    codigo_postal_tienda ,
    ciudad_tienda ,
    pais_tienda , 
    -- END SHOP
    tienda_pelicula ,  --X -- Ubicacion de la pelicula 
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
*/



-- ==================================================================================================
-- Inserting data to the COUNTRY table 
-- ==================================================================================================

INSERT INTO COUNTRY(name)
    SELECT pais_cliente 
        FROM TEMPORARY
            WHERE pais_cliente != '-'
                GROUP BY pais_cliente; 

-- ==================================================================================================
-- Inserting data to the CITY table 
-- ==================================================================================================

INSERT INTO CITY(name, country_id)
    SELECT t.ciudad_cliente, c.country_id AS id
        FROM TEMPORARY t
            INNER JOIN COUNTRY c ON t.pais_cliente = c.name 
                WHERE t.ciudad_cliente != '-' and t.pais_cliente != '-'
                    GROUP BY t.ciudad_cliente, c.country_id; 

select * from city;

-- ==================================================================================================
-- Inserting data to the ACTOR table 
-- ==================================================================================================

INSERT INTO ACTOR(name, surname)
    SELECT 
        SUBSTR(actor_pelicula, 1, INSTR(actor_pelicula, ' ')-1) as name,
        SUBSTR(actor_pelicula, INSTR(actor_pelicula, ' ')+1) as surname    
    FROM TEMPORARY
        WHERE actor_pelicula != '-'
            GROUP BY actor_pelicula;

-- ==================================================================================================
-- Inserting data to the CATEGORY table 
-- ==================================================================================================

INSERT INTO CATEGORY(name)
    SELECT categoria_pelicula 
        FROM TEMPORARY
            WHERE categoria_pelicula != '-'
                GROUP BY categoria_pelicula;

-- ==================================================================================================
-- Inserting data to the LANGUAGE table 
-- ==================================================================================================

INSERT INTO LANGUAGE(name)
    SELECT lenguaje_pelicula 
        FROM TEMPORARY
            WHERE lenguaje_pelicula != '-'
                GROUP BY lenguaje_pelicula;

select * from language;

-- ==================================================================================================
-- Inserting data to the ADDRESS table 
-- ==================================================================================================

-- ????

-- ==================================================================================================
-- Inserting data to the SHOP table 
-- ==================================================================================================

INSERT INTO SHOP(name, address_id)    
    SELECT  nombre_tienda, a.address_id
        FROM TEMPORARY 
            INNER JOIN ADDRESS a ON direccion_tienda = a.direction
            INNER JOIN CITY c ON a.city_id = (SELECT city_id FROM CITY WHERE name = ciudad_tienda)
                WHERE nombre_tienda != '-'
                GROUP BY nombre_tienda, a.address_id;
    
-- Insertando direccion de la tienda
INSERT INTO ADDRESS(direction, city_id)
    SELECT nombre_tienda, direccion_tienda , c.city_id
        FROM TEMPORARY 
            INNER JOIN city c ON ciudad_tienda = c.name 
            INNER JOIN country co ON c.country_id = co.country_id 
                WHERE nombre_tienda != '-'
                    GROUP BY    direccion_tienda ,
                    nombre_tienda,
                                ciudad_tienda ,
                                pais_tienda,
                                c.city_id;
        

-- ==================================================================================================
-- Inserting data to the EMPLOYEE table 
-- ==================================================================================================


-- ==================================================================================================
-- Inserting data to the REWARD table 
-- ==================================================================================================



-- ==================================================================================================
-- Inserting data to the CUSTOMER table 
-- ==================================================================================================


-- ==================================================================================================
-- Inserting data to the RENTAL_MOVIE table 
-- ==================================================================================================


-- ==================================================================================================
-- Inserting data to the MOVIE table 
-- ==================================================================================================

SELECT nombre_pelicula, descripcion_pelicula, ano_lanzamiento,
duracion, dias_renta, costo_renta, costo_por_dano, clasificacion,
lenguaje_pelicula, categoria_pelicula 
FROM TEMPORARY
WHERE nombre_pelicula != '-'
GROUP BY nombre_pelicula, descripcion_pelicula, ano_lanzamiento,
duracion, dias_renta, costo_renta, costo_por_dano, clasificacion,
lenguaje_pelicula, categoria_pelicula ;


-- ==================================================================================================
-- Inserting data to the MOVIE_ACTOR table 
-- ==================================================================================================

SELECT nombre_pelicula, actor_pelicula, descripcion_pelicula, ano_lanzamiento
FROM TEMPORARY 
WHERE nombre_pelicula != '-' and actor_pelicula != '-'
GROUP BY nombre_pelicula, descripcion_pelicula, ano_lanzamiento, actor_pelicula;

-- ==================================================================================================
-- Inserting data to the MOVIE_LANGUAGE table 
-- ==================================================================================================

SELECT nombre_pelicula, lenguaje_pelicula, descripcion_pelicula, ano_lanzamiento
FROM TEMPORARY 
WHERE nombre_pelicula != '-' and actor_pelicula != '-'
GROUP BY nombre_pelicula, descripcion_pelicula, ano_lanzamiento, lenguaje_pelicula;


-- ==================================================================================================
-- Inserting data to the INVENTORY table 
-- ==================================================================================================

-- tienda_pelicula ubicacion de la pelicula
SELECT COUNT(nombre_pelicula), tienda_pelicula, nombre_pelicula, lenguaje_pelicula, descripcion_pelicula, ano_lanzamiento
FROM TEMPORARY 
WHERE nombre_pelicula != '-' and tienda_pelicula != '-'
GROUP BY tienda_pelicula, nombre_pelicula, lenguaje_pelicula, descripcion_pelicula, ano_lanzamiento;


-- ==================================================================================================
-- Inserting data to the INVENTORY_TABLE table 
-- ==================================================================================================


