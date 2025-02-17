use ss12;
create table salary_history (
    history_id int auto_increment primary key,
    emp_id int,
    old_salary decimal(10,2) not null,
    new_salary decimal(10,2) not null,
    change_date datetime not null
);

create table salary_warnings (
    warning_id int auto_increment primary key,
    emp_id int not null,
    warning_message varchar(255) not null,
    warning_date datetime
);

delimiter &&
create trigger after_update_salary
after update on employees
for each row
begin
    declare adjusted_salary decimal(10,2);

    insert into salary_history (emp_id, old_salary, new_salary, change_date)
    values (new.emp_id, old.salary, new.salary, now());

    if new.salary < old.salary * 0.7 then
        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'salary decreased by more than 30%', now());
    end if;

    if new.salary > old.salary * 1.5 then
        set adjusted_salary = old.salary * 1.5;

        update employees 
        set salary = adjusted_salary
        where emp_id = new.emp_id;

        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'salary increased above allowed threshold (adjusted to 150% of previous salary)', now());
    end if;
end &&
delimiter ;

delimiter &&
create trigger after_insert_project
after insert on project
for each row
begin
    declare active_project_count int;

    select count(*) into active_project_count 
    from project 
    where emp_id = new.emp_id 
    and status in ('in progress', 'pending');

    if active_project_count >= 3 then
        signal sqlstate '45000'
        set message_text = 'error: employee cannot have more than 3 active projects.';
    end if;

    if new.status = 'in progress' and new.start_date > curdate() then
        signal sqlstate '45000'
        set message_text = 'error: project start date cannot be in the future.';
    end if;
end &&
delimiter ;

delimiter &&
create view performance_overview as 
select 
    p.project_id, 
    p.name, 
    count(distinct e.emp_id) as total_employees, 
    datediff(p.end_date, p.start_date) as total_days, 
    p.status
from project p  
join employees e on p.emp_id = e.emp_id 
group by p.project_id &&
delimiter ;

update employees set salary = salary * 0.5 where emp_id = 1;

update employees set salary = salary * 2 where emp_id = 2;

insert into project (name, emp_id, start_date, status) 
values ('new project 1', 1, curdate(), 'in progress');

insert into project (name, emp_id, start_date, status) 
values ('new project 2', 1, curdate(), 'in progress');

insert into project (name, emp_id, start_date, status) 
values ('new project 3', 1, curdate(), 'in progress');

insert into project (name, emp_id, start_date, status) 
values ('new project 4', 1, curdate(), 'in progress');

-- invalid project start date case
insert into project (name, emp_id, start_date, status) 
values ('future project', 2, date_add(curdate(), interval 5 day), 'in progress');
