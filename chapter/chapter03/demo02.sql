

SELECT Sno, Sname
FROM Student;

SELECT Sname, Sno, Sdept
FROM Student;

SELECT *
FROM Student;

SELECT Sname, 2020 - Sage /*假设现在为2020年*/
FROM Student;

SELECT Sname, 'Year of Birth: ', 2020 - Sage, LOWER(Sdept)
FROM Student;

SELECT Sname NAME, 'Year of Birth:' BIRTH, 2014 - Sage BIRTHDAY, LOWER(Sdept) DEPARTMENT
FROM Student;

SELECT ALL Sno
FROM SC;

SELECT DISTINCT Sno
FROM SC;

SELECT Sname
FROM Student
WHERE Sdept = 'CS';

SELECT Sname, Sage
FROM Student
WHERE Sage < 20;

SELECT DISTINCT Sno
FROM SC
WHERE Grade < 60;

SELECT Sname, Sdept, Sage
FROM Student
WHERE Sage BETWEEN 20 AND 23;

SELECT Sname, Sdept, Sage
FROM Student
WHERE Sage NOT BETWEEN 20 AND 23;

SELECT Sname, Ssex
FROM Student
WHERE Sdept in ('CS', 'MA', 'IS');

SELECT Sname, Ssex
FROM Student
WHERE Sdept not in ('CS', 'MA', 'IS');

SELECT *
FROM Student
WHERE Sno LIKE '201215121';

SELECT *
FROM Student
WHERE Sno = '201215121';

SELECT Sname, Sno, Ssex
FROM Student
WHERE Sname LIKE '刘%';

SELECT Sname, Sno, Ssex
FROM Student
WHERE Sname NOT LIKE '刘%';

SELECT *
FROM Course
WHERE Cname LIKE 'DB\_%i_ _' ESCAPE '\ ';

SELECT Sno, Cno
FROM SC
WHERE Grade IS NULL;

SELECT Sno, Cno
FROM SC
WHERE Grade IS NOT NULL;

SELECT Sname
FROM Student
WHERE Sdept = 'CS'
  AND Sage < 20;

SELECT   Sname, Ssex
FROM     Student
WHERE    Sdept IN ('CS ','MA ','IS');

SELECT Sname, Ssex
FROM Student
WHERE Sdept = 'CS'
   OR Sdept = 'MA'
   OR Sdept = 'IS';

SELECT   Sno, Grade
FROM     SC
WHERE    Cno= '3'
ORDER BY Grade DESC;

SELECT *
FROM Student
ORDER BY Sdept, Sage DESC;

SELECT COUNT(*)
FROM   Student;

SELECT COUNT(DISTINCT Sno)
FROM   SC;

SELECT SUM(Ccredit)
FROM SC,
     Course
WHERE Sno = '201215121'
  AND SC.Cno = Course.Cno;

SELECT Cno,COUNT(Sno)
FROM SC
GROUP BY Cno;

SELECT Sno
FROM SC
GROUP BY Sno
HAVING COUNT(*) > 2;