--1

SET SERVEROUT ON;
SET VERIFY OFF;

CREATE OR REPLACE FUNCTION Get_Descr (
        v_secId    section.section_id%TYPE
    ) RETURN course.description%TYPE IS
    v_desc course.description%TYPE;
BEGIN

    SELECT c.description INTO v_desc
        FROM course c
        JOIN section s
        ON c.course_no = s.course_no 
        WHERE s.section_id = v_secId;

    RETURN 'Course Description for Section Id ' || v_secId || ' is ' || v_desc;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'There is NO such Section id: ' || v_secId;
        
END Get_Descr;
/

VARIABLE description VARCHAR2(100);

EXECUTE :description := get_descr(150);
PRINT description;

EXECUTE :description := get_descr(999);
PRINT description;

-- 2

SET SERVEROUTPUT ON;
SET VERIFY ON;

CREATE OR REPLACE PROCEDURE show_bizdays (
        v_start_date DATE := sysdate,
        v_num_days PLS_INTEGER := 21
    ) IS
    
    v_work_days CONSTANT PLS_INTEGER := 5;
    v_weekend_days CONSTANT PLS_INTEGER := 2;
    
    v_indx PLS_INTEGER := 1;
    v_day_count PLS_INTEGER := 0;
    v_curr_date DATE := v_start_date;
    
    TYPE tab_date_type IS TABLE OF
        DATE
        INDEX BY PLS_INTEGER;
        
    date_tab tab_date_type;
BEGIN
    
    IF to_char(v_curr_date, 'fmDAY') IN ('SATURDAY', 'SUNDAY') THEN 
            v_curr_date := next_day(v_curr_date, 'MONDAY');
    END IF;
    
    v_day_count := next_day(v_curr_date, 'FRIDAY') - v_curr_date;
    
    WHILE v_indx <= v_num_days LOOP
        date_tab(v_indx) := v_curr_date;
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_indx || ' and the table value is: ' || to_char(date_tab(v_indx), 'dd-MON-yy'));
        IF v_day_count != 0 THEN
            v_day_count := v_day_count - 1;
        ELSE 
            v_day_count := v_work_days - 1;
            v_curr_date := v_curr_date + v_weekend_days;
        END IF;
        v_curr_date := v_curr_date + 1;
        v_indx := v_indx + 1;
    END LOOP;
    
END show_bizdays;
/

EXECUTE show_bizdays;

EXECUTE show_bizdays(sysdate + 7, 10);


--3

SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PACKAGE Lab5 IS
    FUNCTION get_descr(v_secId section.section_id%TYPE) RETURN course.description%TYPE;
    PROCEDURE show_bizdays(v_start_date DATE := sysdate, v_num_days PLS_INTEGER := 21);
END Lab5;
/

CREATE OR REPLACE PACKAGE BODY Lab5 IS

    FUNCTION get_descr (
            v_secId    section.section_id%TYPE
        ) RETURN course.description%TYPE IS
        v_desc course.description%TYPE;
    BEGIN
    
        SELECT c.description INTO v_desc
        FROM course c
        JOIN section s
        ON c.course_no = s.course_no 
        WHERE s.section_id = v_secId;

    RETURN 'Course Description for Section Id ' || v_secId || ' is ' || v_desc;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'There is NO such Section id: ' || v_secId;
            
    END get_descr;


    PROCEDURE show_bizdays (
            v_start_date DATE := sysdate,
            v_num_days PLS_INTEGER := 21
        ) IS
        
        v_work_days CONSTANT PLS_INTEGER := 5;
        v_weekend_days CONSTANT PLS_INTEGER := 2;
        
        v_indx PLS_INTEGER := 1;
        v_day_count PLS_INTEGER := 0;
        v_curr_date DATE := v_start_date;
        
        TYPE tab_date_type IS TABLE OF
            DATE
            INDEX BY PLS_INTEGER;
            
        date_tab tab_date_type;
    BEGIN
        
       IF to_char(v_curr_date, 'fmDAY') IN ('SATURDAY', 'SUNDAY') THEN 
            v_curr_date := next_day(v_curr_date, 'MONDAY');
    END IF;
    
    v_day_count := next_day(v_curr_date, 'FRIDAY') - v_curr_date;
    
    WHILE v_indx <= v_num_days LOOP
        date_tab(v_indx) := v_curr_date;
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_indx || ' and the table value is: ' || to_char(date_tab(v_indx), 'dd-MON-yy'));
        IF v_day_count != 0 THEN
            v_day_count := v_day_count - 1;
        ELSE 
            v_day_count := v_work_days - 1;
            v_curr_date := v_curr_date + v_weekend_days;
        END IF;
        v_curr_date := v_curr_date + 1;
        v_indx := v_indx + 1;
    END LOOP;
        
    END show_bizdays;
        
END;
/


