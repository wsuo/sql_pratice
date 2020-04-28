/*
    本节介绍复杂查询
    包括函数的使用和聚合查询
*/

use sql_invoicing;
# 首先是几种常用的聚合函数

# 查询最大值,最小值,平均值
select
       max(invoice_total) as hightest,
       min(invoice_total) as lowest,
       avg(invoice_total) as average
from invoices;

# 也可以用作日期查询
# 这里是查询最晚的日期
select max(invoice_date) as latest_date
from invoices;

# 使用 SUM() 计算一列的和, 使用 COUNT() 函数计数
select
       sum(invoice_total) as sum,
       count(invoice_total) as count
from invoices;

# 但是 count 函数只会计算非空字段,如果想想把空值也算进去计数就要使用count(*)
select count(*) as total
from invoices;

# 使用 distinct 关键字可以使查询结果只计算不重复的行
select count(distinct client_id) as total_client
from invoices;

select *
from invoices;


select '2019上半年的业绩' as date_range,
       sum(invoice_total) as total_sales,
       sum(payment_total) as total_payments,
       sum(invoice_total - payment_total)
from invoices
where invoice_date between '2019-01-01' and '2019-06-30'
union
select '2019下半年的业绩',
       sum(invoice_total) as total_sales,
       sum(payment_total),
       sum(invoice_total - payment_total)
from invoices
where invoice_date between '2019-07-01' and '2019-12-31'
union
select '2019全年的业绩',
       sum(invoice_total) as total_sales,
       sum(payment_total),
       sum(invoice_total - payment_total)
from invoices
where invoice_date between '2019-01-01' and '2019-12-31'
;

# 查看每个用户的总的钱
select client_id, sum(invoice_total) as total_sales
from invoices
group by client_id
order by total_sales desc ;
# 记住: group by 子句永远是在 from 和 where 子句之后,在 order 子句之前的


select c.state, c.city, sum(i.invoice_total) as total_sales
from invoices i
left join clients c using (client_id)
group by c.state, c.city
order by total_sales desc ;

# 练习使用多个字段分组
select p.date, py.name as payment_method, sum(p.amount) as total_payments
from payments p
join payment_methods py on p.payment_id = py.payment_method_id
group by date, payment_method
order by date;

# 使用 having 子句
# 如果我们查出来总额之后只想要大于500元的怎么办
# 我们不能使用 where 因为那时候数据还没有分组,筛选出来的数据肯定小于500
select client_id, sum(i.invoice_total) as total_sales
from invoices i
group by client_id
having total_sales >= 500;

# 总结一下就是使用 where 在分组之前筛选数据, 使用 having 在分组之后筛选数据
# having 只能使用筛选出来的数据做判断, 而 where 可以使用任意存在的列

use sql_store;

# 找到位于VA州的客户,并且他们消费大于100$
select *
from customers c
;

# 可以得到用户下了那个订单
select *
from orders;

# 这里可以得到订单号,产品id,产品数量,每一个的价格
select *
from order_items;

select customer_id, sum(oi.quantity * oi.unit_price) as total_pay, c.state as state
from customers c
join orders o using (customer_id)
join order_items oi using (order_id)
where state = 'VA'
group by c.customer_id
having total_pay >= 100;

use sql_invoicing;

# with rollup 的使用: 对聚合函数求和
select client_id, sum(invoice_total) as total_sales
from invoices
group by client_id with rollup ;

select *
from payment_methods;

select pm.name, sum(amount) as total
from payments p
join payment_methods pm on p.payment_method = pm.payment_method_id
group by name with rollup ;
