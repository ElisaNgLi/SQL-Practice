-- 1
SET VERIFY OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE mine (
        p_expiry    CHAR,
        p_type  CHAR
    ) IS
    v_num_type      NUMBER;
    v_invalid_type  EXCEPTION;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Last day of the month ' || p_expiry 
        || ' is ' || to_char(last_day(to_date(p_expiry, 'MM/YY')), 'Day'));
    
    IF (UPPER(p_type) = 'P') THEN
        SELECT COUNT(*) INTO v_num_type
        FROM user_objects
        WHERE object_type = 'PROCEDURE';
         DBMS_OUTPUT.PUT_LINE('Number of stored objects of type ' || UPPER(p_type) || ' is ' || v_num_type);
    ELSIF (UPPER(p_type) = 'F') THEN
    SELECT COUNT(*) INTO v_num_type
        FROM user_objects
        WHERE object_type = 'FUNCTION';
         DBMS_OUTPUT.PUT_LINE('Number of stored objects of type ' || UPPER(p_type) || ' is ' || v_num_type);
    ELSIF (UPPER(p_type) = 'B') THEN
    SELECT COUNT(*) INTO v_num_type
        FROM user_objects
        WHERE object_type = 'PACKAGE BOY';
         DBMS_OUTPUT.PUT_LINE('Number of stored objects of type ' || UPPER(p_type) || ' is ' || v_num_type);
    ELSE
        RAISE v_invalid_type;
    END IF;

    EXCEPTION
        WHEN v_invalid_type THEN
            DBMS_OUTPUT.PUT_LINE('You have entered an Invalid letter for the store object. Try P, F or B.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('You have entered an Invalid FORMAT for the MONTH and YEAR. Try MM/YY.');
END;
/

 EXECUTE MINE('11/09','P');
 EXECUTE MINE('12/09','f');
 EXECUTE MINE('01/10','T');
 EXECUTE MINE('13/09','P');


-- 2

SET VERIFY OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE add_zip (
        p_zip       zipcode.zip%TYPE,
        p_city      zipcode.city%TYPE,
        p_state     zipcode.state%TYPE,
        p_status    OUT CHAR,
        p_num       OUT NUMBER
    ) IS
BEGIN
    BEGIN
        SELECT 'FAILURE' INTO p_status
            FROM zipcode
            WHERE zip = p_zip;
            
        DBMS_OUTPUT.PUT_LINE('This ZIPCODE ' || p_zip || ' is already in the Database. Try again.');
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_status := 'SUCCESS';
                INSERT INTO zipcode
                    VALUES(p_zip, initcap(p_city), UPPER(p_state), user, sysdate, user, sysdate);
    END;
    
    SELECT COUNT(*) INTO p_num
        FROM zipcode
        WHERE UPPER(state) = UPPER(p_state);
        
END;
/

ACCEPT s_zip PROMPT 'Enter a zip code: ';
ACCEPT s_city PROMPT 'Enter a city: ';
ACCEPT s_state PROMPT 'Enter a state: ';

VARIABLE zipnum NUMBER;
VARIABLE flag CHAR(7);

EXECUTE add_zip('&s_zip', '&s_city', '&&s_state', :flag, :zipnum);

PRINT flag;
PRINT zipnum;

SELECT *
FROM zipcode
WHERE UPPER(state) = UPPER('&s_state');

EXECUTE IF :flag = 'SUCCESS' THEN ROLLBACK; END IF;




-- 3

SET VERIFY OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION exist_zip (
        p_zip   zipcode.zip%TYPE
    ) RETURN BOOLEAN IS
    v_flag      PLS_INTEGER;
BEGIN
    BEGIN
        SELECT 1 INTO v_flag
            FROM zipcode
            WHERE zip = p_zip;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_flag := 0;
    END;
    
    RETURN v_flag = 1;
        
END;
/

CREATE OR REPLACE PROCEDURE add_zip2 (
        p_zip       zipcode.zip%TYPE,
        p_city      zipcode.city%TYPE,
        p_state     zipcode.state%TYPE,
        p_status    OUT NOCOPY CHAR,
        p_num       OUT NOCOPY NUMBER
    ) IS
BEGIN
    
    IF exist_zip(p_zip => p_zip) THEN
        DBMS_OUTPUT.PUT_LINE('This ZIPCODE ' || p_zip || ' is already in the Database. Try again. ');
        p_status := 'FAILURE';
    ELSE
        INSERT INTO zipcode
            VALUES(p_zip, initcap(p_city), upper(p_state), user, sysdate, user, sysdate);
        p_status := 'SUCCESS';
    END IF;
    
    SELECT count(*) INTO p_num
        FROM zipcode
        WHERE upper(state) = upper(p_state);
END;
/

ACCEPT v_zip PROMPT 'Enter a zip code: ';
ACCEPT v_city PROMPT 'Enter a city: ';
ACCEPT v_state PROMPT 'Enter a state: ';

VARIABLE zipnum NUMBER;
VARIABLE flag CHAR(7);

EXECUTE add_zip2('&v_zip', '&v_city', '&&v_state', :flag, :zipnum);

PRINT flag;
PRINT zipnum;

SELECT *
FROM zipcode
WHERE UPPER(state) = UPPER('&v_state');

EXECUTE IF :flag = 'SUCCESS' THEN ROLLBACK; END IF;






-- 4
SET VERIFY OFF;
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION instruct_status (
        p_first     instructor.first_name%TYPE,
        p_last      instructor.last_name%TYPE
    ) RETURN VARCHAR2 IS
    v_id            instructor.instructor_id%TYPE;
    v_section   NUMBER;
    v_message VARCHAR2(200);
BEGIN

    SELECT instructor_id INTO v_id
    FROM instructor
    WHERE upper(first_name) = upper(p_first)
    AND upper(last_name) = upper(p_last);
    
    SELECT count(*) INTO v_section
    FROM section
    WHERE instructor_id = v_id;
        
    IF v_section >= 10 THEN
        v_message :=  'This Instructor will teach ' || v_section || ' courses and needs a vacation.';
    ELSIF v_section > 0 THEN
        v_message := 'This Instructor will teach ' || v_section || ' courses.';
     ELSE
        v_message := 'This Instructor is NOT scheduled to teach.';
    END IF;
    RETURN v_message;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           v_message := 'There is NO such instructor.';
           RETURN v_message;
        WHEN OTHERS THEN
           v_message := 'Something went wrong.';
           RETURN v_message;
END;
/

SELECT last_name, instruct_status(first_name,last_name) AS "Instructor Status"
FROM instructor
ORDER BY last_name;

VARIABLE message VARCHAR2(200); 

EXECUTE :message := instruct_status('PETER','PAN');
PRINT message;

EXECUTE :message := instruct_status('IRENE','WILLIG');
PRINT message;
