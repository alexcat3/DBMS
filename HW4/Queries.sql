/*Q1: Get the average length of films in each category, ordered by category name */
SELECT AVG(film.length), category.name
FROM film 
	INNER JOIN film_category USING(film_id)
		INNER JOIN category USING(category_id)
GROUP BY category_id
ORDER BY category.name;

/*Q2 Pt 1: Get the category with the longest average film length, and its length */
SELECT category.name, AVG(film.length)
FROM film
	INNER JOIN film_category USING(film_id)
		INNER JOIN category USING(category_id)
GROUP BY(category_id)
ORDER BY AVG(film.length) DESC
LIMIT 1;

/*Q2 Pt 2: Get the category with the shortest average film length, and its length */
SELECT category.name, AVG(film.length)
FROM film
	INNER JOIN film_category USING(film_id)
		INNER JOIN category USING(category_id)
GROUP BY(category_id)
ORDER BY AVG(film.length) ASC
LIMIT 1;

/*Which customers have rented action but not comedy or classic movies?*/
SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
	INNER JOIN rental USING(customer_id)
		INNER JOIN inventory USING(inventory_id)
			INNER JOIN film_category USING(film_id)
				INNER JOIN category USING(category_id)
WHERE category.name = "Action" 
	AND customer_id NOT IN (
		/*Get the ids of all customers that have rented comedy or classic movies*/
		SELECT DISTINCT customer_id
			FROM customer
				INNER JOIN rental USING(customer_id)
					INNER JOIN inventory USING(inventory_id)
						INNER JOIN film_category USING(film_id)
							INNER JOIN category USING(category_id)
		WHERE category.name = "Classics" OR category.name = "Comedy");
        
/*Get the name of the actor who has appeared in the most english language movies*/
SELECT actor.first_name, actor.last_name
FROM actor
	INNER JOIN film_actor USING(actor_id)
		INNER JOIN film USING(film_id)
			INNER JOIN language USING(language_id)
WHERE language.name = "English"
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1;

/*How many distinct movies were rented for exactly 10 days from the store where Mike worked?*/
SELECT COUNT(DISTINCT film_id)
FROM inventory
		INNER JOIN rental USING(inventory_id)
		INNER JOIN staff USING(store_id)
WHERE DATEDIFF(rental.return_date, rental.rental_date) = 10
	AND staff.first_name = "Mike";

/*Alphabetically list actors who appeared in the movie with the largest cast of actors*/
SELECT actor.first_name, actor.last_name
FROM film
	INNER JOIN film_actor USING(film_id)
		INNER JOIN actor USING(actor_id)
WHERE film_id = (
	/*Find the film with the largest cast of actors*/
    SELECT film_id
    FROM film
		INNER JOIN film_actor USING(film_id)
	GROUP BY film_id
    ORDER BY COUNT(actor_id) DESC
    LIMIT 1)
ORDER BY actor.last_name, actor.first_name;