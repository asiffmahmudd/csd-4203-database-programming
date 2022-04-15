--step-1
DROP TABLE gl_sections_copy; 
DROP TABLE gl_professors_copy; 

CREATE TABLE gl_professors_copy AS( 
 SELECT * FROM gl_professors); 
 
ALTER TABLE gl_professors_copy 
ADD CONSTRAINT gl_professors_copy_pk 
PRIMARY KEY (professor_no); 

CREATE TABLE gl_sections_copy AS( 
 SELECT * FROM gl_sections); 
 
ALTER TABLE gl_sections_copy 
ADD CONSTRAINT gl_sections_copy_pk 
PRIMARY KEY (section_id); 

ALTER TABLE gl_sections_copy 
ADD CONSTRAINT gl_sections_copy_professor_no_fk 
FOREIGN KEY (professor_no) 
REFERENCES gl_professors_copy (professor_no); 

SELECT * FROM gl_professors_copy; 
SELECT * FROM gl_sections_copy;


--step-2
CREATE OR REPLACE VIEW professor_section_view AS
    SELECT professor_no, COUNT(section_id) AS TOTAL_SECTIONS
    FROM gl_professors_copy
    LEFT JOIN gl_sections_copy USING(professor_no)
    GROUP BY professor_no;
	
	
--step-3
DELETE FROM professor_section_view
WHERE professor_no = 5001;
--It shows error 
--ORA-01732: data manipulation operation not legal on this view


--step-4
CREATE OR REPLACE TRIGGER professor_delete_trg
INSTEAD OF DELETE ON professor_section_view
FOR EACH ROW
BEGIN
    DELETE FROM gl_sections_copy
    WHERE professor_no = :OLD.professor_no;
    
    DELETE FROM gl_professors_copy
    WHERE professor_no = :OLD.professor_no;
END;


--step-5
DELETE FROM professor_section_view
WHERE professor_no = 5001;
--1 row(s) deleted.

--step-6
SELECT * 
FROM professor_section_view 
WHERE professor_no = 5001; 

SELECT * 
FROM gl_professors_copy 
WHERE professor_no = 5001; 

SELECT * 
FROM gl_sections_copy 
WHERE professor_no = 5001;

-- all of them shows the output "no data found"