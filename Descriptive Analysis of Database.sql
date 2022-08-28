USE Ecomm_schema;

/******************************************************************************************************************/
--- Basic KPIs ---
/******************************************************************************************************************/


--- Realated to Orders ---

--- Minimum Order Value
--------------------------------------------------------------------------------------------------------------------
SELECT ROUND(MIN(Total_order_amount), 2) FROM Orders;

--- Maximum Order Value
--------------------------------------------------------------------------------------------------------------------
SELECT ROUND(MAX(Total_order_amount), 2) FROM Orders;

--- Total Revenue Generated
--------------------------------------------------------------------------------------------------------------------
SELECT ROUND(SUM(Total_order_amount), 2) FROM Orders;

--- Average Order Value
--------------------------------------------------------------------------------------------------------------------
SELECT ROUND(AVG(Total_order_amount), 2) FROM Orders;

--- Orders are from DATES as follows
--------------------------------------------------------------------------------------------------------------------
SELECT MIN(OrderDate), MAX(OrderDate) FROM Orders;

--- Count of Customers who Ordered
--------------------------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT(CustomerID)) FROM Orders;

--- Payment method used for Orders are as follows:
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(A.PaymentID), B.PaymentType FROM Orders A
INNER JOIN Payments B ON A.PaymentID = B.PaymentID
WHERE B.Allowed = 1;

--- Returning Customers
--------------------------------------------------------------------------------------------------------------------
SELECT A.CustomerID, B.FirstName, B.LastName, B.Country, COUNT(A.CustomerID) AS Nos_Orders
FROM Orders A INNER JOIN Customers B ON A.CustomerID = B.CustomerID 
GROUP BY A.CustomerID, B.FirstName, B.LastName, B.Country
HAVING COUNT(A.CustomerID) > 1;

--- Non-Returning Customers
--------------------------------------------------------------------------------------------------------------------
SELECT A.CustomerID, B.FirstName, B.LastName, B.Country, COUNT(A.CustomerID) AS Nos_Orders
FROM Orders A INNER JOIN Customers B ON A.CustomerID = B.CustomerID 
GROUP BY A.CustomerID, B.FirstName, B.LastName, B.Country
HAVING COUNT(A.CustomerID) = 1;

--- Shippers Associated with the orders
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(A.ShipperID ), B.CompanyName, B.Phone
FROM Orders A INNER JOIN Shippers B ON A.ShipperID = B.ShipperID

--- Shipper with along the numbers of Orders they have shipped
--------------------------------------------------------------------------------------------------------------------
SELECT A.ShipperID, B.CompanyName, COUNT(A.OrderID) AS Nos_Orders_Shipped
FROM Orders A INNER JOIN Shippers B ON A.ShipperID = B.ShipperID
GROUP BY A.ShipperID, B.CompanyName
ORDER BY Nos_Orders_Shipped DESC;

--- Day on which we have received most numbers of orders
--------------------------------------------------------------------------------------------------------------------
SELECT OrderDate, COUNT(OrderID) AS Nos_Orders_Received FROM Orders
GROUP BY OrderDate
ORDER BY Nos_Orders_Received DESC;

--- Day on which we have delivered maximum numbers of orders
--------------------------------------------------------------------------------------------------------------------
SELECT DeliveryDate, COUNT(OrderID) AS Nos_Orders_Received FROM Orders
GROUP BY DeliveryDate
ORDER BY Nos_Orders_Received DESC;


--- Day on which we have shipped maximum numbers of orders
--------------------------------------------------------------------------------------------------------------------
SELECT ShipDate, COUNT(OrderID) AS Nos_Orders_Received FROM Orders
GROUP BY ShipDate
ORDER BY Nos_Orders_Received DESC;

--- Day on which we have generated maximum revenue
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 OrderDate, COUNT(OrderID) AS Nos_Orders_Received, ROUND(SUM(Total_order_amount), 2) AS Revenue
FROM Orders
GROUP BY OrderDate
ORDER BY Revenue DESC;

--- Day on which we have generated minimum revenue
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 OrderDate, COUNT(OrderID) AS Nos_Orders_Received, ROUND(SUM(Total_order_amount), 2) AS Revenue
FROM Orders
GROUP BY OrderDate
ORDER BY Revenue;

