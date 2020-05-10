/*
    本节介绍复杂查询,让你精通SQL!!!
    - 子查询
    - 使用 IN 的子查询
    - 相关子查询 (我认为最难的)
*/

#  查询比莴苣贵的蔬菜
use sql_store;
select *
from products
where unit_price > (
    select p.unit_price
    from products p
    where product_id = 3
);

use sql_hr;

# 查询出来员工的工资高于平均水平的
select *
from employees e1
where salary > (
    select avg(e2.salary)
    from employees e2
);

# 从产品表中找出从来没有订单的产品
# 思路是先查询出来所有的有订单的商品,然后查出不在其中的商品
select *
from products
where product_id not in (
    select distinct order_id
    from order_items
);

# 查询没有发票的clients
use sql_invoicing;

select client_id
from clients
where client_id not in (
    select distinct client_id
    from invoices
);

use sql_store;
# 查询出顾客表中的id姓名, 条件是买了莴苣的人
select customer_id, first_name, last_name
from customers
where customer_id in (
    select customer_id
    from orders
    where order_id in (
        select order_items.order_id
        from order_items
        where product_id = 3
    )
);

select distinct customer_id, first_name, last_name
from orders
         join customers c using (customer_id)
         join order_items oi using (order_id)
where product_id = 3;

use sql_invoicing;
# 选出所有大于3号顾客的发票的发票
select *
from invoices
where invoice_total > (
    select max(invoice_total) as 3_max
    from invoices
    where client_id = 3
);

# 也可以使用 ALL 关键字, 他会比较括号里的每一个关键字
select *
from invoices
where invoice_total > all (
    select invoice_total
    from invoices
    where client_id = 3
);

# ANY 关键字, 大于任意一个就可以
-- 栗子: 查询至少有两个发票的顾客
select *
from clients
where client_id in (
    select client_id
    from invoices
    group by client_id
    having count(*) >= 2
);

-- 也可以这样写: =any 和 in 是等价的
select *
from clients
where client_id = any (
    select client_id
    from invoices
    group by client_id
    having count(*) >= 2
);

use sql_hr;

select *
from employees
;

# 相关子查询
# 查看那几个员工所在的部门的工资在平均水平之上
select *
from employees e
where salary > (
    select avg(salary)
    from employees
    where e.employee_id = employees.employee_id
);

# 找出发票金额高于用户平均发票金额的发票
use sql_invoicing;

select client_id
from invoices i
where invoice_total > (
    select avg(i.invoice_total)
    from invoices
    where i.client_id = client_id
);

# 查询有发票的用户, 前面介绍了使用 IN 和 JOIN 的方法,这里介绍第三种方法
select *
from clients
where client_id in (
    select client_id
    from invoices
);

# 使用 EXISTS
select *
from clients c
where exists(
              select c.client_id
              from invoices
              where c.client_id = client_id
          );
# 这里使用了相关子查询, 子查询中使用外部查询的值就是相关子查询
# 如果子查询的数据量很大适合使用 exists, 他只会返回 True 或者 False

# 练习: 找出 sql_store 里面从来没有被订购过的商品
use sql_store;

select *
from products p
where not exists(
        select product_id
        from order_items oi
        where oi.product_id = p.product_id
    );

# 相关子查询是难点, 它不返回一个结果集, 而是每次都执行子查询看看是不是 True

select invoice_id                       as id,
       invoice_total                    as total,
       (
           select avg(invoice_total)
           from invoices
       )                                as average,
       invoice_total - (select average) as diff
from invoices;

use sql_invoicing;

# 相关子查询
select client_id                                 as id,
       name,
       (select sum(invoice_total)
        from invoices
        where client_id = c.client_id)           as total_sales,
       (select avg(invoice_total) from invoices) as average,
       (select total_sales - average)            as different
from clients c;

