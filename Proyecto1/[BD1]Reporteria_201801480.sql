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

SELECT  c.name AS nombre,
        c.surname AS apellido,
        m.title AS pelicula
    FROM RENTAL_MOVIE r  
        INNER JOIN CUSTOMER c ON r.customer_id = c.customer_id
        INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id 
        INNER JOIN MOVIE m ON i.movie_id = m.movie_id
        WHERE r.return_date > (r.rental_date + m.days) OR r.return_date IS NULL;

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

SELECT apellido, cantidad FROM (
    SELECT  a.surname AS apellido,
            COUNT(a.surname) AS cantidad
        FROM ACTOR a
            GROUP BY a.surname
) INNER JOIN (
    SELECT nombre, apellido AS apellido1 FROM (
        SELECT  a.name AS nombre,
                a.surname AS apellido
            FROM ACTOR a
                GROUP BY    a.name,
                            a.surname
    ) INNER JOIN (
        SELECT  a.name AS nombre2 
            FROM ACTOR a
                GROUP BY a.name
                    HAVING COUNT(a.name) >= 2
    ) ON nombre2 = nombre

) ON apellido = apellido1
    GROUP BY apellido, cantidad
        ORDER BY apellido ASC;


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
            WHERE INSTR(LOWER(m.description), 'crocodile') > 0 AND  INSTR(LOWER(m.description), 'shark') > 0
                ORDER BY a.surname ASC;

-- =================================================================================================================
--   7. Mostrar el nombre de la categoria y el numero de peliculas por categoria de
--      todas las categorias de peliculas en las que hay entre 55 y 65 peliculas.
--      Ordenar el resultado por numero de peliculas de forma descendente.
-- =================================================================================================================

SELECT name, cantidad FROM (
    SELECT  c.name,
            COUNT(m.movie_id) AS cantidad 
        FROM MOVIE_CATEGORY mc
            INNER JOIN MOVIE m ON m.movie_id = mc.movie_id 
            INNER JOIN CATEGORY c ON mc.category_id = c.category_id 
                GROUP BY c.name
) WHERE cantidad >= 55 AND cantidad <=65;
            
-- =================================================================================================================
--   8. Mostrar todas las categorias de peliculas en las que la diferencia promedio
--      entre el costo de reemplazo de la pelicula y el precio de alquiler sea superior
--      a 17.
-- =================================================================================================================

SELECT name, ROUND((remplazo - alquiler)/cantidad, 2)AS promedio FROM (
    SELECT  c.name,
            COUNT(m.movie_id) AS cantidad,
            SUM(damage_cost) AS remplazo,
            SUM(rental_cost) AS alquiler
         FROM MOVIE_CATEGORY mc
            INNER JOIN MOVIE m ON m.movie_id = mc.movie_id 
            INNER JOIN CATEGORY c ON c.category_id = mc.category_id 
                GROUP BY    c.name
) WHERE ((remplazo - alquiler)/cantidad) > 17;

SELECT  c.name,
        ROUND(AVG(damage_cost - rental_cost),2) AS promedio
    FROM MOVIE_CATEGORY mc
        INNER JOIN MOVIE m ON m.movie_id = mc.movie_id 
        INNER JOIN CATEGORY c ON c.category_id = mc.category_id 
            GROUP BY    c.name
                HAVING AVG(damage_cost - rental_cost) > 17;

-- =================================================================================================================
--    9. Mostrar el titulo de la pelicula, el nombre y apellido del actor de todas
--       aquellas peliculas en las que uno o mas actores actuaron en dos o mas
--       peliculas.
-- =================================================================================================================

SELECT pelicula, nombre, apellido FROM(
    SELECT  m.title AS pelicula,
            a.name AS nombre,
            a.surname AS apellido
        FROM MOVIE_ACTOR ma
            INNER JOIN ACTOR a ON a.actor_id = ma.actor_id
            INNER JOIN MOVIE m ON m.movie_id = ma.movie_id
) INNER JOIN (
    SELECT  a.name AS nombre2,
            a.surname AS apellido2
        FROM MOVIE_ACTOR ma
            INNER JOIN ACTOR a ON a.actor_id = ma.actor_id
            INNER JOIN MOVIE m ON m.movie_id = ma.movie_id
                GROUP BY    a.name,
                            a.surname
                    HAVING  COUNT(a.actor_id) >= 2
) ON nombre2 = nombre AND apellido2 = apellido
    GROUP BY pelicula, nombre, apellido;

