/*
    触发和事件
*/

/*
    问题描述:
        在发票数据库中, 有一个字段是: payment_total
        他是根据支付表中的数据实时更新的, 因为一旦用户支付了, 这里的总额就要增加
        这就需要使用 --触发器--
*/
use sql_invoicing;

select *
from invoices;

# 修改默认的分隔符
delimiter $$

# 创建触发器语句-- 和支付记录表相关-- 他会在插入支付记录后被触发
create trigger payments_after_insert
    after insert
    on payments
    # 表示触发器会在每个符合条件的行触发, 如果你插入了 5 行, 那么每行都会执行一次
    for each row
# 触发器的代码块, 在这里我们可以修改除了触发器之外的所有的表
begin
    # 这里可以直接写语句或者调用存储过程
    update invoices
        # 设置以支付金额等于当前支付金额加上新的支付金额, NEW 表示刚加入的新纪录, 相同的道理还有 OLD 关键字
    set payment_total = payment_total + NEW.amount
    where invoice_id = NEW.invoice_id;
end $$

# 将分隔符改回分号
delimiter ;

# 做个实验试一下
insert into payments
values (default, 5, 3, '2020-05-09', 10, 1);

# 然后可以观察到 invoice 表中的 payment_total 已经更新了

# 作为练习: 完成一个删除记录的触发器操作
delimiter $$
create trigger payments_after_delete
    after delete
    on payments
    for each row
begin
    update invoices
        # OLD 可以获取刚刚删除的那一行
    set payment_total = payment_total - OLD.amount
    where payment_id = OLD.payment_id;
end
$$

delimiter ;

select *
from payments;

delete
from payments
where payment_id = 9;

# 查看所有的触发器
show triggers;

# 使用 like 可以筛选
show triggers like 'payments%';

# 删除触发器
drop trigger if exists payments_after_delete;


# 新建一张表: 叫做 audit 审查表
create table payment_audit
(
    client_id   int           not null,
    date        date          not null,
    amount      decimal(9, 2) not null,
    action_type varchar(50)   not null,
    action_date datetime      not null
);

drop trigger if exists payments_after_insert;

create trigger payments_after_insert
    after insert
    on payments
    for each row
begin
    update invoices
    set payment_total = payment_total + NEW.amount
    where invoice_id = NEW.invoice_id;

    insert into payment_audit
    values (NEW.client_id, NEW.date, NEW.amount, 'Insert', now());
end $$;

# 展示环境变量
show variables like 'event%';

# 设置事件为打开
set global event_scheduler = on;

# 创建一个事件, 执行定时任务, 进行数据库的自动化维护
delimiter $$
create event yearly_delete_stale_audit_rows
# 输入开始标志
    on schedule
        -- at '2020-05-10'
        every 1 year starts '2020-01-01' ends '2030-01-01'
    do begin
    # 自动删除一年以上的数据
    delete
    from payment_audit
    where action_date < now() - interval 1 year;
end $$

delimiter ;

# 查看所有的事件
show events;

drop event if exists yearly_delete_stale_audit_rows;

# 转化时间的语句, 相当于 update
# alter event ...

# 启用事件
alter event yearly_delete_stale_audit_rows enable;
# 关闭事件
alter event yearly_delete_stale_audit_rows disable;




