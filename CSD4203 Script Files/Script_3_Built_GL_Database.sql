-- Scrip 3 Build GL Database for Database programming Using SQL and PL/SQL

------------------------- GL_DONORS -----
CREATE TABLE gl_donors(
  donor_id              INTEGER       NOT NULL,
  donor_name            VARCHAR2(30)  NOT NULL,
  donor_type            VARCHAR(1)    NOT NULL,
  monthly_pledge_amount DECIMAL(5,0)  NOT NULL,
  registration_code     VARCHAR2(5)   NOT NULL, 
  registration_date     DATE          NOT NULL,
  pledge_months         DECIMAL(3,0),
  CONSTRAINT gl_donors_donor_id_pk
  PRIMARY KEY(donor_id) );

INSERT ALL
INTO gl_donors VALUES ( 1, 'Jake Smith',       'I', 23,  'I1001', '2021-01-03', 24)
INTO gl_donors VALUES ( 2, 'Sally Donor',      'G', 15,  'G1002', '2021-02-28', 24)
INTO gl_donors VALUES ( 3, 'Lakeside Inc.',    'B', 250, 'B1003', '2021-03-31', 24)
INTO gl_donors VALUES ( 4, 'Terry Manis',      'I', 10,  'I1004', '2021-04-01', 36)
INTO gl_donors VALUES ( 5, 'Janis Porter',     'G', 5,   'G1005', '2021-05-15', 18)
INTO gl_donors VALUES ( 6, 'Main Street Inc.', 'B', 40,  'B1006', '2021-06-16', 12)
SELECT * FROM dual;

------------------------- GL_LOANS -----

CREATE TABLE gl_loans (       -- Main Street Bank
    loan_id               INTEGER       NOT NULL,
    first_name            VARCHAR(20)   NOT NULL,
    last_name             VARCHAR(20)   NOT NULL,
    credit_score          DECIMAL(3)    NOT NULL,
    loan_amount           DECIMAL(11,2) NOT NULL,
    monthly_payment       DECIMAL(7,2)  NOT NULL,
    annual_interest_rate  DECIMAL(3,2)  NOT NULL,
    first_payment         DATE          NOT NULL,
  CONSTRAINT gl_loans_pk
  PRIMARY KEY(loan_id) );

INSERT ALL
INTO gl_loans VALUES (100, 'Sammy', 'Smith', 755, 46750, 675.50, 4.25, '2021-05-01')
INTO gl_loans VALUES (200, 'Sally', 'Rose',  590, 22400, 465.75, 5.10, '2021-06-01')
INTO gl_loans VALUES (300, 'Tom',   'Blake', 310, 12600, 345.00, 5.95, '2021-07-01')
INTO gl_loans VALUES (400, 'Ann',   'Cook',  810, 52500, 725.50, 3.85, '2021-08-01')
INTO gl_loans VALUES (500, 'Bill',  'Jakes', 685, 31500, 625.40, 4.75, '2021-09-01')
SELECT * FROM dual;

-- Build Great Lakes Database Tables

-- CREATE tables --
CREATE TABLE gl_schools (
  school_code  VARCHAR(2)  NOT NULL,
  school_name  VARCHAR(64) NOT NULL,
  school_dean  INTEGER
);

CREATE TABLE gl_programs (
  program_code  VARCHAR(3) NOT NULL,
  program_name  VARCHAR(64) NOT NULL,
  school_code   VARCHAR(2)  NOT NULL,
  program_chair INTEGER
);

CREATE TABLE gl_professors (
  professor_no INTEGER     NOT NULL,
  first_name   VARCHAR(64) NOT NULL,
  last_name    VARCHAR(64) NOT NULL,
  office_no    DECIMAL(4), 
  office_ext   DECIMAL(4),
  school_code  VARCHAR(2)
);

CREATE TABLE gl_courses (
  course_code  VARCHAR(6)  NOT NULL,
  course_title VARCHAR(64) NOT NULL,
  credit_hours DECIMAL(1)  NOT NULL,
  program_code VARCHAR(3)  NOT NULL
);

