--p-08-01
--get_professor procedure

CREATE OR REPLACE PACKAGE college_pkg AS
    TYPE professor_rec_type IS RECORD(
         professor_no gl_professors_copy.professor_no%TYPE, 
         first_name gl_professors_copy.first_name%TYPE, 
         last_name gl_professors_copy.last_name%TYPE, 
         office_no gl_professors_copy.office_no%TYPE, 
         office_ext gl_professors_copy.office_ext%TYPE, 
         school_code gl_professors_copy.school_code%TYPE
    );

    PROCEDURE get_professor(
        p_professor_no IN gl_professors_copy.professor_no%TYPE,
        p_professor_rec OUT professor_rec_type
    );
END college_pkg;

CREATE OR REPLACE PACKAGE BODY college_pkg AS
    PROCEDURE get_professor(
        p_professor_no IN gl_professors_copy.professor_no%TYPE, 
        p_professor_rec OUT professor_rec_type
    )
    IS
    BEGIN
        SELECT *
        INTO p_professor_rec
        FROM GL_PROFESSORS_COPY
        WHERE professor_no = p_professor_no;
    END get_professor;
END college_pkg;

DECLARE
    v_professor_no GL_PROFESSORS.professor_no%TYPE;
    v_professor_rec GL_PROFESSORS_COPY%ROWTYPE;
BEGIN
    v_professor_no := :ENTER_PROFESSOR_NO;
    college_pkg.get_professor(v_professor_no, v_professor_rec);
    DBMS_OUTPUT.PUT_LINE('No: ' || v_professor_no);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_professor_rec.first_name || ' ' || v_professor_rec.last_name);
    DBMS_OUTPUT.PUT_LINE('Office ext: ' || v_professor_rec.office_ext);
    DBMS_OUTPUT.PUT_LINE('Office no: ' || v_professor_rec.office_no);

    EXCEPTION
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Professor ' || v_professor_no || ' does not exist in the professor''s table');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;



-- add_professor procedure

CREATE OR REPLACE PACKAGE college_pkg AS 
    PROCEDURE add_professor(
        p_professor_no gl_professors_copy.professor_no%TYPE,
        p_first_name gl_professors_copy.first_name%TYPE,
        p_last_name gl_professors_copy.last_name%TYPE,
        p_office_no gl_professors_copy.office_no%TYPE,
        p_office_ext gl_professors_copy.office_ext%TYPE
    );
END college_pkg;

CREATE OR REPLACE PACKAGE BODY college_pkg AS

    PROCEDURE add_professor(
        p_professor_no gl_professors_copy.professor_no%TYPE,
        p_first_name gl_professors_copy.first_name%TYPE,
        p_last_name gl_professors_copy.last_name%TYPE,
        p_office_no gl_professors_copy.office_no%TYPE,
        p_office_ext gl_professors_copy.office_ext%TYPE
    )
    IS
    BEGIN
        INSERT INTO GL_PROFESSORS_COPY(
            professor_no,
            first_name,
            last_name,
            office_no,
            office_ext
        )
        VALUES(
            p_professor_no,
            p_first_name,
            p_last_name,
            p_office_no,
            p_office_ext
        );
    END add_professor;
END college_pkg;


DECLARE
    v_professor_no gl_professors_copy.professor_no%TYPE;
    v_first_name gl_professors_copy.first_name%TYPE;
    v_last_name gl_professors_copy.last_name%TYPE;
    v_office_no gl_professors_copy.office_no%TYPE;
    v_office_ext gl_professors_copy.office_ext%TYPE;
BEGIN

    v_professor_no := :ENTER_PROFESSOR_NO;
    v_first_name := :ENTER_FIRST_NAME;
    v_last_name := :ENTER_LAST_NAME;
    v_office_no := :ENTER_OFFICE_NO;
    v_office_ext := :ENTER_OFFICE_EXT;

    college_pkg.add_professor(v_professor_no, v_first_name, v_last_name, v_office_no, v_office_ext);

    DBMS_OUTPUT.PUT_LINE('Professor: ' || v_professor_no || ' - ' || v_first_name || ' ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Office ext.: ' || v_office_ext);
    DBMS_OUTPUT.PUT_LINE('Office no: ' || v_office_no);

    EXCEPTION
        WHEN dup_val_on_index THEN
            DBMS_OUTPUT.PUT_LINE('Professor ' || v_professor_no || ' already exists in the professors table');
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Professor ' || v_professor_no || ' does not exist in the professor''s table');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;



-- delete_professor procedure

CREATE OR REPLACE PACKAGE college_pkg AS
    PROCEDURE delete_professor(
        p_professor_no gl_professors_copy.professor_no%TYPE
    );
END college_pkg;

CREATE OR REPLACE PACKAGE BODY college_pkg AS
    PROCEDURE delete_professor(p_professor_no gl_professors_copy.professor_no%TYPE)
    IS
    BEGIN
        DELETE FROM gl_professors_copy
        WHERE professor_no = p_professor_no;
    END delete_professor;
