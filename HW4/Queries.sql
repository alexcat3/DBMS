/*Get the average length of films in each category, ordered by category name */
SELECT AVG(film.length), category.name
FROM film 
	INNER JOIN film_category USING(film_id)
		INNER JOIN category USING(category_id)
GROUP BY category_id
ORDER BY category.name;