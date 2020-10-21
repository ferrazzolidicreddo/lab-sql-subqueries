-- Lab | SQL Intro
USE sakila;
SET SQL_SAFE_UPDATES = 0;

-- Show tables in the database.
SHOW TABLES FROM sakila;

-- Explore tables. (select everything from each table)
SHOW FULL TABLES;

SELECT * FROM sakila.actor;
SELECT * FROM address;
SELECT * FROM category;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT * FROM film_text;
SELECT * FROM inventory;
SELECT * FROM language;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM staff;
SELECT * FROM store;

-- Select one column from a table. Get film titles.
SELECT title AS Film_Titles FROM sakila.film;

-- Select one column from a table and alias it. Get languages.
SELECT name AS Film_Language FROM sakila.language;

-- How many stores does the company have? How many employees? which are their names?
SELECT Count(*) store FROM sakila.store;
SELECT Count(*) staff FROM sakila.staff;
SELECT first_name AS First_Name, last_name AS Last_Name FROM sakila.staff;

-- Lab | SQL Queries 2

-- Select all the actors with the first name ‘Scarlett’.
SELECT *, first_name AS First_Name FROM sakila.actor
WHERE first_name IN ('Scarlett');

-- Select all the actors with the last name ‘Johansson’.
SELECT *, last_name AS Last_Name FROM sakila.actor
WHERE last_name IN ('Johansson');

-- How many films (movies) are available for rent?
SELECT count(distinct(inventory_id)) AS Available FROM sakila.rental;

-- How many films have been rented?
SELECT count(rental_date) AS Rented_count FROM sakila.rental;

-- What is the shortest and longest rental period?
SELECT max(DATEDIFF(last_update, rental_date)) AS Rental_period, last_update AS Last_Update, rental_date AS Rental_date FROM sakila.rental;

-- What are the shortest and longest movie duration? Name the values max_duration and min_duration.
SELECT max(length) AS max_duration, min(length) AS min_duration FROM sakila.film;

-- What's the average movie duration?
SELECT avg(length) AS Average_duration FROM sakila.film;

-- What's the average movie duration expressed in format (hours, minutes)?
SELECT TIME_FORMAT(avg(length), '%T') AS Duration FROM sakila.film;

-- How many movies longer than 3 hours?
SELECT count(length) AS Long_movies FROM sakila.film
WHERE length > 180;

-- Get the name and email formatted. Example: Mary SMITH - mary.smith@sakilacustomer.org.
SELECT first_name, last_name, email, concat((left(first_name,1)), substr(lower(first_name),2),' ', last_name, ' - ', LOWER(email)) AS Formated FROM sakila.customer;

-- What's the length of the longest film title?
SELECT max(CHAR_LENGTH(TRIM(title))) AS Title_Length, title AS Title FROM sakila.film
ORDER BY title DESC;

-- Lab | SQL Queries 3

-- How many distinct (different) actors' last names are there?
SELECT count(distinct last_name) AS Surnames FROM sakila.actor;
 
-- In how many different languages where the films originally produced?
SELECT count(distinct original_language_id) AS Languages FROM sakila.film;

-- How many movies were not originally filmed in English?
SELECT count(distinct original_language_id) AS Languages FROM sakila.film
WHERE original_language_id NOT IN ('English');

-- Get 10 the longest movies from 2006.
SELECT length AS Movie_duration, title AS Title FROM sakila.film
WHERE release_year IN ('2006')
ORDER BY length DESC
LIMIT 10;

-- How many days has been the company operating (check DATEDIFF() function)?
SELECT length AS Movie_duration, title AS Title FROM sakila.film
WHERE release_year IN ('2006')
ORDER BY length DESC
LIMIT 10;

-- Show rental info with additional columns month and weekday. Get 20.
SELECT rental_date AS Rental_Date, MONTHNAME(rental_date) AS Month, DAYNAME(rental_date) AS Weekday FROM sakila.rental
LIMIT 20;

-- Add an additional column day_type with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT *,
CASE
	WHEN (DAYNAME(rental_date) IN ('Sunday' OR 'Saturday')) THEN "weekend"
	ELSE "workday"
END AS 'day_type'
FROM sakila.rental;

-- Alternative approach:
SELECT *,
CASE
	WHEN (dayofweek(rental_date)=6 OR dayofweek(rental_date)=7) THEN "weekend"
	ELSE "workday"
