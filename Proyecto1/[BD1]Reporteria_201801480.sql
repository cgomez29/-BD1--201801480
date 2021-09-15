/* Author: Cristian Gomez - 201801480 */

-- Queries

-- =================================================================================================================
--   1. Mostrar la cantidad de copias que existen en el inventario para la pelicula
--      'Sugar Wonka'.
-- =================================================================================================================.

SELECT i.stock AS Cantidad
    FROM INVENTORY i
        INNER JOIN MOVIE m ON i.movie_id = m.movie_id
            WHERE m.title = 'SUGAR WONKA';

-- =================================================================================================================
--   2. Mostrar el nombre, apellido y pago total de todos los clientes que han rentado
--      peliculas por lo menos 40 veces.
-- =================================================================================================================

SELECT * FROM (
    SELECT  COUNT(c.customer_id) cantidad,
            c.name,
            c.surname,
            SUM(amount_to_pay) AS total
        FROM RENTAL_MOVIE r  
            INNER JOIN CUSTOMER c ON r.customer_id = c.customer_id
                GROUP BY    c.customer_id,
                            c.name,
                            c.surname
    ) WHERE cantidad >= 40;

-- =================================================================================================================
--   3. Mostrar el nombre y apellido del cliente y el nombre de la pelicula de todos
--      aquellos clientes que hayan rentado una pelicula y no la hayan devuelto y
--      donde la fecha de alquiler este mas alla de la especificada por la pelicula.
-- =================================================================================================================

SELECT nombre, apellido, pelicula FROM (
    SELECT  c.name AS nombre,
            c.surname AS apellido,
            m.title AS pelicula, 
            m.days AS dia,
            TRUNC(CAST(r.return_date AS DATE) - CAST(r.rental_date AS DATE)) AS uso,
            r.return_date AS retorno
        FROM RENTAL_MOVIE r  
            INNER JOIN CUSTOMER c ON r.customer_id = c.customer_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id 
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id
) WHERE retorno = NULL OR uso > dia;

-- =================================================================================================================
--   4. Mostrar el nombre y apellido (en una sola columna) de los actores que
--      contienen la palabra 'SON' en su apellido, ordenados por su primer nombre
-- =================================================================================================================

SELECT CONCAT(CONCAT(a.name, ' '), a.surname)
    FROM ACTOR a
        WHERE a.surname LIKE ('%son%')
            ORDER BY a.name ASC;

-- =================================================================================================================
--    5. Mostrar el apellido de todos los actores y la cantidad de actores que tienen
--       ese apellido pero solo para los que comparten el mismo nombre por lo menos
--       con dos actores.
-- =================================================================================================================

SELECT  COUNT(a.surname),
        a.surname 
    FROM  ACTOR a
        WHERE a.name IN (
            SELECT name FROM (
                SELECT  COUNT(a.name) AS n,
                        a.name
                    FROM ACTOR a 
                        GROUP BY a.name
                ) WHERE n >= 2            
            )
        GROUP BY a.surname;

-- =================================================================================================================
--    6. Mostrar el nombre y apellido de los actores que participaron en una pelicula
--       que involucra un 'Cocodrilo' y un 'Tiburon' junto con el ao de lanzamiento
--       de la pelicula, ordenados por el apellido del actor en forma ascendente.
-- =================================================================================================================

SELECT  a.name,
        a.surname,
        m.release_year,
        m.description
    FROM MOVIE_ACTOR ma 
        INNER JOIN MOVIE m ON ma.movie_id = m.movie_id
        INNER JOIN ACTOR a ON ma.actor_id = a.actor_id
            WHERE m.description LIKE('%Crocodile%') AND m.description LIKE('%Tiburon%')
                ORDER BY a.surname ASC;


-- =================================================================================================================
--   7. Mostrar el nombre de la categoria y el numero de peliculas por categoria de
--      todas las categorias de peliculas en las que hay entre 55 y 65 peliculas.
--      Ordenar el resultado por numero de peliculas de forma descendente.
-- =================================================================================================================

