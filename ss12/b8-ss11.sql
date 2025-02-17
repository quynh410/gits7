use salika;
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

create fulltext index idx_film_title_description
on film(title, description);

create index idx_rental_inventory_id
on rental(inventory_id) using hash;

select * from view_long_action_movies
where match(title, description) against ('war' in natural language mode);

delimiter &&
create procedure getrentalbyinventory(in inventory_id int)
begin
    select * from rental
    where inventory_id = inventory_id;
end &&
delimiter ;

drop view if exists view_long_action_movies;
drop view if exists view_texas_customers;
drop view if exists view_high_value_staff;
drop index idx_film_title_description on film;
drop index idx_rental_inventory_id on rental;
drop procedure if exists getrentalbyinventory;
