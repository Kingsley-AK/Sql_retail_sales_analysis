--Create the table 
CREATE TABLE retail_sales(transactions_id INT PRIMARY KEY,
						  sale_date DATE,
						  sale_time TIME,
						  customer_id INT,
						  gender VARCHAR(15),
						  age INT,
						  category	VARCHAR(20),
						  quantiy INT,
						  price_per_unit FLOAT,
						  cogs FLOAT,
						  total_sale FLOAT
						 );
						 
SELECT COUNT(*) FROM retail_sales

-- Checking for null values in all the columns
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
-- Data Cleaning - Deleting the rows with null values
DELETE FROM retail_sales
	WHERE 
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
--Rename the column quantiy to quantity
ALTER TABLE retail_sales
RENAME COLUMN quantiy to quantity;
	
--Date Exploration	
--1. How many sales do we have?
SELECT COUNT(*) as total_sales FROM retail_sales

--2. How many customers do we have?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retail_sales

--3. How many categories do we have?
SELECT DISTINCT category as categories FROM retail_sales

--Data Analysis and Business problems and Answers
--1. Write a SQL query to find all columns for sales made on 2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

--2. Write a SQL query to retrieve all transactions where category is Clothing and quantity sold is more than 3 in the
--month of NOV-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing' AND 
TO_CHAR (sale_date, 'YYYY-MM') = '2022-11'
AND quantity  >= 3
ORDER BY quantity ASC

--3. Write a SQL query to calculate the total sales for each category
SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS total_orders FROM retail_sales
GROUP BY category

--4. Write a SQL query to find the average age of customers who purchased items from the "Beauty" category
SELECT ROUND(AVG(age)) AS avg_age FROM retail_sales
WHERE category = 'Beauty'

--5. Write a SQL query to find all transactions where the total sales is greater than 1000
SELECT customer_id, category, total_sale FROM retail_sales 
WHERE total_sale > 1000
ORDER BY total_sale

--6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT COUNT(DISTINCT(transactions_id)), gender, category FROM retail_sales
GROUP BY gender, category
ORDER BY category

--7. Write a SQL query to calculate the average sale for each month. FInd out the best selling month in each year
SELECT * FROM(
	SELECT EXTRACT(YEAR FROM sale_date) AS year, 
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) 
	FROM retail_sales
	GROUP BY 1, 2) AS T1
WHERE rank = 1

--8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT(customer_id)), category FROM retail_sales
GROUP BY category

--10. Write a SQl query to create each shift and number of orders(Example: Morning <=12)
WITH hourly_sale AS
(SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN  EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon' 
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) FROM hourly_sale
GROUP BY shift

--End of the project
 