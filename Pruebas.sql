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