CREATE TABLE gl_prereqs (
  course_code   VARCHAR(6) NOT NULL,
  course_prereq VARCHAR(6) NOT NULL
);

CREATE TABLE gl_buildings (
  building_code VARCHAR(3)  NOT NULL,
  building_name VARCHAR(64) NOT NULL
);

CREATE TABLE gl_room_types (
  room_type     VARCHAR(2)  NOT NULL,
  description   VARCHAR(64) NOT NULL
);

CREATE TABLE gl_rooms (
  room_no       DECIMAL(4) NOT NULL,
  seats         DECIMAL(3),
  room_type     VARCHAR(2) NOT NULL,
  building_code VARCHAR(3) NOT NULL
);

CREATE TABLE gl_sections (
  section_id     INTEGER    NOT NULL,
  course_section DECIMAL(1) NOT NULL,
  enroll_max     DECIMAL(2) NOT NULL,
  course_code    VARCHAR(6) NOT NULL,
  professor_no   INTEGER    NOT NULL,
  room_no        DECIMAL(4) NOT NULL,
  semester_id    INTEGER    NOT NULL
);

CREATE TABLE gl_semesters (
  semester_id   INTEGER    NOT NULL,
  semester_year DECIMAL(4) NOT NULL,
  semester_term VARCHAR(1) NOT NULL     -- W, S, F
);

CREATE TABLE gl_days (
  section_id  INTEGER    NOT NULL,
  section_day DECIMAL(1) NOT NULL,  -- 1 to 6 representing Monday to Saturday
  start_time  VARCHAR(5) NOT NULL,  -- 8:00 to 6:00 - even hours
  end_time    VARCHAR(5) NOT NULL   -- 1 to 3 hour classes
);

CREATE TABLE gl_lockers (
  locker_no     INTEGER    NOT NULL,
  building_code VARCHAR(3) NOT NULL
);

CREATE TABLE gl_students (
  student_no   INTEGER     NOT NULL,
  first_name   VARCHAR(64) NOT NULL,
  last_name    VARCHAR(64) NOT NULL,
  sex          VARCHAR(1)  NOT NULL,
  enroll_date  DATE,
  major_code   VARCHAR(3),
  locker_no    INTEGER     NOT NULL  -- start at 1000 and increment by 1
);

CREATE TABLE gl_enrollments (
  section_id    INTEGER NOT NULL,
  student_no    INTEGER NOT NULL,
  numeric_grade DECIMAL(3),
  letter_grade  VARCHAR(1)
);

ALTER TABLE gl_schools
ADD CONSTRAINT gl_schools_pk
PRIMARY KEY (school_code);

ALTER TABLE gl_programs
ADD CONSTRAINT gl_programs_pk
PRIMARY KEY (program_code);

ALTER TABLE gl_professors
ADD CONSTRAINT gl_professors_pk
PRIMARY KEY (professor_no);

ALTER TABLE gl_courses
ADD CONSTRAINT gl_courses_pk
PRIMARY KEY (course_code);

ALTER TABLE gl_prereqs
ADD CONSTRAINT gl_prereqs_pk
PRIMARY KEY (course_code, course_prereq);

ALTER TABLE gl_buildings
ADD CONSTRAINT gl_buildings_pk
PRIMARY KEY (building_code);

ALTER TABLE gl_room_types
ADD CONSTRAINT gl_room_type_pk
PRIMARY KEY (room_type);

ALTER TABLE gl_rooms
ADD CONSTRAINT gl_rooms_pk
PRIMARY KEY (room_no);

ALTER TABLE gl_sections
ADD CONSTRAINT gl_sections_pk
PRIMARY KEY (section_id);

ALTER TABLE gl_semesters
ADD CONSTRAINT gl_semesters_pk
PRIMARY KEY (semester_id);

ALTER TABLE gl_days
ADD CONSTRAINT gl_days_pk
PRIMARY KEY (section_id, section_day);

ALTER TABLE gl_lockers
ADD CONSTRAINT gl_lockers_pk
PRIMARY KEY (locker_no);

ALTER TABLE gl_students
ADD CONSTRAINT gl_students_pk
PRIMARY KEY (student_no);