END AS 'day_type'
FROM sakila.rental;

-- How many rentals were in the last month of activity?

SELECT count(*) FROM sakila.rental
WHERE rental_date > '2006-01-14 15:16:03';


-- Lab | SQL Queries 4

-- Get film ratings.
SELECT title, rating FROM sakila.film;

-- Get release years.
SELECT title, release_year FROM sakila.film;

-- Get all films with ARMAGEDDON in the title.
SELECT title FROM sakila.film
WHERE title LIKE '%ARMAGEDDON%';

-- Get all films with APOLLO in the title
SELECT title FROM sakila.film
WHERE title LIKE '%APOLLO%';

-- Get all films which title ends with APOLLO.
SELECT title FROM sakila.film
WHERE title regexp 'APOLLO$';

-- Get all films with word DATE in the title.
SELECT * FROM sakila.film WHERE title LIKE '% DATE' OR title LIKE 'DATE %';
SELECT * FROM sakila.film WHERE title LIKE '%DATE%';

-- Get 10 films with the longest title.
SELECT title, (CHAR_LENGTH(TRIM(title))) AS Title_Length FROM sakila.film
WHERE CHAR_LENGTH(TRIM(title))
ORDER BY Title_length DESC
LIMIT 10;

-- Get 10 the longest films.
SELECT title, length AS Movie_Length FROM sakila.film
ORDER BY length DESC
LIMIT 10;

-- How many films include Behind the Scenes content?
SELECT count(special_features) FROM sakila.film
WHERE special_features LIKE '%Behind_the_Scenes%';

-- List films ordered by release year and title in alphabetical order.
SELECT * FROM sakila.film
ORDER BY release_year AND title ASC;

-- Lab | SQL Queries 5

-- Drop column picture from staff.
ALTER TABLE sakila.staff DROP picture;

-- A new person is hired to help Jon. Her name is TAMMY SANDERS,
-- and she is a customer. Update the database accordingly.
SELECT * FROM sakila.customer
WHERE first_name = 'TAMMY' AND last_name = 'SANDERS';

INSERT INTO staff(staff_id, first_name, last_name, address_id, email, store_id, active, username, password, last_update)
values (
3,
(select first_name FROM customer WHERE customer_id = 75),
(select last_name FROM customer WHERE customer_id = 75),
(select address_id FROM customer WHERE customer_id = 75),
(select email FROM customer WHERE customer_id = 75),
(select store_id FROM customer WHERE customer_id = 75),
(select active FROM customer WHERE customer_id = 75),
'TAMMY', NULL,'2006-02-15 04:57:20');

SELECT * FROM sakila.staff;

-- Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.
SELECT * FROM sakila.film
WHERE title IN ('Academy Dinosaur');

SELECT * FROM sakila.customer
WHERE first_name = 'Charlotte' AND last_name = 'Hunter';

SELECT * FROM sakila.staff;

SELECT * FROM sakila.store;

SELECT * FROM sakila.rental;

