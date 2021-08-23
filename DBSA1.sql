--Assignment 1

--3
SET SERVEROUTPUT ON;  
SET VERIFY OFF; 
ACCEPT description PROMPT 'Enter the beginning of the Course description in UPPER case: '; 
 
DECLARE 
CURSOR c1 IS SELECT * FROM COURSE WHERE PREREQUISITE IS NOT NULL AND UPPER(DESCRIPTION) LIKE UPPER('&description%'); 
 
TYPE Prereqcourse IS RECORD(PreCourseno NUMBER, Predescription VARCHAR2(50), Precost NUMBER); 
 
TYPE coursereq IS RECORD(Courseno NUMBER, description VARCHAR2(50), cost NUMBER, Precourse Prereqcourse); 
 
v_course coursereq; 
 
v_pre NUMBER(5); 
v_count NUMBER(5); 
 
BEGIN 
 
    SELECT COUNT(*) INTO v_pre FROM COURSE WHERE PREREQUISITE IS NOT NULL AND UPPER(DESCRIPTION) LIKE UPPER('&description%'); 
    SELECT count(*) INTO v_count FROM COURSE WHERE UPPER(DESCRIPTION) LIKE UPPER('&description%');     
    IF v_count > 0 THEN 
        IF v_pre > 0 THEN 
            FOR cur_course in c1  
                LOOP 
                    SELECT COURSE_NO, DESCRIPTION, COST INTO v_course.Courseno, v_course.description, v_course.cost 
                    FROM COURSE WHERE COURSE_NO LIKE cur_course.COURSE_NO; 
                     
                    SELECT COURSE_NO, DESCRIPTION, COST INTO v_course.Precourse.PreCourseno, v_course.Precourse.Predescription, v_course.Precourse.Precost 
                    FROM COURSE WHERE COURSE_NO LIKE cur_course.PREREQUISITE; 
                     
                    DBMS_OUTPUT.PUT_LINE('Course: ' || v_course.Courseno || ' - ' || v_course.description); 
                     
                    DBMS_OUTPUT.PUT_LINE('Cost: ' || v_course.cost); 
 
                    DBMS_OUTPUT.PUT_LINE('Prerequisite Course: ' || v_course.Precourse.PreCourseno || ' - ' || v_course.Precourse.Predescription); 
                     
                    DBMS_OUTPUT.PUT_LINE('Prerequisite Cost: ' || v_course.Precourse.Precost); 
                     
                    DBMS_OUTPUT.PUT_LINE('======================================== '); 
                END LOOP; 
            ELSE 
                DBMS_OUTPUT.PUT_LINE('There is NO prerequisite course that starts on &description. Try again.'); 
            END IF; 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('There is NO VALID course that starts on: &description. Try again.'); 
    END IF; 
END; 

