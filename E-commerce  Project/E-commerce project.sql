/* SQL E-commerce Sales Analysis Project*/

--Analysis -1 Basic Data Retrieval.

--1. Retrieve all records from the customers table, displaying all available columns.
select *
from [customers]

--2. Fetch only the customer ID, first name, and email from the customers table.
select customer_id, first_name,email
from[customers]

--3. List all products that belong to the Clothing category. 
select*
from[products]
where category='clothing'

--4. Retrieve all orders where the total purchase amount is greater than 500.
select *
from[orders]
where total_amount>500

--5. Find all customers who joined the platform after January 1, 2023
select*
from [customers]
where join_date > '2023-01-01';

--6. Display the top 5 most expensive products available in the database. 
select top 5 product_name, price 
from[products]
order by price desc

--7 List the latest 10 orders placed, sorted by order date in descending order. 
select top 10 order_id,order_date 
from[orders]
order by order_date desc;

--8 Retrieve all orders that have a status of "Completed". 
select *
from[orders]
where order_status='completed'

--9. Find all orders that were placed between February 1, 2023, and February 28, 2023.
select *
from [orders]
where order_date between '2023-02-01' and '2023-02-28'

--10. List all products that have a price between 50 and 100.
select *
from [products]
where price between 50 and 100

/* Analysis -2 Aggregate Function . */

--1. Count the total number of customers in the database.
select count(customer_id)as total_customers
from[customers]

--2. Find the average order amount from the orders table.
select avg(total_amount)as avg_order_amount
from [orders]

--3. Retrieve the highest and lowest priced products from the product list. 
select top 1 product_name as lowest,price
from [products]
order by price;
select top 1 product_name as highest,price
from [products]
order by price desc;

-- 4. Count the number of products in each category, grouping by category.
select category,
      count(product_name)as count_no_of_product
from [products]
group by category

--5. Calculate the total revenue generated from all orders. 
select sum(total_amount)as total_revenue
from[orders]

--6. Find the total number of orders placed by each customer, sorted by highest to lowest. 
select customer_id,
      count (order_id)as total_no_of_orders
from [orders]
group by customer_id
order by total_no_of_orders desc;

--7 Calculate the total revenue generated for each month in 2023.
select year(order_date)as order_year,
       month(order_date)as order_month, 
       sum(total_amount)as total_revenue
from[orders]
where year(order_date)=2023
group by year(order_date),month(order_date)
order by order_month

--8 List all customers who have placed more than 5 orders. 
 select customer_id,
       count(order_id)as order_count
from[orders]
group by customer_id
having count (order_id)>5

--9. Identify the most frequently used payment method based on the number of transactions.
select top 1 payment_method,
       count(payment_id)as Transcation_id
from [payments]
group by payment_method
order by Transcation_id desc;

--10. Find the average product price for each category. 
select category,
       avg(price)as avg_price
from [products]
group by category
order by avg_price desc

/* Analysis- 3. Joins */

--1. Retrieve all order details along with the customer’s first and last name. 
select o.*, c.first_name,c.last_name
from orders as o
left join customers as c
on o.customer_id=c.customer_id

--2. Fetch order items with product names, quantities, and subtotal values 
select oi.*,p.product_name,p.product_id
from order_items as oi
left join products as p
on oi.product_id=p.product_id

--3. List all payment transactions along with the corresponding order details
select o.*,p.payment_method,p.payment_status
from orders as o
join payments as p 
on o.order_id=p.order_id


--4. Identify customers who have never placed an order 
select c.customer_id,c.first_name,c.last_name,o.order_id
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where o.order_id is null

--5. Find all products that have never been purchased.
select p.*,oi.order_id
from products as p
left join order_items as oi
on p.product_id=oi.product_id
where order_id is null;

--6. Retrieve customers and their total spending by summing up all their orders. 
select c.customer_id, sum(o.total_amount)as total_spending
from customers as c
inner join orders as o
on c.customer_id=o.customer_id
group by c.customer_id
order by total_spending desc;

--7 Get the total number of products ordered by each customer.
select c.customer_id,count(o.order_id)as total_product
from customers as c
inner join orders as o
on c.customer_id=o.customer_id
group by c.customer_id
order by total_product desc

--8 Display all orders along with the names of the products included in each order. 
select oi.*,p.product_name
from order_items as oi
left join products as p 
on oi.product_id=p.product_id

--9. Find orders that do not have any associated payments recorded. 
select o.*, p.payment_id
from orders as o
left join payments as p
on o.order_id=p.order_id
where payment_id is null

--10. Retrieve customers along with the last date they placed an order.
select c.customer_id, c.first_name, c.last_name, max(o.order_date) as last_date
from customers as c
inner join orders as o
on c.customer_id=o.customer_id
group by c.customer_id, c.first_name, c.last_name

/* Analysis- 4. Subqueries & Advanced Filters */

--1. Find the most expensive product in the store using a subquery. 
select*
from[products]
where price=(select max(price) from products)

--2. Retrieve the list of customers who have placed at least one order. 
select *
from [customers]
where customer_id in (select distinct customer_id from orders)

--3. Display orders where the total amount is greater than the average order amount. 
select*
from orders
where total_amount > (select avg(total_amount) from orders)

--4. Find the cheapest product in each category using a correlated subquery. 

select category,product_name,price as cheapest_product
from products as p1
where price=(
select min(price)
from products as p2
where p2.category=p1.category
)

--5. Identify the customer who has placed the highest number of orders
select * 
from [customers]
where customer_id=(select top 1 customer_id from orders
group by customer_id
order by count(order_id)desc)

--6. Fetch the second most expensive product using an alternative ranking method.
select *
from (
select *, rank() over (order by price desc)as rank
from products)as ranking
where ranking.rank  =2

--7 List all customers who have never made a payment for any order.
 select o.customer_id,p.payment_method,payment_status
 from orders as o
 left join payments as p
 on o.order_id=p.order_id
 where payment_method is null

 --8 Retrieve all products with stock levels below the average stock quantity.
 select *
 from [products]
 where stock_quantity <( select avg(stock_quantity) from products)
 order by stock_quantity desc

 --9. Find customers who have spent more than 2000 in total on orders.
 select customer_id,sum(total_amount)as amount
 from[orders]
 group by customer_id
 having sum(total_amount)>2000
