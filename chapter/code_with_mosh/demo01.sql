/*
    一定自己去执行每一条语句!!!

    这里罗列出来所有常用的查询,即你再开发中绝对可以使用到的查询语句
    请大家一定自己动手去做,有些地方我写的很隐晦,目的是让大家自己去思考
    而不是完全无脑照抄,如果你只想快速看一遍就掌握,那本篇文章不适合你学习
*/
# 使用某一个数据库
use sql_store;

select *
from customers;
-- where customer_id = 1;
# order by first_name;

# as是给列名起别名
select distinct first_name, last_name, points as 'coin'
from customers;

# select 后面可以自定义,不管表中有没有
select name, unit_price, unit_price * 1.1 'new price'
from products;

# as 是取别名
select *
from orders as o
where o.order_date >= '2019-01-01';

select *
from customers;

select order_id, product_id, unit_price * quantity total_price
from order_items
where product_id = 6
  and (unit_price * quantity) > 30;

select *
from customers
where state = 'VA'
   or state = 'GA'
   or state = 'FL';

# 相当于或者
select *
from customers
where state in ('VA', 'GA', 'FL');

select *
from products
where quantity_in_stock in (49, 38, 72);

select *
from customers
where points >= 1000
  and points <= 3000;

select *
from customers
where points between 1000 and 3000;

# 相当于一个范围
select *
from customers
where birth_date between '1990-01-01' and '2000-01-01';

# 左右位置不限字符
select *
from customers
where address like '%trail%'
   or address like '%avenue%';

# 模糊查询, % 代表占位符,可以占很多位,这里的意思是查询 phone 以9结尾的
select *
from customers
where phone like '%9';

# | 是或者, 这里的意思是, elka 或者 ambur
select *
from customers
where first_name regexp 'elka|ambur';

# $ 代表必须以某个字符结尾, | 是或者, 以ey结尾或者以on结尾的
select *
from customers
where last_name regexp 'ey$|on$';

# 正则匹配, ^ 代表必须以这个字母开头, | 是或者,默认以左右两边为主体
select *
from customers
where last_name regexp '^my|se';

# 正则匹配,[] 内为可选字段,意思是,有r或者u, br 或者 bu
select *
from customers
where last_name regexp 'b[ru]';

# 查询 phone 为空的人
select *
from customers
where phone is null;

select *
from orders
where shipper_id is null;

# desc 代表降序, asc 代表升序
select *
from customers
order by customer_id desc ;

# where做为条件筛选,也就是只有符合条件的才会被查出来,后面会学到 on ,on是指全部查出来之后再筛选
select *, quantity * unit_price as total_price
from order_items
where order_id = 2
order by total_price desc;

# 分页 limit 后面的数字为每页展示的个数
select *
from customers
limit 6;

# offset 表示偏移的位置,这里表示每页展示 3 条数据,然后偏移 3 条数据
# 就是从 4 开始, 实际上就是 第二页
select *
from customers
limit 3 offset 3;

# 倒序排序之后取前三名
select c.first_name, c.points
from customers c
order by points desc
limit 3;

# 等值连接,内连接,只有符合 on 语句条件的才会被查询出来
select order_id, first_name, last_name
from orders
         join customers c on orders.customer_id = c.customer_id;

select p.product_id, p.name, o.quantity, o.unit_price
from order_items o
         join products p on o.product_id = p.product_id;

# and 语句可以扩展 on 的条件
select *
from order_items oi
         join order_item_notes oin on oi.order_id = oin.order_Id
    and oi.product_id = oin.product_id;

# 左连接是以左边的表为基础,即无论右边的表有没有数据,只要我左边的表有数据,你就算是null也会被查出来
# 这里连续使用了两个 left join ,然后使用 order by 排序
select c.customer_id, c.first_name, o.order_id, s.name
from customers c
         left join orders o on c.customer_id = o.customer_id
         left join shippers s on o.shipper_id = s.shipper_id
order by c.customer_id, o.order_id;

# 查询所有
select *
from order_statuses;

# 左外连接
select p.product_id, p.name, oi.quantity
from products p
         left join order_items oi on p.product_id = oi.product_id
order by p.product_id, oi.quantity;

# 先等值连接,再左外连接: 等值连接的对应的列数一定是一样的
select order_date, order_id, c.first_name, s.name as shiper, os.name as status
from orders o
         join customers c on o.customer_id = c.customer_id
         left join shippers s on o.shipper_id = s.shipper_id
         left join order_statuses os on o.status = os.order_status_id
order by o.order_id;

# 使用数据库
use sql_hr;

# 左外连接
select e.employee_id, e.first_name, m.first_name as Manager
from employees e
         left join employees m
                   on e.reports_to = m.employee_id;

# 使用数据库
use sql_store;

# using 可以代替 on 语句里面的 = ,但是前提是字段名必须相同
select o.order_id, c.first_name, sh.name
from orders o
         join customers c
              using (customer_id)
         left join shippers sh
                   using (shipper_id)
order by o.order_id;

# 字段名必须相同,这里是双主键,也就是 order_id 和 product_id 同时满足条件的才可以
select *
from order_items oi
         left join order_item_notes oin
                   using (order_id, product_id);

use sql_invoicing;

select *
from payment_methods;

select p.date, c.name as client, p.amount, pm.name as payment_mathod
from payments p
         join clients c using (client_id)
         join payment_methods pm on p.payment_method = pm.payment_method_id;

use sql_store;

select sh.name as shipper_name, p.name as product_name
from products as p,
     shippers as sh;

# cross join 和什么也不写一样, 交叉连接
select sh.name as shipper_name, p.name as product_name
from shippers sh
         cross join products p;

select *
from customers;

# 使用union合并几张表的结果,要确保列一样
select c.customer_id, c.first_name, c.points, 'Bronze' as type
from customers c
where c.points < 2000
union
select c.customer_id, c.first_name, c.points, 'Silver' as type
from customers c
where 2000 <= c.points < 3000
union
select c.customer_id, c.first_name, c.points, 'Gold' as type
from customers c
where c.points >= 3000
order by first_name;

# 自然连接,会自动判断相同的字段然后连接,具有不确定性,不建议使用
select *
from orders o
natural join customers c;