ALTER TABLE gl_enrollments
ADD CONSTRAINT gl_enrollments_pk
PRIMARY KEY (section_id, student_no);


INSERT INTO gl_schools VALUES ('BU', 'Business', NULL);
INSERT INTO gl_schools VALUES ('LA', 'Liberal Arts', 5001);
INSERT INTO gl_schools VALUES ('HS', 'Health Sciences', 5002);
INSERT INTO gl_schools VALUES ('CS', 'Computer Studies', 5003);
INSERT INTO gl_schools VALUES ('TE', 'Technology', 5004);
INSERT INTO gl_schools VALUES ('LS', 'Liberal Studies', 5005);

INSERT INTO gl_programs VALUES ('CIS', 'Computer Information Systems', 'CS', 5006);
INSERT INTO gl_programs VALUES ('ACC', 'Accounting', 'BU', NULL);
INSERT INTO gl_programs VALUES ('MGT', 'Management', 'BU', 5007);
INSERT INTO gl_programs VALUES ('NSG', 'Nursing', 'HS', 5008);
INSERT INTO gl_programs VALUES ('BUS', 'Business', 'BU', 5009);
INSERT INTO gl_programs VALUES ('LIB', 'Liberal Studies', 'LS', 5010);

INSERT INTO gl_professors VALUES (5001, 'Olivia', 'Smith',  301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5002, 'Joe',    'Taylor', 301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5003, 'Harish', 'Patel',  301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5004, 'Ann',    'Pratt',  301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5005, 'Wang',   'Lee',    301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5006, 'Julie',  'Adams',  301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5007, 'Liam',   'Davis',  301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5008, 'Shreya', 'Kaur',   301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5009, 'Noah',   'Brown',  301, 3864, 'CS');
INSERT INTO gl_professors VALUES (5010, 'Lucas',  'Miller', 301, 3864, 'CS');

INSERT INTO gl_semesters VALUES (1, 2019, 'W');  
INSERT INTO gl_semesters VALUES (2, 2019, 'S');
INSERT INTO gl_semesters VALUES (3, 2019, 'F');
INSERT INTO gl_semesters VALUES (4, 2020, 'W');
INSERT INTO gl_semesters VALUES (5, 2020, 'S');
INSERT INTO gl_semesters VALUES (6, 2020, 'F');
INSERT INTO gl_semesters VALUES (7, 2021, 'W');
INSERT INTO gl_semesters VALUES (8, 2021, 'S');
INSERT INTO gl_semesters VALUES (9, 2021, 'F');

INSERT INTO gl_buildings VALUES ('A', 'Building A');
INSERT INTO gl_buildings VALUES ('B', 'Building B');
INSERT INTO gl_buildings VALUES ('C', 'Building C');
INSERT INTO gl_buildings VALUES ('D', 'Building D');
INSERT INTO gl_buildings VALUES ('E', 'Building E');

INSERT INTO gl_room_types VALUES ('LH', 'Lecture Hall');
INSERT INTO gl_room_types VALUES ('CL', 'Computer Lab');
INSERT INTO gl_room_types VALUES ('TH', 'Theatre');
INSERT INTO gl_room_types VALUES ('DL', 'Distance Learning');
INSERT INTO gl_room_types VALUES ('GO', 'General Office');
INSERT INTO gl_room_types VALUES ('FO', 'Faculty Office');

INSERT INTO gl_rooms VALUES (101, 30, 'LH', 'A');
INSERT INTO gl_rooms VALUES (102, 60, 'TH', 'A');
INSERT INTO gl_rooms VALUES (103, 60, 'TH', 'A');
INSERT INTO gl_rooms VALUES (104, 40, 'CL', 'A');
INSERT INTO gl_rooms VALUES (105, 30, 'LH', 'A');
INSERT INTO gl_rooms VALUES (201, 60, 'TH', 'A');
INSERT INTO gl_rooms VALUES (202, 60, 'TH', 'A');
INSERT INTO gl_rooms VALUES (203, 40, 'CL', 'A');
INSERT INTO gl_rooms VALUES (301, 2,  'FO', 'A');

