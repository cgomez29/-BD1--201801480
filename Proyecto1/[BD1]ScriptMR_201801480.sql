/* Author: Cristian Gomez */

/* Borrado y creado de la base de datos propuesta */

SELECT * FROM TEMPORARY;

DROP TABLE DIRECTION;
DROP TABLE CUSTOMER;
DROP TABLE CITY;
DROP TABLE COUNTRY;

CREATE TABLE COUNTRY(
    country_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY.
    name VARCHAR2(200) NOT NULL,
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

ALTER TABLE COUNTRY ADD CONSTRAINT country_pk PRIMARY KEY(country_id);

CREATE TABLE CITY(
    city_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name VARCHAR(200) NOT NULL,
    country_id NUMBER NOT NULL,
    PRIMARY KEY(city_id),
    FOREIGN KEY(country_id) REFERENCES COUNTRY(country_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE SHOP(
    shop_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    direction VARCHAR /*PENDIENTE*/
    PRIMARY KEY(shop_id)
);

CREATE TABLE CUSTOMER(
    customer_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name VARCHAR(200) NOT NULL,
    surname VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,´
    registration_date DATE NOT NULL,
    state VARCHAR2(5) NOT NULL,
    shop_id NUMBER NOT NULL,
    PRIMARY KEY(customer_id),
    FOREIGN KEY(shop_id) REFERENCES SHOP(shop_id)
);

CREATE TABLE DIRECTION(
    direction_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    direction VARCHAR(100) NOT NULL,
    distric VARCHAR(100) NOT NULL,
    postal_code NUMBER(6) NOT NULL,
    city_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    PRIMARY KEY(direction_id),
    FOREIGN KEY(city_id) REFERENCES CITY(city_id),
    FOREIGN KEY(customer_id) REFERENCES CUSTOMER(customer_id)
); 



/* MOVIE */

CREATE TABLE CATEGORY(
    category_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name VARCHAR(100),
);

ALTER TABLE CATEGORY ADD CONSTRAINT category_pk PRIMARY KEY(category_id);

CREATE TABLE ACTOR(
    actor_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name VARCHAR(200) NOT NULL,
    surname VARCHAR(200) NOT NULL,
);

ALTER TABLE ACTOR ADD CONSTRAINT actor_pk PRIMARY KEY(actor_id);

CREATE TABLE MOVIE(
    movie_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    title VARCHAR2(200) NOT NULL,
    description VARCHAR2(200) NOT NULL,
    release_year NUMBER(4) NOT NULL,
    duration TIMESTAMP NOT NULL,
    days NUMBER(8) NOT NULL,
    rental_cost NUMBER(8,2) NOT NULL,
    damage_cost NUMBER(8,2) NOT NULL,
    classification VARCHAR2(10) NOT NULL,
    native_language NUMBER NOT NULL,
    category_id NUMBER NOT NULL,
);

ALTER TABLE MOVIE ADD CONSTRAINT movie_pk PRIMARY KEY(movie_id);
ALTER TABLE MOVIE ADD CONSTRAINT movie_category_fk FOREIGN KEY(category_id)
REFERENCES CATEGORY(category) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE LANGUAGE(
    language_id GENERATED BY DEFAULT ON NULL AS IDENTITY,
    name VARCHAR2(200) NOT NULL
);

ALTER TABLE LANGUAGE ADD CONSTRAINT language_pk PRIMARY KEY(language_id);

CREATE TABLE MOVIE_LANGUAGE(
    movie_language_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY,
    movie_id NUMBER NOT NULL,
    language_id NUMBER NOT NULL,
    PRIMARY KEY(movie_language_id),
    FOREIGN KEY(movie_id) REFERENCES MOVIE(movie_id),
    FOREIGN KEY(language_id) REFERENCES LANGUAGE(language_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);