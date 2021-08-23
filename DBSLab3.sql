--Lab3
--A
SET SERVEROUTPUT ON; 
SET VERIFY OFF;

DECLARE 
    TYPE course_table_type IS TABLE OF COURSE.DESCRIPTION%TYPE INDEX BY PLS_INTEGER;
    course_table course_table_type ;
    v_count NUMBER(10) := 1;
    CURSOR c1 IS SELECT DESCRIPTION FROM COURSE WHERE PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN 

OPEN c1;
  LOOP
     fetch c1 into course_table(v_count);
     EXIT  WHEN  c1%NOTFOUND;
     DBMS_OUTPUT.PUT_LINE('Course Description: ' || v_count || ': ' || course_table(v_count));
     v_count := v_count +1;
  END LOOP;
  v_count := v_count -1;
  DBMS_OUTPUT.PUT_LINE('************************************ ');
  DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: ' || v_count);
CLOSE c1;
END;

--B
SET SERVEROUTPUT ON; 
SET VERIFY OFF;

DECLARE 
    TYPE course_table_type IS TABLE OF COURSE%ROWTYPE ;
    course_table course_table_type := course_table_type();
    v_count NUMBER(10);
    CURSOR c1 IS SELECT * FROM COURSE WHERE PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN 

OPEN c1;
  
fetch c1 bulk collect into course_table;

FOR i IN 1..course_table.count
  LOOP
     v_count := i;
     course_table.EXTEND;
     DBMS_OUTPUT.PUT_LINE('Course Description: ' || i || ': ' || course_table(i).DESCRIPTION);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('************************************');
  DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: ' || v_count);
CLOSE c1;
END;


SET SERVEROUTPUT ON; 
SET VERIFY OFF;

DECLARE 
    TYPE course_table_type IS TABLE OF COURSE%ROWTYPE ;
    course_table course_table_type := course_table_type();
    v_count NUMBER(10) := 1;
    CURSOR c1 IS SELECT * FROM COURSE WHERE PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN 
FOR i IN c1
  LOOP
     course_table.EXTEND;
     DBMS_OUTPUT.PUT_LINE('Course Description: ' || v_count || ': ' || i.DESCRIPTION);
      v_count := v_count + 1;
  END LOOP;
      v_count := v_count - 1;
  DBMS_OUTPUT.PUT_LINE('************************************');
  DBMS_OUTPUT.PUT_LINE('Total # of Courses without the Prerequisite is: ' || v_count);
END;

SET SERVEROUTPUT ON
SET VERIFY OFF 

DECLARE	
    TYPE course_table_type IS TABLE OF COURSE%ROWTYPE;
    course_table course_table_type := course_table_type();
    v_count NUMBER(5) := 1;

CURSOR c_course_cursor IS Select DESCRIPTION from course where PREREQUISITE IS NULL ORDER BY DESCRIPTION;

BEGIN
FOR i IN c_course_cursor
LOOP
course_table.EXTEND;
DBMS_OUTPUT.PUT_LINE('Course Description : ' || v_count || ': ' || i.description);
v_count := v_count + 1;
END LOOP;
v_count := v_count - 1;
DBMS_OUTPUT.PUT_LINE('************************************');
DBMS_OUTPUT.PUT_LINE('Total # of Courses' || ' without the Prerequisite is: ' || v_count);
END;

--C

SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT v_zip PROMPT 'Enter three digits of zip: ';

DECLARE
    TYPE T_REC IS RECORD (ZIP_CODE NUMBER, enrollCount NUMBER);
    course_rec T_REC;
    v_count NUMBER(5) :=0;
    v_recordTotal NUMBER(5);
CURSOR c1 IS SELECT zip, count(student_id) from(Select Distinct aa.ZIP, aa.student_id  
                                                FROM STUDENT aa 
                                                LEFT JOIN ENROLLMENT bb ON aa.STUDENT_ID = bb.STUDENT_ID 
                                                WHERE aa.ZIP LIKE '&v_zip'|| '%') 
             GROUP BY ZIP 
             ORDER BY ZIP; 
   
BEGIN
    Select count(*) INTO v_recordTotal FROM STUDENT WHERE ZIP LIKE '&v_zip'|| '%';   
    IF v_recordTotal > 0 THEN 
        OPEN c1;
        LOOP
        FETCH c1 INTO course_rec;
        EXIT  WHEN  c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Zip code: ' || course_rec.zip_code || ' has exactly ' || course_rec.enrollCount || ' students enrolled.');
        v_count := v_count + 1; 
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('************************************');
        DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&v_zip' || ' is ' || v_count);
        DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&v_zip' || ' is ' || v_recordTotal); 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
    END IF;
END;

SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT zip PROMPT 'Enter three digits of zip: ';

DECLARE
    TYPE T_REC IS RECORD (v_zip NUMBER, v_enroll NUMBER);
    course_rec T_REC;
    v_count NUMBER(5) :=0;
    v_total NUMBER(5);
CURSOR c1 IS SELECT zip, count(student_id) FROM(SELECT Distinct s.ZIP, s.student_id  
                                                FROM STUDENT s 
                                                LEFT JOIN ENROLLMENT e ON s.STUDENT_ID = e.STUDENT_ID 
                                                WHERE s.ZIP LIKE '&zip'|| '%') 
             GROUP BY zip 
             ORDER BY zip; 
   
