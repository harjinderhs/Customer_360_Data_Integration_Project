CREATE VIEW View4_ResolutionSuccessRate AS
SELECT
    a.AgentID,
    a.Name AS AgentName,
    a.Department,
    COUNT(csi.InteractionID) AS TotalInteractions,
    SUM(CASE WHEN csi.ResolutionStatus = 'Resolved' THEN 1 ELSE 0 END) AS ResolvedInteractions,
    CAST(ROUND(
        100.0 * SUM(CASE WHEN csi.ResolutionStatus = 'Resolved' THEN 1 ELSE 0 END) 
        / NULLIF(COUNT(csi.InteractionID), 0), 2
    ) AS DECIMAL(5,2)) AS ResolutionSuccessRate
FROM 
    Agents a
LEFT JOIN 
    CustomerServiceInteractions csi ON a.AgentID = csi.AgentID
GROUP BY 
    a.AgentID, a.Name, a.Department;


SELECT * FROM View4_ResolutionSuccessRate