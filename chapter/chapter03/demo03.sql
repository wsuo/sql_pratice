# 查询每个学生及其选修课程的情况
SELECT Student.*, SC.*
FROM Student,
     SC
WHERE Student.Sno = SC.Sno;

# 使用内连接
select *
from student
         inner join
     sc
     on student.Sno = sc.Sno;

# 查询选修2号课程且成绩在90分以上的所有学生的学号和姓名。
SELECT Student.Sno, Sname
FROM Student,
     SC
WHERE Student.Sno = SC.Sno
  AND SC.Cno = '2'
  AND SC.Grade > 90;

# 查询每一门课的间接先修课（即先修课的先修课）
select c1.Cno first, c2.Cpno second
from course c1,
     course c2
where c1.Cpno = c2.Cno;


SELECT Student.Sno, Sname, Ssex, Sage, Sdept, Cno, Grade
FROM Student
         LEFT OUTER JOIN SC
                         ON
                             (Student.Sno = SC.Sno);


select *
from student
         left join sc
                   on student.Sno = sc.Sno
where Cno = 3;

# 查询每个学生的学号、姓名、选修的课程名及成绩
SELECT Student.Sno, Sname, Cname, Grade
FROM Student,
     SC,
     Course /*多表连接*/
WHERE Student.Sno = SC.Sno
  AND SC.Cno = Course.Cno;

SELECT Sname /*外层查询/父查询*/
FROM Student
WHERE Sno IN
      (SELECT Sno /*内层查询/子查询*/
       FROM SC
       WHERE Cno = ' 2 ');

# 查询与“刘晨”在同一个系学习的学生 的3种实现方式
# 第一种
SELECT Sdept
FROM Student
WHERE Sname = '刘晨';

SELECT Sno, Sname, Sdept
FROM Student
WHERE Sdept = 'CS';

# 第二种
SELECT Sno, Sname, Sdept
FROM Student
WHERE Sdept =
      (SELECT Sdept
       FROM Student
       WHERE Sname = '刘晨');

# 第三种
SELECT S1.Sno, S1.Sname, S1.Sdept
FROM Student S1,
     Student S2
WHERE S1.Sdept = S2.Sdept
  AND S2.Sname = '刘晨';

# 查询选修了课程名为 信息系统 的学生学号和姓名
select Sno, Sname
from student
where Sno in (
    select sc.Sno
    from sc
    where Cno in (
        select course.Cno
        from course
        where Cname = '信息系统'
    )
);

# 使用连接查询实现上述功能
select student.Sno, Sname
from student,
     sc,
     course
where student.Sno = sc.Sno
  and sc.Cno = course.Cno
  and Cname = '信息系统';

SELECT *
FROM Student
WHERE Sdept = 'CS'
UNION
SELECT *
FROM Student
WHERE Sage <= 19;

SELECT Sno
FROM SC
WHERE Cno = '1'
UNION
SELECT Sno
FROM SC
WHERE Cno = '2';


# 找出每个学生超过他选修课程平均成绩的课程号
select x.Sno, x.Cno
from sc x
where x.Grade >= (
    select avg(y.Grade)
    from sc y
    where x.Sno = y.Sno
);

# 查询非计算机科学系中比计算机科学系任意一个学生年龄小的学生姓名和年龄
SELECT Sname, Sage
FROM Student
WHERE Sage < ANY (SELECT Sage
                  FROM Student
                  WHERE Sdept = 'CS')
  AND Sdept <> 'CS';

# 用聚集函数实现
SELECT Sname, Sage
FROM Student
WHERE Sage <
      (SELECT MAX(Sage)
       FROM Student
       WHERE Sdept = 'CS')
  AND Sdept <> 'CS';

# 查询非计算机科学系中比计算机科学系所有学生年龄都小的学生姓名及年龄
select student.Sname, student.Sage
from student
where Sage < all (
    select Sage
    from student
    where Sdept = 'CS'
)
  and Sdept <> 'CS';

# 使用聚合函数
select student.Sname, student.Sage
from student
where Sage < (
    select min(sage)
    from student
    where Sdept = 'CS'
)
  and Sdept <> 'CS';

# 查询所有选修了1号课程的学生姓名
select Sname
from student
where exists(
              select *
              from sc
              where sc.Sno = student.Sno
                and Cno = '1');

# 使用谓词IN实现
select Sname
from student
where Sno in (select sc.Sno
              from sc
              where Cno = '1');

# 查询没有选修1号课程的学生姓名
select Sname
from student
where not exists(
        select *
        from sc
        where Cno = '1'
          and sc.Sno = student.Sno
    );


SELECT *
FROM Student
WHERE Sdept = 'CS'
  AND Sage <= 19;

SELECT Sno
FROM SC
WHERE Cno = '1'
  and Cno = '2'
;

SELECT Sno
FROM SC
WHERE Cno = '1'
  AND Sno IN
      (SELECT Sno
       FROM SC
       WHERE Cno = '2');


