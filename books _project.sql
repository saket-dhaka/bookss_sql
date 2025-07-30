-- new project loading..

-- now going to create a new database .
create database newbii;

drop table if exists books1;
create table books1(
Book_id  serial primary key,
Title varchar(80),
Author varchar(30),
Gener varchar(20),
Published_year int,
Price numeric(10,2),
stock int
);
alter table books1
alter column title type varchar(80);

drop table if exists customers1;
create table customers1(
customer_id int primary key,
name varchar(30),
email varchar(50),
phone int,
city varchar(30),
country varchar(20)
);

alter table customers1
alter column country type varchar(60);

drop table if exists orders1;
create table orders1(
order_id serial primary key,
customer_id int,
book_id int,
order_date DATE,
quantity int,
total_amount numeric(10,2)
);


select*from books1;
select *from customers1;
select * from orders1;




/*ok now i have created the tables and imported all the data . now lets
perform data modelling and join these tables.*/

alter table orders1
add constraint fk_customer
foreign key(customer_id)
references customers1(customer_id);

alter table orders1
add constraint fk_book
foreign key(book_id)
references books1(book_id);


/* ok now just going to solve the questions */

-- 1) Retrieve all books in the "Fiction" genre:

select *from books1
where gener='Fiction';

-- 2) Find books published after the year 1950:
select *from books1
where published_year > '1950';

-- 3) List all customers from the Canada:
select *from customers1
where country='Canada';

-- 4) Show orders placed in November 2023:
select * from orders1 
where order_date between '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
select 
sum(stock)as total_stock
from books1;

-- 6) Find the details of the most expensive book:
select *from books1
order by price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from orders1
where quantity>1

-- 8) Retrieve all orders where the total amount exceeds $20:

select *from orders1
where total_amount>20;


-- 9) List all genres available in the Books table:

select distinct(gener)
from books1;

-- 10) Find the book with the lowest stock:
select * from books1
order by stock
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount)
from orders1;


-- now some advance sql questions

-- 1) Retrieve the total number of books sold for each genre:

select*from books1;
select *from customers1;
select * from orders1;

select 
b.gener,
sum(o.quantity)as total_books

from orders1 as o
join  
books1 as b
on b.book_id=o.book_id
group by 1

-- 2) Find the average price of books in the "Fantasy" genre:

select avg(price) from books1
where gener='Fantasy'

-- 3) List customers who have placed at least 2 orders:

select 
c.customer_id,
c.name,
count(o.order_id)as order_placed
from customers1 as c 
join orders1 as o on 
c.customer_id=o.customer_id
group by 1
having count(order_id)>=2

-- 4) Find the most frequently ordered book:


select 
b.title,
count(o.order_id) as frequently_ordered

from orders1 as o 
join books1 as b on 
o.book_id=b.book_id
group by 1 
order by frequently_ordered desc
limit 1

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select * from books1
where gener='Fantasy' 
order by price desc
limit 3


-- 6) Retrieve the total quantity of books sold by each author:

select 

b.author,
sum(o.quantity) as books_sold
from orders1 as o
join books1 as b on
o.book_id=b.book_id
group by 1


-- 7) List the cities where customers who spent over $30 are located:

select*from books1;
select *from customers1;
select * from orders1;


select 
c.city,
o.total_amount

from customers1 as c
join orders1 as o on 
o.customer_id=c.customer_id
group by 1,2
having o.total_amount >'30'


-- 8) Find the customer who spent the most on orders:

select*from books1;
select *from customers1;
select * from orders1;


select 
c.customer_id,
c.name,
sum(o.total_amount) as spent_most

from customers1 as c join 
orders1 as o on
c.customer_id=o.customer_id
group by 1
order by spent_most desc
limit 1


--9) Calculate the stock remaining after fulfilling all orders:

select*from books1;
select *from customers1;
select * from orders1;


select
b.book_id,
coalesce (sum(o.quantity),0)as total_orders,
b.stock- coalesce(sum(o.quantity),0) as remaining_stock
/*SUM(o.quantity) adds up all the order quantities for each book.
COALESCE(..., 0) means:
If there are no orders for that book, just show 0 instead of NULL.
*/
from books1 as b 
join orders1 as o 
on b.book_id=o.book_id
group by 1


