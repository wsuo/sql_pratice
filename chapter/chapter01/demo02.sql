create proc pr_selectV1 as
select *
from v1;


    execute pr_selectV1;

    exec [dbo].[pr_selectV1]

    -- 但是这样的存储过程几乎不用,因为不能改变参数,还不如直接使用视图 view
-- 我们接下来要加参数

    create proc pr_selectV11 @num decimal,
                             @num2 char(10)
    as
    select *
    from v1
    where avg_grade > @num
      and class like '%' + @num2 + '%';

        create procedure selectStudentSource @grade numeric,
                                             @source varchar(30)
        as
        select *
        from Students
        where mgrade > @grade
          and bplace = @source;


            execute selectStudentSource @grade = 200, @source = '温州'
            create procedure selectPrice @pubCompany varchar(20),
                                         @price money output
            as
            select @price = avg(mgrade)
            from Students;

            declare @ee money;

                execute selectStudentSource @ee output;

            select @ee as price;




