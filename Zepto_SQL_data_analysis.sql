Create Database Zepto_DB;

Use Zepto_DB;

Drop table if exists zepto;

-- Data Importing

Select * from zepto;

-- adding new column sku_id to table 'zepto' by alter statement
alter table zepto
add sku_id int identity(1,1);

-- adding primary key constraint using alter statement to column sku_id 
alter table zepto 
add constraint skid1 primary key(sku_id);

Select * from zepto;

--data exploration

--count of rows
Select count(*) from zepto;

--top 10 records of table
Select Top 10 * from zepto;


--Checking null values
Select * From zepto
Where name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--Different product categories
Select Distinct category
FROM zepto
ORDER BY category;

--Products in stock vs out of stock
Select outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--Product names present multiple times
Select  name, COUNT(sku_id) AS "Number of SKUs"
From zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--Data cleaning

--Products with price = 0
Select * from zepto
Where mrp = 0 OR discountedSellingPrice = 0;

Delete from zepto
Where mrp = 0;

--Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

Select mrp, discountedSellingPrice from zepto;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
Select Top 10 name, mrp, discountPercent
From zepto
Order by discountPercent Desc;


--Q2.What are the Products with High MRP ie greater tham 300 but Out of Stock

Select Distinct name,mrp
From zepto
Where outOfStock = 1 and mrp > 300
Order by mrp Desc;

--Q3.Calculate Estimated Revenue for each category

Select category, SUM(discountedSellingPrice * availableQuantity) AS total_revenue
From zepto
Group by category
Order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

Select Distinct name, mrp, discountPercent
From zepto
Where mrp > 500 AND discountPercent < 10
Order by mrp Desc, discountPercent Desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

Select Top 5 category, ROUND(AVG(discountPercent),2) AS avg_discount
From zepto
Group by category
Order by avg_discount Desc;

-- Q6. Find the price per gram for products above 100g and sort by best value.

Select Distinct name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
From zepto
Where weightInGms >= 100
Order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.

Select Distinct name, weightInGms,
CASE When weightInGms < 1000 Then 'Low'
	When weightInGms < 5000 Then 'Medium'
	Else 'Bulk'
	End AS weight_category
From zepto;

--Q8.What is the Total Inventory Weight Per Category 

Select category, SUM(weightInGms * availableQuantity) AS total_weight
From zepto
Group by category
Order by total_weight;