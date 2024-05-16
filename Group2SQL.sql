ALTER TABLE Group2Items RENAME TO items;
ALTER TABLE Group2Category RENAME TO category;
ALTER TABLE Group2Customer RENAME TO customer;
ALTER TABLE Group2Transactions RENAME TO transactions;
ALTER TABLE Group2PaymentMethod RENAME TO paymentmethod;
ALTER TABLE Group2Supplier RENAME TO supplier;
ALTER TABLE Group2ItemSales RENAME TO itemsales;

select * from transactions;
select * from customer; 
select * from paymentmethod;
select * from items;
select * from category;
select * from itemsales;
select * from supplier;

#1.Calculate Total Sales Per Category
SELECT Category, SUM(Net_Sales) as Total_Sales
FROM Category c
JOIN Items i ON c.Category_ID = i.Category_ID
JOIN ItemSales its ON i.SKU_ID = its.SKU_ID
JOIN Transactions t ON its.Transaction_ID = t.Transaction_ID
GROUP BY Category
Order by SUM(Net_Sales) desc;
    
#2. Identify Top 5 Items by Sales
SELECT Item, SUM(Net_Sales) as Total_Sales
FROM Items i 
JOIN ItemSales its ON i.SKU_ID = its.SKU_ID
JOIN Transactions t ON its.Transaction_ID = t.Transaction_ID
GROUP BY Item
ORDER BY Total_Sales DESC
LIMIT 5;

#3. Calculate Average Transaction Value by Payment Method
SELECT Payment_Method, AVG(Total_Collected) as Avg_Transaction_Value
FROM Transactions t 
JOIN PaymentMethod p ON t.Card_Entry_Methods = p.Payment_ID
GROUP BY Payment_Method;
    
#4. List Suppliers Associated with Categories Having Total Sales Above a Certain Threshold
SELECT Supplier_Name, Category
FROM Supplier s
JOIN Category c ON s.Category_ID = c.Category_ID
JOIN Items i ON c.Category_ID = i.Category_ID
JOIN ItemSales its ON i.SKU_ID = its.SKU_ID
JOIN Transactions t ON its.Transaction_ID = t.Transaction_ID
GROUP BY Supplier_Name, Category
HAVING SUM(Net_Sales) > 10;

#5. Identify Customers with the Highest Total Purchase Value
SELECT First_Name, Last_Name, SUM(Net_Sales) as Total_Purchases
FROM Customer c 
JOIN Transactions t ON c.Customer_Reference_ID = t.Customer_Reference_ID
GROUP BY First_Name, Last_Name
ORDER BY Total_Purchases DESC
LIMIT 1;

#6.Calculate the Total Sales and Average Price of Items for Each Category
SELECT Category, SUM(Net_Sales) as Total_Sales, AVG(Price) as Avg_Price
FROM Category c 
JOIN Items i ON c.Category_ID = i.Category_ID
JOIN ItemSales its ON i.SKU_ID = its.SKU_ID
JOIN Transactions t ON its.Transaction_ID = t.Transaction_ID
GROUP BY Category;

#7.Identify the Most Popular Payment Method Based on Transaction Count
SELECT Payment_Method, COUNT(*) as Transaction_Count
FROM Transactions t 
JOIN PaymentMethod p ON t.Card_Entry_Methods = p.Payment_ID
GROUP BY Payment_Method
ORDER BY Transaction_Count DESC
LIMIT 1;

#8.Customers with Most Transactions
SELECT c.First_Name, c.Last_Name, COUNT(t.Transaction_ID) AS Total_Transactions 
FROM Customer c 
JOIN Transactions t ON c.Customer_Reference_ID = t.Customer_Reference_ID 
GROUP BY c.First_Name, c.Last_Name 
ORDER BY Total_Transactions DESC;

#9.Customers’ Favorite Card Brands
SELECT COUNT(Card_Brand), Card_Brand
FROM transactions
GROUP BY Card_Brand;

#10.Sales Performance of Suppliers
SELECT s.Supplier_Name, SUM(t.Net_Sales) AS Total_Sales 
FROM Supplier s 
JOIN Items i ON s.Category_ID = i.Category_ID 
JOIN ItemSales its ON i.SKU_ID = its.SKU_ID 
JOIN Transactions t ON its.Transaction_ID = t.Transaction_ID 
GROUP BY s.Supplier_Name 
ORDER BY Total_Sales DESC;

#11.Identify Items Not Sold
SELECT i.Item 
FROM Items i 
LEFT JOIN ItemSales its ON i.SKU_ID = its.SKU_ID 
WHERE its.SKU_ID IS NULL;

#12.Find the Category with the Most Items
SELECT cat.Category, COUNT(i.Item) AS Total_Items
FROM Category cat 
JOIN Items i ON cat.Category_ID = i.Category_ID
GROUP BY cat.Category
ORDER BY Total_Items DESC 
LIMIT 1;

#13.Customer Count Per Category
SELECT c.Category, COUNT(DISTINCT t.Customer_Reference_ID) AS Unique_Customer_Count 
FROM Category c 
JOIN Items i ON c.Category_ID = i.Category_ID 
JOIN ItemSales its ON i.SKU_ID = its.SKU_ID 
JOIN Transactions t ON its.Transaction_ID = t.Transaction_ID 
GROUP BY c.Category 
ORDER BY Unique_Customer_Count DESC;