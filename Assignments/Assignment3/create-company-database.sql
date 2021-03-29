/* COMPANY Database */
/* Part-1: Create table statements */ 

CREATE TABLE department (
  dname        varchar(25) not null,
  dno          integer,
  mgrssn       char(9) not null, 
  mgrstartdate date,
  primary key (dno),
  unique (dname)
);


CREATE TABLE employee (
  fname    varchar(15) not null, 
  minit    varchar(1),
  lname    varchar(15) not null,
  ssn      char(9),
  bdate    date,
  address  varchar(50),
  gender      char,
  salary   decimal(10,2),
  superssn char(9),
  dno      integer,
  primary key (ssn)
);


CREATE TABLE project (
  pname      varchar(25) not null,
  pno        integer,
  plocation  varchar(15),
  dno        integer not null,
  primary key (pno),
  unique (pname)
);



CREATE TABLE dept_locations (
  dno       integer,
  dlocation varchar(15), 
  primary key (dno,dlocation)
);


CREATE TABLE dependent (
  essn           char(9),
  depname varchar(15),
  gender            char,
  bdate          date,
  relationship   varchar(8),
  primary key (essn,depname)
);



CREATE TABLE works_on (
  ssn   char(9),
  pno    integer,
  hours  decimal(4,1),
  primary key (ssn,pno)
);



/* Part-2: Add Foreign Keys */
/* Execute these commands after you load the tables with initil data */

ALTER TABLE employee ADD CONSTRAINT fke FOREIGN KEY(dno) REFERENCES department(dno);	
ALTER TABLE employee ADD CONSTRAINT fkessn FOREIGN KEY(superssn) REFERENCES employee(ssn);
ALTER TABLE project ADD CONSTRAINT fkpno FOREIGN KEY(dno) REFERENCES department(dno);	
ALTER TABLE dept_locations ADD CONSTRAINT fkdeptpk FOREIGN KEY(dno) REFERENCES department(dno);	
ALTER TABLE dependent ADD CONSTRAINT fkdepefk FOREIGN KEY(essn) REFERENCES employee(ssn);	
ALTER TABLE works_on ADD CONSTRAINT fkwonem FOREIGN KEY(ssn) REFERENCES employee(ssn);	
ALTER TABLE works_on ADD CONSTRAINT fkwonpr FOREIGN KEY(pno) REFERENCES project(pno);




/* In case you need to start-over */

drop table employee;
drop table dependent;
drop table project;
drop table works_on;
drop table dept_locations;
drop table department;





