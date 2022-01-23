DECLARE 
    v_course String(10) := UPPER(:Enter_section_id);
    number_of_sections Number;
BEGIN
    --Executable section begins
    SELECT count(*)
    INTO number_of_sections
    FROM GL_SECTIONS
    WHERE COURSE_CODE = v_course;
    DBMS_OUTPUT.PUT_LINE('There are ' || number_of_sections || ' section(s) offered in course ' || v_course);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;