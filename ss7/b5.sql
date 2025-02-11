create database b5;
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

-- Inserting categories of books into the Categories table
INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Science'),
(2, 'Literature'),
(3, 'History'),
(4, 'Technology'),
(5, 'Psychology');

-- Inserting books into the Books table with details such as title, author, and category
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
(1, 'The History of Vietnam', 'John Smith', 2001, 10, 1),
(2, 'Python Programming', 'Jane Doe', 2020, 5, 4),
(3, 'Famous Writers', 'Emily Johnson', 2018, 7, 2),
(4, 'Machine Learning Basics', 'Michael Brown', 2022, 3, 4),
(5, 'Psychology and Behavior', 'Sarah Davis', 2019, 6, 5);

INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Alice Williams', '123-456-7890', 'alice.williams@email.com'),
(2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com'),
(3, 'Charlie Brown', '555-123-4567', 'charlie.brown@email.com');

INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2025-02-19', '2025-02-15'),
(2, 2, 2, '2025-02-03', '2025-02-17'),
(3, 3, 3, '2025-02-02', '2025-02-16'),
(4, 1, 2, '2025-03-10', '2025-02-24'),
(5, 2, 3, '2025-05-11', '2025-02-25'),
(6, 2, 3, '2025-02-11', '2025-02-25');


INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2025-03-14'),
(2, 2, '2025-02-28'),
(3, 3, '2025-02-15'),
(4, 4, '2025-02-20'),  
(5, 4, '2025-02-20');

INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 5.00),
(2, 2, 0.00),
(3, 3, 2.00);

select title, author, category_name
from Books join Categories on Books.category_id = Categories.category_id
order by author;
select Readers.name, count(Borrowing.book_id) as number_books
from Borrowing 
	join Books on Borrowing.book_id = Books.book_id
    join Readers on Borrowing.reader_id = Readers.reader_id
group by Readers.name;

select avg(Fines.fine_amount) as fine_average  
from Fines;

select title, MAX(available_quantity) as inventory_quantity
from Books
group by title
limit 1;

select name, fine_amount
from Borrowing 
    join Readers on Borrowing.reader_id = Readers.reader_id
	join Returning on Borrowing.borrow_id = Returning.borrow_id
    join Fines on Returning.return_id = Fines.return_id
where fine_amount > 0;

select title, count(borrow_id) as count_books
from Borrowing 
	join Books on Borrowing.book_id = Books.book_id
group by title
order by count_books desc
limit 1;

select name, title, borrow_date 
from Borrowing 
	join Books on Borrowing.book_id = Books.book_id
    join Readers on Borrowing.reader_id = Readers.reader_id
    left join Returning on Returning.borrow_id = Borrowing.borrow_id
where Returning.borrow_id is null
order by borrow_date;

select name, title, borrow_date 
from Borrowing 
	join Books on Borrowing.book_id = Books.book_id
    join Readers on Borrowing.reader_id = Readers.reader_id
    left join Returning on Returning.borrow_id = Borrowing.borrow_id
where Returning.borrow_id is null;

select name, title
from Borrowing 
	join Books on Borrowing.book_id = Books.book_id
    join Readers on Borrowing.reader_id = Readers.reader_id
    join Returning on Returning.borrow_id = Borrowing.borrow_id
where Borrowing.borrow_date <= Returning.return_date;

select name, fine_amount
from Borrowing 
    join Readers on Borrowing.reader_id = Readers.reader_id
	join Returning on Borrowing.borrow_id = Returning.borrow_id
    join Fines on Returning.return_id = Fines.return_id
where fine_amount > 0;

select title, publication_year
from Books
where book_id = (
    select book_id
    from Borrowing
    group by book_id
    order by COUNT(*) desc
    limit 1
);