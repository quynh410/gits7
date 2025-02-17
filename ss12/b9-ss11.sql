use sakila;
create view view_long_action_movies as
select f.film_id, f.title, f.length, c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'action' and f.length > 100;

create view view_texas_customers as
select distinct cu.customer_id, cu.first_name, cu.last_name, ci.city
from customer cu
join address a on cu.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join rental r on cu.customer_id = r.customer_id
where ci.city = 'texas';

create view view_high_value_staff as
select s.staff_id, s.first_name, s.last_name, sum(p.amount) as total_payment
from staff s
join payment p on s.staff_id = p.staff_id
group by s.staff_id
having total_payment > 100;

create unique index idx_unique_email
on customer(email);

create fulltext index idx_film_title_description
on film(title, description);

create index idx_rental_inventory_id
on rental(inventory_id) using hash;

create index idx_rental_customer_id
on rental(customer_id);

create index idx_payment_customer_id
on payment(customer_id);

create view view_active_customer_rentals as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, r.rental_date,
       case when r.return_date is not null then 'Returned' else 'Not Returned' end as status
from customer c
join rental r on c.customer_id = r.customer_id
where c.active = 1 and r.rental_date >= '2023-01-01' and (r.return_date is null or r.return_date >= now() - interval 30 day);

create view view_customer_payments as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, sum(p.amount) as total_payment
from customer c
join payment p on c.customer_id = p.customer_id
where p.payment_date >= '2023-01-01'
group by c.customer_id
having total_payment > 100;

delimiter &&
create procedure getrentalbyinventory(in inventory_id int)
begin
    select * from rental
    where inventory_id = inventory_id;
end &&

delimiter &&
create procedure checkcustomeremail(in email_input varchar(50), out exists_flag int)
begin
    select count(*) > 0 into exists_flag from customer where email = email_input;
end &&

delimiter &&
create procedure getcustomerpaymentsbyamount(in min_amount decimal(10,2), in date_from date)
begin
    select * from view_customer_payments
    where total_payment >= min_amount and date_from >= '2023-01-01';
end &&

delimiter ;

drop view if exists view_long_action_movies;
drop view if exists view_texas_customers;
drop view if exists view_high_value_staff;
drop view if exists view_active_customer_rentals;
drop view if exists view_customer_payments;

drop index idx_unique_email on customer;
drop index idx_film_title_description on film;
drop index idx_rental_inventory_id on rental;
drop index idx_rental_customer_id on rental;
drop index idx_payment_customer_id on payment;

drop procedure if exists getrentalbyinventory;
drop procedure if exists checkcustomeremail;
drop procedure if exists getcustomerpaymentsbyamount;