--- RELATED TO CUSTOMERS ---

--- Total numbers of customers connnected with us
--------------------------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT(CustomerID)) AS Total_Customers FROM Customers;

--- Customer base by country
--------------------------------------------------------------------------------------------------------------------
SELECT Country,COUNT(CustomerID) AS Total_Customers
FROM Customers GROUP BY Country
ORDER BY Total_Customers DESC;

--- Number of cutomers eneterd by date
--------------------------------------------------------------------------------------------------------------------
SELECT DateEntered, COUNT(CustomerID) AS Cust_Connected
FROM Customers
GROUP BY DateEntered ORDER BY Cust_Connected DESC;

--- Number of cutomers by postalcode where number of customers is more than 5
--------------------------------------------------------------------------------------------------------------------
SELECT PostalCode, COUNT(CustomerID) AS Nos_Cust
FROM Customers
GROUP BY PostalCode HAVING COUNT(CustomerID) > 5
ORDER BY Nos_Cust DESC;

--- REALTED TO PRODUCTS ---

--- Number of products under each category
--------------------------------------------------------------------------------------------------------------------
SELECT Category_ID, COUNT(ProductID) AS Nos_Products
FROM Products GROUP BY Category_ID
ORDER BY Nos_Products DESC;


--- PRODUCT WITH MORE THAN 3 RATING
--------------------------------------------------------------------------------------------------------------------
SELECT ProductID, Product, Rating FROM Products
WHERE Rating IS NOT NULL AND Rating > 3
ORDER BY Rating DESC;

--- NUMBER OF PRODUCTS WITH LESS THAN 2.1 RATING
--------------------------------------------------------------------------------------------------------------------
SELECT Rating, COUNT(*) AS Nos_Low_Ratng FROM Products
WHERE Rating IS NOT NULL AND Rating < 2.1
GROUP BY Rating;

--- NUMBER OF PRODUCTS WITH NO RATING
--------------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) AS NOT_RATED FROM Products
WHERE Rating IS NULL
GROUP BY Rating;
--------------------------------------------------------------------------------------------------------------------


/******************************************************************************************************************/
--- BUSINESS REALATED KPIs
/******************************************************************************************************************/

--- Identifying the distinct orders for which the PaymentID is “2”
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(OrderID),* FROM Orders WHERE PaymentID = 2;

--- Identifying the total numbers of orders placed for each PaymentID for order placed between “5/02/2020 and 30/04/2020”
--------------------------------------------------------------------------------------------------------------------
SELECT COUNT(OrderID) AS tOTAL_Order, PaymentID FROM Orders WHERE OrderDate BETWEEN '2020-02-05' AND
'2020-04-30' GROUP BY PaymentID ORDER BY PaymentID ASC;

--- Identifying all the categories which are currently active
--------------------------------------------------------------------------------------------------------------------
SELECT CategoryName,* FROM Category WHERE Active = 1;

--- Identifying the different Payment methods which the company is accepting.
--------------------------------------------------------------------------------------------------------------------
SELECT PaymentType FROM Payments WHERE Allowed = 1;

---- Identifying the customers who belong to Wisconsin and NewYork
--------------------------------------------------------------------------------------------------------------------
SELECT * FROM Customers WHERE City = 'Wisconsin' OR City = 'New York';

--- Identifying the distinct State and City combinations where the customers belong to.
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT CustomerID, CITY, STATE FROM Customers;

--- Identifying all the customers whose length of the first name is 6 and the last name begins with “A”.
--------------------------------------------------------------------------------------------------------------------
SELECT * FROM Customers WHERE FirstName LIKE '______' AND LastName LIKE 'A%';

--- Identifying all the Products for the brand “Cadbury”
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(Product) FROM Products WHERE Brand = 'CADBURY';

--- Identifying all the products whose name contains “a” after 3rd place.
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(Product) FROM Products WHERE Product LIKE '__a%';


--- Identifying the count of customers connected with the company each year
--------------------------------------------------------------------------------------------------------------------
SELECT YEAR (orderdate) AS Year,
COUNT(DISTINCT CustomerID) AS Total_Customer from orders
group by YEAR (orderdate);