BEGIN
    SELECT COUNT(*) INTO v_total FROM STUDENT WHERE ZIP LIKE '&zip'|| '%';   
    IF v_total > 0 THEN 
        OPEN c1;
        LOOP
        FETCH c1 INTO course_rec;
        EXIT  WHEN  c1%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Zip code: ' || course_rec.v_zip || ' has exactly ' || course_rec.v_enroll || ' students enrolled.');
        v_count := v_count + 1; 
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('************************************');
        DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&zip' || ' is ' || v_count);
        DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&zip' || ' is ' || v_total); 
    ELSE 
        DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
    END IF;
END;

SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT zip PROMPT 'Enter three digits of zip: ';

DECLARE
    v_count NUMBER(5) :=0;
    v_total NUMBER(5);
    CURSOR c1 IS SELECT zip, COUNT(student_id) AS studentCount FROM(SELECT Distinct s.zip, s.student_id  
                                                                    FROM STUDENT s
                                                                    LEFT JOIN ENROLLMENT e ON s.STUDENT_ID = e.STUDENT_ID 
                                                                    WHERE s.ZIP LIKE '&zip'|| '%') 
                GROUP BY zip 
                ORDER BY zip;
    student_rec c1%ROWTYPE;  
    TYPE student_table_type IS TABLE OF student_rec%TYPE INDEX BY PLS_INTEGER;
    student_table student_table_type;
   
BEGIN
    Select count(*) INTO v_total FROM STUDENT WHERE ZIP LIKE '&zip'|| '%';
 
    IF v_total > 0 THEN 
            FOR i IN c1
            LOOP
            DBMS_OUTPUT.PUT_LINE('Zip code: ' || i.ZIP || ' has exactly ' || i.studentCount || ' students enrolled.');
            v_count := v_count + 1; 
            END LOOP;
   
        DBMS_OUTPUT.PUT_LINE('************************************');
        DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&zip' || ' is ' || v_count);
        DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&zip' || ' is ' || v_total);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
 END IF;
END;



--D

SET SERVEROUTPUT ON; 
SET VERIFY OFF;

ACCEPT v_zip PROMPT 'Enter three digits of zip: ';

DECLARE
    v_count NUMBER(5) :=0;
    v_recordTotal NUMBER(5);
    CURSOR c1 IS SELECT zip, count(student_id) as studentCount from(Select Distinct aa.ZIP, aa.student_id  
                                                                    FROM STUDENT aa 
                                                                    LEFT JOIN ENROLLMENT bb ON aa.STUDENT_ID = bb.STUDENT_ID 
                                                                    WHERE aa.ZIP LIKE '&v_zip'|| '%') 
                GROUP BY ZIP 
                ORDER BY ZIP;
    student_rec c1%ROWTYPE;  
    TYPE student_table_type IS TABLE OF student_rec%TYPE INDEX BY PLS_INTEGER;
    student_table student_table_type;
   
BEGIN
    Select count(*) INTO v_recordTotal FROM STUDENT WHERE ZIP LIKE '&v_zip'|| '%';
 
    IF v_recordTotal > 0 THEN 
        OPEN c1;
        fetch c1 bulk collect into student_table;
            FOR i IN 1..student_table.count
            LOOP
            DBMS_OUTPUT.PUT_LINE('Zip code: ' || student_table(i).ZIP || ' has exactly ' || student_table(i).studentCount || ' students enrolled.');
            v_count := v_count + 1; 
            END LOOP;
        CLOSE c1;
        DBMS_OUTPUT.PUT_LINE('************************************');
        DBMS_OUTPUT.PUT_LINE('Total # of zip codes under ' || '&v_zip' || ' is ' || v_count);
        DBMS_OUTPUT.PUT_LINE('Total # of Students under zip code ' || '&v_zip' || ' is ' || v_recordTotal);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('This zip area is student empty. Please, try again.');
 END IF;
END;

--A1 Q3
SET SERVEROUTPUT ON; 
SET VERIFY OFF;
ACCEPT description PROMPT 'Enter the beginning of the Course description in UPPER case: ';

DECLARE
CURSOR c1 IS SELECT * FROM COURSE WHERE PREREQUISITE IS NOT NULL AND UPPER(DESCRIPTION) LIKE UPPER('&description%');

TYPE Prereqcourse IS RECORD(PreCourseno NUMBER, Predescription VARCHAR2(50), Precost NUMBER);

TYPE coursereq IS RECORD(Courseno NUMBER, description VARCHAR2(50), cost NUMBER, Precourse Prereqcourse);

v_course coursereq;

Pre_count_check NUMBER(5);
count_check NUMBER(5);

BEGIN

    SELECT count(*) INTO Pre_count_check FROM COURSE WHERE PREREQUISITE IS NOT NULL AND UPPER(DESCRIPTION) LIKE UPPER('&description%');
    SELECT count(*) INTO count_check FROM COURSE WHERE UPPER(DESCRIPTION) LIKE UPPER('&description%');    
    IF count_check > 0 THEN
        IF Pre_count_check > 0 THEN
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
