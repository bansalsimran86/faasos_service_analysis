
--- Creating database 
CREATE DATABASE FAASOS;

--- For working with fasoos database
USE FAASOS;

--- Creating tables inside database and inserting values in them
DROP table if exists driver;

CREATE TABLE driver (
   driver_id INTEGER,
    reg_date DATE 
); 

INSERT INTO driver(driver_id,reg_date)  VALUES
(1,'2021-01-01'),
(2,'2021-01-03'),
(3,'2021-01-08'),
(4,'2021-01-15');

DROP table if exists ingredients;

CREATE TABLE ingredients (
    ingredients_id INTEGER,
    ingredients_name VARCHAR(60)
); 

INSERT INTO ingredients(ingredients_id ,ingredients_name)  VALUES 
(1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

DROP table if exists rolls;

CREATE TABLE rolls (
    roll_id INTEGER,
    roll_name VARCHAR(30)
); 

INSERT INTO rolls(roll_id ,roll_name)  VALUES 
(1 ,'Non Veg Roll'),
(2 ,'Veg Roll');

DROP table if exists rolls_recipes;

CREATE TABLE rolls_recipes (
    roll_id INTEGER,
    ingredients VARCHAR(24)
); 

INSERT INTO rolls_recipes(roll_id ,ingredients)  VALUES 
(1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

DROP table if exists driver_order;

CREATE TABLE driver_order (
    order_id INTEGER,
    driver_id INTEGER,
    pickup_time DATETIME,
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);

INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) VALUES
(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-01-03 00:12:37','13.4km','20 mins','NaN'),
(4,2,'2021-01-04 13:53:03','23.4','40','NaN'),
(5,3,'2021-01-08 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2021-01-08 21:30:45','25km','25mins',null),
(8,2,'2021-01-10 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2021-01-11 18:50:20','10km','10minutes',null);

DROP table if exists customer_orders;

CREATE TABLE customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    roll_id INTEGER,
    not_include_items VARCHAR(4),
    extra_items_included VARCHAR(4),
    order_date DATETIME
);

INSERT INTO
      customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
	  VALUES
(1,101,1,'','','2021-01-01  18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-01-02 23:51:23'),
(3,102,2,'','NaN','2021-01-02 23:51:23'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,2,'4','','2021-01-04 13:23:46'),
(5,104,1,null,'1','2021-01-08 21:00:29'),
(6,101,2,null,null,'2021-01-08 21:03:13'),
(7,105,2,null,'1','2021-01-08 21:20:29'),
(8,102,1,null,null,'2021-01-09 23:54:33'),
(9,103,1,'4','1,5','2021-01-10 11:22:59'),
(10,104,1,null,null,'2021-01-11 18:34:49'),
(10,104,1,'2,6','1,4','2021-01-11 18:34:49');

--- Reviewing the tables created inside the database
select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;

-- A. ROLL METRICS
-- B. DRIVER & CUSTOMER EXPERIENCE
-- C. INGREDIENT OPTIMISATION
-- D. PRICING & RATINGS

-- A - 1. HOW MANY ROLLS WERE ORDERED?
select count(*) as Total_Rolls from customer_orders;

-- A - 2(a). HOW MANY UNQIUE CUSTOMER ORDERS WERE MADE?
select count(distinct order_id) as Unique_Orders from customer_orders;

-- A - 2(b). HOW MANY UNQIUE CUSTOMER HAVE ORDERED ?
select count(distinct customer_id) as Unique_Customers from customer_orders;

-- A - 3(a). HOW MANY SUCCESFUL ORDERS WERE DELIVERED BY EACH DRIVER?
select Driver_ID,count(*) Successful_Orders
from driver_order 
where cancellation not like '%Cancel%'  
   or cancellation is null 
   or cancellation like '%nan%' 
   or cancellation = ' '
group by driver_id 
order by 1;

-- A - 3(b). HOW MANY SUCCESFUL ORDERS WERE DELIVERED BY ALL THE DRIVERS?
select count(order_id) Total_Successful_Orders from driver_order 
where cancellation not like '%Cancel%'  
   or cancellation is null 
   or cancellation like '%nan%' 
   or cancellation = ' ' ;

-- A - 4. HOW MANY EACH TYPE OF ROLL WAS DELIVERED?
select roll_id,count(*) as No_of_Rolls from 
(select roll_id,
         case when cancellation like '%Cancel%' then 'ns' else 's' end as check_s
 from driver_order d join customer_orders c on c.order_id=d.order_id)t1
 where check_s='s'
 group by roll_id
 order by roll_id;

-- A - 5. HOW MANY EACH TYPE OF ROLL WAS ORDERED BY EACH CUSTOMER?
select c.roll_id,
       r.roll_name,
	   count(*) as no_of_rolls 
from customer_orders c 
join rolls r 
on c.roll_id = r.roll_id
group by 
     c.roll_id,
	 r.roll_name;

--Q-6 What was the maximum number of rolls delivered in a single order?
select c.order_id,
       count(*) as no_of from  customer_orders c
join driver_order d 
on c.order_id = d.order_id
where cancellation  in  ('NaN',' ','NULL') or cancellation is null
group by c.order_id
order by no_of desc;

-- A - 7. FOR EACH CUTSOMER, HOW MANY DELIVERED ROLLS HAD AT LEAST 1 CHANGE AND HOW MANY HAD NO CHANGES?
SELECT customer_id,check_,count(*) 
FROM (select *, case 
				when (n1+e1)=1 or (n1+e1)=2 then 'c' 
                when (n1+e1)=0 then 'nc'                 
                else 'error'    
                end as check_ 
from (select customer_id , C.ORDER_id , not_include_items , extra_items_included , cancellation,
                case     
                when not_include_items is null or not_include_items = '' then 0
                else 1  
                end as n1,
		case     
		when extra_items_included is null  or extra_items_included = '' 
		   OR extra_items_included like '%NaN%' then 0
        ELSE 1  
        END as e1
 from customer_orders C 
 join driver_order d 
 on c.order_id=d.order_id
 WHERE cancellation not like '%cancel%'  or cancellation is null
 )T1  )t2
 group by customer_id,check_ 
 order by check_,customer_id;

-- A - 8. How many rolls were delivered that had both exclusions and extras?
SELECT check_ , count(*) 
FROM (select *, (e1+n1) as check_ 
from (select customer_id , C.ORDER_id , not_include_items , extra_items_included , cancellation,
                case     
                when not_include_items is null or not_include_items = '' then 0
                else 1  
                end as n1,
		case     
		when extra_items_included is null  or extra_items_included = '' 
		   OR extra_items_included like '%NaN%' then 0
        ELSE 1  
        END as e1
 from customer_orders C 
 join driver_order d 
 on c.order_id=d.order_id
 WHERE cancellation not like '%cancel%'  or cancellation is null
 )T1  )t2
 group by check_
 order by check_;

-- A - 9. The average distance for each customer?
select c.customer_id, avg(cast(trim(replace(d.distance,'km','')) as decimal)) as avg_distance from customer_orders c 
inner join driver_order d on c.order_id=d.order_id
where d.pickup_time is not null
group by customer_id;
-- A - 10. Reform duration column.
select duration, left(duration,CHARINDEX('m',duration)-1) 
from driver_order
where duration is not null

select duration 
from driver_order 
where duration is not null
-- A - 11. What was the total number of rolls ordered for each hour of the day?
select concat(hour(order_date),'-',(hour(order_date)+1))as each_hour,
	   count(*)  
from customer_orders group by 1 order by 1;
-- A - 12. What was the total number of orders ordered for each day of the week?
select dayname(order_date), count(distinct order_id)  
from customer_orders 
group by 1 
order by 1;

-- B - 1. What was avg time in minutes it took for each driver to arrive at fasoos HQ to pickup the order?
select driver_id, round(sum(dff1)/count(order_id),0) from
(select order_id,driver_id, minute(dff) dff1 from
(select distinct c.order_id,driver_id,order_date,pickup_time,timediff(pickup_time,order_date) dff
 from customer_orders c 
 join driver_order d on c.order_id=d.order_id 
 where pickup_time is not null)t1)t2
 group by 1;
-- OR-----------------------------------------------------------------------------
select driver_id, round(avg(dff1),0) from
(select order_id,driver_id, minute(dff) dff1 from
(select distinct c.order_id,driver_id,order_date,pickup_time,timediff(pickup_time,order_date) dff
 from customer_orders c 
 join driver_order d on c.order_id=d.order_id 
 where pickup_time is not null)t1)t2
 group by 1;

-- B - 2. is there any relation b/w no. of rolls & how long the order takes to prepare?
select Number_of_rolls,round((dff1/Number_of_rolls) ,0)as relation from
(select order_id, count(*) Number_of_rolls,minute(dff) dff1 from
(select c.order_id,driver_id,order_date,pickup_time,timediff(pickup_time,order_date) dff
 from customer_orders c 
 join driver_order d on c.order_id=d.order_id 
 where pickup_time is not null)t1  
 group by 1) t2
 group by 1;

-- B - 3. What was the average distance travelled for each customer?
select customer_id,avg(ND)  FROM
(select customer_id,case 
					when distance like '%km%' then REPLACE(DISTANCE, 'km', '') 
					else distance end as ND from
(select distinct c.order_id, distance, customer_id
 from customer_orders c 
 join driver_order d on c.order_id=d.order_id 
 where pickup_time is not null)t1)t2 group by 1;
 
 -- B - 4. What was the difference between the longest & shortest delivery times for all orders?
select max(duration_)-min(duration_) dff from 
(select *, case 
when duration like '%min%' then left(duration,2)
else duration end as duration_ 
from driver_order where pickup_time is not null)t1;

 -- B - 5. What was the average speed for each driver for each order?
select *, round((distance_/(duration_/60)),1) speed from
(select c.order_id,count(roll_id) cnt,driver_id,
				case 
				when distance like '%km%' then REPLACE(DISTANCE, 'km', '') 
				else distance end as distance_,
                      case 
                      when duration like '%min%' then left(duration,2)
                      else duration end as duration_
		from driver_order d join customer_orders c on c.order_id=d.order_id
		where pickup_time is not null
		group by 1,3,4,5)t1 order by 1;
        
 -- B - 6. What is the successful delivery % for each driver?
 select driver_id,sum(check_),count(order_id), sum(check_)/count(order_id)*100 from(select *, case 
           when cancellation like '%cancel%' then 0 else 1 end as check_ 
 from driver_order)t1
 group by 1;
 

-- Q.What was the avgtime in minutes it took for each driver to arrive at headquarters to pickup the order?

select driver_id, 
       count(driver_id) total_deliveries , 
	   round(avg(diff_) )
from
  (
    select distinct(dro.order_id), 
          dro.driver_id,
		  timestampdiff(minute,co.order_date,dro.pickup_time) as diff_
 from customer_orders co 
    join 
	  driver_order dro 
on 
      co.order_id=dro.order_id 
    and 
	  dro.pickup_time is not null
  ) time_diff 
group by 1 
order by 1;
 
create view diff_chart2 as
select distinct(dro.order_id) , 
       dro.driver_id,dro.pickup_time,
	   co.order_date,
       (minute(dro.pickup_time)-minute(co.order_date)) as diff_
 from customer_orders co 
    join 
	 driver_order dro 
on 
     co.order_id = dro.order_id
    and 
	 dro.pickup_time is not null;
 
select * from date_diff3;
 create view date_diff3 as select *, case 
 when hour(pickup_time) = hour(order_date) then diff_
 when hour(pickup_time) < hour(order_date) then (minute(order_date)-minute(pickup_time)-60)
else "error" end as diff_2  from diff_chart2; 
 
select driver_id,count(driver_id),  avg(diff3) from
(select *, case when diff_2 <0 then (diff_2*-1) 
                else diff_2  
                end as diff3 from date_diff3
				order by 1) diff_4 group by 1 order by 1 ;
                
select driver_id,count(driver_id),  round(avg(diff3)) from 
(select *, case 
		   when diff_2 <0 then (diff_2*-1) 
				else diff_2  end as diff3 from
(select *, case 
		   when hour(pickup_time) = hour(order_date) then diff_
		   when hour(pickup_time) < hour(order_date) then (minute(order_date)-minute(pickup_time)-60)
                else "error" end as diff_2  from
(select distinct(dro.order_id),dro.driver_id,dro.pickup_time,co.order_date,
				(minute(dro.pickup_time)-minute(co.order_date)) as diff_
from customer_orders co join driver_order dro on co.order_id=dro.order_id 
								and dro.pickup_time is not null) diff_chart2 ) date_diff3 ) diff_4 
                                group by 1 
                                order by 1 ;

-- Q. Is there any relationship between number of roll & how long the order takes to prepare?

select No_of_rolls,round(avg(diff_)) from(select order_id,driver_id,count(roll_id) No_of_rolls,diff_ from
(select dro.order_id , dro.driver_id,co.roll_id ,timestampdiff(minute,co.order_date,dro.pickup_time) as diff_
from customer_orders co 
join driver_order dro on co.order_id=dro.order_id and dro.pickup_time is not null) dif10 
    group by 1,2,4 order by 3) final_ch group by 1 order by 1;

-- Q. what was d avg distance travelled for each customer?

select customer_id, round(avg(trim_dist)) from
(select dro.order_id,co.customer_id,dro.distance, trim("km" from distance) trim_dist from driver_order dro
join customer_orders co on co.order_id=dro.order_id and dro.pickup_time is not null
group by 1) dis_ch group by 1 order by 1;

--- Q. longest & shortest diff ?

select *, case 
when duration like "%min%" then trim("mins" from duration)
when duration like "%minute%" then trim("minute" from duration)
when duration like "%minutes%" then trim("minutes" from duration)
else duration end trim_duration 
from driver_order where duration is not null;

select *, charindex('m',duration)-1 from driver_order;

 
 







