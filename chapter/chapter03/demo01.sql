CREATE SCHEMA TEST AUTHORIZATION ZHANG

    CREATE TABLE TAB1
    (
        COL1 SMALLINT,
        COL2 INT,
        COL3 CHAR(20),
        COL4 NUMERIC(10, 3),
        COL5 DECIMAL(5, 2)
    );
insert into Course
values ('2', '数学', null, 2)

-- 数据库系统概论: 第三章 习题

use spj;

/*
    建表
*/

create table Supplier
(
    SNO    varchar(5) primary key, /*供应商代码*/
    SNAME  varchar(10), /*姓名*/
    STATUS tinyint, /*状态*/
    SCITY  varchar(8) /*所在城市*/
);

create table Part
(
    PNO    varchar(5) primary key, /*零件代码*/
    PNAME  varchar(10), /*零件名*/
    COLOR  char(2), /*颜色*/
    WEIGHT tinyint /*重量*/
);

create table Project
(
    JNO   varchar(5) primary key, /*工程项目代码*/
    JNAME varchar(10), /*项目名*/
    JCITY varchar(8), /*项目所在城市*/
);

create table SPJ
(
    SNO varchar(5) not null, /*供应商*/
    PNO varchar(5) not null, /*零件*/
    JNO varchar(5) not null, /*工程项目*/
    QIY tinyint, /*供应量*/
    primary key (SNO, PNO, QIY),
    foreign key (SNO) references Supplier (SNO),
    foreign key (PNO) references Part (PNO),
    foreign key (JNO) references Project (JNO)
);

-- 有问题的 SQL 建表语句
create table SPJ
(
    SNO varchar(5), /*供应商*/
    PNO varchar(5), /*零件*/
    JNO varchar(5), /*工程项目*/
    QIY tinyint, /*供应量*/
    primary key (SNO, PNO, QIY),
    foreign key (SNO) references Supplier (SNO),
    foreign key (PNO) references Part (PNO),
    foreign key (JNO) references Project (JNO)
);

alter table SPJ
    alter column QIY smallint;

-- 对象'PK__SPJ__038322F60AD2A005' 依赖于 列'QIY'

alter table SPJ
    drop constraint PK__SPJ__038322F60AD2A005;

alter table SPJ
    add primary key (SNO, PNO, JNO);

-- 无法在表 'SPJ' 中可为 Null 的列上定义 PRIMARY KEY 约束

alter table SPJ
    alter column SNO varchar(5) not null;
alter table SPJ
    alter column PNO varchar(5) not null;
alter table SPJ
    alter column JNO varchar(5) not null;

-- 添加 check 约束
alter table SPJ
    add constraint ch_spj check (QIY > 10);

-- 删除 check 约束
alter table SPJ
    drop constraint ch_spj;


-- 改正之后的建表语句


/*
    插入数据
*/

insert into Supplier
values ('S1', '精益', 20, '天津'),
       ('S2', '盛锡', 10, '北京'),
       ('S3', '东方红', 30, '北京'),
       ('S4', '丰泰盛', 20, '天津'),
       ('S5', '为民', 30, '上海');

insert into Part
values ('P1', '螺母', '红', 12),
       ('P2', '螺栓', '绿', 17),
       ('P3', '螺丝刀', '蓝', 14),
       ('P4', '螺丝刀', '红', 14),
       ('P5', '凸轮', '蓝', 40),
       ('P6', '齿轮', '红', 30);

insert into Project
values ('J1', '三建', '北京'),
       ('J2', '一汽', '长春'),
       ('J3', '弹簧厂', '天津'),
       ('J4', '造船厂', '天津'),
       ('J5', '机车厂', '唐山'),
       ('J6', '无线电厂', '常州'),
       ('J7', '半导体厂', '南京');

insert into SPJ
values ('S1', 'P1', 'J1', 200),
       ('S1', 'P1', 'J3', 100),
       ('S1', 'P1', 'J4', 700),
       ('S1', 'P2', 'J2', 100),
       ('S2', 'P3', 'J1', 400),
       ('S2', 'P3', 'J2', 200),
       ('S2', 'P3', 'J4', 500),
       ('S2', 'P3', 'J5', 400),
       ('S2', 'P5', 'J1', 400),
       ('S2', 'P5', 'J2', 100),
       ('S3', 'P1', 'J1', 200),
       ('S3', 'P3', 'J1', 200),
       ('S4', 'P5', 'J1', 100),
       ('S4', 'P6', 'J3', 300),
       ('S4', 'P6', 'J4', 200),
       ('S5', 'P2', 'J4', 100),
       ('S5', 'P3', 'J1', 200),
       ('S5', 'P6', 'J2', 200),
       ('S5', 'P6', 'J4', 500);


