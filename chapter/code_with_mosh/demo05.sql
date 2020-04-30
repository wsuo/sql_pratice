/*
    本节介绍基础内建函数
*/

# 对数字的处理
select round(5.2); # 结果是 5 ,向下取整
select ceiling(5.3); # 结果是 6 ,向上取整

select floor(5.2); # 5
select abs(-5.2); # 5.2 绝对值

select rand(1);
# 0-1 的随机数 : 0.40540353712197724

# 对字符的处理
select upper('sky'); # SKY
select lower('SKY'); # sky

select ltrim('  sky'); # sky 去掉左边的空格
select rtrim('sky  '); # sky 去掉右边的空格
select trim('  sky  '); # sky 去掉前后的空格

select right('grandmother', 4); # ther 返回右边的四个, left同理
select substring('grandmother', 3, 4); # andm 起始位置是 3 长度是 4
select locate('a', 'grandmother'); # 3 寻找第一个 a 的位置,大小写不敏感,没有则返回 0
select replace('grandmother', 'mother', 'father'); # 替换 grandmother 为 grandfather
select concat('123', '456');
# 123456 拼接字符串

# 对日期的处理
select now(); # 2020-04-30 08:45:34 获取当前时间, 这是日期的格式
select curdate(), curtime(); # 分别获取日期和时间
select year(now()); # 2020 只要年份
select month(now()); # 只要月份
select day(now()), hour(now()), minute(now()), second(now()); # 只要日, 时, 分, 秒

select monthname(now()), dayname(now());
# April Thursday 返回字符串

# 下面介绍一个 SQL 语言通用的函数
select extract(year from now()); # 2020
select extract(month from now()); # 4
select extract(day from now()); # 30

use sql_store;

# 只显示当年的订单
select *
from orders o
where year(o.order_date) = year(now());

# 由于日期的格式是 2020-04-30 08:45:34 我们需要格式化日期
select date_format(now(), '%y');
# y 表示2位的年份, Y表示4位的年份
# m 表示数字月份, M表示英文的月份
# d 表示 日
select date_format(now(), '%H:%i %p');
# 08:59 AM

# 计算日期和时间
select date_add(now(), interval 1 day); # 加一天
select date_add(now(), interval 1 year); # 加一年
select date_add(now(), interval -1 month); # 减一个月
select date_sub(now(), interval 1 year);
# 减一年

# 计算两个时间的间隔
select datediff('2019-01-05', '2019-01-01'); # 4 天
select datediff('2019-01-01', '2019-01-05'); # -4 天
select time_to_sec('09:00');
# 32400 从0点到9点的秒数


# ifnull 表示如果是 null,就返回后面的字符
select order_id,
       ifnull(shipper_id, '无记录') # 如果为null 就显示 无记录
from orders;

select concat(c.first_name, ' ', c.last_name) as customer,
       ifnull(phone, 'Unknown')               as phone
from customers c;

# if 语句, 第一个是条件, 第二个是如果为 true 显示的值, 第二个是如果是 False 返回的值
select o.order_id               as id,
       o.order_date             as date,
       if(year(o.order_date) = year(now()) - 1,
          'Active', 'Archived') as category
from orders o;


select p.product_id,
       name,
       count(*)                              as orders,
       if(count(*) > 1, 'ManyTimes', 'Once') as frequency
from products p
         join order_items oi on p.product_id = oi.product_id
group by p.product_id, name;


# 如果有多个条件可以使用 case 语句
select order_id,
       case
           when year(order_date) = year(now()) then 'Active'
           when year(order_date) = year(now() - 1) then 'LastYear'
           when year(order_date) < year(now() - 1) then 'Archived'
           else 'Future'
           end as category
from orders;

# 根据用户的积分给他们颁发奖章
select concat(c.first_name, '', c.last_name) as name,
       c.points                              as points,
       case
           when points >= 3000 then 'Gold'
           when points >= 2000 then 'Sliver'
           else 'Bronze'
           end                               as state
from customers c;

