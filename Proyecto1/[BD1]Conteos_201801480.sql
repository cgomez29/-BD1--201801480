/* Author: Cristian Gomez - 201801480 */
-- COUNTS de todas las tablas utilizadas 

SELECT COUNT(*) FROM TEMPORARY;

SELECT COUNT(*) FROM COUNTRY;
SELECT COUNT(*) FROM CITY;
SELECT COUNT(*) FROM ACTOR;
SELECT COUNT(*) FROM CATEGORY;
SELECT COUNT(*) FROM CLASSIFICATION;
SELECT COUNT(*) FROM LANGUAGE;
SELECT COUNT(*) FROM ADDRESS;
SELECT COUNT(*) FROM SHOP;
SELECT COUNT(*) FROM EMPLOYEE;
SELECT COUNT(*) FROM CUSTOMER;
SELECT COUNT(*) FROM MOVIE;
SELECT COUNT(*) FROM MOVIE_LANGUAGE;
SELECT COUNT(*) FROM MOVIE_ACTOR;
SELECT COUNT(*) FROM INVENTORY;
SELECT COUNT(*) FROM RENTAL_MOVIE;



SELECT table_name, num_rows FROM all_tables WHERE owner = 'DB1';

select 'select count(*) from '||table_name||';' from dba_tables where owner = 'DB1';


select table_name, 
       to_number(extractvalue(xmltype(dbms_xmlgen.getxml('select count(*) c from '||owner||'.'||table_name)),'/ROWSET/ROW/C')) as count
from all_tables
where owner = 'DB1'