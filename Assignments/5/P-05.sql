/* 1 */
DECLARE
    v_student_no GL_STUDENTS.student_no%TYPE := :ENTER_STUDENT_NO;
    v_student_name STRING(50);
BEGIN
    SELECT first_name || ' ' || last_name
    INTO v_student_name
    FROM GL_STUDENTS
    WHERE v_student_no = student_no;

    DBMS_OUTPUT.PUT_LINE(v_student_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || v_student_no || ' not found');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/* 2 */
DECLARE
    v_major_code GL_STUDENTS.major_code%TYPE := :ENTER_MAJOR_CODE;
    v_student_name STRING(50);
BEGIN
    SELECT first_name || ' ' || last_name
    INTO v_student_name
    FROM GL_STUDENTS
    WHERE v_major_code = major_code;

    DBMS_OUTPUT.PUT_LINE(v_student_name);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Request returned multiple rows');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No students found for Major ' || v_major_code);
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unknown error occurred. Contact software support.');
END;

/* 3 */
DECLARE
    v_school_code GL_SCHOOLS.school_code%TYPE := :ENTER_SCHOOL_CODE;

    e_string_too_long EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_string_too_long, -6502);
    e_child_rel EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_child_rel, -2292);
BEGIN
    DELETE
    FROM GL_SCHOOLS
    WHERE v_school_code = school_code;
    IF SQL%NOTFOUND THEN
        RAISE NO_DATA_FOUND;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('School code ' || v_school_code || ' does not exist.');
    WHEN e_string_too_long THEN
        DBMS_OUTPUT.PUT_LINE('School code is too long. Can only be two characters long.');
	WHEN e_child_rel THEN
        DBMS_OUTPUT.PUT_LINE('Cannot delete row because of integrity constraint error. There are child foreign key relationships with the GL_SCHOOLS table.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;