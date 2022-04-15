/*----------------1----------------*/
CREATE TABLE GL_PRO_AUDIT_LOG(
    user_id VARCHAR2(30) DEFAULT USER,
    last_change_date DATE DEFAULT SYSDATE,
    trigger_name VARCHAR2(15),
    log_action VARCHAR2(30)
);

/*----------------2----------------*/
CREATE OR REPLACE TRIGGER GL_PROFESSOR_TR
AFTER INSERT ON GL_PROFESSORS_COPY
DECLARE
    v_log_action GL_PRO_AUDIT_LOG.log_action%TYPE := 'INSERT';
    v_trigger_name GL_PRO_AUDIT_LOG.trigger_name%TYPE := 'gl_professor_tr';
BEGIN
    INSERT INTO GL_PRO_AUDIT_LOG(user_id, last_change_date, trigger_name, log_action)
    VALUES(DEFAULT, DEFAULT, v_trigger_name, v_log_action);
END;


/*----------------3----------------*/
DECLARE
    v_professor_no GL_PROFESSORS_COPY.professor_no%TYPE := :ENTER_PROFESSOR_NO;
    v_first_name GL_PROFESSORS_COPY.first_name%TYPE := :ENTER_FIRST_NAME;
    v_last_name GL_PROFESSORS_COPY.last_name%TYPE := :ENTER_LAST_NAME;
    v_office_no GL_PROFESSORS_COPY.office_no%TYPE := :ENTER_OFFICE_NO;
    v_office_ext GL_PROFESSORS_COPY.office_ext%TYPE := :ENTER_OFFICE_EXT;
    v_school_code GL_PROFESSORS_COPY.school_code%TYPE := UPPER(:ENTER_SCHOOL_CODE);
BEGIN
    v_first_name := UPPER(SUBSTR(v_first_name, 1,1)) || LOWER(SUBSTR(v_first_name, 2, LENGTH(v_first_name)));
    v_last_name := UPPER(SUBSTR(v_last_name, 1,1)) || LOWER(SUBSTR(v_last_name, 2, LENGTH(v_last_name)));

    ADD_PROFESSOR(v_professor_no, v_first_name, v_last_name, v_office_no, v_office_ext, v_school_code);

EXCEPTION
    WHEN dup_val_on_index THEN
        DBMS_OUTPUT.PUT_LINE('Professor ' || v_professor_no || ' already exists in the professors table');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


/*----------------4----------------*/
DECLARE
    v_audit_rec GL_PRO_AUDIT_LOG%ROWTYPE;
    CURSOR audit_cursor IS
    SELECT *
    FROM GL_PRO_AUDIT_LOG;
BEGIN
    DBMS_OUTPUT.PUT_LINE('USER_ID  LAST_CHANGE_DATE  TRIGGER_NAME  LOG_ACTION');
    FOR v_audit_rec IN audit_cursor LOOP 
        DBMS_OUTPUT.PUT_LINE(v_audit_rec.user_id || ' ' || v_audit_rec.last_change_date || ' ' || v_audit_rec.trigger_name ||  ' ' || v_audit_rec.log_action);
    END LOOP;
END;


/*----------------5----------------*/

-- covert grade function
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


-- creating update log table
CREATE TABLE GL_ENROLL_UPDATE_LOG(
    user_id VARCHAR2(30) DEFAULT USER,
    last_change_date DATE DEFAULT SYSDATE,
    section_id  NUMBER(5, 0),
    student_no  NUMBER(7,0),
    old_grade  VARCHAR2(2),
    new_grade  VARCHAR2(2),
    log_action  VARCHAR2(30)
);


--creating trigger
CREATE OR REPLACE TRIGGER GL_ENROLL_UPDATE_TR
BEFORE UPDATE OF LETTER_GRADE ON GL_ENROLLMENTS_COPY
FOR EACH ROW
DECLARE
    v_section_id GL_ENROLL_UPDATE_LOG.section_id%TYPE := :OLD.section_id;
    v_student_no GL_ENROLL_UPDATE_LOG.student_no%TYPE := :OLD.student_no;
    v_old_grade GL_ENROLL_UPDATE_LOG.old_grade%TYPE := :OLD.letter_grade;
    v_new_grade GL_ENROLL_UPDATE_LOG.new_grade%TYPE := :NEW.letter_grade;
    v_log_action GL_ENROLL_UPDATE_LOG.log_action%TYPE;
BEGIN
    CASE
        WHEN v_old_grade > v_new_grade THEN v_log_action := 'grade went up';
        WHEN v_old_grade < v_new_grade THEN v_log_action := 'grade went down';
        WHEN v_old_grade = v_new_grade THEN v_log_action := 'grade is the same';
    END CASE;

    INSERT INTO GL_ENROLL_UPDATE_LOG(user_id, last_change_date, section_id, student_no, old_grade, new_grade, log_action)
    VALUES(DEFAULT, DEFAULT, v_section_id, v_student_no, v_old_grade, v_new_grade, v_log_action);
END;


-- anonymas block
DECLARE
    v_section_id GL_ENROLLMENTS_COPY.section_id%TYPE := :ENTER_SECTION_ID;
    v_student_no GL_ENROLLMENTS_COPY.student_no%TYPE := :ENTER_STUDENT_NO;
    v_new_numeric_grade GL_ENROLLMENTS_COPY.numeric_grade%TYPE := :ENTER_NUMERIC_GRADE;
    v_old_grade GL_ENROLLMENTS_COPY.letter_grade%TYPE;
    v_new_grade GL_ENROLLMENTS_COPY.letter_grade%TYPE;
BEGIN
    SELECT letter_grade
    INTO v_old_grade
    FROM GL_ENROLLMENTS_COPY
    WHERE student_no = v_student_no and section_id = v_section_id;

    v_new_grade := CONVERT_NUMERIC_GRADE(v_new_numeric_grade);
    UPDATE GL_ENROLLMENTS_COPY
    SET 
        letter_grade = v_new_grade,
        numeric_grade = v_new_numeric_grade
    WHERE student_no = v_student_no and section_id = v_section_id;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;


