--Quiz 1 DES720

desc dept;


select * from dept;

desc emp;

SELECT empno, SUBSTR(ename,1,12) "Last Name", job, mgr,
       hiredate, sal, comm, deptno "Dept"
     FROM   emp
     ORDER BY 1;
     
-- Show for all employees that work in  New York or Montreal 
--their department name, employee name,  job and salary, but only 
--if their salary is 
--within the range of 2000 to 4200 dollars.

SELECT d.dname AS "Department Name", e.ename AS "Employee Name", e.job, e.sal AS "Salary"
FROM dept d JOIN emp e
ON d.deptno = e.deptno
WHERE d.loc IN ('NEW YORK', 'Montreal') 
AND sal BETWEEN 2000 AND 4200
ORDER BY sal desc;
     
--Who are the employees that were hired AFTER all 
--analysts were hired and that do NOT work as Salesman or Analyst.
--Show their names, jobs, salaries and hire dates.
--Sort the output by the latest  hire date.

SELECT ename AS "Employee Name", job, sal AS "Salary", hiredate
FROM emp
WHERE hiredate > ALL (SELECT hiredate
                    FROM emp
                    WHERE job = 'ANALYST')
AND job NOT IN ('SALESMAN', 'ANALYST')
ORDER BY 4 DESC;

SELECT  job "Position", AVG(sal)"Average Pay"
FROM    emp
WHERE   deptno IN   (SELECT   deptno 
                    FROM    dept 
                    WHERE   dname 
                    IN      ('RESEARCH', 'SALES'))
GROUP BY job
HAVING  AVG(sal)>2500
ORDER BY job
--Which jobs can be found in the departments for Sales or Research 
--and what is the Average amount paid for these jobs. 
--Include only those jobs that need per person more than $2500. 
--Sort the output according to job names alphabetically.

SELECT job AS "Position", ROUND(AVG(sal),1) AS "Average Pay"
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM dept
                 WHERE dname IN ('SALES', 'RESEARCH'))
GROUP BY job
HAVING AVG(sal) > 2500
ORDER BY 1;

--Q4
 SELECT empno empid, ename "Surname",                                     
TO_CHAR(sal, '$99,999.9') "Monthly Pay"
FROM   emp
WHERE ( comm IS NULL  OR sal > 2500)
AND    UPPER(SUBSTR(ename,2,1)) IN ('E','L')
ORDER BY 3 desc ;

select * from emp
where ename = 'CLARK';

--Lab 5 ANSWER
CREATE TABLE client (
    Client_id       NUMBER(5) CONSTRAINT client_client_id_pk PRIMARY KEY,
    Client_name     VARCHAR2(20) NOT NULL CONSTRAINT client_client_name_uk UNIQUE,
    Client_address  VARCHAR2(30),
    Client_city     VARCHAR2(10) NOT NULL,
    Client_prov     CHAR(2)     NOT NULL,
    Client_postal   CHAR(6)     NOT NULL
)   

CREATE TABLE prog (
    Prog_id     NUMBER(5) CONSTRAINT prog_prog_id_pk PRIMARY KEY,
    Prog_name   VARCHAR2(30) NOT NULL,
    Prog_office CHAR(4)     NOT NULL,
    Prog_phone  CHAR(10)
)

CREATE TABLE project (
    Project_id      NUMBER(6) CONSTRAINT project_project_id_pk   PRIMARY KEY,
    Proj_name       VARCHAR2(40) NOT NULL CONSTRAINT project_proj_name_uk UNIQUE,
    Complete_date   DATE DEFAULT SYSDATE,
    Total_cost      NUMBER(8,2) CONSTRAINT project_total_cost_ck CHECK (Total_cost > 0),
    Client_id       NUMBER(5) NOT NULL CONSTRAINT project_client_id_fk REFERENCES client (Client_id)
)

CREATE TABLE project_staff(
    Prog_id         NUMBER(5),
    Project_id      NUMBER(6),
    Week_Year       CHAR(5),
    Hours_worked    NUMBER(4,1) NOT NULL,
    CONSTRAINT project_staff_progid_projectid_weekyear_pk PRIMARY KEY(Prog_id, Project_id,Week_Year),
    CONSTRAINT project_staff_prog_id_fk     FOREIGN KEY(Prog_id) REFERENCES prog (Prog_id),
    CONSTRAINT project_staff_project_id_fk  FOREIGN KEY(Project_id) REFERENCES project(Project_id),
    CONSTRAINT project_staff_hours_worked CHECK (Hours_worked > 0)
)