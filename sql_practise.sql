with new_table as (
Select DISTINCT A.customer_id
	,A.first_name
	,A.last_name
	,B.address_id
	,B1.city
	,C.country
	
FROM 
	Customer A 
LEFT JOIN
	address B
ON A.address_id = B.address_id
LEFT JOIN 
	city B1
ON B.city_id = B1.city_id
LEFT JOIN 
	country C 
ON B1.country_id = C.country_id
LEFT JOIN 
	payment D 
ON A.customer_id = D.customer_id
		
	
),

payment_data as (
Select A.*
	,B.amount
	,B.payment_date
	,C.inventory_id
	
FROM 
	new_table A
LEFT JOIN 
	payment B
ON A.customer_id = B.customer_id
LEFT JOIN 
	rental C 
ON A.customer_id = C.customer_id AND B.rental_id = C.rental_id
	
),

/*
store_details as (Select inv.inventory_id
,film.title
,store.store_id
,store.address_id
from 
inventory inv
LEFT  JOIN 
film
ON inv.film_id = film.film_id
LEFT JOIN 
store 
ON inv.store_id = store.store_id
),
*/

master_data as (
Select DISTINCT A.customer_id
,A.first_name
,A.last_name
,A.city
,A.country
,B.amount
From 
(Select DISTINCT customer_id
	,first_name
	,last_name
	,city
	,country
	,address_id
	,inventory_id
from 
payment_data ) A 
LEFT JOIN 
(select customer_id , sum(amount) as amount
from payment_data
GROUP by 1) B 
on A.customer_id = B.customer_id
)

select * from master_data


