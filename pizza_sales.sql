create database if not exists pizza_sales;
create table if not exists order_details 
(order_details_id int not null, order_id int not null, pizza_id varchar(100) not null, quantity int not null
);
create table if not exists order_time
(order_id int not null, order_date datetime not null, order_time time not null
);
create table if not exists pizza_type
(pizza_type_id varchar(100) not null, pizza_name varchar(200) not null, category varchar(50) not null, ingredients varchar(500) not null
);
create table if not exists pizza_menu
(pizza_id varchar(100) not null, pizza_type_id varchar(100) not null, pizza_size varchar(5) not null, price decimal(4,2)
);
 
-- total no of orders placed --

select count(order_id)
from order_details;

-- total revenue generated --
select sum(price*quantity)
from order_details
	join pizza_menu
	on order_details.pizza_id = pizza_menu.pizza_id;

-- highest priced pizza --
select pizza_type_id, price
from pizza_menu
group by pizza_type_id, price
order by price desc;

-- most common pizza size ordered --
select pizza_size, count(order_id) as cnt_order
from order_details
	join pizza_menu
	on order_details.pizza_id = pizza_menu.pizza_id
group by pizza_size
order by cnt_order desc;

-- top 5 most ordered pizza types along with their quantities --
select pizza_type_id, count(order_id) cnt_order, sum(quantity) as quan
from order_details
	join pizza_menu
	on order_details.pizza_id = pizza_menu.pizza_id
group by pizza_type_id
order by cnt_order desc
limit 5;

-- total quantity of each pizza category ordered -- 
select pizza_type_id, sum(quantity) as tot_qty
from pizza_menu
	join order_details
    on order_details.pizza_id = pizza_menu.pizza_id
    group by pizza_type_id
    order by tot_qty desc;
    
-- distribution of orders by hour of the day --
alter table order_time
add column hour_of_day varchar(10);

update order_time
set hour_of_day = 
	hour(order_time);

select * 
from order_time;

select hour_of_day, count(order_id) as cnt_orders
from order_time
group by hour_of_day
order by cnt_orders desc ;

-- category-wise distribution of pizzas --
select pizza_type_id, count(order_id) as cnt_orders, sum(quantity) as quan
from pizza_menu
	join order_details
	on order_details.pizza_id = pizza_menu.pizza_id
group by pizza_type_id
order by cnt_orders desc;

-- Group the orders by date and calculate --
-- average number of pizzas ordered per day -- 
select order_date, count(order_time.order_id) as cnt_orders, 
avg(quantity) as avg_qty_po, sum(quantity) as tot_qty, 
sum(quantity)/count(distinct order_time.order_date) as avg_qty_day
from order_time
	join order_details
    on order_time.order_id = order_details.order_id
group by order_date
order by order_date ;

-- average number of pizzas ordered per day -- 
select sum(quantity)/count(distinct order_time.order_date) as avg_qty_day
from order_time
	join order_details
    on order_time.order_id = order_details.order_id;

-- top 3 most ordered pizza types based on revenue
-- from sales perspective which pizza is the best selling --

select pizza_type_id, sum(price*quantity) as tot_rev
from pizza_menu
	join order_details
    on pizza_menu.pizza_id = order_details.pizza_id
   group by pizza_type_id
   order by tot_rev desc 
   limit 3;
   
-- Calculate the percentage contribution of each pizza type to total revenue  -- 

alter table order_details
add column revenue decimal(6,2);

update order_details
 join pizza_menu
 on order_details.pizza_id = pizza_menu.pizza_id
 join pizza_type
    on pizza_menu.pizza_type_id = pizza_type.pizza_type_id
set revenue = (
	price*quantity);
    
select * 
from order_details
 join pizza_menu
 on order_details.pizza_id = pizza_menu.pizza_id
 join pizza_type
    on pizza_menu.pizza_type_id = pizza_type.pizza_type_id;
 
 select sum(revenue)
from order_details
 join pizza_menu
 on order_details.pizza_id = pizza_menu.pizza_id;
 
 select category, (sum(revenue)/817860.05)*100 as pct_rev 
from pizza_type
    join pizza_menu
    on pizza_menu.pizza_type_id = pizza_type.pizza_type_id
	join order_details
	on order_details.pizza_id = pizza_menu.pizza_id
 group by category
 order by pct_rev desc;
 
 -- top 3 most ordered pizza types based on revenue for each pizza category --
 select category, pizza_name, sum(revenue) as tot_rev
 from pizza_type
    join pizza_menu
    on pizza_menu.pizza_type_id = pizza_type.pizza_type_id
	join order_details
	on order_details.pizza_id = pizza_menu.pizza_id
    group by category, pizza_name
    order by category, tot_rev desc
   ;
 
 
 
 -- Analyze the cumulative revenue generated over time --
 alter table order_time
 add column month_name varchar(30)
 ;
 
 update order_time
 set month_name = (
 monthname(order_date)
 );
 
 select *
 from order_details
	join order_time
    on order_details.order_id = order_time.order_id;
    

 select month_name, sum(revenue)
 from order_details
	join order_time
    on order_details.order_id = order_time.order_id
group by month_name;

-- --------- end ------------
       

 