-- =================================================================================================================
--    10.Mostrar el nombre y apellido (en una sola columna) de todos los actores y
--       clientes cuyo primer nombre sea el mismo que el primer nombre del actor con
--       ID igual a 8. No debe retornar el nombre del actor con ID igual a 8
--       dentro de la consulta. No puede utilizar el nombre del actor como una
--       constante, unicamente el ID proporcionado.
-- =================================================================================================================

SELECT nombre, apellido 
FROM(
    SELECT  a.name AS nombre,
            a.surname AS apellido
    FROM ACTOR a
UNION 
    SELECT  cu.name AS nombre,
            cu.surname AS apellido
    FROM CUSTOMER cu
) TABLA1 
INNER JOIN (
    SELECT  a.name AS nombre_actor,
            a.surname AS apellido_actor
    FROM ACTOR a
        WHERE a.name LIKE 'Matthew' AND a.surname LIKE 'Johansson'
) ON nombre = nombre_actor 
WHERE apellido <> apellido_actor;

-- =================================================================================================================
--   11. Mostrar el pais y el nombre del cliente que mas peliculas rento asi como
--       tambien el porcentaje que representa la cantidad de peliculas que rento con
--       respecto al resto de clientes del pais
-- =================================================================================================================

SELECT  pais,
        nombre,
        CONCAT((cantidad*100)/(
            SELECT SUM(total) FROM (
                SELECT  COUNT(r.rental_movie_id) AS total
                    FROM RENTAL_MOVIE r 
                        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
                        INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
                        INNER JOIN CITY ci ON a.city_id = ci.city_id
                        INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                            WHERE co.name = pais
                            GROUP BY    cu.name,
                                        cu.surname, 
                                        cu.email,
                                        co.name
                                ORDER BY total 
        )   )     
    , '%')  AS porcentaje   
    FROM (
    SELECT  cu.name AS nombre,
            cu.surname,
            co.name AS pais,
            COUNT(r.rental_movie_id) AS cantidad
        FROM RENTAL_MOVIE r 
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
            INNER JOIN CITY ci ON a.city_id = ci.city_id
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                GROUP BY    cu.name,
                            cu.surname, 
                            cu.email,
                            co.name
                    ORDER BY cantidad DESC FETCH FIRST 1 ROWS ONLY 
);
     

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

SELECT pais, ciudad, categoria, cantidad FROM (
        SELECT  co.name AS pais,
                ci.name AS ciudad,
                ca.name AS categoria,
                COUNT(ca.name) AS cantidad
            FROM RENTAL_MOVIE r
                INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
                INNER JOIN ADDRESS a ON cu.address_id = a.address_id
                INNER JOIN CITY ci ON a.city_id = ci.city_id 
                INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
                INNER JOIN MOVIE_CATEGORY mc ON mc.movie_id = i.movie_id
                INNER JOIN CATEGORY ca ON mc.category_id = ca.category_id
                    GROUP BY    ca.name,
                                ci.name,
                                co.name
) INNER JOIN (
    SELECT pais2, ciudad2, MAX(cantidad2) AS maxcategory FROM (
            SELECT  co.name AS pais2,
                    ci.name AS ciudad2,
                    ca.name AS categoria2,
                    count(ca.name) AS cantidad2
                FROM RENTAL_MOVIE r
                    INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
                    INNER JOIN ADDRESS a ON cu.address_id = a.address_id
                    INNER JOIN CITY ci ON a.city_id = ci.city_id 
                    INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                    INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
                    INNER JOIN MOVIE_CATEGORY mc ON mc.movie_id = i.movie_id
                    INNER JOIN CATEGORY ca ON mc.category_id = ca.category_id
                        GROUP BY    ca.name,
                                    ci.name,
                                    co.name
    
    ) GROUP BY pais2, ciudad2
) ON pais = pais2 AND ciudad = ciudad2 AND cantidad = maxcategory
    WHERE categoria = 'Horror';

-- =================================================================================================================
--    15. Mostrar el nombre del pais, la ciudad y el promedio de rentas por pais. Por
--        ejemplo: si el pais tiene 3 ciudades, se deben sumar todas las rentas de la
--        ciudad y dividirlo dentro de tres (numero de ciudades del pais).
-- =================================================================================================================

