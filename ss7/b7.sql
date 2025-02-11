create database b7;
use b7;

create table student (
    rn int primary key,  
    name varchar(20), 
    age tinyint check (age between 15 and 55)  
);

insert into student (rn, name, age) values
(1, 'nguyen hong ha', 20),
(2, 'truong ngoc anh', 30),
(3, 'tuan minh', 25),
(4, 'dan truong', 22);

create table test (
    testid int primary key, 
    name varchar(20) unique
);

insert into test (testid, name) values
(1, 'epc'),
(2, 'dwxx'),
(3, 'sql1'),
(4, 'sql2');

create table studenttest (
    rn int,            
    testid int,         
    date datetime,      
    mark float default 0,
    primary key (rn, testid),  
    foreign key (rn) references student(rn),
    foreign key (testid) references test(testid)
);

insert into studenttest (rn, testid, date, mark) values
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(3, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(4, 3, '2006-07-19', 1);

-- hiển thị danh sách học viên đã tham gia thi với điểm số và ngày thi
select s.name as student_name, t.name as test_name, st.mark, st.date
from studenttest st
join student s on st.rn = s.rn
join test t on st.testid = t.testid
order by st.date asc;

-- hiển thị học viên chưa thi môn nào
select * from student
where rn not in (select distinct rn from studenttest);

-- hiển thị học viên phải thi lại (điểm dưới 5)
select s.name as student_name, t.name as test_name, st.mark, st.date
from studenttest st
join student s on st.rn = s.rn
join test t on st.testid = t.testid
where st.mark < 5;

-- hiển thị điểm trung bình của học viên, sắp xếp giảm dần
select s.name as student_name, avg(st.mark) as average
from studenttest st
join student s on st.rn = s.rn
group by s.name
order by average desc;

-- hiển thị học viên có điểm trung bình lớn nhất
select s.name as student_name, avg(st.mark) as average
from studenttest st
join student s on st.rn = s.rn
group by s.name
order by average desc
limit 1;

-- hiển thị điểm cao nhất của từng môn học
select t.name as test_name, max(st.mark) as max_mark
from studenttest st
join test t on st.testid = t.testid
group by t.name;

-- hiển thị tất cả học viên và môn học (nếu chưa thi thì điểm là null)
select s.name as student_name, t.name as test_name, st.mark
from student s
cross join test t
left join studenttest st on s.rn = st.rn and t.testid = st.testid;

-- cập nhật tuổi của học viên lên 1 tuổi
update student set age = age + 1;

-- thêm cột status vào bảng student
alter table student add status varchar(10);

-- cập nhật status: <30 tuổi là 'young', >=30 là 'old'
update student
set status = case when age < 30 then 'young' else 'old' end;

-- hiển thị học viên và điểm thi theo ngày tăng dần
select s.name as student_name, t.name as test_name, st.mark, st.date
from studenttest st
join student s on st.rn = s.rn
join test t on st.testid = t.testid
order by st.date;

-- hiển thị học viên có tên bắt đầu bằng 't' và điểm trung bình > 4.5
select s.name, s.age, avg(st.mark) as average
from studenttest st
join student s on st.rn = s.rn
where s.name like 't%'
group by s.name, s.age
having avg(st.mark) > 4.5;

-- hiển thị học viên có điểm trung bình cao nhất
select s.name, avg(st.mark) as average
from studenttest st
join student s on st.rn = s.rn
group by s.name
order by average desc
limit 1;

-- xóa thông tin điểm thi của sinh viên có điểm < 5
delete from studenttest where mark < 5;
