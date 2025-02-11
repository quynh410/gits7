use b5;

create table Categories (
	category_id int primary key,
    category_name varchar(255)
);

create table Books (
	book_id int primary key,
    title varchar(255),
    author varchar(255),
    publication_year int,
    available_quantity int,
    category_id int,
    foreign key(category_id) references Categories(category_id)
);

create table Readers (
	reader_id int primary key,
    name varchar(255),
    phone_number varchar(15),
    email varchar(255)
);

create table Borrowing  (
	borrow_id int primary key,
    reader_id int,
    foreign key(reader_id) references Readers(reader_id),
    book_id int,
    foreign key(book_id) references Books(book_id),
    borrow_date date,
    due_date date
);

create table Returning (
	return_id int primary key,
    borrow_id int,
    foreign key(borrow_id) references Borrowing(borrow_id),
    return_date date
);

create table Fines (
	fine_id int primary key,
    return_id int,
    foreign key(return_id) references Returning(return_id),
    fine_amount decimal(10, 2)
);
-- Insert sample data into Departments table
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8);


-- 1. Lấy tên nhân viên và phòng ban của họ
select e.name, d.department_name 
from employees e
join departments d on e.department_id = d.department_id
order by e.name;

-- 2. Lấy nhân viên có lương trên 5000, sắp xếp theo lương giảm dần
select name, salary 
from employees
where salary > 5000
order by salary desc;

-- 3. Tổng số giờ làm việc của mỗi nhân viên
select e.name, sum(w.hours) as total_hours
from employees e
join work_hours w on e.employee_id = w.employee_id
group by e.name;

-- 4. Lương trung bình trong mỗi phòng ban
select d.department_name, avg(e.salary) as avg_salary
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name;

-- 5. Tổng số giờ làm việc cho mỗi dự án trong tháng 2/2025
select p.project_name, sum(w.hours) as total_hours
from work_hours w
join projects p on w.project_id = p.project_id
where month(w.report_date) = 2 and year(w.report_date) = 2025
group by p.project_name;

-- 6. Tổng số giờ làm việc của mỗi nhân viên trong từng dự án
select e.name, p.project_name, sum(w.hours) as total_hours
from work_hours w
join employees e on w.employee_id = e.employee_id
join projects p on w.project_id = p.project_id
group by e.name, p.project_name;

-- 7. Đếm số nhân viên trong mỗi phòng ban (chỉ lấy phòng có hơn 1 nhân viên)
select d.department_name, count(e.employee_id) as total_employees
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name
having count(e.employee_id) > 1;

-- 8. Lấy 2 báo cáo gần nhất, bỏ qua báo cáo mới nhất
select w.report_date, e.name, w.report_content
from work_hours w
join employees e on w.employee_id = e.employee_id
order by w.report_date desc
limit 2 offset 1;

-- 9. Đếm số báo cáo mỗi ngày (chỉ lấy báo cáo không rỗng, trong khoảng 01/2025 - 02/2025)
select w.report_date, e.name, count(w.report_id) as report_count
from work_hours w
join employees e on w.employee_id = e.employee_id
where w.report_content is not null 
and w.report_date between '2025-01-01' and '2025-02-01'
group by w.report_date, e.name;

-- 10. Tính tổng lương dựa trên giờ làm việc (chỉ lấy nhân viên làm trên 5 giờ)
select e.name, p.project_name, sum(w.hours) as total_hours, 
round(sum(w.hours) * e.salary, 2) as total_salary
from work_hours w
join employees e on w.employee_id = e.employee_id
join projects p on w.project_id = p.project_id
group by e.name, p.project_name, e.salary
having sum(w.hours) > 5
order by total_salary;

