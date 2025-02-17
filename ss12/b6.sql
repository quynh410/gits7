use ss12;
create table budget_warnings (
    warning_id int auto_increment primary key,
    project_id int,
    warning_message varchar(255) not null
);

delimiter &&

create trigger budget_warnings_after 
after update on projects 
for each row
begin
    declare warning_exists int default 0;

    select count(*) into warning_exists
    from budget_warnings
    where project_id = new.project_id;

    if new.total_salary > new.budget and warning_exists = 0 then
        insert into budget_warnings (project_id, warning_message)
        values (new.project_id, 'Budget exceeded due to high salary');
    end if;
end 
delimiter &&

create table projectoverview (
    project_id int auto_increment primary key,
    name varchar(100) not null,
    budget decimal(15,2),
    total_salary decimal(15,2),
    warning_message varchar(255)
);

insert into workers (name, project_id, salary) values 
('Michael', 1, 6000.00),
('Sarah', 2, 10000.00),
('David', 3, 1000.00);

select * from projectoverview;
select * from budget_warnings;
