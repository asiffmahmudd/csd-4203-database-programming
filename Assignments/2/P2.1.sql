DECLARE 
    v_section Number := :Enter_section_id;
    number_of_students Number;
BEGIN
    --Executable section begins
    SELECT COUNT(*)
    INTO number_of_students
    FROM GL_ENROLLMENTS
    WHERE SECTION_ID = v_section;
    DBMS_OUTPUT.PUT_LINE('There are ' || number_of_students || ' students in section ' || v_section);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;