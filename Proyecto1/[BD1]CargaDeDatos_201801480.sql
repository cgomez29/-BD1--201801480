/* Author: Cristian Gomez - 201801480 */
-- upload data

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
-- Inserting data to the CLASIFICATION table 
-- ==================================================================================================

INSERT INTO CLASSIFICATION(name)
    SELECT DISTINCT(clasificacion) 
        FROM TEMPORARY 
            WHERE clasificacion != '-';

-- ==================================================================================================
-- Inserting data to the LANGUAGE table 
-- ==================================================================================================

INSERT INTO LANGUAGE(name)
    SELECT lenguaje_pelicula 
        FROM TEMPORARY
            WHERE lenguaje_pelicula != '-'
                GROUP BY lenguaje_pelicula;

-- ==================================================================================================
-- Inserting data to the ADDRESS table 
-- ==================================================================================================

-- Shop address
INSERT INTO ADDRESS(direction, postal_code, city_id)
    SELECT  direccion_tienda,
            (CASE WHEN codigo_postal_tienda = '-' THEN NULL ELSE codigo_postal_tienda END)AS CODE,
            c.city_id
        FROM TEMPORARY 
            INNER JOIN city c ON ciudad_tienda = c.name 
                WHERE nombre_tienda != '-' AND c.country_id = (SELECT country_id FROM COUNTRY WHERE name = pais_empleado) 
                    GROUP BY    direccion_tienda ,
                                ciudad_tienda ,
                                pais_tienda,
                                codigo_postal_tienda,
                                c.city_id;

-- ==================================================================================================
-- Inserting data to the SHOP table 
-- ==================================================================================================

INSERT INTO SHOP(address_id)    
    SELECT a.address_id
        FROM TEMPORARY 
            INNER JOIN ADDRESS a ON direccion_tienda = a.direction
            INNER JOIN CITY c ON a.city_id = (SELECT city_id FROM CITY WHERE name = ciudad_tienda)
                WHERE nombre_tienda != '-'
                GROUP BY nombre_tienda, a.address_id;
    
-- ==================================================================================================
-- Inserting data to the EMPLOYEE table 
-- ==================================================================================================

-- Employee address
INSERT INTO ADDRESS(direction, postal_code, city_id)
    SELECT  direccion_empleado, 
            (CASE WHEN codigo_postal_empleado = '-' THEN NULL ELSE codigo_postal_empleado END)AS CODE,
            c.city_id
        FROM TEMPORARY 
            INNER JOIN CITY c ON ciudad_empleado = c.name 
            WHERE nombre_empleado != '-' AND c.country_id = (SELECT country_id FROM COUNTRY WHERE name = pais_empleado) 
                GROUP BY    nombre_empleado,
                            direccion_empleado ,
                            codigo_postal_empleado ,
                            ciudad_empleado ,
                            pais_empleado,
                            c.city_id;
                    
INSERT INTO EMPLOYEE(name, surname, email, active, username, password, shop_id, address_id)                                            
    SELECT  SUBSTR(nombre_empleado, 1, INSTR(nombre_empleado, ' ')-1) as name,
            SUBSTR(nombre_empleado, INSTR(nombre_empleado, ' ')+1) as surname,
            correo_empleado,
            empleado_activo,
            usuario_empleado,
            password_empleado,
            s.shop_id,
            a.address_id
        FROM TEMPORARY
            INNER JOIN ADDRESS a ON direccion_empleado = a.direction
            INNER JOIN CITY c ON c.city_id = (SELECT city_id FROM CITY WHERE name = ciudad_empleado)
            INNER JOIN SHOP s ON s.address_id = (SELECT sh.shop_id FROM SHOP sh INNER JOIN ADDRESS ad ON sh.address_id = ad.address_id WHERE ad.direction = direccion_tienda)
            WHERE   nombre_empleado != '-' 
            GROUP BY    nombre_empleado ,
                        correo_empleado ,
                        empleado_activo ,
                        tienda_empleado ,
                        usuario_empleado ,
                        password_empleado ,
                        direccion_empleado ,
                        codigo_postal_empleado ,
                        ciudad_empleado ,
                        pais_empleado,
                        s.shop_id,
                        a.address_id;

-- ==================================================================================================
-- Inserting data to the CUSTOMER table 
-- ==================================================================================================

