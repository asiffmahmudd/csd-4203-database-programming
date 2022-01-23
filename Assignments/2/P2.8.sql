DECLARE 
    v_professor_no GL_PROFESSORS_COPY.PROFESSOR_NO%TYPE := :ENTER_PROFESSOR_NO;
    v_prof_info GL_PROFESSORS_COPY%ROWTYPE;

    H1 STRING(20) := 'Professor Deleted';
    H2 STRING(20) := LPAD('-', LENGTH(H1), '-');
BEGIN
    --Executable section begins
    SELECT * 
    INTO v_prof_info
    FROM GL_PROFESSORS_COPY
    WHERE PROFESSOR_NO = v_professor_no;

    DELETE FROM GL_PROFESSORS_COPY
    WHERE
        PROFESSOR_NO = v_professor_no;
    
    DBMS_OUTPUT.PUT_LINE(H1);
    DBMS_OUTPUT.PUT_LINE(H2);
    DBMS_OUTPUT.PUT_LINE('Professor no: ' || v_professor_no);
    DBMS_OUTPUT.PUT_LINE('First name: ' || v_prof_info.first_name);
    DBMS_OUTPUT.PUT_LINE('Last name: ' || v_prof_info.last_name);
    DBMS_OUTPUT.PUT_LINE('Office no: ' || v_prof_info.office_no);
    DBMS_OUTPUT.PUT_LINE('Office ext: ' || v_prof_info.office_ext);
    DBMS_OUTPUT.PUT_LINE('School code: ' || v_prof_info.school_code);
    

EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
