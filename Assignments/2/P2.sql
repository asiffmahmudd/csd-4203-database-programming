--1--
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

--2--
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

--3--
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

--4--
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


--5--
CREATE OR REPLACE VIEW GL_PROV1 AS
    SELECT 
        PROFESSOR_NO,
        FIRST_NAME || ' ' || LAST_NAME AS NAME,
        OFFICE_NO,
        OFFICE_EXT,
        SCHOOL_NAME
    FROM
        GL_PROFESSORS
        JOIN GL_SCHOOLS USING(SCHOOL_CODE); 

DECLARE 
    H1 STRING(50) := 'Professor Information';
    H2 STRING(50) := LPAD('-', LENGTH(H1), '-');
    prof_info GL_PROV1%ROWTYPE;
    prof_no NUMBER := :ENTER_PROFESSOR_NO;
BEGIN
    --Executable section begins
    SELECT *
    INTO prof_info
    FROM GL_PROV1
    WHERE PROFESSOR_NO = prof_no;

    DBMS_OUTPUT.PUT_LINE(H1);
    DBMS_OUTPUT.PUT_LINE(H2);

    DBMS_OUTPUT.PUT_LINE('Professor no: ' || prof_info.PROFESSOR_NO);
    DBMS_OUTPUT.PUT_LINE('Name: ' || prof_info.NAME);
    DBMS_OUTPUT.PUT_LINE('Office no: ' || prof_info.OFFICE_NO);
    DBMS_OUTPUT.PUT_LINE('Office ext: ' || prof_info.OFFICE_EXT);
    DBMS_OUTPUT.PUT_LINE('School: ' || prof_info.SCHOOL_NAME);
EXCEPTION
	WHEN OTHERS THEN
	  DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
	  DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


--6--
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


--7--
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


--8--
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
