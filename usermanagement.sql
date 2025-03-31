ALTER PLUGGABLE DATABASE ORCLPDB OPEN;

CREATE USER lasindu IDENTIFIED BY lasindu;

CREATE USER shashimalnew IDENTIFIED BY shashimal_password;

GRANT CREATE SESSION TO shashimalnew;

GRANT ALL PRIVILEGES TO LASINDU;


-- Connect as shashimalnew user
-- Create a table inside the schema
CREATE TABLE shashimalnew.my_table (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);


BEGIN
   FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'SHASHIMALNEW') LOOP
      EXECUTE IMMEDIATE 'GRANT ALL ON SHASHIMALNEW.' || t.table_name || ' TO lasindu';
   END LOOP;
END;
/

-- Grant UPDATE and DELETE privileges to user LASINDU on a specific table
GRANT UPDATE, DELETE ON shashimalnew.my_table TO LASINDU;

CREATE TABLE shashimalnew.employee_info (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(100),
    emp_salary NUMBER,
    emp_department VARCHAR2(50)
);


GRANT UPDATE (emp_salary) ON shashimalnew.employee_info TO LASINDU;

-------------------------------------------------------------

CREATE ROLE COADMIN;

GRANT CREATE TABLE TO COADMIN WITH ADMIN OPTION;

GRANT SELECT ON shashimalnew.my_table TO COADMIN;

CREATE ROLE USERMANAGER;

GRANT USERMANAGER TO lasindu;

GRANT USERMANAGER TO COADMIN;


