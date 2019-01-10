-- SQL homework - NHUNG (JASMINE) TRAN
use sakila;
-- Display the first and last names of all actors from the table `actor`.
select first_name, last_name
from actor;
-- Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
select upper(concat(first_name,'',last_name)) as 'Actor_Name' from actor;
-- You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name='Joe';
-- Find all actors whose last name contain the letters `GEN`
select * from actor where last_name like '%GEN';
-- Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
select * from actor where last_name like '%LI' order by last_name, first_name;
-- Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country
where country in ('Afghanistan' , 'Bangladesh', 'China');
-- Add a `description` column to the table `actor`, and use the data type `BLOB`
alter table actor
add column description blob null default null; 
-- Now delete the `description` column.
alter table actor
drop column description; 
-- List the last names of actors, as well as how many actors have that last name.
select distinct 
    last_name, count(last_name) as 'name_count'
from
    actor
group by last_name;
-- List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select distinct
    last_name, count(last_name) as 'name_count'
from
    actor
group by last_name 
having name_count >= 2;
-- The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
update actor 
set 
    first_name = 'HARPO'
where
    first_name = 'GROUCHO'
        and last_name = 'WILLIAMS';
-- Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor 
-- is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
update actor 
set 
    first_name = 
		case
        when first_name = 'HARPO'
        then 'GROUCHO'
    end
where
    actor_id = 172;

-- You cannot locate the schema of the `address` table. 
-- Which query would you use to re-create it?
show create table address;
create table if not exists
 address (
 address_id smallint(5) unsigned not null auto_increment,
 address varchar(50) not null,
 address2 varchar(50) default null,
 district varchar(20) not null,
 city_id smallint(5) unsigned not null,
 postal_code varchar(10) default null,
 phone varchar(20) not null,
 location geometry not null,
 last_update timestamp not null default current_timestamp on update current_timestamp,
 primary key (address_id),
 key idx_fk_city_id (city_id),
 spatial key idx_location (location),
 constraint fk_address_city foreign key (city_id) references city (city_id) on update cascade
);

-- Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
select 
    staff.first_name, staff.last_name, address.address, city.city, country.country
from 
    staff
        inner join 
    address on staff.address_id = address.address_id 
		inner join
	city ON address.city_id = city.city_id
		inner join
	country on city.country_id = country.country_id;

-- Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
select 
    staff.first_name, staff.last_name, sum(payment.amount) as revenue_received
from
    staff
        inner join
    payment on staff.staff_id = payment.staff_id
where
    payment.payment_date like '2005-08%'
group by payment.staff_id;
  	
-- List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select 
    title, count (actor_id) as number_of_actors
from
    film
        inner join 
    film_actor on film.film_id = film_actor.film_id
group by title;
  	
-- How many copies of the film `Hunchback Impossible` exist in the inventory system?
select
    title, count(inventory_id) as number_of_copies
from
    film
        inner join
    inventory on film.film_id = inventory.film_id
where
    title = 'Hunchback Impossible';

-- Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select 
    last_name, first_name, sum(amount) as total_paid
from
    payment
        inner join
    customer on payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name asc;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
select title from film
where language_id in
	(select language_id 
	from language
	where name = "English" )
and (title like "K%") or (title like "Q%");

-- Use subqueries to display all actors who appear in the film `Alone Trip`.
select last_name, first_name
from actor
where actor_id in
	(select actor_id from film_actor
	where film_id in
		(select film_id from film
		where title = "Alone Trip"));
        
-- You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select 
    customer.last_name, customer.first_name, customer.email
from
    customer
        inner join
    customer_list on customer.customer_id = customer_list.ID
where
    customer_list.country = 'Canada';

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select 
    title
from
    film
where
    film_id in (select 
            film_id
        from
            film_category
        where
            category_id in (select 
                    category_id
                from
                    category
                where
                    name = 'Family'));

-- Display the most frequently rented movies in descending order.
select 
    film.title, count(*) AS 'rent_count'
from
    film,
    inventory,
    rental
where
    film.film_id = inventory.film_id
        and rental.inventory_id = inventory.inventory_id
group by inventory.film_id
order by count(*) desc, film.title asc;
  	
-- Write a query to display how much business, in dollars, each store brought in.
select 
    store.store_id, sum(amount) as revenue
from
    store
        inner join
    staff on store.store_id = staff.store_id
        inner join
    payment on payment.staff_id = staff.staff_id
group by store.store_id;

-- Write a query to display for each store its store ID, city, and country.
select
    store.store_id, city.city, country.country
from
    store
        inner join
    address on store.address_id = address.address_id
        inner join
    city on address.city_id = city.city_id
        inner join
    country on city.country_id = country.country_id;
  	
-- List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select 
    name, sum(p.amount) as gross_revenue
from
    category c
        inner join
    film_category fc on fc.category_id = c.category_id
        inner join
    inventory i on i.film_id = fc.film_id
        inner join
    rental r on r.inventory_id = i.inventory_id
        right join
    payment p on p.rental_id = r.rental_id
group by name
order by gross_revenue desc
limit 5;

-- In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
drop view if exists top_five_genres;
create view top_five_genres as
select 
    name, sum(p.amount) as gross_revenue
from
    category c
        inner join
    film_category fc on fc.category_id = c.category_id
        inner join
    inventory i on i.film_id = fc.film_id
        inner join
    rental r on r.inventory_id = i.inventory_id
        right join
    payment p on p.rental_id = r.rental_id
group by name
order by gross_revenue desc
limit 5;
  	
-- How would you display the view that you created in 8a?
select * from top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_five_genres;