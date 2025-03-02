SELECT * FROM customers;

--- removing duplicates from customer table
WITH duplicated AS (
	SELECT DISTINCT ON (customer_id) *
	FROM customers C
	ORDER BY customer_id
)

DELETE FROM customers c
WHERE c.customer_id NOT IN (SELECT customer_id FROM duplicated)
;
----checking for null rows
SELECT *
FROM customers 
WHERE REGION IS NULL
;
---set null values to be unknown
SELECT customer_id, contact_name, COALESCE(region, 'unknown') AS Region
FROM customers
;
---analyze the impact of null
SELECT country, COUNT(*)  AS total_customer, COUNT(region) customerswithregion, COUNT(REGION) customerswithoutregion
FROM customers
GROUP BY country
;

---EXPLORATORY DATA ANALYSIS 

--- query to get the product by category
SELECT product_name, category_name
FROM products p
JOIN categories c ON  p.category_id = c.category_id
;
--- Query to get the most expensive and least expensive product 
(SELECT product_name, unit_price
FROM products
ORDER BY unit_price desc
limit 1)
UNION
(SELECT product_name, unit_price
FROM products
ORDER BY unit_price
limit 1)
;
--- Query to get the current and discontinued products
SELECT product_name,
					CASE WHEN discontinued = 0 THEN 1 ELSE 0 END AS current_products,
					CASE WHEN discontinued = 1 THEN 1 ELSE 0 END AS discontinued_products
FROM products
;
----query to show sales data by category for the year 1997 alone
SELECT c.category_name, SUM (od.quantity*od.unit_price*(1-od.discount)) total_sales
FROM order_details od
JOIN products p ON od.product_id=od.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT (YEAR FROM o.order_date)= 1997
GROUP BY c.category_name
;
--- query to get the  sales amount for each employee
SELECT