SELECT name, cantidad FROM (
    SELECT  c.name,
            COUNT(m.movie_id) AS cantidad 
        FROM MOVIE m 
            INNER JOIN CATEGORY c ON m.category_id = c.category_id 
                GROUP BY c.name
) WHERE cantidad >= 55 AND cantidad <=65;
            
-- =================================================================================================================
--   8. Mostrar todas las categorias de peliculas en las que la diferencia promedio
--      entre el costo de reemplazo de la pelicula y el precio de alquiler sea superior
--      a 17.
-- =================================================================================================================

SELECT name FROM (
    SELECT  c.name,
            COUNT(m.movie_id) AS cantidad,
            SUM(damage_cost) AS remplazo,
            SUM(rental_cost) AS alquiler
        FROM MOVIE m
            INNER JOIN CATEGORY c ON m.category_id = c.category_id 
                GROUP BY    c.name
) WHERE ((remplazo - alquiler)/cantidad) > 17;

SELECT  c.name
    FROM MOVIE m
        INNER JOIN CATEGORY c ON m.category_id = c.category_id 
            GROUP BY    c.name
                HAVING AVG(damage_cost - rental_cost) > 17;

-- =================================================================================================================
--    9. Mostrar el titulo de la pelicula, el nombre y apellido del actor de todas
--       aquellas peliculas en las que uno o mas actores actuaron en dos o mas
--       peliculas.
-- =================================================================================================================
select count(*) from (
SELECT  m.title,
        a.name,
        a.surname
    FROM MOVIE m, ACTOR a 
        WHERE a.actor_id IN (
            SELECT actor_id FROM (
                SELECT  ma.actor_id,
                        COUNT(ma.movie_id) AS actuo
                    FROM MOVIE_ACTOR ma 
                            GROUP BY ma.actor_id
            ) WHERE actuo >= 2
        ));
        

-- =================================================================================================================
--    10.Mostrar el nombre y apellido (en una sola columna) de todos los actores y
--       clientes cuyo primer nombre sea el mismo que el primer nombre del actor con
--       ID igual a 8. No debe retornar el nombre del actor con ID igual a 8
--       dentro de la consulta. No puede utilizar el nombre del actor como una
--       constante, unicamente el ID proporcionado.
-- =================================================================================================================

-- =================================================================================================================
--   11. Mostrar el pais y el nombre del cliente que mas peliculas rento asi como
--       tambien el porcentaje que representa la cantidad de peliculas que rento con
--       respecto al resto de clientes del pais
-- =================================================================================================================

SELECT  pais, 
        nombre, 
        ((cantidad*100)/
            (
                SELECT COUNT(m.movie_id) 
                FROM RENTAL_MOVIE r
                    INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
                    INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
                    INNER JOIN CITY ci ON a.city_id = ci.city_id
                    INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                    INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id  
                    INNER JOIN MOVIE m ON i.movie_id = m.movie_id
                        WHERE co.name = pais
                            GROUP BY    co.name
            )
        ) AS porcentaje
    FROM (
    SELECT  co.name AS pais,
            cu.name AS nombre,
            COUNT(m.movie_id) AS cantidad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
            INNER JOIN CITY ci ON a.city_id = ci.city_id
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id  
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id
                GROUP BY    co.name,
                            cu.surname,
                            cu.email, 
                            cu.name
                    ORDER BY    co.name,
                                cantidad DESC
) WHERE cantidad = (
    SELECT COUNT(m.movie_id) AS cantidad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
            INNER JOIN CITY ci ON a.city_id = ci.city_id
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id  
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id
            WHERE co.name = pais
                GROUP BY    co.name,
                            cu.surname,
                            cu.email, 
                            cu.name
                    ORDER BY    co.name,
                                cantidad DESC FETCH FIRST 1 ROWS ONLY 
) GROUP BY  pais, 
            nombre,
            cantidad;

-- =================================================================================================================
--    12.Mostrar el total de clientes y porcentaje de clientes mujeres por ciudad y pais.
--       El ciento por ciento es el total de mujeres por pais. (Tip: Todos los
--       porcentajes por ciudad de un pais deben sumar el 100%).
-- =================================================================================================================

