-- Databricks notebook source
-- Specifying the schemas to be used
Use Catalog Project;
Use schema kaffee;

-- describing the data type and checking for nulls in each column
DESCRIBE TABLE project.kaffee.bright_coffee_shop_sales_2;

SELECT* FROM project.kaffee.bright_coffee_shop_sales_2;

-- finding the unique store locations
SELECT DISTINCT store_location
FROM project.kaffee.bright_coffee_shop_sales_2;

--COUNTING THE NUMBER OF ROWS IN THE TABLE
SELECT COUNT(*)AS total_rows
FROM project.kaffee.bright_coffee_shop_sales_2;

-- COUNTING ALL THE NUMBER OF ROWS AND CHECKING FOR DISTINCT TRANSACTIONS ID
SELECT COUNT(transaction_id)AS trans_id_count,
       COUNT(DISTINCT transaction_id) AS distinct_trans_count
FROM project.kaffee.bright_coffee_shop_sales_2;

--describing the data type and finding NULLS
DESCRIBE TABLE project.kaffee.bright_coffee_shop_sales_2;

--finding rows containing NULLS
select*
FROM project.kaffee.bright_coffee_shop_sales_2
WHERE transaction_id IS NULL;

--finding COLUMNS containing NULLS
select*
FROM project.kaffee.bright_coffee_shop_sales_2
WHERE transaction_id IS NULL
   OR transaction_date IS NULL
   OR transaction_time IS NULL
   OR transaction_qty IS NULL
   OR unit_price IS NULL
   OR store_id IS NULL
   OR store_location IS NULL
   OR product_id IS NULL
   OR product_category IS NULL
   OR product_type IS NULL
   OR product_detail IS NULL;

   --REPLACING NULLS WITH ZEROS
   SELECT *,
   COALESCE (transaction_qty, 0) AS trans_nO_nulls
   FROM project.kaffee.bright_coffee_shop_sales_2;
   
   select*
FROM project.kaffee.bright_coffee_shop_sales_2;

--Data range of dataset
SELECT MIN(transaction_date) AS earliest_date,
       MAX(transaction_date) AS earliers
       FROM project.kaffee.bright_coffee_shop_sales_2;

--remove timestamps
 SELECT transaction_time,
        DATE_FORMAT(transaction_time, 'HH:mm:ss')AS clean_time
FROM project.kaffee.bright_coffee_shop_sales_2;

--product levels
SELECT DISTINCT product_category,
                product_type,
                product_detail
FROM project.kaffee.bright_coffee_shop_sales_2;

--finding total number of transactions
SELECT count(DISTINCT transaction_id) AS total_trans_id
FROM project.kaffee.bright_coffee_shop_sales_2
GROUP BY transaction_date;

--finding the number of transactions per day
SELECT count(DISTINCT transaction_id) AS total_trans_id
FROM project.kaffee.bright_coffee_shop_sales_2
GROUP BY transaction_date;

--finding the number of transactions per month
SELECT MONTHNAME(transaction_date) AS month,
       COUNT(DISTINCT transaction_id) AS total_transactions
FROM project.kaffee.bright_coffee_shop_sales_2
GROUP BY month;

SELECT unit_price * transaction_qty AS revenue
FROM project.kaffee.bright_coffee_shop_sales_2;

SELECT unit_price,
transaction_qty,
CAST (transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',', '.') AS DOUBLE) AS revenue
FROM project.kaffee.bright_coffee_shop_sales_2;

SELECT MONTHNAME(transaction_date) AS month,
       SUM(CAST (transaction_qty AS DOUBLE) * CAST(REPLACE(unit_price,',', '.') AS DOUBLE)) AS revenue
FROM project.kaffee.bright_coffee_shop_sales_2
GROUP BY month;

SELECT unit_price * transaction_qty AS Revenue
FROM project.kaffee.bright_coffee_shop_sales_2;

--checking for duplicates
SELECT transaction_id,
       COUNT(*)
       FROM project.kaffee.bright_coffee_shop_sales_2
       GROUP BY transaction_id
       HAVING COUNT(*) >1;

--CASE STATEMENTS - Buckets
SELECT transaction_time,
       DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time,
       CASE
       WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'morning'
       WHEN HOUR(transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
       ELSE 'Evening'
       End AS time_bucket
FROM project.kaffee.bright_coffee_shop_sales_2;

SELECT DAYNAME(transaction_date),
       DAYOFWEEK(transaction_date),
       CASE 
       WHEN DAYNAME(transaction_date) IN('Sat', 'Sun') THEN 'Weekend'
       ELSE 'Weekday'
       END AS day_type,
       CASE
       WHEN DAYOFMONTH(transaction_date) BETWEEN 1 AND 10 THEN 'Early month'
       WHEN DAYOFMONTH(transaction_date) BETWEEN 11 AND 20 THEN 'Mid month'
       ELSE 'Month_end'
       END AS Month_period
       FROM project.kaffee.bright_coffee_shop_sales_2;

       SELECT 
        (ROUND(SUM(CAST(transaction_qty AS DOUBLE)* CAST (REPLACE(unit_price, ',','.') AS DOUBLE)),2)) AS revenue
        FROM project.kaffee.bright_coffee_shop_sales_2;

     

       --------------------
       --FINAL BIG QUERY WITH ALL THE NEW COLUMNS
       SELECT transaction_id,
              transaction_date,
              DATE_FORMAT(transaction_time, 'HH:mm:ss') AS clean_time,
              transaction_qty,
              store_id,
              store_location,
              product_id,
              unit_price,
              product_category, 
              product_type,
              product_detail,
              DAYNAME(transaction_date) AS day_name,
              MONTHNAME(transaction_date) AS month_name,
              DAYOFMONTH(transaction_date) AS day_number,
CASE
       WHEN HOUR(transaction_time) BETWEEN 6 AND 10 THEN 'morning'
       WHEN HOUR(transaction_time) BETWEEN 10 AND 13 THEN 'Afternoon'
       ELSE 'Evening'
       End AS time_bucket,
       CASE 
       WHEN DAYNAME(transaction_date) IN('Sat', 'Sun') THEN 'Weekend'
       ELSE 'Weekday'
       END AS day_type,
       CASE
       WHEN DAYOFMONTH(transaction_date) BETWEEN 1 AND 10 THEN 'Early month'
       WHEN DAYOFMONTH(transaction_date) BETWEEN 11 AND 20 THEN 'Mid month'
       ELSE 'Month_end'
       END AS Month_period,

       CASE
       WHEN (CAST(transaction_qty AS DOUBLE)* CAST (REPLACE(unit_price, ',','.') AS DOUBLE)) <50 THEN 'Cheap spend'
       WHEN (CAST(transaction_qty AS DOUBLE)* CAST (REPLACE(unit_price, ',','.') AS DOUBLE)) BETWEEN 51 AND 200 THEN 'low spend'
       WHEN (CAST(transaction_qty AS DOUBLE)* CAST (REPLACE(unit_price, ',','.') AS DOUBLE)) BETWEEN 201 AND 300 THEN 'Medium spend'
       ELSE 'Expensive spend'
       END AS Bucket_spend,
       
       CAST(REPLACE(unit_price,',', '.') AS DOUBLE) AS clean_unit_price,
      ROUND ((CAST(transaction_qty AS DOUBLE)* CAST (REPLACE(unit_price, ',','.') AS DOUBLE)),2) AS revenue
FROM project.kaffee.bright_coffee_shop_sales_2;
       

SELECT *
FROM project.kaffee.bright_coffee_shop_sales_2;

   



