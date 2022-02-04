/* 1 */
DECLARE
    CURSOR course_cursor IS
    SELECT *
    FROM GL_COURSES
    ORDER BY COURSE_CODE;

    v_course_info GL_COURSES%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Course Code  Course Title');
    DBMS_OUTPUT.PUT_LINE('-----------  ------------');
    OPEN course_cursor;
    LOOP
        FETCH course_cursor
        INTO v_course_info;
        EXIT WHEN course_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_course_info.course_code || '    ' || v_course_info.course_title);
    END LOOP;
    CLOSE course_cursor;
END;

/* 2 */
DECLARE
    v_semester_year GL_SEMESTERS.semester_year%TYPE := :ENTER_SEMESTER_YEAR;
    v_semester_term GL_SEMESTERS.semester_term%TYPE := UPPER(:ENTER_SEMESTER_TERM);
    v_professor_no GL_PROFESSORS.professor_no%TYPE := :ENTER_PROFESSOR_NO;
    v_h1 STRING(50);
    v_h2 STRING(50);
    v_professor_info GL_PROFESSORS%ROWTYPE;

    CURSOR teacher_load_cursor(v_semester_year GL_SEMESTERS.semester_year%TYPE, v_semester_term GL_SEMESTERS.semester_term%TYPE, v_professor_no GL_PROFESSORS.professor_no%TYPE) IS
    SELECT course_title, section_id
    FROM GL_SEMESTERS
    JOIN GL_SECTIONS USING(semester_id)
    JOIN GL_PROFESSORS USING(professor_no)
    JOIN GL_COURSES USING(course_code)
    WHERE semester_year = v_semester_year AND semester_term = v_semester_term AND professor_no = v_professor_no
    ORDER BY course_title;

BEGIN
    SELECT *
    INTO v_professor_info
    FROM GL_PROFESSORS
    WHERE professor_no = v_professor_no;

    v_h1 := 'Teaching Load for ' || v_professor_info.first_name || ' ' || v_professor_info.last_name;
    v_h2 := LPAD('-', LENGTH(v_h1), '-'); 
    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE(v_h2);
    DBMS_OUTPUT.PUT_LINE('Semester: ' || v_semester_year || v_semester_term);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Course(s)    Section(s)');
    DBMS_OUTPUT.PUT_LINE('---------    ----------');

    FOR v_teacher_load IN teacher_load_cursor(v_Semester_year, v_semester_term, v_professor_no) LOOP 
        DBMS_OUTPUT.PUT_LINE(v_teacher_load.course_title || '    ' || v_teacher_load.section_id);
    END LOOP;
END;

/* 3 */
DECLARE
    v_semester_year GL_SEMESTERS.semester_year%TYPE := :ENTER_SEMESTER_YEAR;
    v_semester_term GL_SEMESTERS.semester_term%TYPE := UPPER(:ENTER_SEMESTER_TERM);
    v_section_id GL_SECTIONS.section_id%TYPE := :ENTER_SECTION_ID;
    v_h1 STRING(50);
    v_h2 STRING(50);
    v_course_title GL_COURSES.course_title%TYPE;
    v_professor_first_name GL_PROFESSORS.first_name%TYPE;
    v_professor_last_name GL_PROFESSORS.last_name%TYPE;

    CURSOR class_list_cursor(v_semester_year GL_SEMESTERS.semester_year%TYPE, v_semester_term GL_SEMESTERS.semester_term%TYPE, v_section_id GL_SECTIONS.section_id%TYPE) IS
    SELECT student_no, first_name || ' ' || last_name AS student_name
    FROM GL_SEMESTERS
    JOIN GL_SECTIONS USING(semester_id)
    JOIN GL_ENROLLMENTS USING(section_id)
    JOIN GL_STUDENTS USING(student_no)
    WHERE semester_year = v_semester_year AND semester_term = v_semester_term AND section_id = v_section_id
    ORDER BY student_no;

BEGIN
    SELECT course_title, first_name, last_name
    INTO v_course_title, v_professor_first_name, v_professor_last_name
    FROM GL_COURSES gc
    JOIN GL_SECTIONS gs ON (gc.course_code = gs.course_code)
    JOIN GL_PROFESSORS gp ON (gs.professor_no = gp.professor_no)
    WHERE section_id = v_section_id;

    v_h1 := 'Class List for ' || v_course_title;
    DBMS_OUTPUT.PUT_LINE(v_h1);
    DBMS_OUTPUT.PUT_LINE('Semester: ' || v_semester_year || v_semester_term);
    DBMS_OUTPUT.PUT_LINE('Instructor: ' || v_professor_first_name || ' ' || v_professor_last_name);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Student No   Student Name');
    DBMS_OUTPUT.PUT_LINE('----------   ------------');

    FOR v_class_list IN class_list_cursor(v_Semester_year, v_semester_term, v_section_id) LOOP 
        DBMS_OUTPUT.PUT_LINE(v_class_list.student_no || '    ' || v_class_list.student_name);
    END LOOP;
END;