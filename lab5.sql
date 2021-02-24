SET SERVEROUTPUT ON;
--1. Using an explicit cursor with parameters select department_id,
--department_name. If the department has employees select their first_name,
--last_name and salary
DECLARE
    CURSOR c_emp(p_dep_id Departments.department_id%TYPE,p_dep_name Departments.department_name%TYPE) 
        IS
        SELECT first_name, last_name, salary
        FROM Employees e
        WHERE e.department_id = p_dep_id
        ORDER BY department_id;
        v_emp_record c_emp%ROWTYPE;
        v_minId Employees.department_id%TYPE;
        v_maxId Employees.department_id%TYPE;
        v_dep_name Departments.department_name%TYPE;
BEGIN
    SELECT MIN(department_id),MAX(department_id) INTO v_minId,v_maxId FROM Departments;
    SELECT department_name INTO v_dep_name FROM Departments
    Where department_id = v_minId;
    LOOP
        OPEN c_emp(v_minId,v_dep_name);
        LOOP
            FETCH c_emp INTO v_emp_record;
            EXIT WHEN c_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('First Name: ' || v_emp_record.first_name || ' |  Last Name: ' || v_emp_record.last_name ||  ' |  Salary: ' || v_emp_record.salary );
        END LOOP;
                v_minId:=v_minId+10;
        EXIT WHEN v_minId>v_maxId;
        CLOSE c_emp;
    END LOOP;
END;


---2. Write a PL/SQL block to read and display the names of world regions, with
--a count of the number of countries in each region. Include only those regions
--having at least 6 countries. Order your output by ascending region name.
DECLARE
CURSOR countries_cur IS
SELECT region_id, country_name FROM countries
ORDER BY region_id ASC;
v_region_id countries.region_id%TYPE;
v_country_name countries.country_name%TYPE;
BEGIN
OPEN countries_cur;
FETCH countries_cur INTO v_region_id, v_country_name;
DBMS_OUTPUT.PUT_LINE(v_region_id ||' '|| v_country_name);
CLOSE countries_cur;
END;

--3. a. Create a PL/SQL block that declares a cursor called DATE_CUR.
--Pass a parameter of DATE data type to the cursor and print the details of all
--the employees who have joined after that date.
--DEFINE P_HIREDATE = 08-MAR-00
--b. Test the PL/SQL block for the following hire dates: 08-MAR-09, 25-JUN-07, 28-SEP-08, 07-FEB-06.
DECLARE
 CURSOR DATE_CURSOR(JOIN_DATE DATE) IS
 SELECT employee_id,last_name,hire_date FROM employees
 WHERE HIRE_DATE >JOIN_DATE ;
 EMPNO employees.employee_id%TYPE;
 ENAME employees.last_name%TYPE;
 HIREDATE employees.hire_date%TYPE;
 HDATE employees.hire_date%TYPE := '&P_HIREDATE';
 BEGIN
 OPEN DATE_CURSOR(HDATE);
 LOOP
 FETCH DATE_CURSOR INTO EMPNO,ENAME,HIREDATE;
 EXIT WHEN DATE_CURSOR%NOTFOUND;
 DBMS_OUTPUT.PUT_LINE (EMPNO || ' ' || ENAME || ' ' || HIREDATE);
 END LOOP;
 END;


--4. Write a PL/SQL block that inserts a row into PROPOSED_RAISES (create
--new table here) table for each eligible employee. The eligible employees are
--those whose salary is below a chosen value. The salary value is passed as a
--parameter to the cursor. For each eligible employee, insert a row into
--ROPOSED_RAISES with date_proposed = today’s date, date_appoved null,
--and proposed_new_salary 5% greater than the current salary.Test your code
--using a chosen salary value of 5000.
DECLARE CURSOR cur_emp(s_salary NUMBER) 
IS SELECT employee_id,first_name,last_name,salary 
FROM employees WHERE salary<s_salary 
FOR UPDATE;
BEGIN 
FOR v_rec IN cur_emp(5000)
LOOP INSERT
INTO PROPOSED_RAISES(employee_id,first_name,last_name,salary,date_proposed,original_salary)
VALUES(v_rec.employee_id,v_rec.first_name,v_rec.last_name,v_rec.salary*1.05,SYSDATE,v_rec.salary);
END LOOP;
END;

--5. Write a PL/SQL block to display the country name and the number of
--locations listed in a country within a chosen region. The region_id should be
--passed to the cursor as a parameter. Test your block using two region_ids: 1
--and 3. 
DECLARE
CURSOR c_country(p_region_id NUMBER) IS SELECT country_name
FROM countries
WHERE region_id = p_region_id;
v_country_record c_country%ROWTYPE;

BEGIN
OPEN c_country(5);
LOOP
FETCH c_country INTO v_country_record;
EXIT WHEN c_country%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(v_country_record.country_name);
END LOOP;
CLOSE c_country;
END;

--6. Create a PL/SQL block that fetches and displays the names of the five
--departments with the most employees. (Hint: use a join condition). For each of
--these departments, display the department name and the number of
--employees. Order your output so that the department with the most
--employees is displayed first. Use %ROWTYPE and the explicit cursor attribute
--%ROWCOUNT.
DECLARE
CURSOR c_nr_emp IS
SELECT d.department_name, count(e.employee_id)
 FROM departments d, employees e
 WHERE d.department_id=e.department_id
GROUP BY d.department_name
ORDER BY 2 DESC;
v_dept_name departments.department_name%TYPE;
v_nr NUMBER;
BEGIN
DBMS_OUTPUT.PUT_LINE('Primele 5 departamente:');
OPEN c_nr_emp;
LOOP
FETCH c_nr_emp INTO v_dept_name, v_nr;
EXIT WHEN c_nr_emp%ROWCOUNT>5;
DBMS_OUTPUT.PUT_LINE(v_dept_name||', '||v_nr);
END LOOP;
CLOSE c_nr_emp;
END;

--TASK7--
DECLARE CURSOR c_cursor1
IS SELECT department_id,department_name 
FROM departments ORDER BY department_id; 
CURSOR c_cursor2(dep_num NUMBER) 
IS SELECT first_name,last_name,salary 
FROM employees WHERE department_id = dep_num ORDER BY last_name;
BEGIN 
FOR v_record1 IN c_cursor1 
LOOP 
DBMS_OUTPUT.PUT_LINE(v_record1.department_id || ' '|| v_record1.department_name); 
DBMS_OUTPUT.PUT_LINE('------------------------------------'); 
FOR v_record2 IN c_cursor2(v_record1.department_id) 
LOOP 
DBMS_OUTPUT.PUT_LINE(v_record2.first_name||' '||v_record2.last_name||' '||v_record2.salary);
END LOOP;
DBMS_OUTPUT.PUT_LINE(' ');
END LOOP;
END;































