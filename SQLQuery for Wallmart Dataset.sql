SELECT *
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

---- STANDARDIZE DATA
--1/ ADD TIME OF DAY COLUMN

ALTER TABLE WalmartSalesData
ADD Time_of_Day VARCHAR(50)

UPDATE WalmartSalesData 
SET Time_of_Day = CASE
		WHEN TIME BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
		WHEN TIME BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	 END;

--2/ ADD DAY NAME COLUMN

SELECT DATE, DATENAME(WEEKDAY,DATE)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

ALTER TABLE WalmartSalesData
ADD DAY_NAME VARCHAR(50) 

UPDATE WalmartSalesData
SET DAY_NAME = DATENAME(WEEKDAY,DATE)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

-- 3/ADD MONTH COLUMN
ALTER TABLE WalmartSalesData
ADD MONTH_NAME VARCHAR(50) 

UPDATE WalmartSalesData
SET MONTH_NAME = DateName(Month, DATE) 
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

----General Information
-- 1/ How many unique cities does the data have?
SELECT DISTINCT CITY
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

--2/ In which city is each branch?
SELECT DISTINCT CITY, Branch
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY CITY, Branch

----Product 
--1/ How many unique product lines does the data have?
SELECT COUNT(DISTINCT Product_line)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

--2/ What is the most common payment method?
SELECT PAYMENT, COUNT(DISTINCT Invoice_ID)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY Payment
ORDER BY COUNT(DISTINCT Invoice_ID) DESC

--3/ What is the most selling product line?
SELECT PRODUCT_LINE, SUM(Quantity) AS TOTALQUANTITY
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY PRODUCT_LINE
ORDER BY TOTALQUANTITY DESC

--4/What is the total revenue by month?
SELECT MONTH_NAME, (CAST(SUM(TOTAL) AS DECIMAL (10,2))) AS TOTAL_REVENUE
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY MONTH_NAME
ORDER BY TOTAL_REVENUE DESC

--5/ What month had the largest COST OF GOODS COGS?
SELECT MONTH_NAME, (CAST(SUM(cogs) AS DECIMAL (10,2))) AS TOTAL_COGS
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY MONTH_NAME
ORDER BY TOTAL_COGS DESC

--6/ What product line had the largest revenue?
SELECT PRODUCT_LINE, (CAST(SUM(Total) AS DECIMAL (10,2))) AS TOTALREVENUE
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY PRODUCT_LINE
ORDER BY TOTALREVENUE DESC

--7/ What is the city with the largest revenue?
SELECT City, (CAST(SUM(Total) AS DECIMAL (10,2))) AS TOTALREVENUE
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY City
ORDER BY TOTALREVENUE DESC

--8/ What product line had the largest VAT?
SELECT PRODUCT_LINE, (CAST(sum(Tax_5) AS DECIMAL (10,2))) AS TOTAL_VAT
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY PRODUCT_LINE
ORDER BY TOTAL_VAT DESC

--9/Which branch sold more products than average product sold?
SELECT BRANCH, SUM(QUANTITY), AVG(QUANTITY) AS AverageProductSold
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY BRANCH
HAVING SUM(QUANTITY) > (SELECT AVG(QUANTITY) FROM [Wallmart_Sales].[dbo].[WalmartSalesData])
 
--10/ What is the most common product line by gender?
SELECT GENDER, Product_line, COUNT (DISTINCT INVOICE_ID) AS TOTAL_INVOICE
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY  GENDER, Product_line
ORDER BY GENDER, TOTAL_INVOICE DESC

--11/ What is the average rating of each product line?
SELECT  Product_line, ROUND(AVG (Rating),2) AS AVG_RATING
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY Product_line
ORDER BY AVG_RATING

--12/Fetch each product line and add a column to those product line showing "Good", "Bad". 
--Good if its greater than average sales
SELECT  Product_line, ROUND (AVG(TOTAL),2) AS AvgSales,
(CASE WHEN (AVG(TOTAL)) > (SELECT AVG (TOTAL) FROM [Wallmart_Sales].[dbo].[WalmartSalesData]) THEN 'GOOD'
	ELSE 'BAD'
END) as SalesRating
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY Product_line
ORDER BY SalesRating

----Sales
--1/ Number of sales made in each time of the day per weekday
SELECT Time_of_Day, ROUND(SUM (TOTAL),2)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY Time_of_Day
ORDER BY ROUND(SUM (TOTAL),2) DESC

SELECT DAY_NAME, ROUND(SUM (TOTAL),2) AS TOTAL_SALES
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY DAY_NAME
ORDER BY TOTAL_SALES DESC

--2/Which of the customer types brings the most revenue?
SELECT Customer_type, ROUND(SUM (TOTAL),2) AS TOTAL_SALES
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY Customer_type
ORDER BY TOTAL_SALES DESC

--3/Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT CITY, ROUND(AVG (Tax_5),2) AS AVG_TAX
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY CITY
ORDER BY AVG_TAX DESC

--4/ Which customer type pays the most in VAT?
SELECT Customer_type, ROUND(AVG (Tax_5),2) AS AVG_TAX
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY Customer_type
ORDER BY AVG_TAX DESC

----CUSTOMERS
--1/ How many unique customer types does the data have?
SELECT DISTINCT (Customer_type)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

--2/How many unique payment methods does the data have?
SELECT DISTINCT (Payment)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]

--3/ What is the most common customer type?
SELECT Customer_type,COUNT(Customer_type)
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
group by Customer_type
order by Customer_type desc

--4/ Which customer type buys the most?
SELECT Customer_type, sum(total) AS TOTALSALES
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
group by Customer_type 
order by TOTALSALES DESC

--5/ What is the gender of most of the customers?
SELECT Gender, COUNT(Customer_type) AS GenderCount
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
group by Gender
order by GenderCount DESC

SELECT Gender, sum(total) AS TOTALSALES
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
group by Gender
order by TOTALSALES DESC

--6/What is the gender distribution per branch?
SELECT branch,Gender, COUNT(Customer_type) AS GenderCount
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
group by branch, Gender
order by branch DESC

--7/ Which time of the day do customers give most ratings?
SELECT Time_of_Day, AVG(RATING) AS AvgRating
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY time_of_Day
order by AvgRating DESC

--8/ Which time of the day do customers give most ratings per branch?
SELECT BRANCH,Time_of_Day, AVG(RATING) AS AvgRating
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY BRANCH, Time_of_Day
order by AvgRating DESC

--9/ Which day OF the week has the best avg ratings?
SELECT DAY_NAME, AVG(RATING) AS AvgRating
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY DAY_NAME
order by AvgRating DESC

--10/ Which day of the week has the best average ratings per branch?
SELECT BRANCH, DAY_NAME, AVG(RATING) AS AvgRating
FROM [Wallmart_Sales].[dbo].[WalmartSalesData]
GROUP BY BRANCH, DAY_NAME
order by BRANCH,AvgRating DESC







  

