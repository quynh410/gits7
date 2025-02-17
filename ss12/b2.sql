use ss12;
create table price_changes(
    change_id int auto_increment primary key,
    product varchar(100) not null,
    old_price decimal(10,2) not null,
    new_price decimal(10,2) not null
);

delimiter && 
create trigger after_update_price_changes
after update on orders 
for each row
begin 
    insert into price_changes(product, old_price, new_price)
    values(old.product, old.price, new.price);
end 
delimiter &&;

update orders
set price = 800.00
where product = 'Smartphone';

select * from price_changes;

show table status where name = 'orders';
