CREATE VIEW View3_PeakTimeTransactions AS
SELECT
    'Online' AS Channel,
    DATENAME(WEEKDAY, DateTime) AS DayOfWeek,
    DATEPART(HOUR, DateTime) AS HourOfDay,
    COUNT(OrderID) AS TotalTransactions
FROM 
    OnlineTransactions
GROUP BY 
    DATENAME(WEEKDAY, DateTime),
    DATEPART(HOUR, DateTime)

UNION ALL

SELECT
    'In-Store' AS Channel,
    DATENAME(WEEKDAY, DateTime) AS DayOfWeek,
    DATEPART(HOUR, DateTime) AS HourOfDay,
    COUNT(TransactionID) AS TotalTransactions
FROM 
    InStoreTransactions
GROUP BY 
    DATENAME(WEEKDAY, DateTime),
    DATEPART(HOUR, DateTime);

SELECT * FROM View3_PeakTimeTransactions