-- INSERT INTO rental(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
-- values (
-- (rental_id),
-- (current_date()),
-- (367),
-- (select customer_id FROM customer WHERE customer_id = 130),
-- (current_date()),
-- (select staff_id FROM staff WHERE store_id = 1),
-- (current_date())
-- );

INSERT INTO sakila.rental values(rental_id, current_date(), 1, 130, current_date(), 1, current_date());

SELECT * FROM sakila.rental
WHERE customer_id = 130;

DELETE FROM sakila.rental WHERE rental_id = 16051;

-- Delete non-active users, but first, create a backup table deleted_users 
-- to store customer_id, email, and the date the user was deleted.

SHOW FIELDS FROM rental;

CREATE TABLE deleted_users AS (SELECT customer_id, email, create_date, active 
FROM sakila.customer
WHERE active=0);

-- nsert into deleted_users(customer_id, email)
-- select customer_id, email
-- from customer
-- where active = 0;

DELETE FROM sakila.customer WHERE active = 0;

-- Lab | SQL Queries 6
-- We are going to do some database maintenance. We have received the film catalog for 2020. 
-- We have just one item for each film, and all will be placed in store 2. All other movies
-- will be moved to store 1. The rental duration will be 3 days, with an offer price of 2.99€
-- and a replacement cost of 8.99€. The catalog is in a CSV file named films_2020.csv that can
-- be found at files_for_lab folder.

-- Instructions
-- Add the new films to the database.

SHOW VARIABLES LIKE "secure_file_priv";
SET GLOBAL local_infile=1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW FIELDS FROM sakila.film;

CREATE TABLE film_2020
(title VARCHAR(128),
 description TEXT,
 release_year YEAR,
 language_id tinyint unsigned,
 original_language_id tinyint unsigned,
 length smallint unsigned,
 rating enum('G','PG','PG-13','R','NC-17'),
 special_features set('Trailers','Commentaries','Deleted Scenes','Behind the Scenes'));

load data infile 'C:\\Users\\redha\\Ironhack\\lab-sql-6\\files_for_lab\\films_2020.csv'
into table film_2020
fields terminated by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
(title, description, release_year, language_id, original_language_id, length, rating, special_features);

load data infile 'C:\\Users\\redha\\Ironhack\\lab-sql-6\\files_for_lab\\films_2020.csv'
into table film
fields terminated by ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
(title, description, release_year, language_id, original_language_id, length, rating, special_features);

-- Update inventory.
SHOW FIELDS FROM sakila.film;
SHOW FIELDS FROM sakila.rental;
SHOW FIELDS FROM sakila.inventory;
SHOW FIELDS FROM sakila.staff;
SHOW FIELDS FROM payment;

SELECT * FROM sakila.film
WHERE release_year = 2020;

INSERT INTO inventory(film_id)
SELECT film_id
	FROM film
    WHERE release_year = 2020;

ALTER TABLE inventory
ADD COLUMN release_year MEDIUMINT UNSIGNED AFTER film_id;

ALTER TABLE inventory
MODIFY film_id SMALLINT UNSIGNED DEFAULT 10;

INSERT INTO inventory(release_year)
	SELECT release_year
	FROM film;
    
UPDATE inventory
    SET store_id = 2
    WHERE release_year = 2020;
    
UPDATE inventory
    SET store_id = 1
	WHERE release_year <> 2020;
    
UPDATE film
    SET rental_duration = 3;

UPDATE film
    SET rental_duration = 3
    WHERE release_year <> 2020;
    
SELECT * FROM payment;

UPDATE payment
    SET amount = 2.99;

ALTER TABLE payment
ADD COLUMN replacement decimal(5,2) AFTER amount;

UPDATE payment
    SET replacement = 2.99;
 
 
-- Lab | SQL Queries 7

-- Which last names are not repeated?
SELECT distinct last_name AS Distinct_last_names, count(last_name) AS Unique_last_name from sakila.actor
GROUP BY last_name
HAVING Unique_last_name = 1
ORDER BY last_name;

-- Which last names appear more than once?
SELECT distinct last_name AS Distinct_last_names, count(last_name) AS Unique_last_name from sakila.actor
GROUP BY last_name
HAVING Unique_last_name > 1
ORDER BY last_name;

-- Rentals by employee.
SELECT * FROM sakila.rental;
SELECT * FROM sakila.staff;

SELECT distinct staff_id AS Distinct_staff_id, count(staff_id) AS Rentals_per_staff_id from sakila.rental
GROUP BY staff_id
ORDER BY staff_id;

-- Films by year.
SELECT * FROM sakila.film;

SELECT distinct film_id AS Distinct_film_id, count(release_year) AS Total_per_release_year, release_year from sakila.film
GROUP BY release_year
ORDER BY release_year DESC;

-- Films by rating.
SELECT count(release_year) AS Total_per_release_year, rating from sakila.film
GROUP BY rating
ORDER BY Total_per_release_year DESC;

-- Mean length by rating.
SELECT avg(length) AS Mean_length, rating from sakila.film
GROUP BY rating
ORDER BY Mean_length DESC;

-- Which kind of movies (rating) have a mean duration of more than two hours
SELECT avg(length) AS Mean_length, rating from sakila.film
GROUP BY rating
HAVING Mean_length > 120
ORDER BY Mean_length DESC;

-- List movies and add information of average duration for their rating and original language.
SELECT title, language_id, rating, length, avg(length) OVER (PARTITION BY rating) as mean_length
FROM sakila.film
ORDER BY rating, length, language_id;


-- Which rentals are longer than expected?

-- Expected duration of rentals = 3 days
SELECT * FROM sakila.rental;

SELECT customer_id, rental_id, DATEDIFF(return_date, rental_date) AS rental_duration FROM sakila.rental
GROUP BY inventory_id
HAVING rental_duration > 3
ORDER BY customer_id, rental_duration DESC, rental_id;


-- Lab | SQL Queries 8

-- Rank films by length.
SELECT film_id, title, length, RANK () OVER (ORDER BY length DESC) AS ranking FROM sakila.film;


-- Rank films by length within the rating category.
SELECT film_id, title, length, rating, RANK () OVER (PARTITION BY rating ORDER BY length DESC) AS ranking FROM sakila.film;

-- Rank languages by the number of films (as original language).
SELECT distinct original_language_id FROM sakila.film;

SELECT original_language_id, count(film_id) AS Total_films, DENSE_RANK () OVER (ORDER BY count(film_id) DESC) AS ranking FROM sakila.film
GROUP BY original_language_id
ORDER BY Total_films DESC;

-- Rank categories by the number of films.
-- SELECT count(film_id) AS Total_films, DENSE_RANK () OVER (ORDER BY count(film_id) DESC) AS ranking FROM sakila.category
-- GROUP BY catergory_id
-- ORDER BY Total_films DESC;

-- Which actor has appeared in the most films?
select actor.actor_id, actor.first_name, actor.last_name, count(film_id) AS actor_films from sakila.actor
inner join sakila.film_actor
on actor.actor_id = film_actor.actor_id
GROUP BY actor_id
ORDER BY actor_films DESC;

-- Most active customer.
select customer.customer_id, customer.first_name, customer.last_name, count(rental_id) AS customer_activity from sakila.customer
inner join sakila.rental
on customer.customer_id = rental.customer_id
GROUP BY customer_id
ORDER BY customer_activity DESC;

-- Most rented film.
SELECT * FROM sakila.film;
SELECT * FROM sakila.rental;


select film.film_id, film.title, inventory.inventory_id, count(rental_id) AS Freq_rental from sakila.film
inner join sakila.inventory
inner join sakila.rental
on film.film_id = inventory.film_id
GROUP BY film_id
ORDER BY Freq_rental DESC;


-- Lab | SQL Queries 9

-- Instructions
-- We will be trying to predict if a customer will be renting a film this month based 
-- on their previous activity and other details. We will first construct a table with:

-- Customer ID
-- City
-- Most rented film category
-- Total films rented
-- Total money spent

-- How many films rented last month and try to predict if he will be renting this month. 
-- Use date range (15/05/2005 - 30/05/2005) for last month and (15/06/2005 - 30/06/2005) for this month.


-- 1 - Customer ID
SELECT customer_id FROM sakila.customer;
SELECT count(customer_id) FROM sakila.customer;

-- 2 - City
SELECT city FROM sakila.city;
SELECT count(city) FROM sakila.city;

SELECT city_id FROM sakila.city;
SELECT count(city_id) FROM sakila.city;

-- FIRST JOIN
SELECT a.customer_id, c.city FROM sakila.customer AS a
JOIN sakila.address AS b ON a.address_id = b.address_id
JOIN sakila.city AS c ON b.city_id = c.city_id
GROUP BY customer_id
ORDER BY customer_id DESC;

-- 3 - Most rented film category
SELECT customer, category_name FROM
(SELECT rental.customer_id as customer, count(rental.rental_id) as total_rentals, film_category.category_id, category.name as category_name,
row_number() over (partition by rental.customer_id order by count(rental.rental_id) desc) as ranking_max_rented_category
FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY rental.customer_id, film_category.category_id, category.name) AS table_popular_category
WHERE ranking_max_rented_category = 1
ORDER BY customer;

-- 4 - Total films rented
SELECT * FROM sakila.rental;
SELECT count(distinct rental_id) FROM sakila.rental;
SELECT count(distinct inventory_id) FROM sakila.rental;

SELECT customer_id, count(rental_id) AS Rentals, inventory_id AS Inventory_id FROM sakila.rental
GROUP BY inventory_id
ORDER BY Rentals DESC;

SELECT customer_id, count(rental_id) AS Rentals FROM sakila.rental
GROUP BY customer_id
ORDER BY Rentals DESC;

-- 5 - Total money spent
SELECT customer_id, sum(amount) AS Total_money_spent from sakila.payment
GROUP BY customer_id
ORDER BY sum(amount) DESC;

-- 6 - How many films rented last month
SELECT count(rental_id) AS Rentals, rental_date, inventory_id AS Inventory_id FROM sakila.rental
GROUP BY inventory_id
HAVING rental_date > '2005-05-15 00:00:00' AND rental_date < '2005-05-31 00:00:00'
ORDER BY Rentals DESC;

SELECT customer_id, count(rental_id) AS Rentals, rental_date, inventory_id AS Inventory_id FROM sakila.rental
GROUP BY customer_id
HAVING rental_date >= '2005-05-15' AND rental_date <= '2005-05-31'
ORDER BY Rentals DESC;

SELECT customer_id, count(rental_id) AS Rentals, rental_date FROM sakila.rental
GROUP BY customer_id
HAVING rental_date >= '2005-05-15' AND rental_date <= '2005-05-31'
ORDER BY Rentals DESC;

-- Problem / Solution

SELECT customer_id,
CASE
WHEN (rental_date >= '2005-05-15' AND rental_date <= '2005-05-31') THEN count(rental_id)
ELSE 0
END AS Customer_rentals_1st_range
FROM sakila.rental
GROUP BY customer_id;

DROP TABLE rentals_on_1st_range;

CREATE TABLE rentals_on_1st_range AS (SELECT customer_id,
CASE
WHEN (rental_date >= '2005-05-15' AND rental_date <= '2005-05-31') THEN count(rental_id)
ELSE 0
END AS Customer_rentals_1st_range
FROM sakila.rental
GROUP BY customer_id);

SELECT * FROM sakila.rentals_on_1st_range;

SELECT customer_id,
CASE
	WHEN (Customer_rentals_1st_range > 0) THEN 1
	ELSE 0
END AS Customer_rentals_1st_range_binary
FROM sakila.rentals_on_1st_range;

# SELECT customer_id, Customer_rentals_1st_range_binary,
# CASE
# WHEN (Customer_rentals_1st_range > 0) THEN (Customer_rentals_range_binary = 1)
# ELSE (Customer_rentals_range_binary = 0)
# END AS Customer_rentals_1st_range_binary
# FROM sakila.rentals_on_1st_range
# GROUP BY customer_id;

# DROP TABLE rentals_on_1st_range_b;

CREATE TABLE rentals_on_1st_range_b AS (SELECT customer_id,
CASE
	WHEN (Customer_rentals_1st_range > 0) THEN 'YES'
	ELSE 'NO'
END AS Customer_rentals_1st_range_binary
FROM sakila.rentals_on_1st_range);

SELECT * FROM rentals_on_1st_range_b;


-- Range 2 ----------------------------------------

DROP TABLE sakila.rentals_on_2nd_range;

CREATE TABLE rentals_on_2nd_range AS (SELECT customer_id,
CASE
WHEN (rental_date >= '2005-06-15' AND rental_date <= '2005-07-01') THEN count(rental_id)
ELSE 0
END AS Customer_rentals_2nd_range
FROM sakila.rental
GROUP BY customer_id);

SELECT * FROM sakila.rentals_on_2nd_range;

SELECT customer_id,
CASE
	WHEN (Customer_rentals_2nd_range > 0) THEN 'YES'
	ELSE 'NO'
END AS Customer_rentals_2nd_range_binary
FROM sakila.rentals_on_2nd_range;

# SELECT customer_id, Customer_rentals_2nd_range_binary,
# CASE
# WHEN (Customer_rentals_2nd_range > 0) THEN (Customer_rentals_2nd_range_binary = 1)
# ELSE (Customer_rentals_2nd_range_binary = 0)
# END AS Customer_rentals_2nd_range_binary
# FROM sakila.rentals_on_2nd_range
# GROUP BY customer_id;

DROP TABLE rentals_on_2nd_range_b;

CREATE TABLE rentals_on_2nd_range_b AS (SELECT customer_id,
CASE
	WHEN (Customer_rentals_2nd_range > 0) THEN 'YES'
	ELSE 'NO'
END AS Customer_rentals_2nd_range_binary
FROM sakila.rentals_on_2nd_range);

SELECT * FROM rentals_on_2nd_range_b;


-- Lab | SQL Join

-- Instructions

-- List number of films per category.
SELECT * FROM sakila.film;
SELECT * FROM sakila.inventory;
SELECT * FROM sakila.category;
SELECT * FROM sakila.film_category;

SELECT category_id AS Categories, count(film_id) Total_films FROM sakila.film_category
GROUP BY category_id;

-- Display the first and last names, as well as the address, of each staff member.
SELECT * FROM sakila.staff;
SELECT * FROM sakila.address;

SELECT s.first_name, s.last_name, a.address, a.district, a.postal_code FROM sakila.staff AS s
JOIN sakila.address AS a
ON s.address_id = a.address_id;

-- Display the total amount rung up by each staff member in August of 2005.
SELECT * FROM sakila.payment;

SELECT staff_id, sum(amount) AS Total_amount FROM sakila.payment
WHERE payment_date >= '2005-08-01' AND payment_date < '2005-09-01'
GROUP BY staff_id
ORDER BY staff_id;

-- List each film and the number of actors who are listed for that film.
SELECT * FROM sakila.film;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;

SELECT film_id, count(actor_id) AS Total_Actors FROM sakila.film_actor
GROUP BY film_id;

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer.
SELECT c.customer_id, sum(p.amount) AS Total_paid
FROM sakila.payment AS p
JOIN sakila.customer AS c
ON p.customer_id = c.customer_id
GROUP BY customer_id
ORDER BY customer_id ASC; 

-- List the customers alphabetically by last name.
SELECT * FROM sakila.payment;
SELECT * FROM sakila.customer;

SELECT c.first_name, c.last_name, sum(p.amount) AS Total_payment FROM sakila.payment AS p
JOIN sakila.customer AS c
ON p.customer_id = c.customer_id
GROUP BY last_name
ORDER BY c.last_name ASC;

-- Lab | SQL Joins on multiple tables

-- Instructions

-- Write a query to display for each store its store ID, city, and country.
SELECT * FROM sakila.address;

SELECT s.store_id, a.address, a.city_id, ci.city, co.country FROM sakila.store AS s
JOIN sakila.address as a
ON s.address_id = a.address_id
JOIN sakila.city AS ci
ON a.city_id = ci.city_id
JOIN sakila.country AS co
ON ci.country_id = co.country_id;

-- Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, st.staff_id, round(sum(p.amount),0) AS Business_in_Dollars FROM sakila.payment AS p
JOIN sakila.staff AS st
ON p.staff_id = st.staff_id
JOIN sakila.store as s
ON st.store_id = s.store_id
GROUP BY store_id
ORDER BY store_id;

-- What is the average running time of films by category?
SELECT category_id AS Categories, avg(length) Average_length FROM sakila.film_category AS fc
JOIN sakila.film AS f
ON f.film_id = fc.film_id
GROUP BY category_id;

-- Which film categories are longest?
SELECT category_id AS Categories, avg(length) Average_length FROM sakila.film_category AS fc
JOIN sakila.film AS f
ON f.film_id = fc.film_id
GROUP BY category_id
ORDER BY Average_length DESC
LIMIT 3;

-- Display the most frequently rented movies in descending order.
SELECT f.film_id, count(r.rental_id) AS Total_rentals, f.title FROM sakila.rental AS r
JOIN sakila.inventory as i
ON r.inventory_id = i.inventory_id
JOIN sakila.film AS f
ON f.film_id = i.film_id
GROUP BY title
ORDER BY Total_rentals DESC
LIMIT 10;

-- List the top five genres in gross revenue in descending order.

SELECT * FROM sakila.film_category;
SELECT * FROM sakila.category;

SELECT c.name as "Category", sum(p.amount) as "Gross Revenue" FROM sakila.category as c
LEFT JOIN sakila.film_category AS fc
ON c.category_id = fc.category_id
LEFT JOIN sakila.inventory AS i
ON fc.film_id = i.film_id
LEFT JOIN sakila.rental AS r
ON i.inventory_id = r.inventory_id
LEFT JOIN sakila.payment as p
ON r.rental_id = p.rental_id
GROUP BY name
ORDER BY sum(p.amount) DESC
LIMIT 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
-- Yes.

SELECT f.title, f.film_id, r.inventory_id, r.rental_id, s.store_id, r.return_date FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
JOIN sakila.rental AS r
ON r.inventory_id = i.inventory_id
JOIN sakila.staff AS st
ON r.staff_id = st.staff_id
JOIN sakila.store AS s
ON st.store_id = s.store_id
WHERE s.store_id = 1 AND f.film_id = 1;

-- Lab | SQL Self and cross join

-- Instructions

-- Get all pairs of actors that worked together.
SELECT * FROM sakila.film;
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;

SELECT a1.actor_id AS Actor_1, ac1.first_name AS Actor_1_First_name,
	ac1.last_name AS Actor_1_Last_name, a2.actor_id AS Actor_2,
    ac2.first_name AS Actor_2_First_name, ac2.last_name AS Actor_2_Last_name
FROM sakila.film_actor AS a1
LEFT JOIN sakila.actor as ac1
ON a1.actor_id = ac1.actor_id
JOIN sakila.film_actor AS a2
ON a2.film_id = a1.film_id AND a1.actor_id < a2.actor_id
LEFT JOIN sakila.actor as ac2
ON a2.actor_id = ac2.actor_id
GROUP BY a1.actor_id, a2.actor_id;

-- Get all pairs of customers that have rented the same film more than 3 times.

SELECT customer_id, inventory_id, count(rental_id) FROM sakila.rental
GROUP BY inventory_id
HAVING (count(rental_id) > 3)
ORDER BY customer_id, inventory_id;

-- Partially working -- 
SELECT r.customer_id, i.film_id, count(r.rental_id) AS Rental_counter
FROM sakila.rental AS r
JOIN sakila.inventory as i
ON r.inventory_id = i.inventory_id
GROUP BY r.inventory_id
HAVING (count(r.rental_id) > 3) AND (count(Rental_counter) <> 1)
ORDER BY r.inventory_id, r.customer_id;

CREATE TEMPORARY TABLE sakila.rental_counter_3
SELECT r.customer_id, i.film_id, count(r.rental_id) AS Rental_counter
FROM sakila.rental AS r
JOIN sakila.inventory as i
ON r.inventory_id = i.inventory_id
GROUP BY r.inventory_id
HAVING (count(r.rental_id) > 3) AND (count(Rental_counter) <> 1)
ORDER BY r.inventory_id, r.customer_id;

-- SHOWING FANS x FILM (each 'fan' rented the same film more than 3 times)
SELECT customer_id, film_id, Rental_counter, count(film_id) AS Fans FROM sakila.rental_counter_3
GROUP BY film_id
HAVING Fans > 1
ORDER BY film_id;

-- Get all possible pairs of actors and films.

SELECT * FROM (SELECT distinct title FROM sakila.film) as b1
CROSS JOIN (SELECT distinct actor_id, first_name, last_name FROM sakila.actor) AS b2;


-- Lab | SQL Subqueries

-- Instructions

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM sakila.film;
SELECT * FROM sakila.inventory;

# Locating the film_id
SELECT film_id, title FROM sakila.film
WHERE title = 'Hunchback Impossible';

# Verifying the information
SELECT * FROM sakila.inventory
WHERE film_id = 439;

# Counting the number of copies
SELECT film_id, count(film_id) AS N_copies FROM sakila.inventory
WHERE film_id = 439;


-- List all films longer than the average.
# Overview
SELECT * FROM sakila.film;

# Checking the average length
SELECT avg(length) AS Average_length FROM sakila.film;

SET @v1 := (SELECT avg(length) AS Average_length FROM sakila.film);
SELECT @v1;

# Checking the individual Length
SELECT film_id, length FROM sakila.film
GROUP BY film_id;

# Checking films with length longer than the average
SELECT film_id, length FROM sakila.film
GROUP BY film_id
HAVING (length > @v1);
 
-- Use subqueries to display all actors who appear in the film Alone Trip.
# Locating the film_id
SELECT film_id, title FROM sakila.film
WHERE title = 'Alone Trip';

# Cheching the actors from the film
SELECT * FROM sakila.film_actor
WHERE film_id = 17;

# Combining the results
SELECT fa.actor_id, f.film_id, f.title
FROM sakila.film AS f
JOIN sakila.film_actor AS fa
ON f.film_id = fa.film_id
WHERE f.film_id = 17;

#Using subqueries
SELECT actor_id FROM (SELECT * FROM sakila.film_actor
WHERE film_id = 17) AS s1;

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
# Overview
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.film;
SELECT * FROM sakila.category;

# Finding the category_id 
SELECT * FROM sakila.category
WHERE name = 'Family';

#Using subqueries
SELECT film_id, category_id FROM (SELECT * FROM sakila.film_category
WHERE category_id = 8) AS s1;

#Using subqueries (with Film titles)
SELECT s1.category_id AS Category, s1.film_id, s2.title AS Film_title FROM (SELECT * FROM sakila.film_category
WHERE category_id = 8) AS s1
JOIN sakila.film AS s2
ON s1.film_id = s2.film_id;


-- Get name and email from customers from Canada using subqueries. Do the same with joins.
#Overview
SELECT * FROM sakila.customer;
SELECT * FROM sakila.store;
SELECT * FROM sakila.address;
SELECT * FROM city;
SELECT * FROM country;

# Finding which store is in Canada
SELECT st.store_id, st.address_id, a.city_id, c.country_id, co.country FROM sakila.store AS st
JOIN sakila.address AS a
ON st.address_id = a.address_id
JOIN sakila.city AS c
ON a.city_id = c.city_id
JOIN sakila.country AS co
ON c.country_id = co.country_id
WHERE country = 'Canada';

# Finding the canadian customers
SELECT first_name, last_name, email FROM sakila.customer
WHERE store_id = 1;

# Selecting the Canadian store
SELECT st.store_id FROM sakila.store AS st
JOIN sakila.address AS a
ON st.address_id = a.address_id
JOIN sakila.city AS c
ON a.city_id = c.city_id
JOIN sakila.country AS co
ON c.country_id = co.country_id
WHERE country = 'Canada';

# Selecting the Canadians based on the store location
SELECT cs.first_name, cs.last_name, cs.email, co.country FROM sakila.customer AS cs
JOIN sakila.store AS st
ON cs.store_id = st.store_id
JOIN sakila.address AS a
ON st.address_id = a.address_id
JOIN sakila.city AS c
ON a.city_id = c.city_id
JOIN sakila.country AS co
ON c.country_id = co.country_id
WHERE country = 'Canada';

-- Which are films starred by the most prolific actor?
# Overview
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.film;

# Selecting the most prolific actor
SELECT a.first_name, a.last_name, fa.actor_id, count(fa.film_id) AS Film_count, RANK() OVER(ORDER BY fa.actor_id ASC) AS ranking
FROM sakila.film_actor AS fa
JOIN sakila.actor AS a
ON fa.actor_id = a.actor_id
GROUP BY actor_id
ORDER BY Film_count DESC;

-- Films rented by most profitable customer.
# Overview
SELECT * FROM sakila.customer;
SELECT * FROM sakila.payment;
SELECT * FROM sakila.rental;
SELECT * FROM sakila.film;


#Finding the most profitable customer
SELECT customer_id, sum(amount) AS Customer_profit FROM sakila.payment
GROUP BY customer_id
ORDER BY Customer_profit DESC
LIMIT 1;

# Saving the customer_id as a variable
SET @v2 := (SELECT customer_id FROM sakila.payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1);
SELECT @v2;

# Finding inventory_id's of the films rented by the selected customer 
SELECT customer_id, inventory_id FROM sakila.rental
WHERE customer_id = @v2;

#Finding the films details
SELECT t1.customer_id, t3.film_id, t3.title FROM (SELECT customer_id, inventory_id FROM sakila.rental
WHERE customer_id = @v2) AS t1
JOIN sakila.inventory AS t2
ON t1.inventory_id = t2.inventory_id
JOIN sakila.film AS t3
ON t2.film_id = t3.film_id
ORDER BY film_id ASC;

-- Customers who spent more than the average.
# Overview
SELECT * FROM sakila.payment;

#Finding the revenue by customer
SELECT customer_id, sum(amount) AS Customer_revenue FROM sakila.payment
GROUP BY customer_id
ORDER BY Customer_revenue DESC;

# Finding the average
SELECT avg(Customer_revenue) FROM
(SELECT customer_id, sum(amount) AS Customer_revenue FROM sakila.payment
GROUP BY customer_id
ORDER BY Customer_revenue DESC) as sub1;

SET @v2 := (SELECT avg(Customer_revenue) FROM
(SELECT customer_id, sum(amount) AS Customer_revenue FROM sakila.payment
GROUP BY customer_id
ORDER BY Customer_revenue DESC) as sub1);
SELECT @v2;

#Finding the revenue of customer with higher than avg revenue
SELECT customer_id, sum(amount) AS Customer_revenue FROM sakila.payment
GROUP BY customer_id
HAVING Customer_revenue > @v2
ORDER BY Customer_revenue DESC;