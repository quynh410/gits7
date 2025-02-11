create database OrderManagement;
use OrderManagement;

create table tbl_users(
	user_id int primary key auto_increment,
    user_name varchar(50) not null unique,
    user_fullname varchar(100) not null,
    email varchar(100) not null unique,
    user_address text,
    user_phone varchar(20) not null unique
);

create table tbl_employees(
	emp_id char(5) primary key,
    user_id int,
    emp_position varchar(50),
    emp_hire_date date,
    salary decimal(10, 2) not null check(salary > 0),
    status bit default(1),
    foreign key(user_id) references tbl_users(user_id)
);

create table tbl_orders(
	order_id int primary key auto_increment,
    user_id int,
    foreign key(user_id) references tbl_users(user_id),
	order_date date default(current_date),
    order_total_amount int
);

create table tbl_products(
	pro_id char(5) primary key,
    pro_name varchar(100) not null unique,
    pro_price int not null check(pro_price > 0),
    pro_quantity int,
    status bit default(1)
);

create table tbl_order_detail(
    order_detail_id int primary key auto_increment,
    order_id int,
    pro_id char(5),
    foreign key (order_id) references tbl_orders(order_id),
    foreign key (pro_id) references tbl_products(pro_id),
    order_detail_quantity int check(order_detail_quantity > 0),
    order_detail_price decimal(10,2)
);
alter table tbl_orders 
add column order_status enum('Pending', 'Processing', 'Completed', 'Cancelled');

alter table tbl_users
modify column user_phone varchar(11);

alter table tbl_users
drop column email;

insert into tbl_users (user_name, user_fullname, email, user_address, user_phone)
values
('huong', 'huong_heo','huong@gmail.com', 'hn','1234578'),
('mai','mai_ty','mai@gmail.com','qn','87654567'),
('giang','giang_son','giang@gmail.com','hcm','5434029092');

insert into tbl_employees (emp_id, user_id, emp_position, emp_hire_date, salary, status)
values
 (01, 1, 'Manager', '2023-01-15', 5000, 1),
 (02, 2,'salé','2025-02-14',3000,1),
 (03, 3,'post', '2025-03-12',2000,1);

insert into tbl_products (pro_id, pro_name, pro_price, pro_quantity, status)
values 
    ('P013', 'Men men', 2000, 10, 1),
    ('P032', 'Sua chua hyLap', 4200, 5, 1),
    ('P034', 'Bot matcha', 100, 8, 1);

insert into tbl_orders (user_id, order_date, order_total_amount)
values 
    (2, '2025-02-01', 8000),
    (3, '2025-02-02', 1500),
    (2, '2025-02-03', 2100);

insert into tbl_order_detail (order_id, pro_id, order_detail_quantity, order_detail_price)
values 
    (1, 'P013', 2, 2000),
    (2, 'P032', 1, 4200),
    (3, 'P034', 4, 100);

-- 4
-- 4a
select 
    order_id as 'Mã đơn hàng',
    order_date as 'Ngày đặt hàng',
    order_total_amount as 'Tổng tiền',
    case 
        when order_total_amount > 0 then 'Đã thanh toán'
        else 'Chưa thanh toán'
    end as 'Trạng thái đơn hàng'
from tbl_orders;
-- 4b,
select distinct u.user_fullname as 'Tên khách hàng'
from tbl_users u
join tbl_orders o on u.user_id = o.user_id;

-- 5
-- 5a
select 
    p.pro_name as 'Tên sản phẩm',
	sum(od.order_detail_quantity) as 'Số lượng đã bán'
from tbl_order_detail od
join tbl_products p on od.pro_id = p.pro_id
group by p.pro_name;
-- 5b
select 
    p.pro_name as 'Tên sản phẩm',
    sum(od.order_detail_quantity * od.order_detail_price) as 'Tổng doanh thu'
from tbl_order_detail od
join tbl_products p on od.pro_id = p.pro_id
group by p.pro_name
order by `Tổng doanh thu` desc;

-- 6.1  
select u.user_fullname, count(o.order_id) as num_orders
from tbl_orders o 
join tbl_users u on u.user_id = o.user_id
group by o.user_id;

-- 6.2 
select u.user_fullname, count(o.order_id) as num_orders
from tbl_orders o 
join tbl_users u on u.user_id = o.user_id
group by o.user_id
having count(o.order_id) >= 2;


-- 7
select u.user_fullname as cutomer_name, sum(o.order_total_amount) as total_spent
from tbl_users u
group by u.user_id 
order by total_spent desc limit 5;

-- 8
select u.user_fullname, e.emp_position, count(o.order_status) as total_orders
from tbl_employees e
left join tbl_orders o on e.user_id = o.user_id
join tbl_users u on u.user_id = o.user_id
group by e.emp_id, u.user_fullname, e.emp_position
order by total_orders desc;

-- 9
select u.user_fullname, (select max(order_total_amount) from tbl_orders limit 1) as total from tbl_users as u
join tbl_orders as o on u.user_id = o.user_id
where o.order_total_amount = (select max(order_total_amount) from tbl_orders limit 1);

-- 10
select productid, productname, stock_quantity
from products
where productid not in (
    select distinct productid from order_details
);