-- =================================================================================================================
--   13. Mostrar el nombre del pais, nombre del cliente y numero de peliculas
--       rentadas de todos los clientes que rentaron mas peliculas por pais. Si el
--       numero de peliculas maximo se repite, mostrar todos los valores que
--       representa el maximo
-- =================================================================================================================

SELECT pais, name, cantidad FROM ( 
    SELECT  COUNT(cu.customer_id) cantidad,
            co.name AS pais,
            cu.name AS name
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                    GROUP BY    co.name,
                                cu.customer_id,
                                cu.name
                        ORDER BY    co.name,
                                    cantidad DESC
)   WHERE cantidad = (
        SELECT  COUNT(cu2.customer_id) cantidad2
            FROM RENTAL_MOVIE r2
                INNER JOIN CUSTOMER cu2 ON r2.customer_id = cu2.customer_id
                INNER JOIN ADDRESS a2 ON cu2.address_id = a2.address_id 
                INNER JOIN CITY ci2 ON a2.city_id = ci2.city_id 
                INNER JOIN COUNTRY co2 ON ci2.country_id = co2.country_id
                    WHERE co2.name = pais
                        GROUP BY    co2.name,
                                    cu2.customer_id
                            ORDER BY    co2.name,
                                        cantidad2 DESC FETCH FIRST 1 ROWS ONLY    
) ORDER BY pais ASC;


-- =================================================================================================================
--   14. Mostrar todas las ciudades por pais en las que predomina la renta de
--       peliculas de la categoria 'Horror'. Es decir, hay mas rentas que las otras
--       categorias
-- =================================================================================================================

SELECT ciudad, pais FROM(
    SELECT categoria, cantidad, ciudad, pais FROM (
        SELECT  ca.name AS categoria,
                count(ca.name) AS cantidad,
                ci.name AS ciudad,
                co.name AS pais
            FROM RENTAL_MOVIE r
                INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
                INNER JOIN ADDRESS a ON cu.address_id = a.address_id
                INNER JOIN CITY ci ON a.city_id = ci.city_id 
                INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
                INNER JOIN MOVIE m ON i.movie_id = m.movie_id 
                INNER JOIN CATEGORY ca ON m.category_id = ca.category_id
                    GROUP BY    ca.name,
                                ci.name,
                                co.name
                        ORDER BY co.name,
                                 ci.name,
                                 cantidad DESC
    ) WHERE cantidad = (
        SELECT  COUNT(ca.name) AS cantidad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id 
            INNER JOIN CATEGORY ca ON m.category_id = ca.category_id
                WHERE ci.name = ciudad AND co.name = pais
                GROUP BY    ca.name,
                            ci.name,
                            co.name
                    ORDER BY co.name,
                             ci.name,
                             cantidad DESC FETCH FIRST 1 ROWS ONLY  
    )   AND categoria = 'Horror'
);

