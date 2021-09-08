/* Author: Cristian Gomez - 201801480 */
-- Borrado y creado de la base de datos propuesta */

-- ==================================================================================================
-- Deletion of the entire model
-- ==================================================================================================

DROP TABLE SHOP_INVENTORY;
DROP TABLE INVENTORY;
DROP TABLE MOVIE_LANGUAGE;
DROP TABLE LANGUAGE;
DROP TABLE MOVIE_ACTOR;
DROP TABLE MOVIE;
DROP TABLE ACTOR;
DROP TABLE CATEGORY;
DROP TABLE RENTAL_MOVIE;
DROP TABLE CUSTOMER;
DROP TABLE EMPLOYEE;
DROP TABLE SHOP;
DROP TABLE ADDRESS;
DROP TABLE CITY;
DROP TABLE COUNTRY;

-- ==================================================================================================
-- Creation of the COUNTRY table 
-- ==================================================================================================


CREATE TABLE COUNTRY(
    country_id      NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name            VARCHAR2(200)      NOT NULL
);

ALTER TABLE COUNTRY 
    ADD CONSTRAINT country_pk PRIMARY KEY(country_id);

-- ==================================================================================================
-- Creation of the CITY table 
-- ==================================================================================================

CREATE TABLE CITY(
    city_id                 NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name                    VARCHAR(200)    NOT NULL,
    country_id              NUMBER          NOT NULL
);

ALTER TABLE CITY
    ADD CONSTRAINT city_pk PRIMARY KEY(city_id);

ALTER TABLE CITY
    ADD CONSTRAINT city_country_fk FOREIGN KEY(country_id)
        REFERENCES COUNTRY(country_id);

-- ==================================================================================================
-- Creation of the ACTOR table 
-- ==================================================================================================

CREATE TABLE ACTOR (
    actor_id        NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name            VARCHAR(200)    NOT NULL,
    surname         VARCHAR(200)    NOT NULL
);

ALTER TABLE ACTOR 
    ADD CONSTRAINT actor_pk PRIMARY KEY(actor_id);

-- ==================================================================================================
-- Creation of the CATEGORY table
-- ==================================================================================================


CREATE TABLE CATEGORY(
    category_id     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name            VARCHAR(100)
);

ALTER TABLE CATEGORY 
    ADD CONSTRAINT category_pk PRIMARY KEY(category_id);


-- ==================================================================================================
-- Creation of the CLASIFICATION table
-- ==================================================================================================

CREATE TABLE CLASSIFICATION(
    classification_id     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name                  VARCHAR(100)
);

ALTER TABLE CLASSIFICATION 
    ADD CONSTRAINT classification_pk PRIMARY KEY(classification_id);

-- ==================================================================================================
-- Creation of the LANGUAGE table 
-- ==================================================================================================

CREATE TABLE LANGUAGE(
    language_id     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name            VARCHAR2(200) NOT NULL
);

ALTER TABLE LANGUAGE 
    ADD CONSTRAINT language_pk PRIMARY KEY(language_id);

-- ==================================================================================================
-- Creation of the ADDRESS table
-- ==================================================================================================
select count(*) from address;


CREATE TABLE ADDRESS(
    address_id          NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    direction           VARCHAR(100)    NOT NULL,
    distric             VARCHAR(100)    NULL,
    postal_code         NUMBER(6)       NULL,
    city_id             NUMBER          NOT NULL
); 

ALTER TABLE ADDRESS
    ADD CONSTRAINT address_pk PRIMARY KEY(address_id);

ALTER TABLE ADDRESS 
    ADD CONSTRAINT address_city_fk FOREIGN KEY(city_id)
        REFERENCES CITY(city_id);

-- ==================================================================================================
-- Creation of the SHOP table 
-- ==================================================================================================

CREATE TABLE SHOP(
    shop_id         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    address_id      NUMBER          NOT NULL
);

ALTER TABLE SHOP 
    ADD CONSTRAINT shop_pk PRIMARY KEY(shop_id);

ALTER TABLE SHOP
    ADD CONSTRAINT shop_address_fk FOREIGN KEY(address_id)
        REFERENCES ADDRESS(address_id);


-- ==================================================================================================
-- Creation of the EMPLOYEE table 
-- ==================================================================================================
-- INSERT INTO EMPLOYEE(name, surname, email, active, username, password, shop_id, address_id)                    
                
CREATE TABLE EMPLOYEE(
    employee_id         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name                VARCHAR(200)    NOT NULL,
    surname             VARCHAR(200)    NOT NULL,
    email               VARCHAR(200)    NOT NULL,
    active              VARCHAR2(5)     NOT NULL,
    username            VARCHAR(200)    NOT NULL,
    password            VARCHAR(200)    NOT NULL,
    shop_id             NUMBER          NOT NULL,
    address_id          NUMBER          NOT NULL 
);

ALTER TABLE EMPLOYEE
    ADD CONSTRAINT  employee_pk PRIMARY KEY(employee_id);

ALTER TABLE EMPLOYEE 
    ADD CONSTRAINT employee_shop_fk FOREIGN KEY(shop_id)
        REFERENCES SHOP(shop_id);

ALTER TABLE EMPLOYEE 
    ADD CONSTRAINT employee_address_fk FOREIGN KEY(address_id)
        REFERENCES ADDRESS(address_id);


-- ==================================================================================================
-- Creation of the CUSTOMER table
-- ==================================================================================================


CREATE TABLE CUSTOMER(
    customer_id         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name                VARCHAR(200)    NOT NULL,
    surname             VARCHAR(200)    NOT NULL,
    email               VARCHAR(200)    NOT NULL,
    registration_date   DATE            NOT NULL,
    active              VARCHAR2(5)     NOT NULL,
    shop_id             NUMBER          NOT NULL,
    address_id          NUMBER          NOT NULL 
);

