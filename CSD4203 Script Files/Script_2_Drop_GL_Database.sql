-- DROP GL Database for Database Programming using SQL & PL/SQL -- 

BEGIN
  FOR i IN ( SELECT table_name
             FROM   user_tables
             WHERE table_name LIKE 'GL%' )
  LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || i.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
  
  -- Remove the following two DROPs
  EXECUTE IMMEDIATE 'DROP TABLE employees    CASCADE CONSTRAINTS';
  EXECUTE IMMEDIATE 'DROP TABLE departments  CASCADE CONSTRAINTS';
  DBMS_OUTPUT.PUT_LINE ('All exercise tables dropped');  
END;