-- Chapter 6 - Hands-On Assignments

-- 1
CREATE SEQUENCE customers_customer#_seq
  INCREMENT BY 1
  START WITH 1021
  --MINVALUE 1021
  NOCYCLE NOCACHE
;

-- 2
INSERT INTO customers(customer#, lastname, firstname, zip)
  VALUES(customers_customer#_seq.NEXTVAL, 'Shoulders', 'Frank', '23567')
;

-- 3
DROP SEQUENCE my_first_seq;
CREATE SEQUENCE my_first_seq
  INCREMENT BY -3
  --START WITH 5
  MAXVALUE 5
  MINVALUE 0
  NOCYCLE
;

-- 4
--SELECT my_first_seq.NEXTVAL, my_first_seq.NEXTVAL, my_first_seq.NEXTVAL FROM dual;
SELECT my_first_seq.NEXTVAL FROM dual CONNECT BY LEVEL <= 3;

-- 5
ALTER SEQUENCE my_first_seq
  MINVALUE -1000;

-- 6
CREATE SYNONYM numgen FOR my_first_seq;

-- 7
SELECT numgen.CURRVAL FROM dual;
DROP SYNONYM numgen;
DROP SEQUENCE my_first_seq;

-- 8
CREATE BITMAP INDEX customers_satate_idx
  ON customers(state);
SELECT * FROM user_indexes WHERE index_name = UPPER('customers_satate_idx');
DROP INDEX customers_satate_idx;

-- 9
CREATE INDEX customers_lastname_idx
  ON customers(lastname);
SELECT * FROM user_indexes WHERE index_name = UPPER('customers_lastname_idx');
DROP INDEX customers_lastname_idx;

-- 10
CREATE INDEX orders_daystoship_idx
  ON orders(shipdate - orderdate)
;

