DECLARE 
    v_professor GL_PROFESSORS_COPY%ROWTYPE; 
    v_professor_no v_professor.PROFESSOR_NO%TYPE := :ENTER_PROFESSOR_NO;
    v_first_name v_professor.FIRST_NAME%TYPE := :ENTER_FIRST_NAME;
    v_last_name v_professor.LAST_NAME%TYPE := :ENTER_LAST_NAME;
    v_office_no v_professor.OFFICE_NO%TYPE := :ENTER_OFFICE_NO;
    v_office_ext v_professor.OFFICE_EXT%TYPE := :ENTER_OFFICE_EXT;
    v_school_code v_professor.SCHOOL_CODE%TYPE := :ENTER_SCHOOL_CODE;
    H1 STRING(20) := 'Professor Added';
    H2 STRING(20) := LPAD('-', LENGTH(H1), '-');
BEGIN
    --Executable section begins
    v_first_name := UPPER(SUBSTR(v_first_name, 1, 1)) || LOWER(SUBSTR(v_first_name, 2, LENGTH(v_first_name)));
    v_last_name := UPPER(SUBSTR(v_last_name, 1, 1)) || LOWER(SUBSTR(v_last_name, 2, LENGTH(v_last_name)));
    v_school_code := UPPER(v_school_code);
    INSERT INTO GL_PROFESSORS_COPY
    VALUES(v_professor_no, v_first_name, v_last_name, v_office_no, v_office_ext, v_school_code);
    
    DBMS_OUTPUT.PUT_LINE(H1);
    DBMS_OUTPUT.PUT_LINE(H2);
    DBMS_OUTPUT.PUT_LINE('Professor no: ' || v_professor_no);
    DBMS_OUTPUT.PUT_LINE('First name: ' || v_first_name);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Old Office no: ' || v_office_no);
    DBMS_OUTPUT.PUT_LINE('Old Office ext: ' || v_office_ext);
    DBMS_OUTPUT.PUT_LINE('School code: ' || v_school_code);
    

EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
