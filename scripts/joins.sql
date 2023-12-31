
-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT film_title, release_year, worldwide_gross
FROM specs
LEFT JOIN revenue
	USING (movie_id)
ORDER BY worldwide_gross
LIMIT 1;

--a: Semi-Tough, 1977, 3718739

-- 2. What year has the highest average imdb rating?
SELECT release_year, AVG(imdb_rating)
FROM specs
LEFT JOIN rating
	USING (movie_id)
GROUP BY release_year
ORDER BY AVG(imdb_rating) DESC;

--a: 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT film_title, mpaa_rating, company_name, worldwide_gross
FROM specs
INNER JOIN rating
	USING (movie_id)
INNER JOIN distributors
	ON specs.domestic_distributor_id = distributors.distributor_id
INNER JOIN revenue
	USING (movie_id)
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC;

--a: Toy Story4. Walt Disney

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. 
--Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT company_name, COUNT(film_title)
FROM distributors
LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY company_name
ORDER BY COUNT(film_title) DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT company_name
FROM specs
INNER JOIN distributors
	ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN revenue
	USING 	(movie_id)
GROUP BY company_name
ORDER BY AVG(film_budget) DESC
LIMIT 5;

-- "Walt Disney "
-- "Sony Pictures"
-- "Lionsgate"
-- "DreamWorks"
-- "Warner Bros."

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- SELECT headquarters, COUNT(film_title) AS title_count, MAX(imdb_rating) AS max_rating
-- FROM specs
-- INNER JOIN distributors
-- 	ON distributors.distributor_id = specs.domestic_distributor_id
-- INNER JOIN rating
-- 	USING 	(movie_id)
-- WHERE headquarters NOT LIKE '%CA%'
-- GROUP BY headquarters;
--above doesn't return titles--
-- ok if answer to part B is "the one from Chicago"

SELECT film_title, company_name AS company_not_in_CA, imdb_rating
FROM specs
INNER JOIN distributors
	ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN rating
	USING 	(movie_id)
WHERE headquarters NOT LIKE '%CA%'
ORDER BY imdb_rating DESC;

--a: 2, Dirty Dancing

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	'HIGHEST' TYPE,
	COUNT(film_title), 
	AVG(imdb_rating) AS avg_rating
FROM specs
LEFT JOIN rating
	USING (movie_id)
WHERE length_in_min >120
UNION
SELECT 
	'LOWEST' TYPE, 
	COUNT(film_title), 
	AVG(imdb_rating) AS avg_rating
FROM specs
LEFT JOIN rating
	USING (movie_id)
WHERE length_in_min <120;


