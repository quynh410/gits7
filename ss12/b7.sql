use ss12;
create table departments (
    dept_id int auto_increment primary key,
    name varchar(100) not null,
    manager varchar(100) not null,
    budget decimal(15,2)
);

create table employees (
    emp_id int auto_increment primary key,
    name varchar(100),
    dept_id int,
    salary decimal(10,2),
    hire_date date not null,
    foreign key (dept_id) references departments(dept_id)
);

create table project (
    project_id int auto_increment primary key,
    name varchar(100) not null,
    emp_id int,
    start_date date not null,
    end_date date,
    status varchar(100) not null,
    foreign key (emp_id) references employees(emp_id)
);

delimiter &&

create trigger warning_insert_employee
before insert on employees
for each row
begin
    declare project_status varchar(100);

    if new.salary < 500 then
        signal sqlstate '45000'
        set message_text = 'lỗi: lương quá thấp';
    elseif new.dept_id is null or new.dept_id = 0 then
        signal sqlstate '45000'
        set message_text = 'lỗi: nhân viên phải thuộc một phòng ban';
    else
        select ifnull(status, '') into project_status from project where emp_id = new.emp_id limit 1;
        if project_status = 'completed' then
            signal sqlstate '45000'
            set message_text = 'lỗi: nhân viên đã làm việc trong dự án hoàn thành';
        end if;
    end if;
end 

delimiter &&

create table project_warnings (
    warning_id int auto_increment primary key,
    project_id int not null,
    warning_message varchar(255) not null,
    warning_date datetime default current_timestamp,
    foreign key (project_id) references project(project_id)
);

create table dept_warnings (
    warning_id int auto_increment primary key,
    dept_id int not null,
    warning_message varchar(255) not null,
    warning_date datetime default current_timestamp,
    foreign key (dept_id) references departments(dept_id)
);

delimiter &&

create trigger after_update_projects
after update on project
for each row
begin
    declare total_salary decimal(15,2);
    declare department_budget decimal(15,2);
    declare department_id int;

    if new.status = 'delayed' then
        insert into project_warnings (project_id, warning_message)
        values (new.project_id, '⚠ lỗi: dự án bị trì hoãn');
    end if;

    if new.status = 'completed' and new.emp_id is not null then
        update project set end_date = curdate() where project_id = new.project_id;

        select e.dept_id, sum(e.salary), d.budget into department_id, total_salary, department_budget
        from employees e
        join departments d on e.dept_id = d.dept_id
        where e.emp_id = new.emp_id
        group by e.dept_id;
 
        if total_salary > department_budget then
            insert into dept_warnings (dept_id, warning_message)
            values (department_id, '⚠ lỗi: tổng lương nhân viên vượt ngân sách phòng ban');
        end if;
    end if;
end 
delimiter &&

create view fulloverview as
select 
    e.emp_id, 
    e.name as employeename, 
    d.name as departmentname, 
    p.name as projectname, 
    p.status as projectstatus, 
    e.salary,
    coalesce(pw.warning_message, dw.warning_message, 'no warning') as warningmessage
from employees e
join departments d on d.dept_id = e.dept_id
left join project p on p.emp_id = e.emp_id
left join project_warnings pw on pw.project_id = p.project_id
left join dept_warnings dw on dw.dept_id = d.dept_id;

delimiter &&

insert into employees (name, dept_id, salary, hire_date) values 
('alice', 1, 400, '2023-07-01'),
('charlie', 2, 1500, '2023-07-01'),
('david', 1, 2000, '2023-07-01');

update project set status = 'delayed' where project_id = 1;
update project set status = 'completed' where project_id = 2;
update project set status = 'completed' where project_id = 3;
update project set status = 'in progress' where project_id = 4;

select * from fulloverview;
