/*
    介绍视图
*/

use sql_invoicing;

# 创建一个 sales_by_client 视图
create view sales_by_client as
select c.client_id,
       c.name,
       sum(i.invoice_total) as total
from clients c
         join invoices i on c.client_id = i.client_id
group by c.client_id, c.name;

# view 不保存数据, 数据是真实的保存在表中的
select *
from sales_by_client sc
         join clients c on sc.client_id = c.client_id;


# 创建一个 clients_balance 视图
create view clients_balance as
select c.client_id,
       c.name,
       sum(i.invoice_total - i.payment_total) as balance
from clients c
         join invoices i on c.client_id = i.client_id
group by c.client_id, c.name;
