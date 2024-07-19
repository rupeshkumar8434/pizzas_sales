create database pizzahut; 
use pizzahut;
create table orders(
 order_id int not null,
 order_date date not null,
 order_time time not null,
 primary key(order_id)
);

create table order_details(
 order_details_id int not null,
 order_id int not null,
 pizza_id text not null,
 quantity int not null,
 primary key(order_details_id)
);

select *from pizzahut.pizzas;

select *from pizzahut.order_details;


-- Q1 Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- Q2 Calculate the total revenue generated from pizza sales.
select 
round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas 
on pizzas.pizza_id = order_details.pizza_id;



-- Q3 Identify the highest-priced pizza.


select pizza_types.name , pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Q4 Identify the most common pizza size ordered.
select quantity ,count(order_details_id)
from order_details group by quantity;

select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size order by order_count desc;


-- Q5 List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by quantity limit 5;


-- Q6 Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,
sum(order_details.quantity)as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- Q7 Determine the distribution of orders by hour of the day.
select hour(order_time) as hour ,count(order_id) as order_count from orders
group by hour(order_time);

-- Q8 Join relevant tables to find the category-wise distribution of pizzas.
select category , count(name) from pizza_types
group by category ;


-- Q9 Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0)from
(select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id=order_details.order_id
group by orders.order_date) as order_quantity;


-- Q10 Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,
sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- Q11 Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date,
sum(order_details.quantity*pizzas.price)as revenue
from order_details join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.order_date) as sales;