-- Customer address

INSERT INTO ADDRESS(direction, postal_code, city_id)
    SELECT  direccion_cliente, 
            (CASE WHEN codigo_postal_cliente = '-' THEN NULL ELSE codigo_postal_cliente END) AS CODE,
            c.city_id
        FROM TEMPORARY 
            INNER JOIN CITY c ON ciudad_cliente = c.name 
            WHERE nombre_cliente != '-' AND c.country_id = (SELECT country_id FROM COUNTRY WHERE name = pais_cliente) 
                GROUP BY    nombre_cliente ,
                            correo_cliente ,
                            cliente_activo ,
                            fecha_creacion ,
                            tienda_preferida ,
                            direccion_cliente ,
                            codigo_postal_cliente ,
                            ciudad_cliente ,
                            pais_cliente,
                            c.city_id;

INSERT INTO CUSTOMER(name, surname, email, registration_date, active, shop_id, address_id)
SELECT  SUBSTR(t.nombre_cliente, 1, INSTR(t.nombre_cliente, ' ')-1) as name,
        SUBSTR(t.nombre_cliente, INSTR(t.nombre_cliente, ' ')+1) as surname,
        t.correo_cliente ,
        (TO_TIMESTAMP(t.fecha_creacion, 'DD/MM/YYYY')),
        t.cliente_activo,
        s.shop_id,
        a.address_id 
    FROM TEMPORARY t
        INNER JOIN ADDRESS a ON t.direccion_cliente = a.direction AND t.codigo_postal_cliente = a.postal_code
        INNER JOIN SHOP s ON s.address_id = (
                SELECT sh.shop_id FROM SHOP sh WHERE address_id = (
                    SELECT ad.address_id
                        FROM TEMPORARY temp
                            INNER JOIN ADDRESS ad ON temp.direccion_tienda = ad.direction
                                WHERE temp.nombre_tienda != '-' AND temp.nombre_tienda = t.tienda_preferida
                                GROUP BY temp.nombre_tienda, ad.address_id
                )
            ) 
        WHERE nombre_cliente != '-' 
        GROUP BY    t.nombre_cliente ,
                    t.correo_cliente ,
                    t.cliente_activo ,
                    t.fecha_creacion ,
                    t.tienda_preferida,
                    t.direccion_cliente ,
                    t.codigo_postal_cliente ,
                    t.ciudad_cliente ,
                    t.pais_cliente,
                    s.shop_id,
                    a.address_id;

-- ==================================================================================================
-- Inserting data to the MOVIE table 
-- ==================================================================================================

INSERT INTO MOVIE(title, description, release_year, duration, days, rental_cost, damage_cost, native_language, classification_id)
    SELECT  nombre_pelicula,
            descripcion_pelicula,
            ano_lanzamiento,
            duracion,
            dias_renta,
            costo_renta,
            costo_por_dano,
            l.language_id,
            c.classification_id
    FROM TEMPORARY
        INNER JOIN CLASSIFICATION c ON  clasificacion = c.name 
        INNER JOIN LANGUAGE l ON lenguaje_pelicula = l.name
            WHERE nombre_pelicula != '-'
                GROUP BY    nombre_pelicula,
                            descripcion_pelicula,
                            ano_lanzamiento,
                            duracion,
                            dias_renta,
                            costo_renta,
                            costo_por_dano,
                            clasificacion,
                            lenguaje_pelicula,
                            categoria_pelicula,
                            l.language_id,
                            c.classification_id;

-- ==================================================================================================
-- Inserting data to the MOVIE_CATEGORY table 
-- ==================================================================================================

INSERT INTO MOVIE_CATEGORY(movie_id, category_id)
    SELECT  m.movie_id,
            ca.category_id
        FROM TEMPORARY 
            INNER JOIN CATEGORY ca ON categoria_pelicula = ca.name
            INNER JOIN MOVIE m ON nombre_pelicula = m.title
            WHERE nombre_pelicula != '-'
                GROUP BY    nombre_pelicula,
                            descripcion_pelicula,
                            ano_lanzamiento,
                            categoria_pelicula,
                            m.movie_id,
                            ca.category_id;

-- ==================================================================================================
-- Inserting data to the MOVIE_LANGUAGE table 
-- ==================================================================================================