/*
    查询
*/

-- 1.找出所有供应商的姓名和所在的城市
select SNAME, SCITY
from Supplier;

-- 2.找出所有零件的名称、颜色、重量
select PNAME, COLOR, WEIGHT
from Part;

-- 3.找出使用供应商 S1 所提供零件的工程号码
select p.JNO
from Project p
         join SPJ S on p.JNO = S.JNO
where SNO = 'S1';

-- 4.找出工程 J2 使用的各种零件的名称及其数量
select PNAME, QIY
from Part P
         join SPJ S on P.PNO = S.PNO
where JNO = 'J2';

-- 5.找出上海厂商提供的所有零件号码
select P.PNO
from Part P
         join SPJ S on P.PNO = S.PNO
         join Supplier S2 on S.SNO = S2.SNO
where SCITY = '上海';

-- 6.找出使用上海零件的工程名称
select JNAME
from Project P
         join SPJ S on P.JNO = S.JNO
         join Supplier S2 on S.SNO = S2.SNO
where SCITY = '上海';

-- 7.找出没有使用天津产的零件的工程号码
select JNO
from SPJ
where JNO not in (select distinct P.JNO
                  from Project P
                           join SPJ S on P.JNO = S.JNO
                           join Supplier S2 on S.SNO = S2.SNO
                  where SCITY = '天津');

-- 8.把全部的红色零件的颜色改为蓝色
update Part
set COLOR = '蓝'
where COLOR = '红';

-- 9.由S5供给J4的零件P6改为由S3供应

update SPJ
set SNO = 'S3'
where SNO = 'S5'
  and JNO = 'J4'
  and PNO = 'P6';

-- 10.从供应商关系中删除供应商号是S2的记录，并从供应情况关系中删除相应的记录

delete
from Supplier
where SNO = 'S2';

delete
from SPJ
where SNO = 'S2';

-- 11.请将(S2，J6，P4，200)插入供应情况关系

insert into SPJ (SNO, PNO, JNO, QIY)
values ('S2', 'J6', 'P4', 200);

/*
    创建视图
*/
create view VSP
as
select SNO, PNO, QIY
from Project J
         join SPJ S on J.JNO = S.JNO
where J.JNAME = '三建';

-- 1.找出三建工程项目使用的各种零件代码及其数量
select PNO, sum(QIY) as num
from VSP
group by PNO;

-- 2.找出供应商S1的供应情况
select *
from VSP
where SNO = 'S1';

/*
-- 1.用户王明对两个表有SELECT权力。
GRANT SELECT ON TABLE 职工,部门 TO 王明;
-- 2.用户李勇对两个表有INSERT和DELETE权力。
GRANT INSERT, DELETE ON TABLE 职工,部门 TO 李勇;
-- 3.每个职工只对自己的记录有SELECT权力。
GRANT SELECT ON TABLE 职工 WHERE USER() = NAME TO ALL;
-- 4.用户刘星对职工表有SELECT权力，对工资字段具有更新权力。
GRANT SELECT, UPDATE(工资) ON TABLE 职工 TO 刘星;
-- 5.用户张新具有修改这两个表的结构的权力。
GRANT ALTER TABLE ON TABLE 职工,部门 TO 张新;
-- 6.用户周平具有对两个表所有权力（读，插，改，删数据），并具有给其他用户授权的权力。
GRANT ALL PRIVILEGES ON TABLE 职工, 部门 TO 周平 WITH GRANT OPTION ;
-- 7.用户杨兰具有从每个部门职工中SELECT最高工资、最低工资、平均工资的权力，他不能查看每个人的工资。
CREATE VIEW 部门工资
AS
SELECT MAX(工资), MIN(工资), AVG(工资)
FROM 职工
JOIN 部门 USING(部门号)
GROUP BY 职工, 部门号;

GRANT SELECT ON VIEW 部门工资 TO 杨兰;
*/

/*
    完整性约束条件
*/

CREATE TABLE DEPT
(
    Deptno      NUMBER(2),
    Deptname    VARCHAR(10),
    Manager     VARCHAR(10),
    PhoneNumber Char(12),
    CONSTRAINT PK_SC PRIMARY KEY (Deptno)
);

CREATE TABLE EMP
(
    Empno  NUMBER(4),
    Ename  VARCHAR(10),
    Age    NUMBER(2),
    Job    VARCHAR(9),
    Sal    NUMBER(7, 2),
    Deptno NUMBER(2),
    CONSTRAINT C1 CHECK ( Age <= 60),
    CONSTRAINT FK_DEPTNO FOREIGN KEY (Deptno) REFERENCES DEPT (Deptno)
);

