USE sakila;

#-----------------------1--------------------------
/*Question 1. 36 rows returned*/
SELECT DATE(rental_date) AS 'Rental Date', COUNT(*) AS 'Total Rent'
FROM rental
GROUP BY LEFT(rental_date, 10)
HAVING COUNT(*) > 100;

/*Question 2. 10 rows returned*/
SELECT CONCAT(last_name, ', ', first_name) AS Name, LEFT(rental_date, 7) AS `Date`, COUNT(*) AS `Count`
FROM rental 
	JOIN staff
		USING(staff_id)
GROUP BY Name, YEAR(rental_date), MONTH(rental_date)
ORDER BY Name, `Count` DESC;

/*Question 3. 5 rows returned*/
SELECT YEAR(payment_date) AS `Year`, MONTH(payment_date) AS `Month`, SUM(amount) AS `Total`
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY YEAR(payment_date) DESC, MONTH(payment_date) DESC;

/*Question 4. 46 rows returned*/
SELECT CONCAT(last_name, ', ', first_name) AS Name, district, COUNT(*) AS 'Count', SUM(amount) AS 'Total'
FROM payment
	JOIN customer
		USING (customer_id)
	JOIN address
		USING (address_id)
GROUP BY Name
HAVING SUM(amount) >= 150
ORDER BY Name;

/*Question 5. 2 rows returned*/
SELECT COUNT(*) AS 'Film Count', category.name AS Category
FROM film
	JOIN film_category
		USING (film_id)
	JOIN category
		USING (category_id)
GROUP BY Category
HAVING COUNT(*) > 70
ORDER BY COUNT(*) DESC;

#--------------------------2--------------------------------
/*Question 6. 3 rows returned*/
SELECT city
FROM city
	JOIN country 
		USING (country_id)
WHERE city LIKE '%south%' AND country_id IN (  SELECT country_id
											   FROM country
											   WHERE country LIKE '%united%');
                                                                                            
/*Question 7. 107 rows returned*/
SELECT customer_id, first_name, last_name, email
FROM customer
WHERE customer_id IN (	SELECT customer_id
						FROM payment
						WHERE amount >= 10);
	
/*Question 8. 15 rows returned*/
SELECT DISTINCT category.name
FROM film
	JOIN film_category
		USING (film_id)
	JOIN category
		USING (category_id)
WHERE film_id IN (  SELECT film_id
					FROM film
					WHERE length > 180);
                    
/*Question 9. 2 rows returned*/
SELECT DISTINCT city
FROM city
	JOIN address
		USING (city_id)
	JOIN store
		USING (address_id)
	JOIN inventory
		USING (store_id)
	JOIN film
		USING (film_id)
WHERE film_id = (   SELECT film_id
					FROM film
					WHERE title = 'Airplane Sierra');
                    
/*Question 10. 6 rows returned*/
SELECT last_name, first_name, COUNT(*)
FROM actor
	JOIN film_actor
		USING (actor_id)
	JOIN film
		USING (film_id)
	JOIN film_category
		USING (film_id)
	JOIN category 
		USING (category_id)
WHERE category_id IN (	SELECT category_id
						FROM film
							JOIN film_category
								USING (film_id)
							JOIN category
								USING (category_id)
						GROUP BY category_id
						HAVING COUNT(*) > 60)
GROUP BY actor_id
HAVING COUNT(*) > 25;