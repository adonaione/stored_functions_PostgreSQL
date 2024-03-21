-- Stored Procedures!

SELECT *
FROM customer;

-- If you don't have loyalty member column, execute the following:
--ALTER TABLE customer
--ADD COLUMN loyalty_member BOOLEAN;

-- Reset all of the customers to not be loyalty members
UPDATE customer
SET loyalty_member = FALSE;

SELECT *
FROM customer
WHERE loyalty_member = TRUE;

-- Create a Procedure that will make any customer who has spent >= $100 a loyalty member


-- Step 1. Get all of the customer IDs of those who have spent at least $100
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) >= 100;

-- Step 2. Write a DML statement to update any customer whose ID is in Step 1's query
UPDATE customer
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >= 100
);

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;

-- Step 3. Take the command from Step 2 and put it as the body of a procedure
CREATE OR REPLACE PROCEDURE update_loyalty_status()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) >= 100
	);
END;
$$;

-- Execute a procdure - use CALL
CALL update_loyalty_status();

SELECT *
FROM customer
WHERE loyalty_member = TRUE;

-- Lets pretend that a user close to the threshold makes a new payment 
SELECT customer_id, sum(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) BETWEEN 95 AND 100;

SELECT *
FROM customer 
WHERE customer_id = 175;

-- add a new payment for customer 175 of 4.99
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (175, 1, 1, 4.99, '2024-03-21 12:02:30');

-- call the procedure again
CALL update_loyalty_status();

select *
FROM customer c 
WHERE customer_id = 175;

-- creating a procedure for inserting data
SELECT *
FROM actor;

SELECT NOW();

INSERT INTO actor(first_name, last_name, last_update)
VALUES ('Emma', 'Stone', NOW());

SELECT *
FROM actor a 
ORDER BY actor_id DESC;

CREATE OR REPLACE PROCEDURE add_actor(first_name varchar, last_name varchar)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES (first_name, last_name, NOW());
END;
$$;

-- add actors
CALL add_actor('Robert', 'Downey Jr.');
CALL add_actor('Florence', 'Pugh');

SELECT * FROM actor ORDER BY actor_id DESC;

-- To remove a procedure, use DROP PROCEDURE procedure_name
DROP PROCEDURE IF EXISTS update_layalty_status;











