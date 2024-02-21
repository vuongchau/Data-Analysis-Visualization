SELECT * 
FROM pizza_sales

--1/ Total Revenue
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales

-- 2/Average Order Revenue
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS Average_Order_Revenue
FROM pizza_sales

-- 3/ Total Pizza Sold
SELECT SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales

-- 4/ Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales

--5/ Average Pizza Per Order
SELECT CAST(CAST (SUM(quantity) AS decimal(10,2))/CAST(COUNT(DISTINCT order_id) AS decimal(10,2)) AS DECIMAL(10,2)) AS Average_Pizza_By_Order
FROM pizza_sales

--6/ Daily trend for Total order
SELECT DATENAME(DW,order_date) AS Daily_order, COUNT(DISTINCT order_id) AS Total_ORDER
FROM pizza_sales
GROUP BY DATENAME(DW,order_date)

--7/ Monthly trend for Total Order
SELECT DATENAME(MONTH,order_date) AS Monthly_Order, COUNT(DISTINCT order_id) AS Total_ORDER
FROM pizza_sales
GROUP BY DATENAME(MONTH,order_date)
ORDER BY Total_ORDER DESC

--8/ %Sale by pizza category in January
SELECT pizza_category,SUM(total_price) AS Total_Sales, SUM(total_price)*100 / (SELECT SUM (total_price)from pizza_sales) AS PCT
FROM pizza_sales
WHERE Month(order_date) = 1
GROUP BY pizza_category

--9/ %Sale by pizza size in Quarter 1
SELECT pizza_size, CAST(SUM (total_price)AS decimal(10,2)) AS Total_Sales, CAST(SUM(total_price) *100 / (SELECT SUM (total_price)from pizza_sales WHERE DATEPART(QUARTER,order_date)=1)AS decimal(10,2)) AS PCT
FROM pizza_sales
WHERE DATEPART(QUARTER,order_date)=1
GROUP BY pizza_size
ORDER BY PCT DESC

--10/ Top 5 Best Seller by Quantity, Revenue, Total Order
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC

SELECT TOP 5 pizza_name, SUM(order_id) AS Total_Order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order DESC

--11/ Top 5 Bottom Seller by Quantity, Revenue, Total Order
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC

SELECT TOP 5 pizza_name, SUM(order_id) AS Total_Order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order ASC