INSERT INTO gl_courses VALUES ('CIS100', 'Web Technologies I', 4, 'CIS');
INSERT INTO gl_courses VALUES ('CIS200', 'Web Technologies II', 4, 'CIS');
INSERT INTO gl_courses VALUES ('CIS300', 'Web Technologies III', 4, 'CIS');
INSERT INTO gl_courses VALUES ('CIS400', 'Database Design & SQL', 4, 'CIS');
INSERT INTO gl_courses VALUES ('CIS105', 'Programming Logic', 4, 'CIS');
INSERT INTO gl_courses VALUES ('CIS225', 'Python Programming', 4, 'CIS');
INSERT INTO gl_courses VALUES ('ENG101', 'Communications I', 3, 'BUS');
INSERT INTO gl_courses VALUES ('ENG201', 'Communication II', 3, 'BUS');
INSERT INTO gl_courses VALUES ('BUS100', 'Introduction to Business', 3, 'BUS');
INSERT INTO gl_courses VALUES ('MTH120', 'Algebra', 4, 'BUS');
INSERT INTO gl_courses VALUES ('MTH400', 'Geometry', 3, 'BUS');
INSERT INTO gl_courses VALUES ('BUS230', 'Business Planning', 3, 'BUS');
INSERT INTO gl_courses VALUES ('MGT410', 'Human Resources Management', 3, 'MGT');
INSERT INTO gl_courses VALUES ('MGT415', 'Project Management', 4, 'MGT');
INSERT INTO gl_courses VALUES ('NSG130', 'Nursing Theory I', 3, 'NSG');
INSERT INTO gl_courses VALUES ('NSG230', 'Nursing Theory II', 3, 'NSG');
INSERT INTO gl_courses VALUES ('ACC103', 'Accounting Theory', 4, 'ACC');
INSERT INTO gl_courses VALUES ('ACC104', 'Microeconomics', 3, 'ACC');
INSERT INTO gl_courses VALUES ('ACC205', 'Financial Accounting', 4, 'ACC');
INSERT INTO gl_courses VALUES ('ANT100', 'Anthropology', 3, 'LIB');
INSERT INTO gl_courses VALUES ('GEO101', 'The Physical Environment', 3, 'LIB');

INSERT INTO gl_prereqs VALUES ('CIS200', 'CIS100');
INSERT INTO gl_prereqs VALUES ('CIS300', 'CIS200');
INSERT INTO gl_prereqs VALUES ('CIS225', 'CIS100');
INSERT INTO gl_prereqs VALUES ('CIS225', 'CIS105');
INSERT INTO gl_prereqs VALUES ('ENG201', 'ENG101');

INSERT INTO gl_sections VALUES (10001, 1, 40, 'CIS100', 5001, 101, 7);
INSERT INTO gl_sections VALUES (10002, 2, 40, 'CIS100', 5002, 101, 7);
INSERT INTO gl_sections VALUES (10003, 3, 40, 'CIS100', 5003, 101, 7);
INSERT INTO gl_sections VALUES (10004, 1, 40, 'CIS200', 5004, 101, 7);
INSERT INTO gl_sections VALUES (10005, 2, 40, 'CIS200', 5001, 101, 7);
INSERT INTO gl_sections VALUES (10006, 1, 40, 'CIS300', 5002, 101, 7);
INSERT INTO gl_sections VALUES (10007, 2, 40, 'CIS300', 5003, 101, 7);
INSERT INTO gl_sections VALUES (10008, 1, 40, 'CIS400', 5004, 101, 7);
INSERT INTO gl_sections VALUES (10009, 2, 40, 'CIS400', 5001, 101, 7);
INSERT INTO gl_sections VALUES (10010, 1, 40, 'CIS105', 5002, 101, 7);
INSERT INTO gl_sections VALUES (10011, 2, 40, 'CIS105', 5003, 101, 7);
INSERT INTO gl_sections VALUES (10012, 3, 40, 'CIS105', 5004, 101, 7);
INSERT INTO gl_sections VALUES (10013, 1, 40, 'CIS225', 5005, 101, 7);
INSERT INTO gl_sections VALUES (10014, 2, 40, 'CIS225', 5006, 101, 7);

