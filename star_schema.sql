
--
select f.title, sum(p.amount) as revenue from payment as p
Join rental r on  p.rental_id=r.rental_id
Join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
group by f.title
order by sum(p.amount) desc


--
select p.payment_id, p.rental_id, p.amount, r.rental_id, r.inventory_id, i.film_id, f.title from payment as p
Join rental r on  p.rental_id=r.rental_id
Join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id

---
--
create table dimDate
(
     date_key integer NOT NULL PRIMARY KEY,
     date date NOT NULL,
     year smallint NOT NULL,
     quarter smallint NOT NULL,
     month smallint NOT NULL,
     day smallint NOT NULL,
     week smallint NOT NULL,
     is_weekend boolean
);
---

select column_name,data_type from information_schema.columns where table_name ='dimdate'
---
drop table dimCustomer

create table dimCustomer
(
     Customer_key SERIAL PRIMARY KEY,
     Customer_id smallint NOT NULL,
     First_name varchar(45) NOT NULL,
     Last_name varchar(45) NOT NULL,
	 email varchar(50),
     address varchar(50) NOT NULL,
     address2 varchar(50),
     district varchar(20) NOT NULL,
	 city varchar(50) NOT NULL,
	 country varchar(50) NOT NULL,
	 postal_code varchar(10),
	 phone varchar(20) NOT NULL,
	 active smallint NOT NULL,
	 create_date timestamp NOT NULL,
	 start_date date NOT NULL,
	 end_date date NOT NULL
);

---
create table dimMovie
(
     Movie_key SERIAL PRIMARY KEY,
     film_id smallint NOT NULL,
     title varchar(255) NOT NULL,
     description text,
	 release_year year,
     language varchar(20) NOT NULL,
     original_language varchar(20),
     rental_duration smallint NOT NULL,
	 length smallint NOT NULL,
	 rating varchar(5) NOT NULL,
	 special_features varchar(60) NOT NULL
);

create table dimStore
(
     Store_key SERIAL PRIMARY KEY,
     Store_id smallint NOT NULL,
     address varchar(50) NOT NULL,
     address2 varchar(50),
     district varchar(20) NOT NULL,
	 city varchar(50) NOT NULL,
	 country varchar(50) NOT NULL,
	 postal_code varchar(10),
	 manager_first_name varchar(45) NOT NULL,
	 manager_last_name varchar(45) NOT NULL,
	 start_date date NOT NULL,
	 end_date date NOT NULL
);


insert into dimDate
(date_Key, date, year, quarter, month, day, week, is_weekend)
select 
        distinct(to_char(payment_date :: date, 'yyyMMDD')::integer) as date_key,
        date(payment_date) as date,
        extract(year from payment_date) as year,
        extract (quarter from payment_date) as quarter,
		extract (month from payment_date) as month,
		extract (day from payment_date) as day,
		extract (week from payment_date) as week,
	    case when extract (ISODOW from payment_date) in (6,7) then true else false end
from payment;

select * from payment limit 10;
20070215

select * from dimDate;

insert into dimcustomer (Customer_key, Customer_id, First_name, Last_name, email, address, address2,district, city,
	 country,
	 postal_code,
	 phone,
	 active,
	 create_date,
	 start_date,
     end_date)
select c.customer_id as Customer_key,
       c.customer_id,
       c.First_name,
       c.Last_name,
	   c.email,
       a.address,
       a.address2,
       a.district,
	   ci.city,
	   co.country,
	   postal_code,
	   a.phone,
	   c.active,
	   c.create_date,
	  now()        as start_date,
	  now()        as end_date
from customer c
join address a on (c.address_id = a.address_id)
join city ci on (a.city_id = ci.city_id)
join country co on (ci.country_id = co.country_id);
----
insert into dimStore
(
     Store_key,
     Store_id,
     address,
     address2,
     district,
	 city,
	 country,
	 postal_code,
	 manager_first_name,
	 manager_last_name,
	 start_date,
	 end_date 
)
select s.store_id as store_key,
       s.store_id,
       st.First_name,
       st.Last_name,
	   st.email,
       a.address,
       a.address2,
       a.district,
	   c.city,
	   co.country,
	   postal_code, 
	   st.last_name ,
	  now()        as start_date,
	  now()        as end_date
from store s
join staff st  on (s.manager_staff_id = st.staff_id)
join address a on (s.address_id = a.address_id)
join city c on (a.city_id = c.city_id)
join country co on (c.country_id = co.country_id);



select * from staff
select * from store
select * from address

 create table factsales
 (
    sales_key serial primary key,
    date_key integer references dimDate(date_key),
    customer_key integer references dimCustomer(customer_key),
    movie_key integer references dimMovie(movie_key),
    store_key integer references dimStore (store_key),
    sales_amount numeric);

insert into factsales( date_key, customer_key, movie_key, store_key, sales_amount)
select sales_key
       to_char(payment_date :: Date, 'yyyyMMDD'):: integer as date_key,
	   p.customer_id as customer_key,
	   i.film_id as movie_key,
	   i.store_id as store_key,
	   p.amount as sales_amount
from payment p
join rental r on (p.rental_id = r.rental_id)
join inventory i on (r.inventory_id = i.inventory_id);
