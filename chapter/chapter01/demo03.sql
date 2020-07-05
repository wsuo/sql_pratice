/*
    触发器
*/
select *
from Students;

insert into Students (sno, sname)
values ('2011102', '张三2');

create trigger del_book
    ON Students
    for delete
    as
    if ((select count(*)
         from deleted) > 1)
        begin
            print '操作不成功,一次只能删除一条记录!';
            rollback transaction;
        end

delete from Students where sno in ('2011101')