--- Identifying the count of customers in each State
--------------------------------------------------------------------------------------------------------------------
SELECT State,
COUNT(CustomerID), COUNT(DISTINCT(CustomerID)) AS Total_Customer
FROM Customers
GROUP BY State;

/* Segment the customers into “New” and “Old” categories. Tag the customer as “New” if his database stored date 
is greater than “1st July 2020” else tag the customer as “Old”. Also, find the count of customers in both
the categories. */
--------------------------------------------------------------------------------------------------------------------
SELECT CASE
WHEN DateEntered > '2020-07-01' THEN 'NEW'
ELSE 'OLD'
END AS TAG_NEW_OLD,
COUNT(CUSTOMERID) AS Total_Customer FROM Customers
GROUP BY CASE
WHEN DateEntered > '2020-07-01' THEN 'NEW'
ELSE 'OLD' END;

--- OR
WITH CTE1 AS(
SELECT *, CASE
WHEN DateEntered > '2020-07-01' THEN 'NEW'
ELSE 'OLD'
END AS TAG
FROM Customers)
SELECT TAG,COUNT(*) FROM CTE1 GROUP BY TAG;

--- Identifying the count of distinct products that the company sells within each category
--------------------------------------------------------------------------------------------------------------------
SELECT Category_ID, COUNT(ProductID) AS TOTAL_PRODUCTS
FROM Products
GROUP BY Category_ID
ORDER BY Category_ID;

--- Identifying the number of orders in each month of the year “2021”
--------------------------------------------------------------------------------------------------------------------
SELECT MONTH (OrderDate) AS MONTH, COUNT(OrderID) AS TOTAL_ORDERS
FROM Orders WHERE YEAR(OrderDate) ='2021'
GROUP BY MONTH (OrderDate)
ORDER BY MONTH (OrderDate);

--- Identifying the average order amount by each CustomerID in each month of Year “2020”
--------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT(CustomerID), MONTH(OrderDate) AS MONTH, 
AVG(Total_order_amount) AS Avg_Order_Amount FROM Orders 
WHERE YEAR(OrderDate) = '2020'
GROUP BY CustomerID, MONTH(OrderDate)
ORDER BY CustomerID;

--- Identifying the Month-Year combinations which had the highest customer acquisition
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 MONTH(DateEntered) AS MONTH, YEAR(DateEntered) AS YEAR, 
COUNT (*) AS TOTAL_CUSTOMERS FROM Customers
GROUP BY MONTH(DateEntered), YEAR(DateEntered)
ORDER BY TOTAL_CUSTOMERS DESC;

--- Identifying the most selling ProductID in 2021
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 ProductID, SUM(Quantity) AS TOTAL_QUANTITY
FROM OrderDetails 
GROUP BY ProductID
ORDER BY TOTAL_QUANTITY DESC;


--- Identifying which Supplier ID supplied the least number of products
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 SupplierID, COUNT(DISTINCT(ProductID)) AS TOTAL_PRODUCTS
FROM OrderDetails
GROUP BY SupplierID
ORDER BY TOTAL_PRODUCTS;

--- Identifying the OrderIDs which were delivered exactly after 15 days.
--------------------------------------------------------------------------------------------------------------------
SELECT OrderID, DATEDIFF(DAY,OrderDate, DeliveryDate) AS Total_Days
FROM Orders GROUP BY OrderID, DATEDIFF(DAY,ORDERDATE, DeliveryDate)
HAVING DATEDIFF(DAY,OrderDate, DeliveryDate) = 15;

/* The company is tying up with a Bank for providing offers to a certain set of premium customers only. 
We want to know those CustomerIDs who have ordered for a total amount of more than 7000 in the past 3 months. */
--------------------------------------------------------------------------------------------------------------------
SELECT CustomerID, SUM(Total_order_amount) AS Total_AMOUNT
FROM ORDERS WHERE CUSTOMERID IN
(SELECT CustomerID
FROM Orders GROUP BY CustomerID HAVING SUM(Total_order_amount) >7000)
AND DATEDIFF(MONTH,OrderDate,GETDATE()) <= 3
GROUP BY CustomerID
ORDER BY CustomerID;

