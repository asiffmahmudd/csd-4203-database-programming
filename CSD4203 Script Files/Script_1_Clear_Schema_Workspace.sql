BEGIN
  FOR i IN ( SELECT table_name
             FROM user_tables )
  LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || i.table_name || ' CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE(i.table_name || ' table dropped');
  END LOOP;
  
  FOR i IN (SELECT 'DROP ' || object_type || ' ' || object_name as stmt
            FROM user_objects
            WHERE object_type IN ('VIEW', 'PACKAGE', 'SEQUENCE', 'PROCEDURE', 'FUNCTION', 'INDEX'))
  LOOP
    EXECUTE IMMEDIATE i.stmt;
  END LOOP;
  
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('Schema Workspace is clean');
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

