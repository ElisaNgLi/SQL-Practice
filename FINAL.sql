CREATE OR REPLACE PROCEDURE RaiseError (

       p_Raise IN BOOLEAN := TRUE,

       p_ParameterA OUT NUMBER) IS

   BEGIN

              p_ParameterA := 11;

   IF p_Raise THEN

         RAISE DUP_VAL_ON_INDEX;

      ELSE

         RETURN;

      END IF;

   END RaiseError;

   /

 

  DECLARE                                                                                                

      v_TempVar NUMBER;                                                                            

  BEGIN

      RaiseError (false, v_TempVar) ;                                             

      INSERT INTO temp_table (num_col)                                             

      VALUES (v_TempVar);                                                                                                 

       v_TempVar := 22;                                                                                          

      RaiseError(true, v_TempVar);

      v_TempVar := 33;

  EXCEPTION

      WHEN OTHERS THEN

          INSERT INTO temp_table (num_col)

          VALUES (v_TempVar);

  END;

  /
  SELECT num_col FROM temp_table;
  
 
 -- 2
 
CREATE OR REPLACE PROCEDURE topemps (
        v_empCount NUMBER,
        v_depID EMPLOYEES.DEPARTMENT_ID%TYPE
) IS
        cursor c1 IS
        SELECT LAST_NAME, SALARY FROM EMPLOYEES
        WHERE DEPARTMENT_ID <> depID
        ORDER BY SALARY DESC, LAST_NAME;

 

        c1Row c1%rowtype;
        v_temp_Name EMPLOYEES.LAST_NAME%TYPE;
        v_temp_Salary EMPLOYEES.SALARY%TYPE;

 

        v_invalid_count EXCEPTION;
        v_invalid_depID EXCEPTION;

 

BEGIN
        IF v_empcount < 1 THEN
                RAISE v_invalid_count;
        END IF;

 

        OPEN c1;
        FETCH c1 into c1Row;

 

        IF c1%rowcount = 0 THEN
                RAISE v_invalid_depID;
        ELSE
                close c1;
                OPEN c1;
                FOR i IN 1..v_empCount
                LOOP
                        FETCH C1 INTO v_temp_Name, v_temp_Salary;
                        EXIT WHEN c1%NOTFOUND;
                        INSERT INTO top_emp Values(v_temp_Name, v_temp_Salary);
                END LOOP;
        END IF;

 


        EXCEPTION
                WHEN v_invalid_count THEN
                        dbms_output.put_line('You must enter positive integer for number of employees');
                WHEN v_invalid_depID THEN
                        dbms_output.put_line('Your department number is invalid');
END;
/

--3

CREATE OR REPLACE TRIGGER Upd_Rem_Emp_Trig
BEFORE DELETE OR UPDATE ON employees
FOR EACH ROW
WHEN (SUBSTR(OLD.job_id, 3, 3) = 'MAN' OR SUBSTR(OLD.job_id,3,3) = 'MGR')
BEGIN
    DBMS_OUTPUT.PUT_LINE('Deleting a MAN or MGR...');
    
    IF (to_char(sysdate, 'DY') IN ('SAT', 'SUN')) OR 
        (to_char(sysdate, 'HH24:MI')) NOT BETWEEN '08:00' AND '17:00' THEN
        
        RAISE_APPLICATION_ERROR(-20101, 'You can only delete employee during week days');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleting Employee.....');
    END IF;
END;
/

UPDATE employees 
SET email = 'TEST'
WHERE employee_id = 120; 

    
DELETE FROM employees
WHERE employee_id = 198; 
    
ROLLBACK;


SELECT * FROM EMPLOYEES;
