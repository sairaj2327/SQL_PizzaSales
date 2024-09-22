# Pizza Sales Analysis SQL Project

## Project Overview

**Project Title**: Pizza Sales Analysis  


This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a pizza sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who want to build a solid foundation in SQL.

## Objectives

1. **Set up a Pizza sales database**: Create and populate a pizza sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `d1.db`.
- **Table Creation**: 4 tables named `orders`, 'orders_details', 'pizzas', 'pizza_types' is created to store the sales data. The table structure includes columns for 'pizza_id', 'pizza_type_id', 'size',	'price', 'pizza_type_id', 'name',	'category', 'ingredients', 'order_id', 'date', 'time', 'order_details_id', 'order_id', 'pizza_id', 'quantity'.


```sql
CREATE DATABASE d1;

CREATE TABLE order_details
(
    order_details_id int not null,
    order_id int not null,
    order_date int not null,
    order_time int not null,
    primary key (order_id)
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Orders Count**: Find out how many orders are in the dataset.
- **Category Count**: Identify all unique pizza categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.


SELECT * FROM order_details
WHERE 
    order_details IS NULL OR order_id IS NULL OR pizza_id IS NULL OR 
    quantity IS NULL;

DELETE FROM order_details
WHERE 
   order_details IS NULL OR order_id IS NULL OR pizza_id IS NULL OR 
   quantity IS NULL;

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve the total number of orders placed**:
```sql
select count(order_id) as Total_Orders from orders
```

2. **Calculate the total revenue generated from pizza sales**:
```sql
select round(sum(orders_details.quantity*pizzas.price),2)
as Total_revenue
from orders_details
join  pizzas 
on
orders_details.pizza_id= pizzas.pizza_id
```

3. **Identify the highest-priced pizza.**:
```sql
select  pizza_types.name,
        pizzas.price
from pizza_types 
join pizzas 
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by price desc
limit 1
```

4. **Identify the most common pizza size ordered**:
```sql
select pizzas.size, count(orders_details.order_details_id) as Count
from pizzas
join orders_details
on pizzas.pizza_id = orders_details.pizza_id 
group by pizzas.size
order by count desc
```

5. **List the top 5 most ordered pizza types along with their quantities**:
```sql
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
```

6. **Join the necessary tables to find the total quantity of each pizza category ordered**:
```sql
select pizza_types.category as Category,
sum(orders_details.quantity)as Quantity
from pizza_types  
Join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
Join orders_details
on pizzas.pizza_id = orders_details.pizza_id
group by Category 
order by quantity desc
```

7. **Determine the distribution of orders by hour of the day**:
```sql
select hour(orders.order_time), count(orders.order_id)
from orders
group by hour(orders.order_time)
```

8. **Join relevant tables to find the category-wise distribution of pizzas**:
```sql
select pizza_types.category as Category, count(pizza_types.name)
from pizza_types
group by Category
```

9. **Group the orders by date and calculate the average number of pizzas ordered per day**:
```sql
select avg(Average_Pizzas)from
(select orders.order_date as Order_Date, round(sum(orders_details.quantity),2) as Average_Pizzas
from orders
join orders_details
on orders.order_id=orders_details.order_id
group by Order_Date)as Quantity_table
```

10. **Determine the top 3 most ordered pizza types based on revenue**:
```sql

select pizza_types.name as Name, sum(orders_details.quantity*pizzas.price) as Price
from orders_details
join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by Price desc
limit 3
```

11. **Calculate the percentage contribution of each pizza type to total revenue**:
```sql
select pizza_types.category, round((sum(orders_details.quantity*pizzas.price)/ 
(select sum(orders_details.quantity*pizzas.price)
from orders_details Join pizzas
on orders_details.pizza_id=pizzas.pizza_id))*100,2) as Revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join orders_details
on pizzas.pizza_id=orders_details.pizza_id
group by  pizza_types.category
order by Revenue desc
```

12. **Analyze the cumulative revenue generated over time**:
```sql
select order_date, sum(revenue) over (order by order_date)as Cumli_Rev from
(select orders.order_date,  sum(orders_details.quantity*pizzas.price)as revenue
from orders_details join pizzas
on orders_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id=orders_details.order_id
group by orders.order_date) as sales
```
13. **Determine the top 3 most ordered pizza types based on revenue for each pizza category**:
```sql
select name,Revenue,cate from
(select cate,name,Revenue, rank() over(partition by cate order by Revenue desc)as Rn
from
(select pizza_types.category as cate, pizza_types.name as name, sum(orders_details.quantity*pizzas.price)as Revenue
from orders_details
join pizzas
on orders_details.pizza_id=pizzas.pizza_id
join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
group by Cate, name) as a) as b
where Rn<=3
```


## Findings

- **Sales Demographics**: The dataset includes pizzas of various types, with sales distributed across different categories such as vegetarian and Non vegitarian.
- **High-Value Transactions**: Based on the date we had found top most selling items.
- **Sales Trends**: Daily analysis shows variations in sales, helping to identify repeatative items.
- **Product Insights**: The analysis identifies the top-spending pizzas and the most popular item in categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, order demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different days and pizza types.
- **Product Insights**: Reports on top Pizzas and unique counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns and product performance.

