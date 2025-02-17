create database ss12;
use ss12;

create table orders (
    order_id int auto_increment primary key,
    customer_name varchar(100) not null,
    product varchar(100) not null,
    quantity int default 1,
    price decimal(10, 2) not null check (price > 0),
    order_date date not null
) engine = 'myisam';

insert into orders (customer_name, product, quantity, price, order_date) values
('alice', 'laptop', 2, 1500.00, '2023-01-10'),
('bob', 'smartphone', 5, 800.00, '2023-02-15'),
('carol', 'laptop', 1, 1500.00, '2023-03-05'),
('alice', 'keyboard', 3, 100.00, '2023-01-20'),
('dave', 'monitor', null, 300.00, '2023-04-10');

delimiter &&

create trigger before_insert_orders
before insert on orders
for each row
begin
    if new.quantity is null or new.quantity < 1 then
        set new.quantity = 1;
    end if;
    if new.order_date is null then
        set new.order_date = curdate();
    end if;
end;

delimiter &&;

insert into orders (customer_name, product, quantity, price, order_date) values
('Anna', 'Tablet', NULL, 400.00, NULL),
('John', 'Mouse', -3, 50.00, '2023-05-01');

drop trigger before_insert_orders;