INSERT INTO gl_sections VALUES (10015, 1, 35, 'ACC103', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10016, 2, 35, 'ACC103', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10017, 1, 30, 'ACC104', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10018, 2, 30, 'ACC104', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10019, 1, 35, 'ACC205', 5010, 101, 7);

INSERT INTO gl_sections VALUES (10020, 1, 50, 'ENG101', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10021, 2, 50, 'ENG101', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10022, 1, 40, 'ENG201', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10023, 1, 35, 'BUS100', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10024, 2, 35, 'BUS100', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10025, 3, 25, 'BUS100', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10026, 1, 40, 'ENG201', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10027, 1, 30, 'BUS230', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10028, 2, 30, 'BUS230', 5010, 101, 7);

INSERT INTO gl_sections VALUES (10029, 1, 50, 'MGT410', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10030, 2, 50, 'MGT410', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10031, 3, 40, 'MGT410', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10032, 1, 20, 'MGT415', 5010, 101, 7);
INSERT INTO gl_sections VALUES (10033, 2, 20, 'MGT415', 5010, 101, 7);

INSERT INTO gl_sections VALUES (10034, 1, 40, 'CIS100', 5010, 101, 2);
INSERT INTO gl_sections VALUES (10035, 2, 40, 'CIS100', 5010, 101, 2);
INSERT INTO gl_sections VALUES (10036, 1, 35, 'CIS200', 5010, 101, 2);
INSERT INTO gl_sections VALUES (10037, 1, 40, 'CIS300', 5010, 101, 2);
INSERT INTO gl_sections VALUES (10038, 1, 35, 'CIS400', 5010, 101, 2);
INSERT INTO gl_sections VALUES (10039, 1, 40, 'CIS100', 5010, 101, 3);
INSERT INTO gl_sections VALUES (10040, 1, 35, 'CIS200', 5010, 101, 3);
INSERT INTO gl_sections VALUES (10041, 1, 40, 'CIS300', 5010, 101, 3);
INSERT INTO gl_sections VALUES (10042, 1, 35, 'CIS400', 5010, 101, 3);
INSERT INTO gl_sections VALUES (10043, 1, 40, 'CIS100', 5010, 101, 4);
INSERT INTO gl_sections VALUES (10044, 1, 35, 'CIS200', 5010, 101, 4);
INSERT INTO gl_sections VALUES (10045, 1, 40, 'CIS300', 5010, 101, 4);
INSERT INTO gl_sections VALUES (10046, 1, 35, 'CIS400', 5010, 101, 4);
INSERT INTO gl_sections VALUES (10047, 1, 40, 'CIS100', 5010, 101, 5);
INSERT INTO gl_sections VALUES (10048, 1, 35, 'CIS200', 5010, 101, 5);
INSERT INTO gl_sections VALUES (10049, 1, 40, 'CIS300', 5010, 101, 5);
INSERT INTO gl_sections VALUES (10050, 1, 35, 'CIS400', 5010, 101, 5);
INSERT INTO gl_sections VALUES (10051, 1, 40, 'CIS100', 5010, 101, 6);
INSERT INTO gl_sections VALUES (10052, 1, 35, 'CIS200', 5010, 101, 6);
INSERT INTO gl_sections VALUES (10053, 1, 40, 'CIS300', 5010, 101, 6);
INSERT INTO gl_sections VALUES (10054, 1, 35, 'CIS400', 5010, 101, 6);
INSERT INTO gl_sections VALUES (10055, 1, 40, 'CIS100', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10056, 1, 35, 'CIS200', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10057, 1, 40, 'CIS300', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10058, 1, 35, 'CIS400', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10059, 1, 40, 'CIS100', 5010, 101, 8);
INSERT INTO gl_sections VALUES (10060, 1, 35, 'CIS200', 5010, 101, 8);
INSERT INTO gl_sections VALUES (10061, 1, 40, 'CIS300', 5010, 101, 8);
INSERT INTO gl_sections VALUES (10062, 1, 35, 'CIS400', 5010, 101, 8);
INSERT INTO gl_sections VALUES (10063, 1, 40, 'CIS100', 5010, 101, 9);
INSERT INTO gl_sections VALUES (10064, 1, 35, 'CIS200', 5010, 101, 9);
INSERT INTO gl_sections VALUES (10065, 1, 40, 'CIS300', 5010, 101, 9);
INSERT INTO gl_sections VALUES (10066, 1, 35, 'CIS400', 5010, 101, 9);

