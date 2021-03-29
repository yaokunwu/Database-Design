Assignment 3
/* All the SQL statements have been tested on PostgreSQL (I have problem signing up for oracle cloud)*/


/* Part 1 */

CREATE TABLE book (
  book_id      char(3),
  title  varchar(50),
  publisher_name varchar(50),
  primary key (book_id)
);

CREATE TABLE book_authors (
  book_id	char(3),
  author_name	varchar(50),
  primary key (book_id, author_name)
);

CREATE TABLE publisher (
  name           varchar(50),
  address	varchar(50),
  phone		char(10),
  primary key (name)
);

CREATE TABLE book_copies (
  book_id	char(3),
  branch_id	char(2),
  no_of_copies   integer,
  primary key (book_id, branch_id)
);

CREATE TABLE book_loans (
  book_id	char(3),
  branch_id	char(2),
  card_no	char(5),
  date_out    date,
  due_date    date,
  return_date    date default null,
  primary key (book_id, branch_id,card_no)
);

CREATE TABLE library_branch (
  branch_id	char(2),
  branch_name   varchar(50),
  address	varchar(50),
  primary key (branch_id)
);

CREATE TABLE borrower (
  card_no	char(5),
  name   varchar(50),
  address	varchar(50),
  phone		char(10),
  primary key (card_no)
);


ALTER TABLE book ADD CONSTRAINT fkename FOREIGN KEY(publisher_name) REFERENCES publisher(name) on delete set null;	
ALTER TABLE book_authors ADD CONSTRAINT fkeidauthors FOREIGN KEY(book_id) REFERENCES book(book_id) on delete cascade;
ALTER TABLE book_copies ADD CONSTRAINT fkeidcopies FOREIGN KEY(book_id) REFERENCES book(book_id) on delete cascade;
ALTER TABLE book_copies ADD CONSTRAINT fkeidbranch FOREIGN KEY(branch_id) REFERENCES library_branch(branch_id) on delete cascade;
ALTER TABLE book_loans ADD CONSTRAINT fkeidloansbook FOREIGN KEY(book_id) REFERENCES book(book_id) on delete cascade;
ALTER TABLE book_loans ADD CONSTRAINT fkeidloansbranch FOREIGN KEY(branch_id) REFERENCES library_branch(branch_id) on delete cascade;
ALTER TABLE book_loans ADD CONSTRAINT fkeidcard FOREIGN KEY(card_no) REFERENCES borrower(card_no) on delete cascade;


/* Part 2 */

1.
a).
select dname, count(*)
from department d1, employee e1
where  d1.dno = e1.dno and d1.dno in (
	(select dno from (select d2.dno, avg(salary)
			 from department d2, employee e2
			 where e2.dno = d2.dno
			 group by d2.dno
			 having avg(salary) > 30000) as s))
group by dname

b).
select dname, count(*)
from department d1, employee e1
where  d1.dno = e1.dno and e1.gender='M' and d1.dno in (
	(select dno from (select d2.dno, avg(salary)
			 from department d2, employee e2
			 where e2.dno = d2.dno
			 group by d2.dno
			 having avg(salary) > 30000) as s))
group by dname

c).
select fname,lname
from employee E, department D
where E.dno=D.dno and D.dno in (select distinct dno
				from employee
				where salary in (select max(salary)
				from employee))

d).
select fname,lname
from employee
where salary >= 10000 + (select min(salary)
			from employee)

e).
select fname, lname
from employee E
where salary = (select min(salary)
				from employee E2
				where E.dno = E2.dno)
	 and (select count(*)
		 from dependent Q
		 where E.ssn = Q.essn) > 1

2.
a)
create view q_2_a as
select dname as department_name, fname as manager_fname,lname as manager_lname,salary as manager_salary 
from department D, employee E
where D.mgrssn = E.ssn

b).

create view q_2_b as
select dname as department_name, fname as manager_fname,lname as manager_lname, ecount as number_of_employees ,pcount as number_of_projects 
from (employee e1 join department d1 on e1.ssn = d1.mgrssn) join 
(select dno, ecount, pcount
from (select d.dno, count(*) as ecount
  		from  department d left outer join employee e on e.dno=d.dno
  		group by d.dno) m1 natural join
 		(select d.dno, count(pno) as pcount
 		from department d left outer join project p on p.dno=d.dno
 		group by d.dno) m2) m3 on d1.dno = m3.dno

c).
create view q_2_c as
select pname as project_name, dname as department_name, ecount as number_of_employees, hourcount as total_hours 
from (project p left outer join department d on p.dno = d.dno) natural join 
 (select pno, ecount, hourcount
 from (select p.pno, count(*) as ecount, sum(hours) as hourcount
   		from  project p left outer join works_on w on p.pno=w.pno
   		group by p.pno) m1) m2

d).
create view q_2_d as
select pname as project_name, dname as department_name, ecount as number_of_employees, hourcount as total_hours 
from (project p left outer join department d on p.dno = d.dno) natural join 
(select pno, ecount, hourcount
from (select p.pno, count(*) as ecount, sum(hours) as hourcount
   		from  project p left outer join works_on w on p.pno=w.pno
   		group by p.pno having count(*) > 1) m1) m2

e).
create view q_2_e as
select e.fname as employee_fname,e.lname as employee_lname,e.salary as employee_salary,e.dno as employee_dno, m.fname as mgr_fname,m.lname as mgr_lname,m.salary as mgr_salary, dept_avg_salary
from employee e, department d, employee m, (select d2.dno as mdno, avg(salary) as avg_salary
						from employee e2, department d2
						where e2.dno = d2.dno
						group by d2.dno) m2
where e.dno = d.dno and d.mgrssn = m.ssn and d.dno = mdno