--- Identify if there are any ShipperIDs that got associated with us in 2021 only.
--------------------------------------------------------------------------------------------------------------------
WITH CTE1 AS(
SELECT DISTINCT(ShipperID) FROM Orders where datepart(year,ShipDate)=2020),
CTE2 AS(
SELECT DISTINCT(ShipperID) FROM Shippers),
CTE3 AS(
SELECT CTE2.ShipperID, Shippers.CompanyName FROM CTE2 INNER JOIN Shippers ON CTE2.ShipperID = Shippers.ShipperID)
SELECT * FROM CTE3 WHERE ShipperID NOT IN (SELECT * FROM CTE1);

/* The leadership wants to know the customer base who have ordered only once in the past 6 months such that 
they can be provided with certain offers to prevent customer churn. Also, find the number of purchases in 
each category for these customers.*/
--------------------------------------------------------------------------------------------------------------------
SELECT * FROM Customers WHERE CustomerID IN 
(SELECT CustomerID FROM Orders WHERE DATEDIFF(MONTH,OrderDate,GETDATE()) <= 6 
GROUP BY CustomerID HAVING COUNT(CustomerID) = 1);

--- PART B
SELECT C.CustomerID, C.FirstName,C.LastName, C.City, C.State, C.Country,
ROUND(SUM(O.total_order_amount),2) AS Total_Amount_Spend, COUNT(O.OrderID) AS Nos_Orders
FROM Customers C INNER JOIN Orders as O 
ON C.customerid = O.customerid and O.orderdate >= DATEADD(MONTH,-6,GETDATE())
GROUP BY C.CustomerID, C.FirstName,C.LastName, C.City, C.State, C.Country
HAVING COUNT(O.OrderID) = 1;

/* The company is tying up with a Bank for providing offers to a certain set of premium customers only. 
We want to know those customers who have ordered for a total amount of more than 7000 in the past 3 months.
*/
--------------------------------------------------------------------------------------------------------------------
SELECT O.CustomerID, C.FirstName, C.LastName, SUM(O.Total_order_amount) AS Total_order_amount
FROM Orders O INNER JOIN Customers C  ON O.CustomerID = C.CustomerID
WHERE DATEDIFF(MONTH,OrderDate,GETDATE()) <= 3
GROUP BY O.CustomerID, C.FirstName, C.LastName
HAVING SUM(O.Total_order_amount) > 7000;

--- The leadership wants to know which is their top-selling category and least-selling category in 2021
--------------------------------------------------------------------------------------------------------------------
--- TOP-SELLING CATEGORY
SELECT TOP 1 C.CategoryName, SUM(QUANTITY) AS MOST_SOLD FROM Orders O
LEFT JOIN OrderDetails A ON O.OrderID = A.OrderID
LEFT JOIN Products B ON A.ProductID = B.ProductID
LEFT JOIN Category C ON B.Category_ID = C.CategoryID
WHERE C.Active = 1 AND YEAR(O.OrderDate) = 2021
GROUP BY C.CategoryName, C.CategoryID
ORDER BY MOST_SOLD DESC;

--- LEAST-SELLING CATEGORY
SELECT TOP 1 C.CategoryName, SUM(QUANTITY) AS MOST_SOLD FROM Orders O
LEFT JOIN OrderDetails A ON O.OrderID = A.OrderID
LEFT JOIN Products B ON A.ProductID = B.ProductID
LEFT JOIN Category C ON B.Category_ID = C.CategoryID
WHERE C.Active = 1 AND YEAR(O.OrderDate) = 2021
GROUP BY C.CategoryName, C.CategoryID
ORDER BY MOST_SOLD;

--- We need to flag the Shipper companies whose average delivery time is less than 3 days to incentivize them
--------------------------------------------------------------------------------------------------------------------
SELECT SHIPPERID, CASE
WHEN AVG(DATEDIFF(DAY,ORDERDATE,DELIVERYDATE)) < 3 THEN '1'
ELSE '0' END AS TAG
FROM Orders
GROUP BY ShipperID;