END college_pkg;


DECLARE
    v_professor_no gl_professors_copy.professor_no%TYPE;
    v_first_name gl_professors_copy.first_name%TYPE;
    v_last_name gl_professors_copy.last_name%TYPE;
    v_office_no gl_professors_copy.office_no%TYPE;
    v_office_ext gl_professors_copy.office_ext%TYPE;
BEGIN

    v_professor_no := :ENTER_PROFESSOR_NO;

    college_pkg.delete_professor(v_professor_no);

    IF SQL%ROWCOUNT = 0 THEN
        RAISE no_data_found;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Delete professor request completed');
    END IF;

    EXCEPTION
        WHEN dup_val_on_index THEN
            DBMS_OUTPUT.PUT_LINE('Professor ' || v_professor_no || ' already exists in the professors table');
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Professor ' || v_professor_no || ' does not exist in the professor''s table');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;



-- p08-02

CREATE OR REPLACE PACKAGE donor_pkg AS
    TYPE donor_rec_type IS RECORD(
         donor_id gl_donors.donor_id%TYPE, 
         donor_name gl_donors.donor_name%TYPE, 
         donor_type gl_donors.donor_type%TYPE, 
         monthly_pledge_amount gl_donors.monthly_pledge_amount%TYPE, 
         registration_code gl_donors.registration_code%TYPE, 
         registration_date gl_donors.registration_date%TYPE,
         pledge_months gl_donors.pledge_months%TYPE
    );

    PROCEDURE get_donor(
        p_donor_id IN gl_donors.donor_id%TYPE,
        p_donor_rec OUT donor_rec_type
    );

    PROCEDURE get_donor(
        p_donor_registration_code IN gl_donors.registration_code%TYPE,
        p_donor_rec OUT donor_rec_type
    );
END donor_pkg;

CREATE OR REPLACE PACKAGE BODY donor_pkg AS
    PROCEDURE get_donor(
        p_donor_id IN gl_donors.donor_id%TYPE,
        p_donor_rec OUT donor_rec_type
    )
    IS
    BEGIN
        SELECT *
        INTO p_donor_rec
        FROM gl_donors
        WHERE donor_id = p_donor_id;
    END get_donor;

    PROCEDURE get_donor(
        p_donor_registration_code IN gl_donors.registration_code%TYPE,
        p_donor_rec OUT donor_rec_type
    )
    IS
    BEGIN
        SELECT *
        INTO p_donor_rec
        FROM gl_donors
        WHERE registration_code = p_donor_registration_code;
    END get_donor;
END donor_pkg;

DECLARE
    v_donor_id gl_donors.donor_id%TYPE;
    v_donor_rec gl_donors%ROWTYPE;
BEGIN
    v_donor_id := :ENTER_DONOR_ID;
    donor_pkg.get_donor(v_donor_id, v_donor_rec);

    DBMS_OUTPUT.PUT_LINE('Donor name: ' || v_donor_rec.donor_name);
    DBMS_OUTPUT.PUT_LINE('Donor type: ' || v_donor_rec.donor_type);
    DBMS_OUTPUT.PUT_LINE('Pledge amount: ' || TO_CHAR(v_donor_rec.monthly_pledge_amount, 'fm$999.00'));
    DBMS_OUTPUT.PUT_LINE('Pledge months: ' || v_donor_rec.pledge_months);
    DBMS_OUTPUT.PUT_LINE('Total amounts: ' || TO_CHAR(v_donor_rec.monthly_pledge_amount * v_donor_rec.pledge_months, 'fm$9999.00'));
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Donor request by donor id completed');

    EXCEPTION
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Donor not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;

DECLARE
    v_registration_code gl_donors.registration_code%TYPE;
    v_donor_rec gl_donors%ROWTYPE;
BEGIN
    v_registration_code := :ENTER_REGISTRATION_CODE;
    donor_pkg.get_donor(v_registration_code, v_donor_rec);

    DBMS_OUTPUT.PUT_LINE('Donor name: ' || v_donor_rec.donor_name);
    DBMS_OUTPUT.PUT_LINE('Donor type: ' || v_donor_rec.donor_type);
    DBMS_OUTPUT.PUT_LINE('Pledge amount: ' || TO_CHAR(v_donor_rec.monthly_pledge_amount, 'fm$999.00'));
    DBMS_OUTPUT.PUT_LINE('Pledge months: ' || v_donor_rec.pledge_months);
    DBMS_OUTPUT.PUT_LINE('Total amounts: ' || TO_CHAR(v_donor_rec.monthly_pledge_amount * v_donor_rec.pledge_months, 'fm$9999.00'));
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Donor request by registration code completed');

    EXCEPTION
        WHEN no_data_found THEN
            DBMS_OUTPUT.PUT_LINE('Donor not found');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
END;
