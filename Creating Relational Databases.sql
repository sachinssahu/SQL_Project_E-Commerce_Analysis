--- CREATING RELATIONAL DATABASE
CREATE DATABASE Ecomm_schema;

--- USING THE CREATED DATABASE
USE Ecomm_schema;

/***********************************************************************************************************/

--- CREATING TABLES AS PER DESIRED SCHEMA ---

CREATE TABLE Suppliers(
SupplierID int PRIMARY KEY NOT NULL,
CompanyName	varchar(50) NOT NULL,
Address	varchar(50) NOT NULL,
City varchar(50) NOT NULL,
State varchar (30) NOT NULL,
PostalCode varchar(60) NOT NULL,
Country varchar(50) NOT NULL,
Phone varchar(15) NOT NULL,
Email varchar(25) NOT NULL);

--- CHECKING CREATED TABLE
SELECT * FROM Suppliers;


--- CREATING TABLES
CREATE TABLE Payments(
PaymentID int PRIMARY KEY,
PaymentType	varchar(50) NOT NULL,
Allowed	bit NOT NULL);

--- CHECKING CREATED TABLE
SELECT * FROM Payments;


--- CREATING TABLES
CREATE TABLE Shippers(
ShipperID int Primary Key,
CompanyName	varchar(50) NOT NULL,
Phone varchar(25) NOT NULL);

--- CHECKING CREATED TABLE
SELECT * FROM Shippers;


--- CREATING TABLES
CREATE TABLE Category(
CategoryID int PRIMARY KEY,
CategoryName varchar(50) NOT NULL,
Active varchar(3) NOT NULL);

--- CHECKING CREATED TABLE
SELECT * FROM Category;


--- CREATING TABLES
CREATE TABLE Customers(
CustomerID int Primary Key,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
City varchar(50) NOT NULL,
State varchar(30) NOT NULL,
Country	varchar(60) NOT NULL,
PostalCode varchar(50) NOT NULL,
Phone varchar(15) NOT NULL,
Email varchar(25) NOT NULL,
DateEntered varchar(15) NOT NULL);

--- CHECKING CREATED TABLE
SELECT * FROM Customers;


--- CREATING TABLES
CREATE TABLE Products(
ProductID int PRIMARY KEY,
Product varchar(100) NOT NULL,
CategoryID int NOT NULL,
Sub_Category varchar(50) NOT NULL,
Brand varchar(50) NOT NULL,
Sale_Price float NOT NULL,
Market_Price float NOT NULL,
Type varchar(50) NOT NULL,
Rating varchar(25) NOT NULL
CONSTRAINT For_key3 Foreign Key (CategoryID) REFERENCES Category(CategoryID));

--- CHECKING CREATED TABLE
SELECT * FROM Products;


--- CREATING TABLES
CREATE TABLE Orders(
OrderID int PRIMARY KEY,
CustomerID int Foreign Key (CustomerID) REFERENCES Customers(CustomerID),
PaymentID int Foreign Key (PaymentID) REFERENCES Payments(PaymentID),
OrderDate datetime NOT NULL,
ShipperID int Foreign Key (ShipperID) REFERENCES Shippers(ShipperID),
ShipDate datetime NOT NULL,
DeliveryDate datetime NOT NULL,
Total_order_amount Float NOT NULL);

--- CHECKING CREATED TABLE
SELECT * FROM Orders;


--- CREATING TABLES
CREATE TABLE OrderDetails(
OrderDetailID int PRIMARY KEY,
OrderID	int Foreign Key (OrderID) REFERENCES Orders(OrderID),
ProductID int Foreign Key (ProductID) REFERENCES Products(ProductID),
Quantity int NOT NULL,
SupplierID int Foreign Key (SupplierID) REFERENCES Suppliers(SupplierID));

--- CHECKING CREATED TABLE
SELECT * FROM OrderDetails;

--- GIVES TABLE INFORMATION IN THE DATABASE
SELECT * FROM INFORMATION_SCHEMA.TABLES;

--- GIVES COLUMNS INFORMATION IN THE DATABASE
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;