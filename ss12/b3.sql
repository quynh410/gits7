use ss12;
create table deleted_orders(
    delete_id int auto_increment primary key,
    order_id int not null,
    customer_name varchar(100),
    product varchar(100),
    order_date date not null,
    delete_at datetime not null
);

delimiter && 
create trigger deleted_orders_after 
after delete on orders 
for each row
begin
    insert into deleted_orders(order_id, customer_name, product, order_date, delete_at)
    values(old.order_id, old.customer_name, old.product, old.order_date, now());
end &&
delimiter ;

delete from orders where order_id = 4;
delete from orders where order_id = 5;

select * from deleted_orders;