INSERT INTO gl_sections VALUES (10067, 1, 35, 'ACC103', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10068, 2, 35, 'ACC103', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10069, 1, 30, 'ACC104', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10070, 2, 30, 'ACC104', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10071, 1, 35, 'ACC205', 5010, 101, 1);

INSERT INTO gl_sections VALUES (10072, 1, 50, 'MGT410', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10073, 2, 50, 'MGT410', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10074, 3, 40, 'MGT410', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10075, 1, 20, 'MGT415', 5010, 101, 1);
INSERT INTO gl_sections VALUES (10076, 2, 20, 'MGT415', 5010, 101, 1);

INSERT INTO gl_days VALUES (10001, 1, '8:30', '10:30');
INSERT INTO gl_days VALUES (10001, 3, '1:30', '3:30');

INSERT INTO gl_lockers VALUES (5000, 'A');

insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1000, 'Meagan', 'Farenden', 'F', '2019-11-07', 'NSG', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1001, 'Elianora', 'Ponsford', 'F', '2019-03-25', 'MGT', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1002, 'Kristina', 'Littefair', 'F', '2019-11-10', 'MGT', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1003, 'Dalis', 'Filchagin', 'M', '2019-05-30', 'MGT', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1004, 'Corrinne', 'Wooder', 'F', '2019-06-05', 'BUS', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1005, 'Paulo', 'MacCallester', 'M', '2019-06-07', 'NSG', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1006, 'Malynda', 'Rudyard', 'F', '2019-07-01', 'ACC', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1007, 'Jesus', 'Henrichsen', 'M', '2019-02-03', 'BUS', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1008, 'Paxton', 'Giraudy', 'M', '2019-04-15', 'ACC', 5000);
insert into gl_students (student_no, first_name, last_name, sex, enroll_date, major_code, locker_no) values (1009, 'Shelton', 'Witcombe', 'M', '2019-11-12', 'BUS', 5000);

INSERT INTO gl_enrollments VALUES (10001, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10001, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10001, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10001, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10001, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10002, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10002, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10002, 1007, 72, 'B');
INSERT INTO gl_enrollments VALUES (10002, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10002, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10003, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10003, 1001, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10003, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10003, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10003, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10004, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10004, 1006, 90, 'A');
INSERT INTO gl_enrollments VALUES (10004, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10004, 1008, 79, 'B');
INSERT INTO gl_enrollments VALUES (10004, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10005, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10005, 1001, 70, 'B');
INSERT INTO gl_enrollments VALUES (10005, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10005, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10005, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10006, 1005, 76, 'B');
INSERT INTO gl_enrollments VALUES (10006, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10006, 1007, 92, 'A');
INSERT INTO gl_enrollments VALUES (10006, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10006, 1009, 64, 'C');

INSERT INTO gl_enrollments VALUES (10007, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10007, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10007, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10007, 1003, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10007, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10008, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10008, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10008, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10008, 1008, 79, 'B');
INSERT INTO gl_enrollments VALUES (10008, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10009, 1000, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10009, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10009, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10009, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10009, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10010, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10010, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10010, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10010, 1008, 90, 'A');
INSERT INTO gl_enrollments VALUES (10010, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10011, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10011, 1001, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10011, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10011, 1003, 69, 'C');
INSERT INTO gl_enrollments VALUES (10011, 1004, 76, 'B');
INSERT INTO gl_enrollments VALUES (10012, 1005, 77, 'B');
INSERT INTO gl_enrollments VALUES (10012, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10012, 1007, 71, 'B');
INSERT INTO gl_enrollments VALUES (10012, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10012, 1009, 78, 'B');

