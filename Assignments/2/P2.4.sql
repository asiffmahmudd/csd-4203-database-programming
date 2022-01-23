CREATE OR REPLACE VIEW gl_stdV1 AS
    SELECT 
        GS.STUDENT_NO,
        GS.FIRST_NAME || ' ' || GS.LAST_NAME AS STUDENT_NAME,
        GPROG.PROGRAM_NAME AS MAJOR,
        GC.COURSE_TITLE AS COURSE,
        GSEC.SECTION_ID AS SECTION,
        GP.FIRST_NAME || ' ' || GP.LAST_NAME AS PROF_NAME,
        GE.LETTER_GRADE AS GRADE
    FROM GL_STUDENTS GS
    JOIN GL_ENROLLMENTS GE ON(GS.STUDENT_NO = GE.STUDENT_NO)
    JOIN GL_SECTIONS GSEC ON(GE.SECTION_ID = GSEC.SECTION_ID)
    JOIN GL_COURSES GC ON(GSEC.COURSE_CODE = GC.COURSE_CODE)
    JOIN GL_PROGRAMS GPROG ON(GS.MAJOR_CODE = GPROG.PROGRAM_CODE)
    JOIN GL_PROFESSORS GP ON(GSEC.PROFESSOR_NO = GP.PROFESSOR_NO);

DECLARE 
    H1 STRING(50) := 'Student Grade: ' || TO_CHAR(CURRENT_DATE, 'Day, Month dd, yyyy');
    H2 STRING(50) := LPAD('-', LENGTH(H1), '-');
    student_info gl_stdV1%ROWTYPE;
    v_student_no NUMBER := :ENTER_STUDENT_NO;
    v_section NUMBER:= :ENTER_SECTION_ID;
BEGIN
    --Executable section begins
    SELECT *
    INTO student_info
    FROM gl_stdV1
    WHERE STUDENT_NO = v_student_no
    AND SECTION = v_section;

    DBMS_OUTPUT.PUT_LINE(H1);
    DBMS_OUTPUT.PUT_LINE(H2);

    DBMS_OUTPUT.PUT_LINE('Student: ' || student_info.STUDENT_NAME);
    DBMS_OUTPUT.PUT_LINE('Major: ' || student_info.MAJOR);
    DBMS_OUTPUT.PUT_LINE('Course: ' || student_info.COURSE);
    DBMS_OUTPUT.PUT_LINE('Section: ' || student_info.SECTION);
    DBMS_OUTPUT.PUT_LINE('Professor: ' || student_info.PROF_NAME);
    DBMS_OUTPUT.PUT_LINE('Grade: ' || student_info.GRADE);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;