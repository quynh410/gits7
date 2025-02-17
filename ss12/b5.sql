use ss12;
create table projects (
    project_id int auto_increment primary key,
    name varchar(100) not null,
    budget decimal(15,2),
    total_salary decimal(15,2) default 0
);

create table workers(
    workers_id int auto_increment primary key,
    name varchar(100),
    project_id int,
    salary decimal(10,2),
    foreign key (project_id) references projects(project_id)
);

insert into projects (name, budget) values
('Bridge construction', 10000.00),
('Road expansion', 15000.00),
('Office renovation', 8000.00);

delimiter && 
create trigger insert_after 
after insert on workers 
for each row
begin    
    update projects 
    set total_salary = total_salary + new.salary
    where project_id = new.project_id;
end 
delimiter && 

delimiter &&  
create trigger after_delete
after delete on workers 
for each row
begin    
    update projects 
    set total_salary = total_salary - old.salary
    where project_id = old.project_id;
end 
delimiter && 

insert into workers (name, project_id, salary) values
('John', 1, 2500.00),
('Alice', 1, 3000.00),
('Bob', 2, 2000.00),
('Eve', 2, 3500.00),
('Charlie', 3, 1500.00);

delete from workers where workers_id = 1; 
