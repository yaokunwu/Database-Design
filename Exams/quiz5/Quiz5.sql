/* Quiz5 */

/* Question-1:  */ 

create TRIGGER Check_Employee_Salary
FOR INSERT OR UPDATE OF Salary ON Employee
COMPOUND TRIGGER
  TYPE Salaries_t             IS TABLE OF Employee.Salary%TYPE;
  Mgr_Salaries                Salaries_t;
  TYPE Department_IDs_t       IS TABLE OF Employee.DNo%TYPE;
  Department_IDs              Department_IDs_t;

  TYPE Department_Salaries_t  IS TABLE OF Employee.Salary%TYPE
                                INDEX BY VARCHAR2(80);
  Department_Mgr_Salaries     Department_Salaries_t;

  BEFORE STATEMENT IS
  BEGIN
    SELECT               Salary, NVL(e.Dno, -1)
      BULK COLLECT INTO  Mgr_Salaries, Department_IDs
      FROM               Employee e, Department d
      WHERE              e.SSN = d.MgrSSN;
    FOR j IN 1..Department_IDs.COUNT() LOOP
      Department_Mgr_Salaries(Department_IDs(j)) := Mgr_Salaries(j);
    END LOOP;
  END BEFORE STATEMENT;

  AFTER EACH ROW IS
  BEGIN
    IF :NEW.Salary >
      Department_Mgr_Salaries(:NEW.Dno)
    THEN
      Raise_Application_Error(-20000, 'Higher than manager');
    END IF;
  END AFTER EACH ROW;
END Check_Employee_Salary;


/* Question-2:  */ 

CREATE TABLE OVERDUE (
    Book_title varchar(50),
    Borrower_name varchar(50),
    Borrower_phone char(10),
    due_date date
);

create PROCEDURE find_Overdue(branch_id IN LIBRARY_BRANCH.Branch_id%TYPE) AS 

thisRecord OVERDUE%ROWTYPE;

CURSOR OverdueRecord IS
SELECT K.Title, P.Name, P.Phone, B.Due_date FROM BOOK_LOANS B, LIBRARY_BRANCH L, BORROWER P, BOOK K
WHERE B.Branch_id=L.Branch_id AND L.Branch_id = branch_id AND B.Card_no = P.Card_no And B.Book_id = K.Book_id And B.Due_date < CURDATE() And B.Return_date is null;

BEGIN
OPEN OverdueRecord;
LOOP
  FETCH OverdueRecord INTO thisRecord;
  EXIT WHEN (OverdueRecord%NOTFOUND);

  INSERT INTO OVERDUE VALUES (thisRecord.Title, thisRecord.Name, thisRecord.Phone, thisRecord.Due_date);
END LOOP;
CLOSE OverdueRecord;
END;
