CREATE View View2_CutsomerSegments AS
WITH LoyaltyRanked AS (
    SELECT 
        la.CustomerID,
        la.TierLevel,
        CASE la.TierLevel
            WHEN 'Platinum' THEN 4
            WHEN 'Gold' THEN 3
            WHEN 'Silver' THEN 2
            WHEN 'Bronze' THEN 1
            ELSE 0
        END AS TierRank
    FROM LoyaltyAccounts la
),
HighestTier AS (
    SELECT CustomerID, TierLevel
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY TierRank DESC) AS rnk
        FROM LoyaltyRanked
    ) ranked
    WHERE rnk = 1
),
OnlineSpend AS (
    SELECT 
        CustomerID,
        SUM(Amount) AS OnlineAmount,
        COUNT(DISTINCT OrderID) AS PurchaseCount
    FROM OnlineTransactions
    GROUP BY CustomerID
),
InStoreSpend AS (
    SELECT 
        CustomerID,
        SUM(Amount) AS InStoreAmount,
        COUNT(DISTINCT TransactionID) AS PurchaseCount
    FROM InStoreTransactions
    GROUP BY CustomerID
),
CustomerSpend AS (
    SELECT 
        c.CustomerID,
        c.Name,
        c.Email,
        ISNULL(ht.TierLevel, 'None') AS TierLevel,
        ISNULL(os.OnlineAmount, 0) + ISNULL(iss.InStoreAmount, 0) AS TotalSpend,
        ISNULL(os.PurchaseCount, 0) + ISNULL(iss.PurchaseCount, 0) AS PurchaseFrequency
    FROM Customers c
    LEFT JOIN HighestTier ht ON c.CustomerID = ht.CustomerID
    LEFT JOIN OnlineSpend os ON c.CustomerID = os.CustomerID
    LEFT JOIN InStoreSpend iss ON c.CustomerID = iss.CustomerID
),
SpendWithPercentile AS (
    SELECT *,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY TotalSpend) OVER () AS P90Spend
    FROM CustomerSpend
)
SELECT
    CustomerID,
    Name,
    Email,
    TierLevel,
    TotalSpend,
    PurchaseFrequency,
    CASE
        WHEN TotalSpend >= P90Spend THEN 'High-Value Customer'
        WHEN PurchaseFrequency = 1 THEN 'One-Time Buyer'
        WHEN TierLevel IN ('Gold', 'Platinum') THEN 'Loyalty Champion'
        ELSE 'Regular Customer'
    END AS Segment
FROM SpendWithPercentile;

SELECT * FROM View2_CutsomerSegments ORDER BY TotalSpend DESC;