VARIABLE description VARCHAR2(100);

EXECUTE :description := lab5.get_descr(150);
PRINT description;

EXECUTE :description := lab5.get_descr(999);
PRINT description;


EXECUTE lab5.show_bizdays;

EXECUTE lab5.show_bizdays(sysdate + 7, 10);

--4

SET SERVEROUTPUT ON;
SET VERIFY OFF;

CREATE OR REPLACE PACKAGE lab5 IS
    FUNCTION get_descr(v_secId section.section_id%TYPE) RETURN course.description%TYPE;
    PROCEDURE show_bizdays(v_start_date DATE := sysdate, v_num_days PLS_INTEGER := 21);
    PROCEDURE show_bizdays(v_date_start DATE := sysdate);
END lab5;
/

CREATE OR REPLACE PACKAGE BODY lab5 IS

    FUNCTION Get_Descr (
            v_secId    section.section_id%TYPE
        ) RETURN course.description%TYPE IS
        v_desc course.description%TYPE;
    BEGIN
    
        SELECT c.description INTO v_desc
        FROM course c
        JOIN section s
        ON c.course_no = s.course_no 
        WHERE s.section_id = v_secId;

    RETURN 'Course Description for Section Id ' || v_secId || ' is ' || v_desc;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'There is NO such Section id: ' || v_secId;
            
    END Get_Descr;


    PROCEDURE show_bizdays (
            v_start_date DATE := sysdate,
            v_num_days PLS_INTEGER := 21
        ) IS
        
        v_work_days CONSTANT PLS_INTEGER := 5;
        v_weekend_days CONSTANT PLS_INTEGER := 2;
        
        v_indx PLS_INTEGER := 1;
        v_day_count PLS_INTEGER := 0;
        v_curr_date DATE := v_start_date;
        
        TYPE tab_date_type IS TABLE OF
            DATE
            INDEX BY PLS_INTEGER;
            
        date_tab tab_date_type;
    BEGIN
        
         IF to_char(v_curr_date, 'fmDAY') IN ('SATURDAY', 'SUNDAY') THEN 
            v_curr_date := next_day(v_curr_date, 'MONDAY');
    END IF;
    
    v_day_count := next_day(v_curr_date, 'FRIDAY') - v_curr_date;
    
    WHILE v_indx <= v_num_days LOOP
        date_tab(v_indx) := v_curr_date;
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_indx || ' and the table value is: ' || to_char(date_tab(v_indx), 'dd-MON-yy'));
        IF v_day_count != 0 THEN
            v_day_count := v_day_count - 1;
        ELSE 
            v_day_count := v_work_days - 1;
            v_curr_date := v_curr_date + v_weekend_days;
        END IF;
        v_curr_date := v_curr_date + 1;
        v_indx := v_indx + 1;
    END LOOP;
        
    END show_bizdays;
    
   --ACCEPT num_days NUMBER PROMT 'Enter number of days: ';
    PROCEDURE show_bizdays (
        v_date_start DATE := sysdate
    ) IS
    
        v_work_days CONSTANT PLS_INTEGER := 5;
        v_weekend_days CONSTANT PLS_INTEGER := 2;
        
        v_indx PLS_INTEGER := 1;
        v_day_count PLS_INTEGER := 0;
        v_curr_date DATE := v_date_start;
        
        TYPE tab_date_type IS TABLE OF
            DATE
            INDEX BY PLS_INTEGER;
            
        date_tab tab_date_type;
    BEGIN

         IF to_char(v_curr_date, 'fmDAY') IN ('SATURDAY', 'SUNDAY') THEN 
            v_curr_date := next_day(v_curr_date, 'MONDAY');
    END IF;
    
    v_day_count := next_day(v_curr_date, 'FRIDAY') - v_curr_date;
    
    WHILE v_indx <= &num_days LOOP
        date_tab(v_indx) := v_curr_date;
        DBMS_OUTPUT.PUT_LINE('The index is : ' || v_indx || ' and the table value is: ' || to_char(date_tab(v_indx), 'dd-MON-yy'));
        IF v_day_count != 0 THEN
            v_day_count := v_day_count - 1;
        ELSE 
            v_day_count := v_work_days - 1;
            v_curr_date := v_curr_date + v_weekend_days;
        END IF;
        v_curr_date := v_curr_date + 1;
        v_indx := v_indx + 1;
    END LOOP;
    END show_bizdays;
    
END;
/


VARIABLE description VARCHAR2(100);

EXECUTE :description := lab5.get_descr(150);
PRINT description;

EXECUTE :description := lab5.get_descr(999);
PRINT description;

EXECUTE lab5.show_bizdays(v_start_date => sysdate);

EXECUTE lab5.show_bizdays(sysdate + 7, 10);

EXECUTE lab5.show_bizdays(v_date_start => sysdate);


