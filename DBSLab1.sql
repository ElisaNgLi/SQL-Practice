--Lab2
-- 1
SET  SERVEROUTPUT ON
SET  VERIFY  OFF
ACCEPT scale PROMPT 'Enter your input scale (C or F) for temperature: ';
ACCEPT temp PROMPT 'Enter your temperature value to be coverted: ';
DECLARE
    v_scale VARCHAR2(1) := '&scale';
    v_temp NUMBER(4,1) := '&temp';
BEGIN
    IF UPPER(v_scale) = 'F' THEN
        v_temp := (v_temp - 32) * 5/9;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in C is exactly ' || TO_CHAR(v_temp));
    ELSIF UPPER(v_scale) = 'C' THEN
        v_temp := (v_temp * 9/5) + 32;
        DBMS_OUTPUT.PUT_LINE('Your converted temperature in F is exactly ' || TO_CHAR(v_temp));
    ELSE
    DBMS_OUTPUT.PUT_LINE('This is NOT a valid scale. Must be C or F.');
    END IF;       
END;

--2
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT id PROMPT 'Please enter the Instructor Id: ';
DECLARE 
    v_id NUMBER := '&id';
    v_name INSTRUCTOR.FIRST_NAME%TYPE;
    v_section NUMBER;
    v_message VARCHAR2(100);
BEGIN
    SELECT first_name || ' ' || last_name INTO v_name
    FROM instructor
    WHERE v_id = instructor_id;
    
    SELECT COUNT(section_id) INTO v_section
    FROM section
    WHERE v_id = instructor_id;
    
    DBMS_OUTPUT.PUT_LINE('Instructor ' || v_name || ' , teaches ' || v_section || ' section(s)');
    
    v_message := CASE
        WHEN v_section > 9 THEN 'This instructor needs to rest in the next term.'
        WHEN v_section > 5 THEN 'This instructor teaches enough sections.'
        ELSE 'This instructor may teach more sections.'
        END;
        
    DBMS_OUTPUT.PUT_LINE(v_message);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('This is NOT a valid instructor');
            
END;

-- 3
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT numb PROMPT 'Please enter a Positive Integer: ';
DECLARE
    v_numb NUMBER(6) := '&numb';
    v_count NUMBER(6);
    v_add NUMBER(9) := 0;
    v_message VARCHAR2(5);
BEGIN
    IF v_numb < 0 THEN
        DBMS_OUTPUT.PUT_LINE('This is NOT a positive integer.');
    ELSE
        IF MOD(v_numb, 2) = 0 THEN
            v_message := 'EVEN';
            v_count := v_numb;
            WHILE v_count > 0 LOOP
            v_add := v_add + v_count;
            v_count := v_count - 2;
            END LOOP;
        ELSE
            v_message := 'Odd';
            v_count := v_numb;
            WHILE v_count > 0 LOOP
            v_add := v_add + v_count;
            v_count := v_count - 2;
            END LOOP;
        END IF;
        DBMS_OUTPUT.PUT_LINE('The sum of ' || v_message || ' integers between 1 and ' || v_numb || ' is ' || v_add);
        
    END IF;
    
END;

-- 4
UPDATE Departments SET location_id = 1400
WHERE department_id in (40,70);

SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT id PROMPT 'Enter valid Location Id: ';
DECLARE
    v_id DEPARTMENTS.LOCATION_ID%TYPE := '&id';
    v_dept NUMBER;
    v_emp NUMBER;
    v_count1 NUMBER;
    v_count2 NUMBER;
BEGIN
    SELECT COUNT(department_id) INTO v_dept
    FROM Departments
    WHERE v_id = location_id;
    
    SELECT COUNT(employee_id) INTO v_emp
    FROM Employees
    WHERE department_id in (SELECT department_id 
                            FROM Departments
                            WHERE v_id = location_id);
    FOR v_count1 in 1..v_dept LOOP
        DBMS_OUTPUT.PUT_LINE('Outer Loop: Department #'|| v_count1);
        FOR v_count2 in 1..v_emp LOOP
            DBMS_OUTPUT.PUT_LINE('* Inner Loop: Employee #'|| v_count2);
        END LOOP;
    END LOOP;
END;
/
ROLLBACK;
    
