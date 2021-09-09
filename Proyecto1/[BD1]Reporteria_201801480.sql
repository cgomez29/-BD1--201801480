/* Author: Cristian Gomez - 201801480 */

-- Queries

-- =================================================================================================================
--   1. Mostrar la cantidad de copias que existen en el inventario para la pelicula
--      'Sugar Wonka'.
-- =================================================================================================================
SELECT SUM(Cantidad) FROM (
    SELECT i.stock AS Cantidad
        FROM INVENTORY i
            INNER JOIN MOVIE m ON i.movie_id = m.movie_id
                WHERE m.title = 'SUGAR WONKA');

-- =================================================================================================================
--   2. Mostrar el nombre, apellido y pago total de todos los clientes que han rentado
--      peliculas por lo menos 40 veces.
-- =================================================================================================================

SELECT * FROM (
    SELECT  COUNT(c.customer_id) total,
            c.name,
            c.surname,
            SUM(amount_to_pay)
        FROM RENTAL_MOVIE r  
            INNER JOIN CUSTOMER c ON r.customer_id = c.customer_id
                GROUP BY    c.customer_id,
                            c.name,
                            c.surname
    ) WHERE total >= 40;

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
            ORDER BY a.name DESC;

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
--       que involucra un 'Cocodrilo' y un 'Tiburon' junto con el año de lanzamiento
--       de la pelicula, ordenados por el apellido del actor en forma ascendente.
-- =================================================================================================================





-- =================================================================================================================
--   7. Mostrar el nombre de la categoria y el numero de peliculas por categoria de
--      todas las categorias de peliculas en las que hay entre 55 y 65 peliculas.
--      Ordenar el resultado por numero de peliculas de forma descendente.
-- =================================================================================================================

-- =================================================================================================================
--   8. Mostrar todas las categorias de peliculas en las que la diferencia promedio
--      entre el costo de reemplazo de la pelicula y el precio de alquiler sea superior
--      a 17.
-- =================================================================================================================

-- =================================================================================================================
--    9. Mostrar el titulo de la pelicula, el nombre y apellido del actor de todas
--       aquellas peliculas en las que uno o mas actores actuaron en dos o mas
--       peliculas.
-- =================================================================================================================

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

-- =================================================================================================================
--   14. Mostrar todas las ciudades por pais en las que predomina la renta de
--       peliculas de la categoria 'Horror'. Es decir, hay mas rentas que las otras
--       categorias
-- =================================================================================================================

-- =================================================================================================================
--    15. Mostrar el nombre del pais, la ciudad y el promedio de rentas por ciudad. Por
--        ejemplo: si el pais tiene 3 ciudades, se deben sumar todas las rentas de la
--        ciudad y dividirlo dentro de tres (numero de ciudades del pais).
-- =================================================================================================================

-- =================================================================================================================
--   16. Mostrar el nombre del pais y el porcentaje de rentas de peliculas de la
--       categoria 'Sports'.
-- =================================================================================================================

-- =================================================================================================================
--   17. Mostrar la lista de ciudades de Estados Unidos y el numero de rentas de
--       peliculas para las ciudades que obtuvieron mas rentas que la ciudad
--       'Dayton'.
-- =================================================================================================================

-- =================================================================================================================
--   18. Mostrar el nombre, apellido y fecha de retorno de pelicula a la tienda de todos
--       los clientes que hayan rentado mas de 2 peliculas que se encuentren en
--       lenguaje Ingles en donde el empleado que se las vendio ganara mas de 15
--       dolares en sus rentas del dia en la que el cliente rento la pelicula.
-- =================================================================================================================

-- =================================================================================================================
--   19. Mostrar el numero de mes, de la fecha de renta de la pelicula, nombre y
--       apellido de los clientes que mas peliculas han rentado y las que menos en
--       una sola consulta.
-- =================================================================================================================

-- =================================================================================================================
--   20. Mostrar el porcentaje de lenguajes de peliculas mas rentadas de cada ciudad
--       durante el mes de julio del año 2005 de la siguiente manera: ciudad,
--       lenguaje, porcentaje de renta.
-- =================================================================================================================