drop table if exists prices;
drop table if exists transactions;

create table prices 
	(
		item_id integer not null primary key,
	    price float not null 
	    	check (price > 0)
    );
   
create table transactions
	(
	  	transaction_id integer not null primary key, 
	   	item_id integer not null REFERENCES prices, 
	   	quantity integer not null 
	   		check (quantity > 0), 
	   	purchase_date date not null
	);
 
insert into prices 
	(item_id, price)
values 
	(1, 2),
	(2, 3);

insert into transactions 
	(transaction_id, item_id, quantity, purchase_date) 
values 
	(1, 1, 5, '2017-01-28'),
	(2, 2, 3, '2017-01-27'),
	(3, 2, 5, '2017-01-27'),
	(4, 2, 1, '2017-01-26'),
	(5, 2, 1, '2017-01-26'),
	(6, 2, 1, '2017-01-26'),
	(7, 2, 1, '2017-01-26'),
	(8, 2, 1, '2017-01-26'),
	(9, 2, 1, '2017-01-26'),
	(10, 2, 1, '2017-01-26'),
	(11, 2, 1, '2017-01-26'),
	(12, 2, 5, '2017-01-26'),
	(13, 2, 1, '2017-01-26'),
	(14, 2, 1, '2017-01-26'),
	(15, 2, 1, '2017-01-26'),
	(16, 2, 1, '2017-01-26'),
	(17, 2, 1, '2017-01-26'),
	(18, 2, 1, '2017-01-26'),
	(19, 2, 1, '2017-01-26'),
	(20, 2, 1, '2017-01-26'),
	(21, 2, 1, '2017-01-26'),
	(22, 2, 1, '2017-01-26'),
	(23, 2, 1, '2017-01-26');
	
-- 1. Total number, average and standard deviation of purchase quantities per weekday (Monday­Friday) ordered by descending number of purchases. 
select extract(isodow from purchase_date) as weekday, -- 1 = Monday 
	count(1) as number, 
	avg(quantity) as average, 
	round(stddev_samp(quantity),4) as st_deviation
from transactions 
group by weekday
order by number desc;

-- 2.Total revenue of items that are sold more than 20 times in 2017.
select sum(quantity * price) as revenue
from transactions t
	join prices p
		on p.item_id = t.item_id
where t.item_id in 
	(
		select item_id
		from transactions
		where date_part('year', purchase_date) = 2017
		group by item_id 
		having count(1) > 20
	);

-- 3. Date with the highest and lowest total purchase quantity.
with dates as 
	(
	select purchase_date, sum(quantity) as sum
	from transactions
	group by purchase_date
	)
	(
		select 
			'min_sales' as param, purchase_date, sum as quantity
		from dates
		order by sum asc
		limit 1
	)
union all 
	(
		select 
			'max_sales', purchase_date, sum
		from dates
		order by sum desc
		limit 1
	);

-- 4. For each item get the transaction_ID with the highest quantity.
-- assumption: if max quantity is the same for several trx_id, then multiple lines are in the result  
select t.item_id, transaction_id --, t.quantity
from transactions t 
	join 
	(
		select item_id, max(quantity) as quantity
		from transactions
		group by item_id
	) max
	on max.quantity = t.quantity 
		and max.item_id = t.item_id;


