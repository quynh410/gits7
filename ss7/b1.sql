use b3;

create table categories (
    category_id int primary key auto_increment,
    category_name varchar(255) not null
);

create table books (
    book_id int primary key auto_increment,
    title varchar(255) not null,
    author varchar(255),
    category_id int,
    quantity int not null,
    foreign key (category_id) references categories(category_id) on delete cascade
);

create table readers (
    reader_id int primary key auto_increment,
    name varchar(255) not null,
    phone_number varchar(15),
    email varchar(255)
);

create table borrowing (
    borrow_id int primary key auto_increment,
    reader_id int,
    book_id int,
    borrow_date date not null,
    foreign key (reader_id) references readers(reader_id) on delete cascade,
    foreign key (book_id) references books(book_id) on delete cascade
);

create table returning (
    return_id int primary key auto_increment,
    borrow_id int,
    return_date date not null,
    foreign key (borrow_id) references borrowing(borrow_id) on delete cascade
);

create table fines (
    fine_id int primary key auto_increment,
    return_id int,
    fine_amount decimal(10,2) not null,
    foreign key (return_id) references returning(return_id) on delete cascade
);

insert into categories (category_name) values ('Khoa học'), ('Văn học');

insert into books (title, author, category_id, quantity) 
values ('Sách Khoa học 1', 'Tác giả A', 1, 10), ('Sách Văn học 1', 'Tác giả B', 2, 15);

insert into readers (name, phone_number, email) 
values ('Nguyễn Văn A', '0987654321', 'a@email.com'), ('Trần Thị B', '0912345678', 'b@email.com');

insert into borrowing (reader_id, book_id, borrow_date) 
values (1, 1, '2024-02-01'), (2, 2, '2024-02-02');

insert into returning (borrow_id, return_date) 
values (1, '2024-02-10'), (2, '2024-02-12');

insert into fines (return_id, fine_amount) 
values (1, 50000), (2, 75000);

update readers 
set phone_number = '0909090909', email = 'updated@email.com' 
where reader_id = 1;

delete from books where book_id = 1;