SELECT pais, ciudad, ROUND(v1.total/v2.cantidad, 2) 
    FROM (
        SELECT  co.name AS pais,
            ci.name AS ciudad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
            INNER JOIN ADDRESS a ON a.address_id = cu.address_id 
            INNER JOIN CITY ci ON ci.city_id = a.city_id 
            INNER JOIN COUNTRY co ON  co.country_id = ci.country_id
                GROUP BY    co.name,
                            ci.name
    ) INNER JOIN (
         SELECT pais AS pais2, SUM(cantidad2) AS total FROM (

            SELECT  co.name AS pais,
                    ci.name AS ciudad,
                    COUNT(r.rental_movie_id) AS cantidad2
                FROM RENTAL_MOVIE r
                    INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
                    INNER JOIN ADDRESS a ON a.address_id = cu.address_id 
                    INNER JOIN CITY ci ON ci.city_id = a.city_id 
                    INNER JOIN COUNTRY co ON  co.country_id = ci.country_id
                        GROUP BY    ci.name,
                                    co.name
            ) GROUP BY pais
    
    ) v1 ON pais2 = pais
    INNER JOIN (
        SELECT pais AS pais3, COUNT(cantidad) AS cantidad FROM (
            SELECT  co.name AS pais,
                    ci.name AS ciudad,
                    COUNT(r.rental_movie_id) AS cantidad
                FROM RENTAL_MOVIE r
                    INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
                    INNER JOIN ADDRESS a ON a.address_id = cu.address_id 
                    INNER JOIN CITY ci ON ci.city_id = a.city_id 
                    INNER JOIN COUNTRY co ON  co.country_id = ci.country_id
                        GROUP BY    co.name,
                                    ci.name
            ) GROUP BY  pais
    ) v2 ON v2.pais3 = pais;

-- =================================================================================================================
--   16. Mostrar el nombre del pais y el porcentaje de rentas de peliculas de la
--       categoria 'Sports'.
-- =================================================================================================================

SELECT  pais, 
        CONCAT(ROUND((cantidad*100)/(
            SELECT  COUNT(rental_movie_id) AS total
                FROM RENTAL_MOVIE r
                    INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
                    INNER JOIN ADDRESS a ON cu.address_id = a.address_id
                    INNER JOIN CITY ci ON a.city_id = ci.city_id 
                    INNER JOIN COUNTRY co ON ci.country_id = co.country_id
                    WHERE co.name = pais
                        GROUP BY    co.name
        ), 2),'%') AS porcentaje 
    FROM(
    SELECT  co.name AS pais,
            COUNT(rental_movie_id) AS cantidad
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id =  cu.customer_id
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN COUNTRY co ON ci.country_id = co.country_id
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id
            INNER JOIN MOVIE_CATEGORY mc ON mc.movie_id = i.movie_id
            INNER JOIN CATEGORY ca ON mc.category_id = ca.category_id
                WHERE   ca.name = 'Sports'
                GROUP BY    co.name
);

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
            INNER JOIN MOVIE_CATEGORY mc ON mc.movie_id = i.movie_id
            INNER JOIN CATEGORY ca ON mc.category_id = ca.category_id
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
            INNER JOIN MOVIE_CATEGORY mc ON mc.movie_id = i.movie_id
            INNER JOIN CATEGORY ca ON mc.category_id = ca.category_id
                WHERE   co.name = 'United States' AND ci.name = 'Dayton'
                GROUP BY    ci.name
);

-- =================================================================================================================
--   18. Mostrar el nombre, apellido y fecha de retorno de pelicula a la tienda de todos
--       los clientes que hayan rentado mas de 2 peliculas que se encuentren en
--       lenguaje Ingles en donde el empleado que se las vendio ganara mas de 15
--       dolares en sus rentas del dia en la que el cliente rento la pelicula.
-- =================================================================================================================

