-- Stored Functions

-- Example - We are often asked to get the count of actord who have a last name starting with _

SELECT count(*) 
FROM actor a 
WHERE last_name LIKE 'A%'; --7

SELECT count(*) 
FROM actor 
WHERE last_name LIKE 'B%'; --22

SELECT count(*) 
FROM actor 
WHERE last_name LIKE 'C%'; --15

-- Create a Stored Function that will give the count of actors 
-- with a last name starting with *letter*

CREATE OR REPLACE FUNCTION get_actor_count(letter varchar(1))
RETURNS integer
LANGUAGE plpgsql
AS $$
	DECLARE actor_count integer;
BEGIN 
	SELECT count(*) INTO actor_count
	FROM actor 
	WHERE last_name LIKE concat(letter, '%');
RETURN actor_count;
END;
$$;

-- execute the function
SELECT get_actor_count('A');
SELECT get_actor_count('B');
SELECT get_actor_count('C');


-- To delete a stored function, use the DROP command
-- DROP FUNCTION IF EXISTS function name *if function name is unique
-- DROP FUNCTION IF EXISTS function_name(argtype) *if function name not unique
DROP FUNCTION IF EXISTS get_actor_name_count(integer);
DROP FUNCTION IF EXISTS get_actor_name_count;



-- Stored function return a table
-- example 2 - we are often asked to provide a table of all customers that live in "country" with the first, last, addresss, city, district, and country
SELECT first_name, last_name, address, city, district, country
FROM customer c 
JOIN address a 
ON c.address_id = a.address_id 
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id 
WHERE country = 'Indonesia';

-- write the above query into a function
CREATE OR REPLACE FUNCTION customer_in_country(country_name varchar)
RETURNS TABLE (
	first_name varchar,
	last_name varchar,
	address varchar,
	city varchar,
	district varchar,
	country varchar
) -- must be lined up WITH query below
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country -- must line up WITH TABLE coumns above
	FROM customer c 
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci
	ON a.city_id = ci.city_id
	JOIN country co
	ON ci.country_id = co.country_id 
	WHERE co.country = country_name;
END;
$$;

-- execute a function that returns a ttable - use sel;ect ... from cunction_name();
SELECT *
FROM customer_in_country('United States');

SELECT *
FROM customer_in_country('Mexico');

SELECT *
FROM customer_in_country('Canada')
WHERE district = 'Ontario';



















