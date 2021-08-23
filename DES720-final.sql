SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT input PROMPT 'Enter employee ID: ';
DECLARE
    CURSOR C1 IS
      SELECT job_id
      FROM   job_history
      WHERE  job_id IN (SELECT job_id
                        FROM   employees);
                        v_total NUMBER;
BEGIN

OPEN C1;
IF C1%FOUND THEN 
CLOSE C1;


SELECT 
             Count(start_date)  INTO v_total
      FROM   employees e
             left outer join job_history jh USING (employee_id)
     WHERE  e.job_id = '&input'
      GROUP  BY first_name;
DBMS_OUTPUT.PUT_LINE('Job: ' || job_id );
DBMS_OUTPUT.PUT_LINE('Number of Job: ' || v_total);



END IF;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('That employee ID doesnt exist. Try Again ');

END; 
/

--Create a PL/SQL block to retrieve the total number of different jobs on which a certain employee worked. --This block will accept one value to hold the employee ID. It will display the number of different jobs that employee worked until now, --including also the current job. -- --Use an Explicit Cursor that will count number of different job positions that employee held in the past. -- --Also, you need to add the code that will be able to tell whether the current job is the same as one of the past jobs and not include this case in the count. -- --Add exception handling to account for an invalid employee ID. -- --You will use tables EMPLOYEES and JOB_HISTORY. -- --Show also the Testing with one valid Id and one invalid Id.

