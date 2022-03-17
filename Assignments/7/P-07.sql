/****** 1 ******/
CREATE OR REPLACE FUNCTION convert_numeric_grade
    (p_numeric_grade IN GL_ENROLLMENTS.NUMERIC_GRADE%TYPE)
RETURN VARCHAR
IS
    p_letter_grade GL_ENROLLMENTS.LETTER_GRADE%TYPE;
BEGIN
    CASE 
        WHEN p_numeric_grade >= 90 THEN p_letter_grade := 'A';
        WHEN p_numeric_grade >= 80 THEN p_letter_grade := 'B';
        WHEN p_numeric_grade >= 70 THEN p_letter_grade := 'C';
        WHEN p_numeric_grade >= 60 THEN p_letter_grade := 'D';
        WHEN p_numeric_grade < 60 THEN p_letter_grade := 'F';
    END CASE;
    RETURN p_letter_grade;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found!');
        RETURN NULL;
END convert_numeric_grade;



DECLARE
    v_numeric_grade GL_ENROLLMENTS.numeric_grade%TYPE := :ENTER_NUMERIC_GRADE;
    v_letter_grade GL_ENROLLMENTS.letter_grade%TYPE;
    OUT_OF_RANGE EXCEPTION;
    PRAGMA EXCEPTION_INIT(OUT_OF_RANGE, -6502);
BEGIN
    IF v_numeric_grade < 0 OR v_numeric_grade > 100 THEN
        RAISE OUT_OF_RANGE;
    END IF;
    v_letter_grade := convert_numeric_grade(v_numeric_grade);
    DBMS_OUTPUT.PUT_LINE('Numeric grade: ' || v_numeric_grade);
    DBMS_OUTPUT.PUT_LINE('Letter grade: ' || v_letter_grade);
EXCEPTION
    WHEN OUT_OF_RANGE THEN
        DBMS_OUTPUT.PUT_LINE('Grade ' || v_numeric_grade || ' invalid. Must be between 0 and 100.');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

/****** 2 ******/
CREATE OR REPLACE FUNCTION get_numeric_grade
    (p_section_id IN GL_ENROLLMENTS.section_id%TYPE,
    p_student_no IN GL_ENROLLMENTS.student_no%TYPE)
RETURN NUMBER
IS
    p_numeric_grade GL_ENROLLMENTS.numeric_grade%TYPE;
BEGIN
    SELECT numeric_grade
    INTO p_numeric_grade
    FROM GL_ENROLLMENTS
    WHERE student_no = p_student_no AND section_id = p_section_id;
    RETURN p_numeric_grade;
END get_numeric_grade;



DECLARE
    v_section_id GL_ENROLLMENTS.section_id%TYPE := :ENTER_SECTION_ID;
    v_student_no GL_ENROLLMENTS.student_no%TYPE := :ENTER_STUDENT_NO;
    v_numeric_grade GL_ENROLLMENTS.numeric_grade%TYPE;
BEGIN
    v_numeric_grade := get_numeric_grade(v_section_id, v_student_no);
	
    DBMS_OUTPUT.PUT_LINE('Student id: ' || v_student_no);
    DBMS_OUTPUT.PUT_LINE('Section no: ' || v_section_id);
    DBMS_OUTPUT.PUT_LINE('Numeric Grade: ' || COALESCE(TO_CHAR(v_numeric_grade, 'fm999'), 'NG'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || v_student_no || ' Section: ' || v_section_id || ' not found');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


/****** 3 ******/
CREATE OR REPLACE FUNCTION get_letter_grade
    (p_section_id IN GL_ENROLLMENTS.section_id%TYPE,
    p_student_no IN GL_ENROLLMENTS.student_no%TYPE)
RETURN VARCHAR
IS
    p_letter_grade GL_ENROLLMENTS.letter_grade%TYPE;
BEGIN
    SELECT letter_grade
    INTO p_letter_grade
    FROM GL_ENROLLMENTS
    WHERE student_no = p_student_no AND section_id = p_section_id;
    RETURN p_letter_grade;
END get_letter_grade;



DECLARE
    v_section_id GL_ENROLLMENTS.student_no%TYPE := :ENTER_SECTION_ID;
    v_student_no GL_ENROLLMENTS.section_id%TYPE := :ENTER_STUDENT_NO;
    v_letter_grade GL_ENROLLMENTS.letter_grade%TYPE;
BEGIN
    v_letter_grade := get_letter_grade(v_section_id, v_student_no);
	
    DBMS_OUTPUT.PUT_LINE('Student id: ' || v_student_no);
    DBMS_OUTPUT.PUT_LINE('Section no: ' || v_section_id);
    DBMS_OUTPUT.PUT_LINE('Letter Grade: ' || COALESCE(v_letter_grade, 'NG'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || v_student_no || ' Section: ' || v_section_id || ' not found');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


/****** 4 ******/
CREATE OR REPLACE FUNCTION get_full_name
    (p_student_no IN GL_STUDENTS.student_no%TYPE)
RETURN VARCHAR
IS
    p_first_name GL_STUDENTS.first_name%TYPE;
    p_last_name GL_STUDENTS.last_name%TYPE;
BEGIN
    SELECT first_name, last_name
    INTO p_first_name, p_last_name
    FROM GL_STUDENTS
    WHERE student_no = p_student_no;
    RETURN p_first_name || ' ' || p_last_name;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Student ' || p_student_no || ' not found!');
        RETURN NULL;
END get_full_name;



DECLARE
    v_student_no GL_STUDENTS.student_no%TYPE := :ENTER_SECTION_ID;
    v_full_name VARCHAR(100);
BEGIN
    v_full_name := get_full_name(v_student_no);
	
    IF v_full_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Student: ' || v_student_no);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_full_name);
    END IF;
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


/****** 5 ******/

DECLARE
    v_section_id GL_ENROLLMENTS.student_no%TYPE := :ENTER_SECTION_ID;
    v_student_no GL_ENROLLMENTS.section_id%TYPE := :ENTER_STUDENT_NO;
    v_full_name VARCHAR(100);
    v_letter_grade GL_ENROLLMENTS.letter_grade%TYPE;
    v_numeric_grade GL_ENROLLMENTS.numeric_grade%TYPE;
BEGIN
    v_full_name := get_full_name(v_student_no);
    v_letter_grade := get_letter_grade(v_section_id, v_student_no);
    v_numeric_grade := get_numeric_grade(v_section_id, v_student_no);
	
    IF v_full_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Student: ' || v_student_no || ' ' || v_full_name);
         DBMS_OUTPUT.PUT_LINE('Numeric Grade: ' || COALESCE(TO_CHAR(v_numeric_grade, '999'), 'NG'));
        DBMS_OUTPUT.PUT_LINE('Letter Grade: ' || COALESCE(v_letter_grade, 'NG'));
    END IF;
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
