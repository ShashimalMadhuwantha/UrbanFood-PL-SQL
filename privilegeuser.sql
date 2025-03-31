

-- Grant SELECT privilege on a specific table
GRANT SELECT ON shashimalnew.my_table TO other_user;

-- Grant all privileges on all tables in the schema
BEGIN
   FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'SHASHIMALNEW') LOOP
      EXECUTE IMMEDIATE 'GRANT ALL ON SHASHIMALNEW.' || t.table_name || ' TO lasindu';
   END LOOP;
END;
/
