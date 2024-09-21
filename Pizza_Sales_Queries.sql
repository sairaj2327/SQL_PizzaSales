/* Retrieve the total number of orders placed */

select count(order_id) as Total_Orders from orders



/*Calculate the total revenue generated from pizza sales*/

select round(sum(orders_details.quantity*pizzas.price),2) as Total_revenue from orders_details
join  pizzas 
on orders_details.pizza_id= pizzas.pizza_id



/*Identify the highest-priced pizza.*/

select pizza_types.name,pizzas.price from pizza_types 
join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id order by price desc limit 1



/*Identify the most common pizza size ordered*/

select pizzas.size, count(orders_details.order_details_id) as Count
from pizzas join orders_details
on pizzas.pizza_id = orders_details.pizza_id 
group by pizzas.size
order by count desc



/*List the top 5 most ordered pizza types along with their quantities*/

select pizza_types.name , sum(orders_details.quantity) as Quantity 
from pizza_types 
join pizzas
on
pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details
on
pizzas.pizza_id = orders_details.pizza_id
group by pizza_types.name 
order by Quantity desc limit 5



/*Join the necessary tables to find the total quantity of each pizza category ordered*/

select pizza_types.category as Category, sum(orders_details.quantity)as Quantity from pizza_types  
Join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
Join orders_details
on pizzas.pizza_id = orders_details.pizza_id
group by Category 
order by quantity desc



/* Determine the distribution of orders by hour of the day */

select hour(orders.order_time), count(orders.order_id) from orders
group by hour(orders.order_time)



/* Join relevant tables to find the category-wise distribution of pizzas */

select pizza_types.category as Category, count(pizza_types.name)
from pizza_types
group by Category



/* Group the orders by date and calculate the average number of pizzas ordered per day */

select avg(Average_Pizzas)from
(select orders.order_date as Order_Date, round(sum(orders_details.quantity),2) as Average_Pizzas
from orders join orders_details
on orders.order_id=orders_details.order_id
group by Order_Date)as Quanity_table



/*Determine the top 3 most ordered pizza types based on revenue */

select pizza_types.name as Name, sum(orders_details.quantity*pizzas.price) as Price from orders_details
join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by Price desc
limit 3



/*Calculate the percentage contribution of each pizza type to total revenue */

select pizza_types.category, round((sum(orders_details.quantity*pizzas.price)/ 
(select sum(orders_details.quantity*pizzas.price)
from orders_details Join pizzas
on orders_details.pizza_id=pizzas.pizza_id))*100,2) as Revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details
on pizzas.pizza_id=orders_details.pizza_id
group by  pizza_types.category
order by Revenue desc



/*Analyze the cumulative revenue generated over time */

select order_date, sum(revenue) over (order by order_date)as Cumli_Rev from
(select orders.order_date,  sum(orders_details.quantity*pizzas.price)as revenue
from orders_details join pizzas
on orders_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=orders_details.order_id
group by orders.order_date) as sales



/*Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/
select name,Revenue,cate from
(select cate,name,Revenue, rank() over(partition by cate order by Revenue desc)as Rn from
(select pizza_types.category as cate, pizza_types.name as name, sum(orders_details.quantity*pizzas.price)as Revenue
from orders_details join pizzas
on orders_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by Cate, name) as a) as b
where Rn<=3

