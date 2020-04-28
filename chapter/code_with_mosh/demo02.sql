/*
    一定要自己动手去敲!!!

    这里介绍数据的增删改查, 即 CRUD
*/

use sql_store;

# 首先展示一次添加一条记录
# 按照顺序添加值,数据库中有默认值的可以写 default 或者 null
# 类型要对应, 在 MySQL 中, 日期的格式为 2000-08-21
insert into customers
values (default,
        'Shuo',
        'Wang',
        '2000-08-21',
        null,
        'address',
        'city',
        'CA',
        default);

# 也可以这样写, 括号后面写列名,然后一一对应
insert into customers (first_name,
                       last_name,
                       birth_date,
                       address,
                       city,
                       state)
VALUES ('Shuo',
        'Wang',
        '2000-08-22',
        'address',
        'city',
        'CA');

# 查询出来看一下
select *
from customers;

# 一次插入多条数据
insert into shippers (name)
values ('Shipper1'),
       ('Shipper2'),
       ('Shipper3');

select *
from shippers;

# 向多张表中插入数据
insert into orders (customer_id, order_date, status)
values (1, '2000-09-09', 1);

# MySQL 的内建函数,获取最后一个插入的 id 值
select last_insert_id();

insert into order_items (order_id, product_id, quantity, unit_price)
values (last_insert_id(), 2, 1, 3.66),
       (last_insert_id(), 1, 2, 4.88);

select *
from orders;

# 复制一张表中的数据到另一张表
# 这种方法只会转移数据,相关的属性不会转移
create table order_archived as
select *
from orders;

# 如果我们只想转移特定的数据到存档表中呢? 比如只想复制 2019 年之前的订单?
insert into order_archived # 或者使用 create 建表语句也可以
select *
from orders
where order_date < '2019-01-01';

use sql_invoicing;

select *
from invoices;

# 将client_id用 客户的名字替换, 同时只要有支付日期的数据
# 思路: 无论如何,要先将数据查询出来
create table invoices_archived
select i.invoice_id,
       number,
       c.name as client,
       invoice_total,
       payment_total,
       invoice_date,
       due_date,
       payment_date
from invoices i
         join clients c on i.client_id = c.client_id
    and i.payment_date IS NOT NULL;

# 使用 update 更新一条或多条记录
update invoices
set payment_date  = default,
    payment_total = 0
where invoice_id = 1;

# 这里会有一个问题就是计算完成之后小数点没了
update invoices
set payment_total = invoice_total * 0.5,
    payment_date  = due_date
where invoice_id = 3;

use sql_store;

# 将出生于 1990 年之前的人 积分多加 50
update customers c
set c.points = c.points + 50
where c.birth_date < '1990-01-01';

use sql_invoicing;

# update 使用子查询
update invoices i
set payment_total = i.invoice_total * 0.5,
    payment_date  = due_date
where client_id = (
    select c.client_id
    from clients c
    where c.state in ('CA', 'NY')
);

use sql_store;

# 更新订单表,如果用户的积分大于3000,
update orders o
set o.comments = 'Gold Customer'
where o.customer_id in (
    select c.customer_id
    from customers c
    where c.points >= 3000);


use sql_invoicing;

# 删除数据
# 删除所有数据
delete from invoices;

# 使用 where 子句删除指定数据
delete from invoices
where invoice_id = 1;

# 同样的, where 子句中可以使用 select 语句来指定多条数据