SELECT nombre, apellido, fecha_retorno FROM (
    SELECT  cu.name AS nombre,
            cu.surname AS apellido,
            r.rental_date,
            TO_CHAR(r.return_date, 'DD/MM/YYYY') AS fecha_retorno,
            r.amount_to_pay AS ganancia
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id 
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id 
            INNER JOIN MOVIE_LANGUAGE ml ON m.movie_id = ml.movie_id
            INNER JOIN LANGUAGE la ON ml.language_id = la.language_id
                WHERE la.name = 'English             ' 
                    GROUP BY    cu.name,
                                cu.surname,
                                cu.email,
                                r.rental_date,
                                r.return_date,
                                r.amount_to_pay
)   GROUP BY nombre, apellido, fecha_retorno
        HAVING SUM(ganancia) >= 15 AND COUNT(ganancia) >=2
            ORDER BY nombre;
                    

-- =================================================================================================================
--   19. Mostrar el numero de mes, de la fecha de renta de la pelicula, nombre y
--       apellido de los clientes que mas peliculas han rentado y las que menos en
--       una sola consulta.
-- =================================================================================================================

(SELECT DISTINCT mes, nombre, apellido FROM (
    SELECT  TO_CHAR(r.rental_date,'MM') AS mes,
            cu.name AS nombre,
            cu.surname AS apellido
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
            WHERE cu.customer_id = (
                SELECT  cu.customer_id
                    FROM RENTAL_MOVIE r
                        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id            
                        GROUP BY cu.customer_id
                        HAVING COUNT(cu.customer_id) = (
                            SELECT MAX(COUNT(r.customer_id)) AS maximo
                                FROM RENTAL_MOVIE r
                                    GROUP BY r.customer_id 
                        )        
            ) 
)           
)UNION(       
SELECT DISTINCT mes, nombre, apellido FROM (
    SELECT  TO_CHAR(r.rental_date,'MM') AS mes,
            cu.name AS nombre,
            cu.surname AS apellido
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id
            WHERE cu.customer_id = (
                SELECT  cu.customer_id
                    FROM RENTAL_MOVIE r
                        INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id            
                        GROUP BY cu.customer_id
                        HAVING COUNT(cu.customer_id) = (
                            SELECT MIN(COUNT(r.customer_id)) AS maximo
                                FROM RENTAL_MOVIE r
                                    GROUP BY r.customer_id 
                        )        
            ) 
)         
) ORDER BY nombre, mes;
    
-- =================================================================================================================
--   20. Mostrar el porcentaje de lenguajes de peliculas mas rentadas de cada ciudad
--       durante el mes de julio del ano 2005 de la siguiente manera: ciudad,
--       lenguaje, porcentaje de renta.
-- =================================================================================================================

SELECT ciudad, lenguaje, ((cantidad*100)/total) AS porcentaje, cantidad, total  FROM  (
    SELECT  ci.name AS ciudad,
            la.name AS lenguaje,
            COUNT(la.language_id) AS cantidad  
        FROM RENTAL_MOVIE r
            INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
            INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
            INNER JOIN CITY ci ON a.city_id = ci.city_id 
            INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id 
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id 
            INNER JOIN MOVIE_LANGUAGE ml ON m.movie_id = ml.movie_id
            INNER JOIN LANGUAGE la ON ml.language_id = la.language_id
                WHERE TO_CHAR(r.rental_date,'MM') = 7 AND TO_CHAR(r.rental_date,'yyyy') = 2005
                    GROUP BY    ci.name,
                                la.name

)INNER JOIN (
    SELECT ciudad2, SUM(cantidad) AS total FROM (
        SELECT  ci.name AS ciudad2,
                la.name AS lenguaje2,
                COUNT(la.language_id) AS cantidad  
            FROM RENTAL_MOVIE r
                INNER JOIN CUSTOMER cu ON r.customer_id = cu.customer_id 
                INNER JOIN ADDRESS a ON cu.address_id = a.address_id 
                INNER JOIN CITY ci ON a.city_id = ci.city_id 
                INNER JOIN INVENTORY i ON r.inventory_id = i.inventory_id 
                INNER JOIN MOVIE m ON i.movie_id = m.movie_id 
                INNER JOIN MOVIE_LANGUAGE ml ON m.movie_id = ml.movie_id
                INNER JOIN LANGUAGE la ON ml.language_id = la.language_id
                    WHERE TO_CHAR(r.rental_date,'MM') = 7 AND TO_CHAR(r.rental_date,'yyyy') = 2005
                        GROUP BY    ci.name,
                                    la.name
    ) GROUP BY ciudad2

) ON ciudad = ciudad2;