ALTER TABLE CUSTOMER 
    ADD CONSTRAINT customer_pk PRIMARY KEY(customer_id);

ALTER TABLE CUSTOMER 
    ADD CONSTRAINT customer_shop_fk FOREIGN KEY(shop_id)
        REFERENCES SHOP(shop_id);

ALTER TABLE CUSTOMER 
    ADD CONSTRAINT customer_address_fk FOREIGN KEY(address_id)
        REFERENCES ADDRESS(address_id);

-- ==================================================================================================
-- Creation of the MOVIE table 
-- ==================================================================================================

CREATE TABLE MOVIE(
    movie_id            NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    title               VARCHAR2(200)   NOT NULL,
    description         VARCHAR2(200)   NOT NULL,
    release_year        NUMBER(4)       NOT NULL,
    duration            NUMBER(4)          NOT NULL,
    days                NUMBER(8)       NOT NULL,
    rental_cost         NUMBER(8,2)     NOT NULL,
    damage_cost         NUMBER(8,2)     NOT NULL,
    native_language     NUMBER          NOT NULL,
    classification_id   NUMBER          NOT NULL,
    category_id         NUMBER          NOT NULL
);

ALTER TABLE MOVIE 
    ADD CONSTRAINT movie_pk PRIMARY KEY(movie_id);

ALTER TABLE MOVIE 
    ADD CONSTRAINT movie_classification_fk FOREIGN KEY(classification_id)
        REFERENCES CLASSIFICATION(classification_id) ON DELETE CASCADE;

ALTER TABLE MOVIE 
    ADD CONSTRAINT movie_category_fk FOREIGN KEY(category_id)
        REFERENCES CATEGORY(category_id) ON DELETE CASCADE;

-- ==================================================================================================
-- Creation of the INVENTORY table 
-- ==================================================================================================

CREATE TABLE INVENTORY(
    inventory_id        NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    stock               NUMBER NOT NULL,
    movie_id            NUMBER NOT NULL,
    shop_id             NUMBER NOT NULL
);

ALTER TABLE INVENTORY 
    ADD CONSTRAINT inventory_pk PRIMARY KEY(inventory_id);

ALTER TABLE INVENTORY    
    ADD CONSTRAINT inventory_movie_fk FOREIGN KEY(movie_id)
        REFERENCES MOVIE(movie_id);

ALTER TABLE INVENTORY    
    ADD CONSTRAINT inventory_shop_fk FOREIGN KEY(shop_id)
        REFERENCES SHOP(shop_id);

-- ==================================================================================================
-- Creation of the RENTAL_MOVIE table
-- ==================================================================================================

CREATE TABLE RENTAL_MOVIE(
    rental_movie_id     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    rental_date         TIMESTAMP       NOT NULL,
    return_date         TIMESTAMP       NULL,
    amount_to_pay       NUMBER(8,4)     NOT NULL,
    pay_date            TIMESTAMP       NOT NULL,
    employee_id         NUMBER          NOT NULL,  
    inventory_id        NUMBER          NOT NULL,
    customer_id         NUMBER          NOT NULL 
);

ALTER TABLE RENTAL_MOVIE
    ADD CONSTRAINT rental_movie_pk PRIMARY KEY(rental_movie_id);

ALTER TABLE RENTAL_MOVIE 
    ADD CONSTRAINT rental_movie_employee_fk FOREIGN KEY(employee_id)
        REFERENCES EMPLOYEE(employee_id);

ALTER TABLE RENTAL_MOVIE 
    ADD CONSTRAINT rental_movie_inventory_fk FOREIGN KEY(inventory_id)
        REFERENCES INVENTORY(inventory_id);

ALTER TABLE RENTAL_MOVIE 
    ADD CONSTRAINT rental_movie_customer_fk FOREIGN KEY(customer_id)
        REFERENCES CUSTOMER(customer_id);

-- ==================================================================================================
-- Creation of the MOVIE_ACTOR table 
-- ==================================================================================================

CREATE TABLE MOVIE_ACTOR(
    movie_actor_id      NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    movie_id            NUMBER      NOT NULL,
    actor_id            NUMBER       NOT NULL
);

ALTER TABLE MOVIE_ACTOR
    ADD CONSTRAINT movie_actor_pk PRIMARY KEY(movie_actor_id);

ALTER TABLE MOVIE_ACTOR 
    ADD CONSTRAINT movie_actor_movie_fk FOREIGN KEY(movie_id)
    REFERENCES MOVIE(movie_id);

ALTER TABLE MOVIE_ACTOR 
    ADD CONSTRAINT movie_actor_actor_fk FOREIGN KEY(actor_id)
    REFERENCES ACTOR(actor_id);

-- ==================================================================================================
-- Creation of the MOVIE_LANGUAGE table 
-- ==================================================================================================


CREATE TABLE MOVIE_LANGUAGE(
    movie_language_id       NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    movie_id                NUMBER      NOT NULL,
    language_id             NUMBER      NOT NULL
);

ALTER TABLE MOVIE_LANGUAGE 
    ADD CONSTRAINT movie_language_pk PRIMARY KEY(movie_language_id);

ALTER TABLE MOVIE_LANGUAGE
    ADD CONSTRAINT movie_language_movie_fk FOREIGN KEY(movie_id)
        REFERENCES MOVIE(movie_id);

ALTER TABLE MOVIE_LANGUAGE
    ADD CONSTRAINT movie_language_language_fk FOREIGN KEY(language_id)
        REFERENCES LANGUAGE(language_id);
        
