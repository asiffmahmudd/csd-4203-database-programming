--
DECLARE 
    v_section Number := :Enter_section_id;
    avg_grade Number;
BEGIN
    --Executable section begins
    SELECT AVG(NUMERIC_GRADE)
    INTO avg_grade
    FROM GL_ENROLLMENTS
    WHERE SECTION_ID = v_section;
    DBMS_OUTPUT.PUT_LINE('The average grade in section  ' || v_section || ' is ' || avg_grade);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;