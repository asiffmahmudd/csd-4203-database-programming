-- P404 step-1
CREATE OR REPLACE VIEW P404V AS
    SELECT semester_year, semester_term, section_id, student_no, enroll_date
    FROM GL_SEMESTERS
    JOIN GL_SECTIONS USING (semester_id)
    JOIN GL_ENROLLMENTS USING (section_id)
    JOIN GL_STUDENTS USING (student_no)
	WHERE NUMERIC_GRADE IS NULL AND LETTER_GRADE IS NULL;

-- P404 step-2
SELECT * FROM P404V;

-- P404 step-3
DECLARE
    v_year P404V.semester_year%TYPE := :ENTER_SEMESTER_YEAR;
    v_term P404V.semester_term%TYPE := UPPER(:ENTER_SEMESTER_TERM);

    CURSOR course_cursor(v_semester_year P404V.semester_year%TYPE, v_semester_term P404V.semester_term%TYPE) IS
    SELECT *
    FROM P404V
    WHERE semester_year = v_semester_year AND semester_term = v_semester_term;

    v_h1 STRING(50) := 'Enrollment Missing Grade Verification'; 
    v_h2 STRING(50) := LPAD('-', LENGTH(v_h1), '-');
    v_course_info P404V%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2);
    DBMS_OUTPUT.PUT_LINE('Year: ' || v_year || ' Term: ' || v_term);
    DBMS_OUTPUT.PUT_LINE('Section Student No Enroll Date');
    DBMS_OUTPUT.PUT_LINE('------- ---------- -----------');

    FOR v_course IN course_cursor(v_year, v_term) LOOP 
        DBMS_OUTPUT.PUT_LINE(v_course.section_id || ' ' || v_course.student_no || ' ' || v_course.enroll_date);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

--P404 step-4
DECLARE
    v_year P404V.semester_year%TYPE := :ENTER_SEMESTER_YEAR;
    v_term P404V.semester_term%TYPE := UPPER(:ENTER_SEMESTER_TERM);

    CURSOR course_cursor(v_semester_year P404V.semester_year%TYPE, v_semester_term P404V.semester_term%TYPE) IS
    SELECT *
    FROM P404V
    WHERE semester_year = v_semester_year AND semester_term = v_semester_term;

    v_h1 STRING(50) := 'Enrollment Missing Grade Verification'; 
    v_h2 STRING(50) := LPAD('-', LENGTH(v_h1), '-');
    v_course_info P404V%ROWTYPE;
    v_temp NUMBER;

BEGIN
    IF v_year IS NULL OR v_term IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('** Either year or term were not entered. The listing shows missing grades for thecurrent term. **');
        v_year := TO_CHAR(SYSDATE, 'yyyy');
        v_temp := TO_NUMBER(TO_CHAR(SYSDATE, 'mm'));
        CASE 
            WHEN v_temp <= 4 THEN v_term := 'W';
            WHEN v_temp <= 8 THEN v_term := 'S';
            WHEN v_temp <= 12 THEN v_term := 'F';
        END CASE; 
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2);
    DBMS_OUTPUT.PUT_LINE('Year: ' || v_year || ' Term: ' || v_term);
    DBMS_OUTPUT.PUT_LINE('Section Student No Enroll Date');
    DBMS_OUTPUT.PUT_LINE('------- ---------- -----------');

    FOR v_course IN course_cursor(v_year, v_term) LOOP 
        DBMS_OUTPUT.PUT_LINE(v_course.section_id || ' ' || v_course.student_no || ' ' || v_course.enroll_date);
    END LOOP;
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


--P404 step-5, step-6
DECLARE
    v_year P404V.semester_year%TYPE := :ENTER_SEMESTER_YEAR;
    v_term P404V.semester_term%TYPE := UPPER(:ENTER_SEMESTER_TERM);

    CURSOR course_cursor(v_semester_year P404V.semester_year%TYPE, v_semester_term P404V.semester_term%TYPE) IS
    SELECT *
    FROM P404V
    WHERE semester_year = v_semester_year AND semester_term = v_semester_term;

    v_h1 STRING(50) := 'Enrollment Missing Grade Verification'; 
    v_h2 STRING(50) := LPAD('-', LENGTH(v_h1), '-');
    v_course_info P404V%ROWTYPE;
    v_temp NUMBER;
    v_row_count NUMBER := 0;

BEGIN
    IF v_year IS NULL OR v_term IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('** Either year or term were not entered. The listing shows missing grades for thecurrent term. **');
        v_year := TO_CHAR(SYSDATE, 'yyyy');
        v_temp := TO_NUMBER(TO_CHAR(SYSDATE, 'mm'));
        CASE 
            WHEN v_temp <= 4 THEN v_term := 'W';
            WHEN v_temp <= 8 THEN v_term := 'S';
            WHEN v_temp <= 12 THEN v_term := 'F';
        END CASE; 
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2);
    DBMS_OUTPUT.PUT_LINE('Year: ' || v_year || ' Term: ' || v_term);
    DBMS_OUTPUT.PUT_LINE('Section Student No Enroll Date');
    DBMS_OUTPUT.PUT_LINE('------- ---------- -----------');

    FOR v_course IN course_cursor(v_year, v_term) LOOP 
        v_row_count := v_row_count + 1;
        DBMS_OUTPUT.PUT_LINE(v_course.section_id || ' ' || v_course.student_no || ' ' || v_course.enroll_date);
    END LOOP;
    IF v_row_count = 0 THEN 
        RAISE NO_DATA_FOUND;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('** There are no missing grades for ' || v_year || v_term ||' **');
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('** The following undetermined error occured. Contact software support. **');
        DBMS_OUTPUT.PUT_LINE('** Error code: ' || SQLCODE || ' **');
        DBMS_OUTPUT.PUT_LINE('** Error message: ' || SQLERRM || ' **');
END;
