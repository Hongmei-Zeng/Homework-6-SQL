USE sakila;

/*1a*/
SELECT first_name, last_name
FROM actor;

/*1b*/
SELECT first_name, last_name, CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS actor_name
FROM actor;

/*2a*/
SELECT actor_ID, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

/*2b*/
SELECT *
FROM actor
WHERE last_name LIKE '%GEN%';

/*2c*/
SELECT *
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;

/*2d*/
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/*3a*/
ALTER TABLE actor
ADD description BLOB;

/*3b*/
ALTER TABLE actor
DROP COLUMN description;

/*4a*/
SELECT last_name, COUNT(last_name) AS number_of_the_last_name
FROM actor
GROUP BY last_name;

/*4b*/
SELECT last_name, COUNT(last_name) AS num_last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>=2;

/*4c*/
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

/*4d*/
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name='HARPO' AND last_name='WILLIAMS';

/*5a*/
DESC address;

/*6a*/
SELECT s.first_name, s.last_name, a.address 
FROM staff s
JOIN address a
ON s.address_id = a.address_id;

/*6B*/
SELECT s.staff_id, s.username, sum(p.amount) AS total_amount
FROM staff s
JOIN payment p USING(staff_id)
WHERE YEAR(p.payment_date)=2005 AND MONTH(p.payment_date)=8
GROUP BY p.staff_id;

/*6C*/
SELECT f.title, count(fa.actor_id) AS num_actors
FROM film f
JOIN film_actor fa USING(film_id)
GROUP BY fa.film_id;

/*6d*/
SELECT f.title, count(i.film_id) AS num_copies
FROM film f
JOIN inventory i USING(film_id)
WHERE f.title = 'Hunchback Impossible'
GROUP BY i.film_id;

/*6e*/
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_amount
FROM payment p
JOIN customer c USING(customer_id)
GROUP BY p.customer_id
ORDER BY c.last_name; 

/*7a*/
SELECT f.title
FROM film f
WHERE f.title LIKE 'K%' OR f.title LIKE 'Q%'
AND f.language_id = 
	(SELECT l.language_id
     FROM language l
     WHERE l.name='English');

/*7b*/
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
WHERE fa.film_id =
	(SELECT f.film_id
     FROM film f
     WHERE f.title='Alone Trip');

/*7c*/
SELECT cu.first_name, cu.last_name, cu.email
FROM customer cu
JOIN address a USING(address_id) 
JOIN city ci USING(city_id)
JOIN country co USING(country_id) 
WHERE co.country = 'Canada';

/*7d*/
SELECT f.title
FROM film f
JOIN film_category fc USING(film_id)
JOIN category c USING(Category_id)
WHERE c.name = 'Family';

/*7e*/
SELECT f.title, sum(inv_rental.num_rented) AS total_num_rented
FROM film f
JOIN (SELECT i.inventory_id, i.film_id, count(r.inventory_id) AS num_rented
	  FROM inventory i
	  JOIN rental r ON i.inventory_id=r.inventory_id
	  GROUP BY r.inventory_id) AS inv_rental ON inv_rental.film_id=f.film_id
GROUP BY inv_rental.film_id
ORDER BY total_num_rented DESC;

/*7f*/
SELECT store.store_id, sum(amount) AS total_rental_amount
FROM store
JOIN staff USING(store_id)
JOIN payment USING(staff_id)
GROUP BY payment.staff_id;

/*7g*/
SELECT st.store_id, ci.city, co.country
FROM store st
JOIN address ad USING(address_id) 
JOIN city ci USING(city_id)
JOIN country co USING(country_id);

/*7h*/
SELECT c.name AS Top_Genres, sum(ren_pay.sum_amount) AS Gross_Revenue
FROM category c
JOIN film_category fc USING(category_id)
JOIN inventory i USING(film_id)
JOIN (SELECT r.inventory_id, p.customer_id, sum(p.amount) AS sum_amount
	  FROM payment p
	  JOIN rental r USING(customer_id)
	  GROUP BY p.customer_id, r.inventory_id) AS ren_pay ON i.inventory_id=ren_pay.inventory_id
GROUP BY i.film_id, fc.category_id
ORDER BY Gross_Revenue DESC
LIMIT 5;

/*8a*/
/*DROP VIEW IF EXISTS Top_5_Genres;*/
CREATE VIEW Top_5_Genres AS
SELECT Top_Genres, Gross_Revenue
FROM 
(SELECT c.name AS Top_Genres, sum(ren_pay.sum_amount) AS Gross_Revenue
FROM category c
JOIN film_category fc USING(category_id)
JOIN inventory i USING(film_id)
JOIN (SELECT r.inventory_id, p.customer_id, sum(p.amount) AS sum_amount
	  FROM payment p
	  JOIN rental r USING(customer_id)
	  GROUP BY p.customer_id, r.inventory_id) AS ren_pay ON i.inventory_id=ren_pay.inventory_id
GROUP BY i.film_id, fc.category_id
ORDER BY Gross_Revenue DESC
LIMIT 5) AS top_genres_rev;

/*8b*/
SELECT * FROM Top_5_Genres;

/*8c*/
DROP VIEW Top_5_Genres;