create database b3;
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



-- Hiển thị danh sách tất cả các sách
select * from books;

-- Hiển thị danh sách tất cả độc giả
select * from readers;

-- Lấy thông tin về các bạn đọc và các sách mà họ đã mượn, bao gồm tên bạn đọc, tên sách và ngày mượn
select readers.name, books.title, borrowing.borrow_date
from borrowing
join readers on borrowing.reader_id = readers.reader_id
join books on borrowing.book_id = books.book_id;

-- Lấy thông tin về các sách và thể loại của chúng, bao gồm tên sách, tác giả và tên thể loại
select books.title, books.author, categories.category_name
from books
join categories on books.category_id = categories.category_id;

-- Lấy thông tin về các bạn đọc và các khoản phạt mà họ phải trả, bao gồm tên bạn đọc, số tiền phạt và ngày trả sách
select readers.name, fines.fine_amount, returning.return_date
from fines
join returning on fines.return_id = returning.return_id
join borrowing on returning.borrow_id = borrowing.borrow_id
join readers on borrowing.reader_id = readers.reader_id;

-- Cập nhật số lượng sách còn lại của cuốn sách có book_id = 1 thành 15
update books set quantity = 15 where book_id = 1;

-- Xóa bạn đọc có reader_id = 2 khỏi bảng readers
delete from readers where reader_id = 2;

-- Thêm lại bạn đọc có reader_id = 2 vào bảng readers
insert into readers (reader_id, name, phone_number, email) 
values (2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com');

