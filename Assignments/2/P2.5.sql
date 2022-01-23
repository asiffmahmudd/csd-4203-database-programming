CREATE OR REPLACE VIEW GL_PROV1 AS
    SELECT 
        PROFESSOR_NO,
        FIRST_NAME || ' ' || LAST_NAME AS NAME,
        OFFICE_NO,
        OFFICE_EXT,
        SCHOOL_NAME
    FROM
        GL_PROFESSORS
        JOIN GL_SCHOOLS USING(SCHOOL_CODE); 

DECLARE 
    H1 STRING(50) := 'Professor Information';
    H2 STRING(50) := LPAD('-', LENGTH(H1), '-');
    prof_info GL_PROV1%ROWTYPE;
    prof_no NUMBER := :ENTER_PROFESSOR_NO;
BEGIN
    --Executable section begins
    SELECT *
    INTO prof_info
    FROM GL_PROV1
    WHERE PROFESSOR_NO = prof_no;

    DBMS_OUTPUT.PUT_LINE(H1);
    DBMS_OUTPUT.PUT_LINE(H2);

    DBMS_OUTPUT.PUT_LINE('Professor no: ' || prof_info.PROFESSOR_NO);
    DBMS_OUTPUT.PUT_LINE('Name: ' || prof_info.NAME);
    DBMS_OUTPUT.PUT_LINE('Office no: ' || prof_info.OFFICE_NO);
    DBMS_OUTPUT.PUT_LINE('Office ext: ' || prof_info.OFFICE_EXT);
    DBMS_OUTPUT.PUT_LINE('School: ' || prof_info.SCHOOL_NAME);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
