create database workmanagement;
use workmanagement;

create table departments (
    department_id int auto_increment primary key,
    department_name varchar(255) not null,
    location varchar(255)
);

create table employees (
    employee_id int auto_increment primary key,
    name varchar(255) not null,
    email varchar(255) unique not null,
    phone varchar(20),
    department_id int,
    foreign key (department_id) references departments(department_id)
);

create table projects (
    project_id int auto_increment primary key,
    project_name varchar(255) not null,
    start_date date,
    end_date date
);

create table timesheets (
    timesheet_id int auto_increment primary key,
    employee_id int,
    project_id int,
    work_date date not null,
    hours_worked decimal(5,2) not null,
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id)
);

create table workreports (
    report_id int auto_increment primary key,
    employee_id int,
    project_id int,
    report_date date not null,
    work_summary text,
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id)
);

insert into departments (department_name, location) values
('Kỹ Thuật', 'Hà Nội'),
('Nhân Sự', 'TP. Hồ Chí Minh');

insert into employees (name, email, phone, department_id) values
('Nguyễn Văn A', 'nguyenvana@email.com', '0123456789', 1),
('Trần Thị B', 'tranthib@email.com', '0987654321', 2);

insert into projects (project_name, start_date, end_date) values
('Dự án AI', '2024-01-01', '2024-06-30'),
('Dự án Web', '2024-02-01', '2024-07-31');

insert into timesheets (employee_id, project_id, work_date, hours_worked) values
(1, 1, '2024-02-05', 8),
(2, 2, '2024-02-06', 7);

insert into workreports (employee_id, project_id, report_date, work_summary) values
(1, 1, '2024-02-10', 'Hoàn thành phần mềm AI'),
(2, 2, '2024-02-11', 'Phát triển giao diện Web');


update projects
set project_name = 'Dự án Trí Tuệ Nhân Tạo'
where project_id = 1;

delete from employees where employee_id = 1;
