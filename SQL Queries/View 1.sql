CREATE VIEW View1_AverageOrderValue AS
SELECT 
    p.Category AS ProductCategory,
    c.Address AS Location,
    COUNT(o.OrderID) AS TotalOnlineOrders,
    SUM(o.Amount) AS Amount,
    CAST(ROUND(SUM(o.Amount) / COUNT(o.OrderID), 2) AS DECIMAL(10, 2)) AS AverageOrderValue
FROM 
    dbo.OnlineTransactions AS o
JOIN 
	dbo.Customers AS c ON o.CustomerID = c.CustomerID
JOIN
	dbo.Products AS p ON o.ProductID = p.ProductID
GROUP BY 
    p.Category, c.Address

SELECT * FROM View1_AverageOrderValue ORDER BY Amount DESC

