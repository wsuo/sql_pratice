/*

    SQL 的事务
    - 原子性: 像原子一样不可分割
    - 一致性:
    - 隔离性:
    - 持久性:

    文章链接: https://blog.csdn.net/weixin_43941364/article/details/106068139

*/

use sql_store;

-- 开启一个事务
start transaction;

insert into orders(customer_id, order_date, status)
values (1, '2020-05-10', 1);

insert into order_items
values (last_insert_id(), 1, 1, 1);

-- 提交就代表结束事务了
commit;

rollback;
-- 回滚事务

# 每一个 SQL 语句都被设置成自动提交
show variables like 'autocommit';

# 过个用户同时修改同一个数据称为并发, MYSQL 会自动锁定 update 的内容

# 事务带来的常见的问题
/*
    - 1.丢失更新: 两个事物同时修改数据,
    - 2.脏读(无效数据读取): 读取到未提交的数据
        A事务读取还没有提交时-另一个事务B却将A的还没有提交的数据当成了真实存在的,如果A最后提交了还好,如果A回滚了,那么B中的数据就是假的;
        即读取了还未提交的数据,数据是脏的;
        -- 为了解决这个问题,我们可以提供一定的隔离度,即事务修改的数据不会立即被其他事物看到,除非他已经提交了
        -- 标准的 SQL 定义了四个隔离级别 - 针对脏读的就是 提交读 (Read Committed) 只能读取已经提交的数据
    - 3.不可重复读取: 两次读取的内容可能会不同
        事务A执行子查询,在外层查询中先获取指定的值,这个时候事务B过来修改了A刚才读的数据,但是之后A的子查询再次读了这个数据
        而这个数据两次读到的值不一样了.这就是不可重复读
        -- 这个时候应该增加隔离级别: 可重复读,达到这个目的 -> 以最开始的那个数据为准,不受事务B修改的影响,隔离级别是事务的级别.
    - 4.幻读: 丢失符合条件的某些行
        在事务A中使用 where 查询,此时事务 B 修改了原来符合条件的数据,使得它现在不符合条件了.
        需要的隔离等级: 序列化 Serializable 等级,使该事务可以知道其他事物正在修改数据.
            这样他就会等待其他事务修改完之后才会执行事务,缺点就是如果并发比较多,执行会很慢

    等级越高,性能消耗越大;
    MySQL默认是可重复读的隔离等级;
*/

-- 查看隔离等级
show variables like 'transaction_isolation';

-- 设置隔离等级
set transaction isolation level SERIALIZABLE ;

-- 在当前会话中设置
set session transaction isolation level serializable ;




