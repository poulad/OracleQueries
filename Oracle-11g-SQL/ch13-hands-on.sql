-- Chapter 13 - Hands-On Assignments

-- 1
CREATE VIEW contact AS
  SELECT NAME publisher, contact, phone FROM publisher
;

-- 2
CREATE OR REPLACE VIEW contact AS
  SELECT NAME publisher, contact, phone FROM publisher
  WITH READ ONLY
;

-- 3
CREATE FORCE VIEW homework13 AS
  SELECT col1, col2 FROM firstattempt
;

-- 4
DESC homework13;

-- 5
CREATE VIEW reorderinfo AS
  SELECT isbn, title, contact, phone
    FROM books NATURAL JOIN publisher
;

-- 6
UPDATE reorderinfo SET contact = 'POULAD' WHERE title LIKE '%MICKEY%';
/* 
  Error: Can not update columns of a non-key-preserved table
  Column CONTACT belongs to the PUBLISHER table, but the PRIMARY KEY
  of PUBLISHER table is not listed in the view.
*/

-- 7
UPDATE reorderinfo SET isbn = 0202020202 WHERE title LIKE '%MICKEY%';
/* 
  Error: Integrity constraint violated
  Since the ISBN column is referenced as a foreign key in other tables,
  any attempt to change its value will fail.
*/

-- 8
DELETE FROM reorderinfo WHERE title LIKE '%MICKEY%';
/* 
  Error: Integrity constraint violated
  Since the ISBN column is referenced as a foreign key in other tables,
  any attempt to delete the record will fail.
*/

-- 9
ROLLBACK;

-- 10
DROP VIEW reorderinfo;

-- Advance Challenge;
CREATE VIEW profitable AS
  SELECT isbn, title, ROUND((retail-cost)/cost*100, 2) profit_percentage
    FROM books
    WHERE isbn IN (
      SELECT isbn FROM orderitems
      GROUP BY isbn
      ORDER BY SUM(quantity) DESC
      FETCH FIRST 5 ROWS ONLY
    )
  WITH READ ONLY
;

SELECT * FROM profitable;
