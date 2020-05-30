/*
    数据库改错练习
*/


-- 1.定义视图V_S_AVG，该视图包含学生的学号和选课数量
create view V_S_AVG
as
select sno, COUNT(cno)
from sc
group by sno

-- 错误: 使用和聚合函数,要指定列名;
-- 改正 1:
create view V_S_AVG(sno, count)
as
select sno, COUNT(cno)
from sc
group by sno;

-- 改正 2:
create view V_S_AVG
as
select sno, COUNT(cno) as count
from sc
group by sno;

-- 2.删除000001课的选修情况
delete *
from SC
where cno = '000001'

-- 不要加 *

-- 3.按课程号统计各门课程的平均分
select cno, AVG(grade)
from SC
group by sno

-- 改正:
select cno, AVG(grade)
from SC
group by cno

-- 4.插入学生('1301101','刘备')
insert into students
values ('1301101', '刘备')

-- 改正:
insert into students(sno, sname)
values ('1301101', '刘备')

-- 5.查询学生的学号、姓名和选课数量（包括选课为0的学生）
select students.sno, students.sname, COUNT(cno)
from SC,
     Students
where sc.sno = students.sno
group by students.sno, students.sname;

/*
    题目中说包括选课为 0 的学生,就想到外连接
*/
-- 改正:
select Students.sno, Students.sname, count(cno)
from Students
         left join SC S on Students.sno = S.sno
group by Students.sno, Students.sname;

-- 6.查询比“03物流1”所有学生入学成绩高的其他班学生的信息
select *
from students
where grade > (select grade from students where class = '03物流');

-- 改正:
/*
    1.属性值写错了,应该是 mgrade
    2.class写错了,应该是'03物流1'
    3.子查询返回的值不止一个
*/
-- 解决办法 1
select *
from Students
where mgrade > all (
    select mgrade
    from Students
    where class = '03物流1'
);
-- 解决办法 2
select *
from Students
where mgrade > (
    select max(mgrade)
    from Students
    where class = '03物流1'
);

-- 7.按姓名逆序查询“03物流1”班的学生信息
select *
from students
order by sname where class='03物流1'

/*
    1. where 子句不能放在 order by 后面
    2. order by 默认是 asc 逆序是 desc
*/
select *
from Students
where class = '03物流1'
order by sname desc;

-- 8.查询入学平均分高于80的班级信息
select class
from students
where AVG(mgrade) > 80

/*
    1.where 子句不能使用 聚合函数 应该放在 having 中
    2.班级有多个, 使用 group by 分组
*/
-- 改正:
select class
from Students
group by class
having avg(mgrade) > 80;

-- 9.查询工龄最长的10位教师的信息
select
top 10
from teachers;

/*
    1.top 10 后面应该跟上列名,表示要查询什么信息,这里是 * ,代表所有信息
    2.没有排序条件,这里要的是 工龄最长的,所以应该按照工龄排序
*/
select
top 10
*
from Teachers
order by wday;

-- 10. 统计教师中所有“副教授”的人数
select ps, COUNT('副教授')
from teachers;

/*
    1.count 函数中只能用列名或者*
    2.没有分组,应该按照 ps 进行分组
    3.没加条件,应该过滤一下只要ps是副教授的信息
*/
-- 改正:
select ps, count(ps)
from Teachers
where ps = '副教授'
group by ps;

-- 11. 查询学生选修课程的信息（学生学号，学生姓名，课程号，课程名）
select sno, sname, cno, cname
from Students,
     course;

/*
    1.这里相当于交叉连接,查询结果是笛卡尔积,肯定不对
    2.应该使用中间表 SC
*/

select Students.sno, sname, C.cno, cname
from Students
         join SC S on Students.sno = S.sno
         join Course C on S.cno = C.cno;

-- 12.查询选修了“信息系统分析与设计”的学生学号
select sno
from SC
where cno = (select cno from Course where cname = '信息系统分析与设计')

-- 子查询的查询结果可能不止一个,应该使用 in 关键字
-- 查询结果是对的,但是没必要写成嵌套查询,另一种实现方式更好,使用等值连接

select sno
from SC
         join Course C on SC.cno = C.cno
where cname = '信息系统分析与设计';

-- 13.查询不重复学生班级的名称
select distant class
from Students;

/*
    1.distant 应该是 distinct 代表不重复
*/

-- 改正:
select distinct class
from Students;

-- 14.修改学号为“0311101”的同学的课程号“0000027”的成绩为80，绩点为1.0
update SC
set grade=80 and point = 1.0
where sno = '0311101'
  and cno = 0000027