--- Find out the Average delivery time for each category by each shipper
--------------------------------------------------------------------------------------------------------------------
SELECT D.CategoryName, S.CompanyName ,AVG(DATEDIFF(DAY,ORDERDATE,DELIVERYDATE)) AS AVG_DELIVERY_TIME 
FROM Orders A
LEFT JOIN OrderDetails B ON A.OrderID = B.OrderID
LEFT JOIN Shippers S ON A.ShipperID = S.ShipperID
LEFT JOIN Products C ON B.ProductID = C.ProductID
LEFT JOIN Category D ON C.Category_ID = D.CategoryID
GROUP BY D.CategoryName, S.CompanyName
ORDER BY D.CategoryName, S.CompanyName;

/* We need to see the most used Payment method by customers such that we can tie-up with those Banks 
in order to attract more customers to our website. */
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 B.PaymentType, COUNT(*) AS TIMES_USED FROM Orders A 
LEFT JOIN Payments B ON A.PaymentID = B.PaymentID
GROUP BY B.PaymentType 
ORDER BY TIMES_USED DESC;


/* Write a query to show the number of customers, number of orders placed, and total order amount per month 
in the year 2021. Assume that we are only interested in the monthly reports for a single year (January-December). */
--------------------------------------------------------------------------------------------------------------------
SELECT MONTH(ORDERDATE) AS MONTH_, COUNT(DISTINCT(CUSTOMERID)) AS TOTAL_CUSTOMERS, 
COUNT(*) AS TOTAL_ORDERS, ROUND(SUM(Total_order_amount),2) AS REVENUE 
FROM Orders WHERE YEAR(OrderDate) = 2021
GROUP BY MONTH(OrderDate)
ORDER BY MONTH_;

--- Find the numbers of orders fulfilled by Suppliers residing in the same Country as the customer.
--------------------------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT(A.OrderID)) AS Nos_Orders, 
('Orders Fulfilled by Suppliers residing in the same Country as the customer') AS REMARKS FROM Orders A
LEFT JOIN OrderDetails B ON A.OrderID = B.OrderID
LEFT JOIN Customers C ON A.CustomerID = C.CustomerID
LEFT JOIN Suppliers D ON B.SupplierID = D.SupplierID
WHERE C.Country = D.Country;


--- Find the cumulative sum of total order amount for the year 2021
--------------------------------------------------------------------------------------------------------------------
WITH CTE1 AS(
SELECT OrderID, ROUND(Total_order_amount,2) AS Total_order_amount,
SUM(Total_order_amount) OVER(ORDER BY ORDERID) AS CUMMULATIVE_ORDER_AMOUNT
FROM Orders WHERE YEAR(OrderDate) = 2021)
SELECT OrderID, Total_order_amount, ROUND(CUMMULATIVE_ORDER_AMOUNT,2) FROM CTE1;


--- Find the cumulative sum of total orders placed for the year 2020
--------------------------------------------------------------------------------------------------------------------
WITH CTE1 AS(
SELECT OrderID, ROUND(Total_order_amount,2) AS Total_order_amount,
SUM(Total_order_amount) OVER(ORDER BY ORDERID) AS CUMMULATIVE_ORDER_AMOUNT
FROM Orders WHERE YEAR(OrderDate) = 2020)
SELECT OrderID, Total_order_amount, ROUND(CUMMULATIVE_ORDER_AMOUNT,2) FROM CTE1;


--- MOST SOLD PRODUCT
--------------------------------------------------------------------------------------------------------------------
SELECT TOP 1 C.Product, B.ProductID, SUM(B.Quantity) AS TOTAL FROM Orders A
LEFT JOIN OrderDetails B ON A.OrderID = B.OrderID
LEFT JOIN Products C ON B.ProductID = C.ProductID
GROUP BY C.Product, B.ProductID
ORDER BY TOTAL DESC;


/* Create a YOY analysis for the count of customers enrolled with the company each month.
Columns should be month year_n, year_m */
--------------------------------------------------------------------------------------------------------------------
SELECT * FROM (
SELECT MONTH(DateEntered) AS MONTHS , YEAR(DateEntered) AS YEAR_,
COUNT(DISTINCT(CUSTOMERID)) AS TOTAL_CUST FROM Customers
GROUP BY MONTH(DateEntered), YEAR(DateEntered)) C
PIVOT( SUM(TOTAL_CUST) FOR YEAR_ IN ([2020],[2021])) AS T1;


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------