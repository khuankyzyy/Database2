SET SERVEROUTPUT ON;
// TASK 1
 /* A)  collection is an ordered group of elements having the same data type.
    B) Index by table is based on a single field or column
    C) INDEX BY table is based on a single field or column. An INDEX BY table of records is based on a composite
    record type.
    D) v_pops_tab is index by table, I know it in countries.population%TYPE (It stores only one row)
    */


ALTER TABLE countries ADD country_no NUMBER(4,0);
DECLARE 
    v_no NUMBER (4,0):= 1;
BEGIN    
    FOR i IN ( SELECT country_id, country_name from countries) LOOP
        UPDATE countries SET country_no = v_no WHERE country_id = i.country_id;
        dbms_output.put_line(v_no || ' ' || i.country_name);
        v_no := v_no + 1;
    END LOOP;
END;
select * from countries;

// TASK 2.A

DECLARE
    TYPE t_cname IS TABLE OF varchar2(30) INDEX BY BINARY_INTEGER;
    t_cname_tab t_cname;
BEGIN
    FOR cname_record IN (SELECT country_name, country_no FROM countries) LOOP
        t_cname_tab(cname_record.country_no) := cname_record.country_name;
    END LOOP;
END;

// TASK 2.B

SET SERVEROUTPUT ON;
DECLARE
    TYPE t_cname IS TABLE OF varchar2(30) INDEX BY BINARY_INTEGER;
    t_cname_tab t_cname;
    calc number;
BEGIN
    FOR cname_record IN (SELECT country_name, country_no FROM countries) LOOP
        t_cname_tab(cname_record.country_no) := cname_record.country_name;
    END LOOP;
    
    FOR calc IN t_cname_tab.FIRST..t_cname_tab.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(t_cname_tab(calc));
    END LOOP;
END;

// TASK 2.C
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_cname IS TABLE OF varchar2(30) INDEX BY BINARY_INTEGER;
    t_cname_tab t_cname;
BEGIN
    FOR cname_record IN (SELECT country_name, country_no FROM countries) LOOP
        t_cname_tab(cname_record.country_no) := cname_record.country_name;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(t_cname_tab(t_cname_tab.FIRST));
    DBMS_OUTPUT.PUT_LINE(t_cname_tab(t_cname_tab.LAST));
    DBMS_OUTPUT.PUT_LINE(t_cname_tab.COUNT);
END;

//TASK 3.A
DECLARE
    TYPE t_emp IS TABLE OF employees%ROWTYPE 
    INDEX BY BINARY_INTEGER;
    t_emp_tab t_emp;
BEGIN
    FOR emp_cur IN (SELECT * FROM employees) LOOP
        t_emp_tab(emp_cur.employee_id) := emp_cur;
    END LOOP;
END;

// TASK 3.B
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_emp IS TABLE OF employees%ROWTYPE 
    INDEX BY BINARY_INTEGER;
    t_emp_tab t_emp;
    x number;
BEGIN
    FOR emp_cur IN (SELECT * FROM employees) LOOP
        t_emp_tab(emp_cur.employee_id) := emp_cur;
    END LOOP;
    
    FOR x IN t_emp_tab.FIRST..t_emp_tab.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(t_emp_tab(x).last_name || '     ' || t_emp_tab(x).job_id || '     ' || t_emp_tab(x).salary );
    END LOOP;
END;