INSERT INTO MOVIE_LANGUAGE(movie_id, language_id)
    SELECT  m.movie_id,
            l.language_id
        FROM TEMPORARY 
            INNER JOIN LANGUAGE l ON lenguaje_pelicula = l.name
            INNER JOIN MOVIE m ON nombre_pelicula = m.title
            WHERE nombre_pelicula != '-'
                GROUP BY    nombre_pelicula,
                            descripcion_pelicula,
                            ano_lanzamiento,
                            lenguaje_pelicula,
                            m.movie_id,
                            l.language_id;

-- ==================================================================================================
-- Inserting data to the MOVIE_ACTOR table 
-- ==================================================================================================

INSERT INTO MOVIE_ACTOR(movie_id, actor_id)
    SELECT  m.movie_id,
            a.actor_id
        FROM TEMPORARY 
            INNER JOIN ACTOR a ON actor_pelicula = CONCAT(CONCAT(name, ' '), surname)
            INNER JOIN MOVIE m ON nombre_pelicula = m.title
                WHERE nombre_pelicula != '-' and actor_pelicula != '-'
                    GROUP BY    nombre_pelicula,
                                actor_pelicula,
                                descripcion_pelicula,
                                ano_lanzamiento,
                                a.actor_id,
                                m.movie_id;


-- ==================================================================================================
-- Inserting data to the INVENTORY table 
-- ==================================================================================================

INSERT INTO INVENTORY(stock, movie_id, shop_id)
    SELECT  COUNT(t1.nombre_pelicula) Stock,
            m.movie_id,
            s.shop_id
        FROM TEMPORARY t1
            INNER JOIN MOVIE m ON t1.nombre_pelicula = m.title
            INNER JOIN SHOP s ON s.shop_id = (
                SELECT sh.shop_id FROM SHOP sh WHERE address_id = (
                    SELECT ad.address_id
                        FROM TEMPORARY temp
                            INNER JOIN ADDRESS ad ON temp.direccion_tienda = ad.direction
                                WHERE temp.nombre_tienda != '-' AND temp.nombre_tienda = t1.tienda_pelicula
                                GROUP BY temp.nombre_tienda, ad.address_id
                    )
                )
                WHERE t1.nombre_pelicula != '-' and t1.tienda_pelicula != '-'
                    GROUP BY    t1.tienda_pelicula,
                                t1.nombre_pelicula,
                                t1.descripcion_pelicula,
                                t1.ano_lanzamiento,
                                m.movie_id,
                                s.shop_id;


-- ==================================================================================================
-- Inserting data to the RENTAL_MOVIE table 
-- ==================================================================================================

INSERT INTO RENTAL_MOVIE (rental_date, return_date, amount_to_pay, pay_date, employee_id, inventory_id, customer_id)
  SELECT DISTINCT   (TO_TIMESTAMP(t1.fecha_renta, 'DD-MM-YYYY HH24:MI')), 
                    (CASE WHEN t1.fecha_retorno = '-' THEN NULL ELSE TO_TIMESTAMP(t1.fecha_retorno, 'DD-MM-YYYY HH24:MI') END) AS ReturnDate,
                     t1.monto_a_pagar,
                    (TO_TIMESTAMP(t1.fecha_pago, 'DD-MM-YYYY HH24:MI')),
                    e.employee_id,
                    i.inventory_id,
                    c.customer_id
        FROM TEMPORARY t1
            INNER JOIN MOVIE m ON t1.nombre_pelicula = m.title 
            INNER JOIN INVENTORY i ON m.movie_id = i.movie_id
            INNER JOIN EMPLOYEE e ON i.shop_id = e.shop_id
            INNER JOIN CUSTOMER c ON t1.correo_cliente = c.email 
                WHERE i.shop_id = (
                    SELECT sh.shop_id FROM SHOP sh WHERE sh.address_id = (
                        SELECT ad.address_id
                            FROM TEMPORARY temp
                                INNER JOIN ADDRESS ad ON temp.direccion_tienda = ad.direction
                                    WHERE temp.nombre_tienda != '-' AND temp.nombre_tienda = t1.tienda_pelicula
                                    GROUP BY temp.nombre_tienda, ad.address_id
                        )
                );

