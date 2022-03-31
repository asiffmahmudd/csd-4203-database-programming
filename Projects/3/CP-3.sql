-- creating the view
CREATE OR REPLACE VIEW P0605V AS
    SELECT 
        school_code AS "SCHOOL CODE", 
        program_code AS "PROGRAM CODE",
        course_code AS "COURSE CODE",
        credit_hours AS "CREDIT HOURS",
        section_id AS "SECTION ID",
        semester_year AS "SEMESTER YEAR",
        semester_term AS "SEMESTER TERM",
        student_no AS "STUDENT NO",
        first_name || ', ' || last_name AS "STUDENT NAME",
        COALESCE(letter_grade, 'N/G') AS "STUDENT LETTER GRADE"
    FROM
        GL_SCHOOLS 
        JOIN GL_PROGRAMS USING(school_code)
        JOIN GL_COURSES USING(program_code)
        JOIN GL_SECTIONS USING(course_code)
        JOIN GL_SEMESTERS USING(semester_id)
        JOIN GL_ENROLLMENTS USING(section_id)
        JOIN GL_STUDENTS USING(student_no);


CREATE OR REPLACE PROCEDURE course_listing(
    p_school_code IN gl_schools.school_code%TYPE,
    p_semester_year IN gl_semesters.semester_year%TYPE,
    p_semester_term IN gl_semesters.semester_term%TYPE
)
IS
    PROCEDURE L1_Break;
    PROCEDURE L2_Break;
    PROCEDURE L3_Break;
    PROCEDURE get_school_name;
    PROCEDURE get_program_name;
    PROCEDURE get_course_title;

    prt_school_name gl_schools.school_name%TYPE;
    prt_program_name gl_programs.program_name%TYPE;
    prt_program_code gl_programs.program_code%TYPE;
    prt_course_code gl_courses.course_code%TYPE;
    prt_course_title gl_courses.course_title%TYPE;
    prt_section_id VARCHAR(5);

    hold_program_code gl_programs.program_code%TYPE;
    hold_course_code gl_courses.course_code%TYPE;
    hold_course_title gl_courses.course_title%TYPE;
    hold_section_id gl_sections.Section_id%TYPE;

    SPACES CONSTANT VARCHAR(32) := ' ';
    ZEROS CONSTANT DECIMAL(9) := 0;

    v_head1 VARCHAR(80) := 'Grades for school of ';
    v_head2 VARCHAR(80);
    v_head3 VARCHAR(132) := LPAD('Course', 15) || LPAD('Section', 37) || LPAD('Student', 13) || LPAD('Grade', 25);
    v_head4 VARCHAR(132) := LPAD('------', 15) || LPAD('-------', 37) || LPAD('-------', 13) || LPAD('-----', 25);

    v_section_count INTEGER := 0;
    v_course_count INTEGER := 0;
    v_program_count INTEGER := 0;
    v_school_count INTEGER := 0;

    CURSOR c1_cursor IS
        SELECT * 
        FROM P0605V
        WHERE "SCHOOL CODE" = p_school_code AND "SEMESTER YEAR" = p_semester_year AND "SEMESTER TERM" = p_semester_term
        ORDER BY "PROGRAM CODE", "COURSE CODE", "SECTION ID", "STUDENT NO";
    c1_rec c1_cursor%ROWTYPE;

    PROCEDURE Initialization IS
    BEGIN
        OPEN c1_cursor;
        FETCH c1_cursor INTO c1_rec;

        hold_program_code := c1_rec."PROGRAM CODE";
        hold_course_code := c1_rec."COURSE CODE";
        hold_section_id := c1_rec."SECTION ID";
        prt_program_code := hold_program_code;
        prt_course_code := hold_course_code;
        get_course_title;
        prt_course_title := hold_course_title;
        prt_section_id := c1_rec."SECTION ID";

        get_school_name;
        v_head1 := v_head1 || prt_school_name || LPAD(p_semester_term || p_semester_year, 10);
        DBMS_OUTPUT.PUT_LINE(LPAD(v_head1, 57));
        v_head2 := LPAD('-', LENGTH(v_head1), '-');
        DBMS_OUTPUT.PUT_LINE(LPAD(v_head2, 57));
        DBMS_OUTPUT.NEW_LINE;
        get_program_name;
        DBMS_OUTPUT.PUT_LINE('Program: ' || prt_program_code || ' - ' || prt_program_name);
        DBMS_OUTPUT.PUT_LINE(v_head3);
        DBMS_OUTPUT.PUT_LINE(v_head4);
    END Initialization;

    PROCEDURE detail_processing IS
        BEGIN
            DBMS_OUTPUT.PUT_LINE(LPAD(prt_course_code, 15) || ' ' ||
                                 RPAD(prt_course_title, 26) || 
                                 LPAD(prt_section_id, 10) ||
                                 LPAD(c1_rec."STUDENT NO", 10) || ' ' ||
                                 RPAD(c1_rec."STUDENT NAME", 20) ||
                                 LPAD(c1_rec."STUDENT LETTER GRADE", 5)
                                );
            v_section_count := v_section_count + 1;
            prt_course_code := SPACES;
            prt_course_title := SPACES;
            prt_section_id := SPACES;
    END detail_processing;

    PROCEDURE Check_control_break IS
    BEGIN
        CASE
            WHEN c1_rec."PROGRAM CODE" <> hold_program_code THEN
                L1_break;
                L2_break;
                L3_break;
            WHEN c1_rec."COURSE CODE" <> hold_course_code THEN
                L1_break;
                L2_break;
            WHEN c1_rec."SECTION ID" <> hold_section_id THEN
                L1_break;
            ELSE NULL;
        END CASE;
    END check_control_break;

    PROCEDURE L1_break IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(LPAD('* Section ' || hold_section_id || ' count: ' || LPAD(v_section_count, 2), 32));
        DBMS_OUTPUT.NEW_LINE;
        hold_section_id := c1_rec."SECTION ID";
        prt_section_id := c1_rec."SECTION ID";
        v_course_count := v_course_count + v_section_count;
        v_section_count := ZEROS;
    END L1_break;

    PROCEDURE L2_break IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('** Course ' || hold_course_code || ' ' || hold_course_title || ' count: ' || LPAD(v_course_count, 2), 60));
        DBMS_OUTPUT.NEW_LINE;
        hold_course_code := c1_rec."COURSE CODE";
        prt_course_code := c1_rec."COURSE CODE";
        get_course_title;
        prt_course_title := hold_course_title;
        v_program_count := v_program_count + v_course_count;
        v_course_count := ZEROS;
    END L2_break;

    PROCEDURE L3_break IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('*** Program ' || prt_program_name || ' count: ' || v_program_count, 60));
        DBMS_OUTPUT.NEW_LINE;
        v_school_count := v_school_count + v_program_count;

        IF NOT c1_cursor%NOTFOUND THEN
            hold_program_code := c1_rec."PROGRAM CODE";
            get_program_name;
            DBMS_OUTPUT.PUT_LINE(LPAD('-', 90, '-'));
            DBMS_OUTPUT.PUT_LINE('Program: ' || hold_program_code || '-' || prt_program_name);
            DBMS_OUTPUT.PUT_LINE(v_head3);
            DBMS_OUTPUT.PUT_LINE(v_head4);
            v_program_count := ZEROS;
        END IF;
    END L3_break;

    PROCEDURE get_school_name IS
        BEGIN
            SELECT school_name INTO prt_school_name
            FROM gl_schools
            WHERE school_code = p_school_code;
    END get_school_name;

    PROCEDURE get_program_name IS
        BEGIN
            SELECT program_name INTO prt_program_name
            FROM gl_programs
            WHERE program_code = c1_rec."PROGRAM CODE";
    END get_program_name;

    PROCEDURE get_course_title IS
        BEGIN
            SELECT course_title INTO hold_course_title
            FROM gl_courses
            WHERE course_code = c1_rec."COURSE CODE";
    END get_course_title;

    PROCEDURE termination IS
    BEGIN
        L1_break;
        L2_break;
        L3_break;
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('**** Total students in school of ' || prt_school_name || ': ' || v_school_count, 60));
        CLOSE c1_cursor;
    END termination;

    BEGIN
        Initialization;
        LOOP
            Check_control_break;
            detail_processing;
            FETCH c1_cursor INTO c1_rec;
            EXIT WHEN c1_cursor%NOTFOUND;
        END LOOP;
        termination;
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END course_listing;

BEGIN
    course_listing(UPPER(:ENTER_SCHOOL_CODE), :ENTER_YEAR, UPPER(:ENTER_TERM_F_W_S));
END;