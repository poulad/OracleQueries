-- Chapter 3 - Hands-On Assignments

-- 9
DECLARE
  proj_id dd_project.idproj%TYPE := &Project_ID;
  proj_name dd_project.projname%TYPE;
  pledge_count NUMBER;
  pledge_sum number;
  pledge_avg NUMBER;
BEGIN
  SELECT projname, count(pledgeamt), sum(pledgeamt), avg(pledgeamt)
    INTO proj_name, pledge_count, pledge_sum, pledge_avg
    FROM dd_project NATURAL JOIN dd_pledge
    GROUP BY idproj, projname
    HAVING idproj = proj_id;
  dbms_output.put_line(proj_id || ', ' || proj_name || ', ' || pledge_count
    || ', ' || pledge_sum || ', ' || pledge_avg
  );
END;


-- 10
-- DROP SEQUENCE dd_projid_seq;
CREATE SEQUENCE dd_projid_seq
  MINVALUE 530
  INCREMENT BY 1
  NOCACHE
;
DECLARE
  TYPE project_record IS record (
    ID dd_project.idproj%TYPE,
    NAME dd_project.projname%TYPE,
    startdate dd_project.projstartdate%TYPE,
    enddate dd_project.projenddate%TYPE,
    fund dd_project.projfundgoal%TYPE
  );
  new_project project_record;
BEGIN
  new_project.id := dd_projid_seq.nextval;
  new_project.NAME := 'HK Animal Shelter Extension';
  new_project.startdate := to_date('01/01/2013', 'mm/dd/yyyy');
  new_project.enddate := TO_DATE('05/31/2013', 'mm/dd/yyyy');
  new_project.fund := 65000;
  INSERT INTO dd_project(idproj, projname, projstartdate, projenddate, projfundgoal)
    VALUES(new_project.id, new_project.name, new_project.startdate, new_project.enddate, new_project.fund);
END;


-- 11
BEGIN
  FOR pledge IN (SELECT idpledge, iddonor, pledgeamt, paymonths
      FROM dd_pledge
      WHERE pledgedate BETWEEN startmonth AND endmonth
      ORDER BY paymonths)
  loop
    dbms_output.put(pledge.idpledge || ', ' || pledge.iddonor || ', ' ||
      '$' || pledge.pledgeamt || ', ');
    IF pledge.paymonths = 0 THEN
      dbms_output.put('Lump Sum.');
    ELSE
      dbms_output.put('Monthly - ' || pledge.paymonths);
    END IF;
    -- dbms_output.new_line();
  END LOOP;
END;


-- 12
DECLARE
  pledge_id dd_pledge.idpledge%TYPE := &plege_id;
  donor_id dd_pledge.iddonor%TYPE;
  amount dd_pledge.pledgeamt%TYPE;
  total_paid dd_payment.payamt%TYPE;
  difference dd_payment.payamt%TYPE;
BEGIN
  SELECT iddonor, pledgeamt, sum(payamt), pledgeamt - sum(payamt)
    INTO donor_id, amount, total_paid, difference
    FROM dd_pledge NATURAL JOIN dd_payment
    GROUP BY idpledge, iddonor, pledgeamt
    HAVING idpledge = pledge_id
  ;
  dbms_output.put_line(pledge_id || ', ' || donor_id || ', $' || amount || ', $'
    || total_paid || ', $' || difference);
END;


-- 13
DECLARE
  project_id dd_project.idproj%TYPE := &Project_id;
  project_name dd_project.projname%TYPE;
  startdate dd_project.projstartdate%TYPE;
  old_fund dd_project.projfundgoal%TYPE;
  new_fund dd_project.projfundgoal%TYPE := &New_Fund_Amount;
BEGIN
  SELECT projname, projstartdate, projfundgoal
    INTO project_name, startdate, old_fund
    FROM dd_project
    WHERE idproj = project_id;
  UPDATE dd_project
    SET projfundgoal = new_fund
    WHERE idproj = project_id;
  dbms_output.put_line('Project Name: ' || project_name ||', Start: ' ||
  startdate || ', Old fund goal: ' || old_fund || ', New fund goal: ' ||
  new_fund);
END;