/*
    1. set 后面不能用 and
*/

-- 改正:

update SC
set grade=80,
    point=1.0
where sno = '0311101'
  and cno = 0000027

-- 15.修改“03计算应用1”班的平均成绩为80
update sc
set avg(grade)=80
where class = '03计算应用'

-- 无法实现
-- 错误: 不能修改聚合函数的值,平均分不能修改,只能修改已有的属性

-- 16.创建表tblTest(id 主键 自动增长 主键, name 字符串 非空）
create table tblTest
(
    id   char(10) identity (1,1) primary key not null,
    name varchar(50)
)

/*
    1.identity (1,1) 表示自增, 从1开始,每次+1, 所以可以省略
        identity 标识代表它必须是基本的整数类型 int、bigint、smallint、tinyint、decimal 或者 小数位是 0 的 numeric
        并且约束是 not null
    2.name 没有加列级完整性约束条件: not null
*/
create table tblTest
(
    id   int identity primary key not null,
    name varchar(50)              not null
)

-- 17.删除表tblTest（假设已存在）
drop tblTest;

-- 增加 table 关键字
drop table tblTest;

-- 18.新建班级为“03物流1”的学生视图v_wl3
create view v_vl3
select *
from students
where class = '03物流1'

-- 错误: 少了一个 as 关键字
create view v_vl3 as
select *
from students
where class = '03物流1'

-- 19. 查询所有教师教学的课程数
select count(*)
from tc;

/*
    1.这个查询查的是所有的数据的条数
    2.应该根据老师分组,分别查每个老师教几门课,使用聚合函数
    3.有的 tno 为 null, 所以应该加一个条件就是不为 null
*/

select tno, count(cno) as class_num
from TC
where tno IS NOT NULL
group by tno;

-- 20. 查询信息工程学院职称为讲师和助教的教师信息
select *
from teachers
where ps = '讲师'
  and ps = '助教'
  and dept = '信息工程学院'

/*
    1.条件错误, ps 应该是或的关系,用 or 或者 in
    2.加括号
*/
-- 改正 1:
select *
from Teachers
where (ps = '讲师'
    or ps = '助教')
  and dept = '信息工程学院';

-- 改正 2:
select *
from Teachers
where ps in ('讲师', '助教')
  and dept = '信息工程学院';


-- 21.查询既选修了“数据库原理”又选修了“数据结构”的学生的学号和姓名。
select sno, sname
from sc
where cno in (select cno from Course where cname = '数据库原理' or '数据结构');

-- 错误:
/*
    查不出来,原因:
    1.涉及到多表使用外连接,join
    2.where子句中的条件必须使用布尔类型的条件
    3.要求的是同时选修,应该是 and 而不是 or
*/

-- 改正:
-- 思路一: 
/*
    1.先选出来所有选修这两门课程中任意一门课程的学生
    2.再在这里面选看一下谁选课的数量 > 2
*/
select S.sno, sname
from Students
         join SC S on Students.sno = S.sno
         join Course C on S.cno = C.cno
where cname in ('数据库原理', '数据结构')
group by S.sno, sname
having count(cname) = 2;

-- 思路二:
/*
    1.分别查出来选修这两门的学生
    2.再查看谁同时属于这两个集合
*/
select sno, sname
from Students
where sno in (
    select sno
    from Course C
             join SC S on C.cno = S.cno
    where cname = '数据库原理'
)
  and sno in (
    select sno
    from Course C
             join SC S on C.cno = S.cno
    where cname = '数据结构'
);

-- 22.查询选修课人数在5人以上的课程，显示课程号、人数，按人数升序排列。
select cno, COUNT(sno)
from SC
group by cno where COUNT(cno)>5
order by COUNT (cno) desc

/*
    语法错误
    1.where 子句中不能使用聚合函数
    2.COUNT(sno)要统一: 计算学生人数,但是这里也可以,因为是一对一
    3.desc是降序,不写或者写asc是升序;
*/

select cno, COUNT(sno)
from SC
group by cno
having COUNT(sno) > 5
order by COUNT(sno);

/*select C.cno, count(sno) as num
from SC
         join Course C on SC.cno = C.cno
group by C.cno
having count(sno) > 5
order by num;*/

-- 23.查询选修了课程的学生选修的门数，显示学号、姓名、选课门数
select sno, sname, COUNT(sno)
from Students
         join SC on Students.sno = SC.sno
group by sno

/*
    1.选课门数应该是 count(cno)
    2.select 后面的字段必须是 group by 语句中出现的字段或者聚合函数, 所以应该是 group by SC.sno, sname;
    3.有两处 sno,需要起别名或者使用 表名.属性名的 方式区分
*/

select SC.sno, sname, COUNT(cno)
from Students
         join SC on Students.sno = SC.sno
group by SC.sno, sname;

-- 24.查询所有同学的选修课的门数，包括选修了课程和还未选修课程的同学。
select sno, COUNT(*)
from Students
         left join SC on Students.sno = SC.sno
group by sno

/*
    1.sno 没有指定是哪一个表中的,应该按照 Student.sno 分组,如果是按照 Sc 的那么只会有已经选课的同学的数据
    2.count(*) 写错了,应该是 count(cno) 因为统计的是选课的门数; count(*)会把那个空行也查出来
*/
select Students.sno, count(cno)
from Students
         left join SC S on Students.sno = S.sno
group by Students.sno;

-- 25.查询03物流1班同学的选修课情况，显示学号和课程号。
select sno, cno
from sc
where sno = (select sno from Students where class = '03物流1')

/*
    1.子查询的返回结果不止一个,应该使用 in
*/

select sno, cno
from sc
where sno in (
    select sno
    from Students
    where class = '03物流1'
);

-- 26.查询教师上课的情况，显示教师名和课程名
select tname, cname
from Teachers
         join Course on tno = cno;

/*
    查不出来
    1.因为 tno 和 cno 不是一一对应关系,
        应该先用 Teacher 连接 TC 表 然后再连接 Course
*/

select tname, cname
from Teachers
         join TC T on Teachers.tno = T.tno
         join Course C on T.cno = C.cno;

-- 27.查询所有课程被选修的情况，包括被选修了课程和还未被选修课程，显示课程名和人数。
select cname, COUNT(sno)
from SC
         left join Course on SC.cno = Course.cno
group by cname

/*
    1.左外连接的关系反了,改成 right join 或者 调换表的位置\
        他这样会把所有选修了的课程查出来
    2.我的写法是: 不管这门课有没有被选都会查出来
*/
select cname, COUNT(sno)
from SC
         right join Course on SC.cno = Course.cno
group by cname;

-- 28.创建视图v1，显示班级和每个班级同学的入学平均分。
create view v1
as
select class, avg(mgrade)
from Students

/*
    语法错误
    1.使用了聚合函数作为列,起别名或者在 视图名后面用括号指定
    2.没有按照班级分组
*/

create view v1
as
select class, avg(mgrade) as avg_grade
from Students
group by class;

-- 29.查询课程名中有“计算机”的课程的任课老师，显示课程名，教师名。
select cname, tname
from course
         join Teachers on Course.cno = Teachers.tno
where tname = '计算机'

/*
    查不出来:
    1.课程名中有,说明是模糊查询,应该使用 like _占一个字符,%代表多个字符
    2.tname是教师的名字,应该使用课程名字
    3.这两个表之间没有联系, cno 与 tno 不是对应的关系,应该在中间 join 一个 TC 表
    4.查询结果有可能又重复的 使用 distinct 去重
*/

select distinct cname, tname
from Teachers
         join TC T on Teachers.tno = T.tno
         join Course C on T.cno = C.cno
where cname like '%计算机%';

-- 30.查询工资高于信息工程学院最高工资的老师的所有信息。
select *
from Teachers
having pay > (
    select MAX(pay)
    from Teachers
    where dept = '信息工程学院'
);

/*
    语法错误:
    1.having 中的子句字段必须包含在 group by 中或者是聚合函数
    2.应该使用 where ,having是在查出结果之前进行过滤,where 是查出结果之后
*/
select *
from Teachers
where pay > (
    select max(pay)
    from Teachers
    where dept = '信息工程学院'
);

-- 31.查询选修课程最多的同学的学号和姓名。
select
top 1
sno
,
sname
from Students
         join SC on Students.sno = SC.sno
order by sno desc

/*
    语句错误:
    1.sno未指定是哪一个
    2.应该按照学号和姓名分组,然后对选的课程进行计数
    3.排序条件应该是 count(cno),而不是学号
*/

select
top 1
Students.sno
,
sname
from Students
         join SC on Students.sno = SC.sno
group by Students.sno, sname
order by count(cno) desc

-- 32.查询没有被选修过的课程的课程号和课程名。
select cno, cname
from Course
         join sc on Course.cno = sc.cno
where Course.cno = Null

/*
    1.没有指定是哪一个表中的cno
    2.join只会查出来有记录的,也就是查出来的肯定是被选修过得,应该使用 left join
    3. = null 应该写成 is null
*/

select Course.cno, cname
from Course
         left join SC S on Course.cno = S.cno
where sno IS NULL;

-- 33.向students表中插入一条记录(“1413121”,“李易峰”，“14软工1”，“男”)
insert into Students
values ('1413121', '李易峰', '14软工', '男')

/*
    语法错误
    1.在表名后面价格括号指定要插入的列名,或者将表中的其余信息也写上
*/

-- 34.查询刘涛选修的课程的名字。
select cname
from Course
where cno = (select sno from Students where cname = '刘涛')

/*
    语法错误
    1.因为在 Students 表中没有 cname 这个字段
    2.字段不匹配, 子查询查出来的是学号,而where中要的是课程号,两个没有比较的意义
    3.而且就算查出来了返回结果不止一个也不能用 = 号,应该用 in
    4.应该join一张SC表,因为 SC 只能知道选没选, Course 可以知道课程名称
*/
-- 解法一:
select cname
from Course
         join SC S on Course.cno = S.cno
where sno in (select sno from Students where sname = '刘涛')

-- 解法二:
select cname
from Course
         join SC S on Course.cno = S.cno
         join Students S2 on S.sno = S2.sno
where sname = '刘涛'

-- 35.定义视图v2 ，显示生源地为宁波的所有学生的学号、姓名、年龄
create view v2
as
select sno, sname, YEAR(bday) - YEAR(GETDATE())
from Students
where bplace = 宁波

/*
    语法错误
    1.宁波要加引号
    2.年龄计算错误,写反了,这样的结果是负数
    3.第三列年龄是表中没有的字段,要起别名或者在视图后指定列名
*/
create view v2
as
select sno, sname, YEAR(GETDATE()) - YEAR(bday) as age
from Students
where bplace = '宁波'


-- 36. 删除姚明老师的上课记录。
delete
from TC
where tno = (
    select tno
    from Course
    where tname = '姚明'
);

/*
    1.Course表中没有 tname,应该从 Teachers 表中查
*/
delete
from TC
where tno = (
    select tno
    from Teachers
    where tname = '姚明'
);

-- 37.定义视图v3,显示所有学生的信息及选课信息，一列学号显示所有学生的学号，一列学号显示的是选了课的学生的学号。
create view V3
as
select students.*, sc.*
from students
         left join sc on Students.sno = SC.sno

/*
    列名重复问题
    使用 as 起别名
*/
create view V3
as
select students.*, sc.sno as SC_sno, sc.cno, sc.term, grade, point
from students
         left join sc on Students.sno = SC.sno

-- 38.查询上课班级多于1个的教师，显示教师名、上课班级数，结果按上课班级数降序排列。
select tname, COUNT(class)
from Teachers
         join TC on Teachers.tno = TC.tno
order by COUNT(class) desc group by tno
having COUNT (class)>1


/*
    语法错误
    1.order by 应该放在最后
    2.tno不明确,两张表中都有
*/

select tname, COUNT(class)
from Teachers
         join TC on Teachers.tno = TC.tno
group by tc.tno, tname
having COUNT(class) > 1
order by COUNT(class) desc;

-- 39.查询赵薇电子商务课程的成绩。
select grade
from Students
         join SC
         join Course
              on Students.sno = SC.sno and SC.cno = Course.cno
where sname = '赵薇'
  and cname = '电子商务';

/*
    语法错误
    1.on后面不能使用 and,只能指定一个条件
*/

select grade
from Students
         join SC
              on Students.sno = SC.sno
         join Course
              on SC.cno = Course.cno
where sname = '赵薇'
  and cname = '电子商务'

-- 40.将赵薇电子商务课程的成绩改为90分。
update from SC
set grade = 90 where sno = (select sno from students where sname = '赵薇')
  and cno = (select cno from course where cname = '电子商务')

/*
    语法错误
    1.update 直接跟表名, 不能加 from, from 应该放在 set 语句的后面
    2.子查询返回的值不止一个,应该使用 in
*/

-- 改正1:
update SC
set grade = 90
where sno = (select sno from students where sname = '赵薇')
  and cno in (select cno from course where cname = '电子商务')

-- 改正2:
update sc
set grade = 90
from Students
         join SC S on Students.sno = S.sno
         join Course C on S.cno = C.cno
where sname = '赵薇'
  and cname = '电子商务';

