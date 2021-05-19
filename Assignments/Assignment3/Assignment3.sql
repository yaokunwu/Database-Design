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
select Dname, COUNT(*) Number_Of_Employee
from DEPARTMENT d, EMPLOYEE e
where d.Dno = e.Dno
group by Dname
having AVG(Salary) > 30000;

b).
select dname, count(*)
from department d1, employee e1
where  d1.dno = e1.dno and e1.gender='M' and d1.dno in (
	(select d2.dno from department d2, employee e2
			 where e2.dno = d2.dno
			 group by d2.dno
			 having avg(salary) > 30000))
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

/* below is also fine*/
select e1.fname, e1.lname
from employee e1
where e1.salary = (select min(salary)
				from employee e2
				where e1.dno = e2.dno)
	  and 
		exists(select *
				from dependent d
				where e1.ssn = d.essn)

2.
a)
create view q_2_a as
select dname as department_name, fname as manager_fname,lname as manager_lname,salary as manager_salary 
from department D, employee E
where D.mgrssn = E.ssn

b).

create view q_2_b as
select dname, fname, lname, (select count(*)
							from employee e2
							where e2.dno = d1.dno) as ne,
							(select count(*)
                                from project w2
                                where w2.dno = d1.dno) as np
from employee e1, department d1
where e1.ssn = d1.mgrssn

c).
create view q_2_c as
select pname, dname, (select count(*)
							from works_on w2
							where p1.pno = w2.pno) as ne,
							(select sum(hours)
                                from works_on w3
                                where w3.pno = p1.pno) as nh
from project p1, department d1
where p1.dno = d1.dno

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
select e1.Fname as efn, e1.lname as eln, e1.salary as es, d1.dname, e2.fname as mfn, e2.lname as mln, e2.salary as ms,
(select AVG(salary)
from employee e3
where e3.dno = e1.dno) 
from employee e1, department d1, employee e2
where e1.dno = d1.dno and d1.mgrssn = e2.ssn





