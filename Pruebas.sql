

-- ==================================================================================================
--  ANOTATIONS
-- ==================================================================================================


-- 1. X
-- 2. *
-- 3. *
-- 4. *
-- 5. *
-- 6. *
-- 7. *
-- 8. *
-- 9. *
-- 10. **
-- 11. X
-- 12. - 
-- 13. *
-- 14. *
-- 15. *
-- 16. *
-- 17. *
-- 18. *
-- 19. *?????????????
-- 20. *


-- ====================================================

SELECT  COUNT(ac.surname),
        ac.surname,
        ac.name
    FROM  ACTOR ac
        WHERE ac.name = (
            SELECT name FROM (
                SELECT  COUNT(a.name) AS n,
                        a.name
                    FROM ACTOR a 
                        WHERE a.name = ac.name
                            GROUP BY a.name
                ) WHERE n >= 2            
            )
        GROUP BY ac.surname, ac.name;
        
Select * from Actor WHERE surname = 'Akroyd';
Select * from Actor WHERE name = 'Debbie';
Select * from Actor WHERE name = 'Christian';
Select * from Actor WHERE name = 'Kirsten';

    SELECT  COUNT(ac.surname) AS n,
            ac.surname
        FROM ACTOR ac 
            WHERE (
                SELECT COUNT(name) FROM (
                    SELECT  a.name,
                            a.surname
                        FROM ACTOR a 
                            WHERE a.name = ac.name
                                GROUP BY a.name, 
                                     a.surname
                    )   
            ) >= 2
            GROUP BY ac.surname 
    



-- ==================================================================================================
-- Creation of the REWARD table
-- ==================================================================================================

CREATE TABLE REWARD(
    reward_id           NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    amount_to_pay       NUMBER(8,4)     NOT NULL,
    pay_date            TIMESTAMP       NOT NULL,
    employee_id         NUMBER          NOT NULL  
);

ALTER TABLE REWARD 
    ADD CONSTRAINT reward_pk PRIMARY KEY(reward_id);

ALTER TABLE REWARD 
    ADD CONSTRAINT reward_employee_fk FOREIGN KEY(employee_id)
        REFERENCES EMPLOYEE(employee_id);


-- ==================================================================================================
-- Inserting data to the REWARD table 
-- ==================================================================================================

INSERT INTO REWARD(amount_to_pay, pay_date, employee_id) 
    SELECT  monto_a_pagar,
            (TO_TIMESTAMP(fecha_pago, 'DD-MM-YYYY HH24:MI')),
            e.employee_id
        FROM TEMPORARY
            INNER JOIN EMPLOYEE e ON e.username = usuario_empleado AND e.email = correo_empleado
            WHERE   nombre_empleado != '-' AND nombre_cliente != '-' AND
                    fecha_renta != '-' AND fecha_retorno != '-'
            GROUP BY    direccion_cliente ,
                        nombre_empleado,
                        correo_empleado,
                        empleado_activo,
                        tienda_empleado,
                        usuario_empleado,
                        fecha_renta, 
                        fecha_retorno, 
                        monto_a_pagar,
                        nombre_cliente,
                        correo_cliente,
                        nombre_pelicula,
                        fecha_pago,
                        e.employee_id;


-- rental_movie


    SELECT DISTINCT  (TO_TIMESTAMP(t1.fecha_renta, 'DD-MM-YYYY HH24:MI')) AS rental_date, 
            (CASE WHEN t1.fecha_retorno = '-' THEN NULL ELSE TO_TIMESTAMP(t1.fecha_retorno, 'DD-MM-YYYY HH24:MI') END) AS return_date,
             t1.monto_a_pagar AS amount_to_pay,
            (TO_TIMESTAMP(t1.fecha_pago, 'DD-MM-YYYY HH24:MI')) AS pay_date,
            e.employee_id,
            i.inventory_id AS inventory_id,
            c.customer_id AS customer_id
        FROM TEMPORARY t1
            INNER JOIN EMPLOYEE e ON t1.usuario_empleado = e.username
            INNER JOIN CUSTOMER c ON t1.correo_cliente = c.email
            INNER JOIN INVENTORY i ON i.inventory_id = (
                    SELECT  inv.inventory_id 
                            FROM INVENTORY inv 
                                INNER JOIN MOVIE m ON inv.movie_id = m.movie_id 
                                INNER JOIN SHOP s ON inv.shop_id = s.shop_id 
                                    WHERE   t1.tienda_pelicula != '-' AND t1.nombre_pelicula != '-' AND
                                            m.title = t1.nombre_pelicula AND s.shop_id = (
                                                SELECT sh.shop_id FROM SHOP sh WHERE sh.address_id = (
                                                    SELECT ad.address_id
                                                        FROM TEMPORARY temp
                                                            INNER JOIN ADDRESS ad ON temp.direccion_tienda = ad.direction
                                                                WHERE temp.nombre_tienda != '-' AND temp.nombre_tienda = t1.tienda_pelicula
                                                                GROUP BY temp.nombre_tienda, ad.address_id
                                                    )
                    )
                ) 
            
            WHERE   t1.nombre_cliente != '-' AND t1.nombre_pelicula != '-' AND t1.nombre_empleado != '-' AND
                    t1.tienda_pelicula != '-';   
  

  -- =================================================================================================================
--   11. Mostrar el pais y el nombre del cliente que mas peliculas rento asi como
--       tambien el porcentaje que representa la cantidad de peliculas que rento con
--       respecto al resto de clientes del pais
-- =================================================================================================================
SELECT  cu.name,
        cu.surname,
        cu.email,
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
--    15. Mostrar el nombre del pais, la ciudad y el promedio de rentas por pais. Por
--        ejemplo: si el pais tiene 3 ciudades, se deben sumar todas las rentas de la
--        ciudad y dividirlo dentro de tres (numero de ciudades del pais).
-- =================================================================================================================

SELECT pais, AVG(cantidad) FROM (

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
) GROUP BY pais;


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


ALTER TABLE EMPLOYEE
    ADD CONSTRAINT ck_employee_active CHECK (active IN ('Si', 'No'));

select * from employee;