INSERT INTO gl_enrollments VALUES (10013, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10013, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10013, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10013, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10013, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10014, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10014, 1006, 64, 'C');
INSERT INTO gl_enrollments VALUES (10014, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10014, 1008, 58, 'D');
INSERT INTO gl_enrollments VALUES (10014, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10015, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10015, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10015, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10015, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10015, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10016, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10016, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10016, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10016, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10016, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10017, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10017, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10017, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10017, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10017, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10018, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10018, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10018, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10018, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10018, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10019, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10019, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10019, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10019, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10019, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10020, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10020, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10020, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10020, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10020, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10021, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10021, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10021, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10021, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10021, 1004, 90, 'A');
INSERT INTO gl_enrollments VALUES (10022, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10022, 1006, 65, 'C');
INSERT INTO gl_enrollments VALUES (10022, 1007, 91, 'A');
INSERT INTO gl_enrollments VALUES (10022, 1008, 72, 'B');
INSERT INTO gl_enrollments VALUES (10022, 1009, 90, 'A');

INSERT INTO gl_enrollments VALUES (10023, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10023, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10023, 1002, 65, 'C');
INSERT INTO gl_enrollments VALUES (10023, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10023, 1004, 78, 'B');
INSERT INTO gl_enrollments VALUES (10024, 1005, 58, 'D');
INSERT INTO gl_enrollments VALUES (10024, 1006, 77, 'B');
INSERT INTO gl_enrollments VALUES (10024, 1007, 70, 'B');
INSERT INTO gl_enrollments VALUES (10024, 1008, 75, 'B');
INSERT INTO gl_enrollments VALUES (10024, 1009, 80, 'A');

INSERT INTO gl_enrollments VALUES (10025, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10025, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10025, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10025, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10025, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10026, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10026, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10026, 1007, 72, 'B');
INSERT INTO gl_enrollments VALUES (10026, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10026, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10027, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10027, 1001, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10027, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10027, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10027, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10028, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10028, 1006, 90, 'A');
INSERT INTO gl_enrollments VALUES (10028, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10028, 1008, 78, 'B');
INSERT INTO gl_enrollments VALUES (10028, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10029, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10029, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10029, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10029, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10029, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10030, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10030, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10030, 1007, 92, 'A');
INSERT INTO gl_enrollments VALUES (10030, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10030, 1009, 64, 'C');

INSERT INTO gl_enrollments VALUES (10031, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10031, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10031, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10031, 1003, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10031, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10032, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10032, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10032, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10032, 1008, 71, 'B');
INSERT INTO gl_enrollments VALUES (10032, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10033, 1000, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10033, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10033, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10033, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10033, 1004, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10034, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10034, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10034, 1007, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10034, 1008, 90, 'A');
INSERT INTO gl_enrollments VALUES (10034, 1009, NULL, NULL);

INSERT INTO gl_enrollments VALUES (10035, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10035, 1001, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10035, 1002, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10035, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10035, 1004, 78, 'B');
INSERT INTO gl_enrollments VALUES (10036, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10036, 1006, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10036, 1007, 71, 'B');
INSERT INTO gl_enrollments VALUES (10036, 1008, NULL, NULL);
INSERT INTO gl_enrollments VALUES (10036, 1009, 78, 'B');

INSERT INTO gl_enrollments VALUES (10067, 1000, 90, 'A');
INSERT INTO gl_enrollments VALUES (10067, 1001, 71, 'B');
INSERT INTO gl_enrollments VALUES (10067, 1002, 92, 'A');
INSERT INTO gl_enrollments VALUES (10067, 1003, 64, 'C');
INSERT INTO gl_enrollments VALUES (10068, 1004, 90, 'A');
INSERT INTO gl_enrollments VALUES (10068, 1005, 78, 'B');
INSERT INTO gl_enrollments VALUES (10068, 1006, 65, 'C');
INSERT INTO gl_enrollments VALUES (10068, 1007, 91, 'A');
INSERT INTO gl_enrollments VALUES (10069, 1008, 72, 'B');
INSERT INTO gl_enrollments VALUES (10069, 1009, 90, 'A');

-- Foreign Keys --
ALTER TABLE gl_courses
ADD CONSTRAINT gl_courses_program_code_fk
FOREIGN KEY (program_code)
REFERENCES gl_programs (program_code);

