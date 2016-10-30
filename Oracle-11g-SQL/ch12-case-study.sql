-- Chapter 13 - Hands-On Assignments

-- 1
SELECT LAST, FIRST 
  FROM officers 
  WHERE officer_id IN
    (SELECT officer_id
      FROM crime_officers
      GROUP BY officer_id
      HAVING COUNT(*) >
        (SELECT AVG(COUNT(*)) FROM crime_officers GROUP BY officer_id)
    )
;

-- 2
SELECT LAST, FIRST
  FROM criminals
    NATURAL JOIN
      (SELECT criminal_id
        FROM crimes
        GROUP BY criminal_id
        HAVING count(*) < 
          (SELECT avg(count(*)) FROM crimes GROUP BY criminal_id))
  WHERE v_status = 'N'
;

-- 3
SELECT appeal_id, crime_id, hearing_date - filing_date "DAYS", status
  FROM appeals
  WHERE (hearing_date - filing_date) < 
    (SELECT avg(hearing_date - filing_date) FROM appeals)
;

-- 4
SELECT LAST, FIRST
  FROM prob_officers
  JOIN
    (SELECT prob_id 
      FROM sentences
      GROUP BY prob_id
      HAVING count(*) < (SELECT AVG(COUNT(*)) FROM sentences GROUP BY prob_id HAVING prob_id IS NOT NULL)
        AND prob_id IS NOT NULL)
    USING (prob_id)
;

-- 5
SELECT * FROM crimes
  WHERE crime_id IN
    (SELECT crime_id FROM appeals
      GROUP BY crime_id
      HAVING count(*) = (SELECT MAX(COUNT(*)) FROM appeals GROUP BY crime_id)
    )
;
