DECLARE 
    v_professor_no GL_PROFESSORS_COPY.PROFESSOR_NO%TYPE := :ENTER_PROFESSOR_NO;
    v_new_office_no GL_PROFESSORS_COPY.OFFICE_NO%TYPE := :ENTER_NEW_OFFICE_NO;
    v_new_office_ext GL_PROFESSORS_COPY.OFFICE_EXT%TYPE := :ENTER_NEW_OFFICE_EXT;
    
    v_prof_info GL_PROFESSORS_COPY%ROWTYPE;

    H1 STRING(20) := 'Professor Updated';
    H2 STRING(20) := LPAD('-', LENGTH(H1), '-');
BEGIN
    --Executable section begins
    SELECT * 
    INTO v_prof_info
    FROM GL_PROFESSORS_COPY
    WHERE PROFESSOR_NO = v_professor_no;

    UPDATE GL_PROFESSORS_COPY
    SET
        OFFICE_NO = v_new_office_no,
        OFFICE_EXT = v_new_office_ext
    WHERE
        PROFESSOR_NO = v_professor_no;
    
    DBMS_OUTPUT.PUT_LINE(H1);
    DBMS_OUTPUT.PUT_LINE(H2);
    DBMS_OUTPUT.PUT_LINE('Professor no: ' || v_professor_no);
    DBMS_OUTPUT.PUT_LINE('First name: ' || v_prof_info.first_name);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || v_prof_info.last_name);
    DBMS_OUTPUT.PUT_LINE('Old Office no: ' || v_prof_info.office_no || ' New Office no: ' || v_new_office_no);
    DBMS_OUTPUT.PUT_LINE('Old Office ext: ' || v_prof_info.office_ext || ' New Office ext: ' || v_new_office_ext);
    DBMS_OUTPUT.PUT_LINE('School code: ' || v_prof_info.school_code);
    

EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
