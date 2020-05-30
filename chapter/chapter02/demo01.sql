select *
from orders;

select *
from orderitem;

select *
from products;

# 先把约束关闭
SET FOREIGN_KEY_CHECKS = 0;

# 删除订单号为 abc 的那一条记录
delete oi, o
from orderitem oi
         inner join orders o
                    on o.id = oi.order_id
where id = 'aaa';

# 完了再开启约束
SET FOREIGN_KEY_CHECKS = 1;


delete
from orderitem
where order_id = 'aaa';

delete
from orders
where id = 'aaa';

insert into orders(id, money)
values ('aaa', 200);

insert into orderitem(order_id, product_id, buynum)
values ('aaa', '23cfa820-0eeb-4436-9538-5154f569d87b', 1);
