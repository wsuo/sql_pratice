/*
    存储-过程
    procedure-过程
    相当于函数, 使用 call 调用, 可以使用参数
*/

use sql_invoicing;

# 定义一个过程, 使用定界符 $$
delimiter $$
create procedure get_client()
begin
    select * from client;
end $$
delimiter ;


# 调用过程
call get_client();

# 删除一个过程
drop procedure if exists get_client;

# 有参数的过程
create procedure `get_invoices_by_client`(client_id int(11))
begin
    select *
    from invoices i
    where i.client_id = client_id;
end;

# 试着调用一个函数
call get_invoices_by_client(1);


use sql_store;

# 来点复杂的,比如设置默认值
create procedure get_clients_by_state(
    state varchar(2)
)
begin
    if state is null then
        set state = 'CA';
    else
        select *
        from client c
        where state = c.state;
    end if;
end;

# 异常捕捉
create procedure `make_payment`(invoice_id int,
                                payment_amount decimal(9, 2),
                                payment_date date)
begin
    if payment_amount <= 0 then
        signal sqlstate '22003' set message_text = '非法的支付金额';
    end if;
    update invoice i
    set i.payment_moount = payment_amount,
        i.payment_date   = payment_date,
        i.payment_id     = payment_id;
end;


# OUT 输出参数
create procedure get_unpaid_invoice_for_client(client_id int,
                                               out invoice_count int,
                                               out invoice_total decimal(9, 2))
begin
    select count(*), sum(invoices.invoice_total)
    into invoice_count, invoice_total
    from invoices i
    where i.client_id = client_id
      and payment_total = 0;
end;

# 变量的定义 用户或回话变量, 会保存到内存中
set @invoice_count = 0;

# 本地变量, 不会持久化到内存当中,随着过程结束接销毁
# declare risk = 0; (只能定义在procedure中)

# 创建自定义函数,只能返回单一的值
create function get_risk_factor_for_client(
    client_id int
)
    returns Integer # 返回值类型
#     deterministic # 确定性
    reads sql data # 从数据库中读取数据
#     modifies sql data  # 对数据库进行增删改查
begin
    return 1;
end;

# 使用 drop 删除函数