ALTER TABLE gl_prereqs
ADD CONSTRAINT gl_prereqs_course_code_fk
FOREIGN KEY (course_code)
REFERENCES gl_courses (course_code);

ALTER TABLE gl_prereqs
ADD CONSTRAINT gl_prereqs_course_prereq_fk
FOREIGN KEY (course_prereq)
REFERENCES gl_courses (course_code);

ALTER TABLE gl_enrollments
ADD CONSTRAINT gl_enrollments_section_id_fk
FOREIGN KEY (section_id)
REFERENCES gl_sections (section_id);

ALTER TABLE gl_enrollments
ADD CONSTRAINT gl_enrollments_student_no_fk
FOREIGN KEY (student_no)
REFERENCES gl_students (student_no);

ALTER TABLE gl_professors
ADD CONSTRAINT gl_professors_school_code_fk
FOREIGN KEY (school_code)
REFERENCES gl_schools (school_code);

ALTER TABLE gl_professors
ADD CONSTRAINT gl_professors_office_no_fk
FOREIGN KEY (office_no)
REFERENCES gl_rooms (room_no);

ALTER TABLE gl_programs
ADD CONSTRAINT gl_programs_chair_fk
FOREIGN KEY (program_chair)
REFERENCES gl_professors (professor_no);

ALTER TABLE gl_programs
ADD CONSTRAINT gl_programs_school_code_fk
FOREIGN KEY (school_code)
REFERENCES gl_schools (school_code);

ALTER TABLE gl_rooms
ADD CONSTRAINT gl_rooms_building_code_fk
FOREIGN KEY (building_code)
REFERENCES gl_buildings (building_code);

ALTER TABLE gl_rooms
ADD CONSTRAINT gl_rooms_room_type_fk
FOREIGN KEY (room_type)
REFERENCES gl_room_types (room_type);

ALTER TABLE gl_schools
ADD CONSTRAINT gl_schools_dean_fk
FOREIGN KEY (school_dean)
REFERENCES gl_professors (professor_no);

ALTER TABLE gl_sections
ADD CONSTRAINT gl_sections_course_code_fk
FOREIGN KEY (course_code)
REFERENCES gl_courses (course_code);

ALTER TABLE gl_sections
ADD CONSTRAINT gl_sections_professor_no_fk
FOREIGN KEY (professor_no)
REFERENCES gl_professors (professor_no);

ALTER TABLE gl_sections
ADD CONSTRAINT gl_sections_rooms_no_fk
FOREIGN KEY (room_no)
REFERENCES gl_rooms (room_no);

ALTER TABLE gl_sections
ADD CONSTRAINT gl_sections_semester_id_fk
FOREIGN KEY (semester_id)
REFERENCES gl_semesters (semester_id);

ALTER TABLE gl_days
ADD CONSTRAINT gl_days_section_id_fk
FOREIGN KEY (section_id)
REFERENCES gl_sections (section_id);

ALTER TABLE gl_students
ADD CONSTRAINT gl_students_major_fk
FOREIGN KEY (major_code)
REFERENCES gl_programs (program_code);

ALTER TABLE gl_students
ADD CONSTRAINT gl_students_locker_no_fk
FOREIGN KEY (locker_no)
REFERENCES gl_lockers (locker_no);

ALTER TABLE gl_lockers
ADD CONSTRAINT gl_lockers_building_code_fk
FOREIGN KEY (building_code)
REFERENCES gl_buildings (building_code);


-- Chapter 2 and 6
    
  CREATE TABLE gl_professors_copy AS
  SELECT * FROM gl_professors;

  ALTER TABLE gl_professors_copy 
  ADD CONSTRAINT gl_professors_copy_pk
  PRIMARY KEY ( professor_no );

-- Chapter 6
  

  CREATE TABLE gl_enrollments_copy AS
  SELECT * FROM gl_enrollments;

  ALTER TABLE gl_enrollments_copy 
  ADD CONSTRAINT gl_enrollments_copy_pk
  PRIMARY KEY ( section_id, student_no );

