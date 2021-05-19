set serveroutput on
DECLARE
   v_line varchar2(40);
BEGIN
v_line := 'Hello World';
dbms_output.put_line(v_line);
END;


***

create or replace procedure findMin(x IN number, y IN number, z OUT number) AS
BEGIN
   IF x < y THEN
      z:= x;
   ELSE
      z:= y;
   END IF;
END;


set serveroutput on
DECLARE
a number;
b number;
c number;
BEGIN
   a:= 23;
   b:= 45;
   findMin(a, b, c);
   dbms_output.put_line(' Minimum of (23, 45) : ' || c);
END;



/* Procedure that will assign all employees in Research department to a new project */

create or replace PROCEDURE Assign_Project(pnumber IN Project.Pno%TYPE, hours IN number) AS 

thisEmployee Employee%ROWTYPE;

CURSOR Dept5Emps IS
SELECT E.* FROM Employee E, Department D WHERE E.Dno=D.Dno AND Dname='Research';

BEGIN
OPEN Dept5Emps;
LOOP
  FETCH Dept5Emps INTO thisEmployee;
  EXIT WHEN (Dept5Emps%NOTFOUND);

  INSERT INTO WORKS_ON VALUES (thisEmployee.SSN, pnumber, hours);
  dbms_output.put_line(thisEmployee.SSN || ' has been assigned to the new project.');

END LOOP;
CLOSE Dept5Emps;
END;





/* Procedure that will increase employee salaries by 10% for all employees in Research department */

create or replace PROCEDURE Salary_Increase1 AS 

thisEmployee Employee%ROWTYPE;

CURSOR Dept5Emps IS
SELECT E.* FROM Employee E, Department D WHERE E.Dno=D.Dno AND Dname='Research'
FOR UPDATE;

BEGIN
OPEN Dept5Emps;
LOOP
  FETCH Dept5Emps INTO thisEmployee;
  EXIT WHEN (Dept5Emps%NOTFOUND);
  dbms_output.put_line(thisEmployee.SSN);
  dbms_output.put_line(thisEmployee.Salary);
  UPDATE Employee SET Salary = Salary * 1.1
  WHERE SSN= thisEmployee.SSN;

END LOOP;
CLOSE Dept5Emps;
END;



begin
salary_increase1();
end;
select avg(salary) from employee e, department d where e.dno=d.dno and dname='Research';




/* Procedure that will increase employee salaries by 10% for all employees who has the minimum salary in their respective departments. */


create or replace PROCEDURE Salary_Increase2 AS 

thisEmployee Employee%ROWTYPE;

CURSOR MinSalaryEmps IS
SELECT * FROM Employee E1 WHERE Salary =  
(SELECT MIN(Salary) FROM Employee E2 WHERE E2.Dno = E1.DNo)
FOR UPDATE;

BEGIN
OPEN MinSalaryEmps;
LOOP
  FETCH MinSalaryEmps INTO thisEmployee;
  EXIT WHEN (MinSalaryEmps%NOTFOUND);
  dbms_output.put_line(thisEmployee.SSN);
  dbms_output.put_line(thisEmployee.Salary);
  UPDATE Employee SET Salary = Salary * 1.1
  WHERE SSN= thisEmployee.SSN;

END LOOP;
CLOSE MinSalaryEmps;
END;