-- =================================================================================================================
--    15. Mostrar el nombre del pais, la ciudad y el promedio de rentas por ciudad. Por
--        ejemplo: si el pais tiene 3 ciudades, se deben sumar todas las rentas de la
--        ciudad y dividirlo dentro de tres (numero de ciudades del pais).
-- =================================================================================================================
--SELECT COUNT(*) FROM (
SELECT  TRUNC(cantidad/( 
            SELECT  count(ci.name)
                FROM CITY ci 
                    INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                        WHERE co.name = pais
                            GROUP BY co.name
        ),1) AS promedio, 
        pais,
        ciudad 
    FROM (
    SELECT  COUNT(r.rental_movie_id) AS cantidad,
            ci.name AS ciudad,
            co.name AS pais
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                GROUP BY    co.name,
                            ci.name
);

 SELECT  COUNT(r.rental_movie_id) AS cantidad,
            ci.name AS ciudad,
            co.name AS pais
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                GROUP BY    co.name,
                            ci.name    
            

SELECT  count(ci.name)
                FROM CITY ci 
                    INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                        WHERE co.name = 'Argentina'
                            GROUP BY co.name;


 SELECT  SUM(r.rental_movie_id) AS cantidad,
            ci.name AS ciudad,
            co.name AS pais
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                GROUP BY    co.name,
                            ci.name    

-- =================================================================================================================
--   16. Mostrar el nombre del pais y el porcentaje de rentas de peliculas de la
--       categoria 'Sports'.
-- =================================================================================================================

SELECT  COUNT(rental_movie_id) AS cantidad,
        co.name AS pais
    FROM RENTAL_MOVIE r
        INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
        INNER JOIN ADDRESS a ON cu.address_id = a.address_id
        INNER JOIN CITY ci ON a.city_id = ci.city_id 
        INNER JOIN COUNTRY co ON ci.country_id = co.country_id
        INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
        INNER JOIN MOVIE m ON i.movie_id = m.movie_id
        INNER JOIN CATEGORY ca ON m.category_id = ca.category_id
            WHERE   ca.name = 'Sports'
            GROUP BY    co.name,
                        ci.name 


-- =================================================================================================================
--   17. Mostrar la lista de ciudades de Estados Unidos y el numero de rentas de
--       peliculas para las ciudades que obtuvieron mas rentas que la ciudad
--       'Dayton'.
-- =================================================================================================================

SELECT cantidad, ciudad FROM (
    SELECT  COUNT(rental_movie_id) AS cantidad,
            ci.name AS ciudad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id
            INNER JOIN CATEGORY ca ON m.category_id = ca.category_id
                WHERE   co.name = 'United States' 
                GROUP BY    ci.name
) WHERE cantidad > (
    SELECT  COUNT(rental_movie_id) AS cantidad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id
            INNER JOIN CATEGORY ca ON m.category_id = ca.category_id
                WHERE   co.name = 'United States' AND ci.name = 'Dayton'
                GROUP BY    ci.name
);

-- =================================================================================================================
--   18. Mostrar el nombre, apellido y fecha de retorno de pelicula a la tienda de todos
--       los clientes que hayan rentado mas de 2 peliculas que se encuentren en
--       lenguaje Ingles en donde el empleado que se las vendio ganara mas de 15
--       dolares en sus rentas del dia en la que el cliente rento la pelicula.
-- =================================================================================================================

SELECT  cu.name,
        cu.surname,
        r.return_date,
    FROM RENTAL_MOVIE r 
        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
     

-- =================================================================================================================
--   19. Mostrar el numero de mes, de la fecha de renta de la pelicula, nombre y
--       apellido de los clientes que mas peliculas han rentado y las que menos en
--       una sola consulta.
-- =================================================================================================================

(SELECT  TO_CHAR(r.rental_date,'MM'),
        cu.name,
        cu.surname,
        COUNT(r.rental_movie_id) AS cantidad
    FROM RENTAL_MOVIE r
        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
        GROUP BY    cu.name,
                    cu.surname,
                    r.rental_date
            ORDER BY cantidad DESC FETCH FIRST 10 ROW ONLY)
UNION 
(SELECT  TO_CHAR(r.rental_date,'MM'),
        cu.name,
        cu.surname,
        COUNT(r.rental_movie_id) AS cantidad
    FROM RENTAL_MOVIE r
        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
        GROUP BY    cu.name,
                    cu.surname,
                    r.rental_date
            ORDER BY cantidad ASC FETCH FIRST 10 ROW ONLY);
    
-- =================================================================================================================
--   20. Mostrar el porcentaje de lenguajes de peliculas mas rentadas de cada ciudad
--       durante el mes de julio del ano 2005 de la siguiente manera: ciudad,
--       lenguaje, porcentaje de renta.
-- =================================================================================================================


--porcentaje de lenguajes de las peliculas mas rentadas de cada ciudad 


--where mes = 7 year = 2005

SELECT  ci.name AS ciudad,
        co.name AS pais,
        COUNT(la.language_id) AS cantidad  
    FROM RENTAL_MOVIE r
        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
        INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
        INNER JOIN CITY ci ON a.city_id = ci.city_id 
        INNER JOIN COUNTRY co ON ci.country_id = co.country_id 
        INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id 
        INNER JOIN MOVIE m ON i.movie_id = m.movie_id 
        INNER JOIN MOVIE_LANGUAGE ml ON m.movie_language_id = ml.movie_language_id
        INNER JOIN LANGUAGE la ON ml.language_id = la.language_id
            GROUP BY    co.name,
                        ci.name;
                        cantidad    
