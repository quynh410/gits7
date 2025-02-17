use ss12;
create table order_warnings (
    warning_id int auto_increment primary key,
    order_id int not null,
    warning_message varchar(255)
);

delimiter && 

create trigger order_warnings_after
after insert on orders
for each row 
begin
    declare warning_message varchar(255);
    
    if new.price > 5000 then 
        set warning_message = 'Total value exceeds limit';
    end if;
    
    insert into order_warnings(order_id, warning_message)
    values (new.order_id, warning_message);
end 

delimiter &&;

insert into orders (customer_name, product, quantity, price, order_date) values
('Mark', 'Monitor', 2, 3000.00, '2023-08-01'),
('Paul', 'Mouse', 1, 50.00, '2023-08-02');
