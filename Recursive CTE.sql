
-- Returns all raw imported transactions (1000)
SELECT *
  FROM DC1.dbo.raw_Transactions

-- Returns all transactions where ModifiedID is not null (36)
SELECT TransactionID,
       ClientID,
       Client_Name,
       Value,
       Description,
       Date,
       ModifiedID
  FROM DC1.dbo.raw_Transactions WHERE ModifiedID IS NOT NULL ORDER BY Client_Name, TransactionID
   
-- Analysis on transactions with duplicate dates and descriptions on the same client

--DROP TABLE #tempTransactions
SELECT t.* 
--INTO #tempTransactions 
FROM DC1.dbo.raw_Transactions t
LEFT JOIN (
SELECT ClientID,
	   CAST(Description as NVARCHAR(200)) as Description, 
	   Date 
	FROM DC1.dbo.raw_Transactions
	GROUP BY ClientID,
		   CAST(Description as NVARCHAR(200)),
		   Date
	HAVING COUNT(CAST(Description as NVARCHAR(200))) > 2 AND COUNT(Date) > 2) t1 on t.ClientID = t1.ClientID AND t.Date = t1.Date WHERE t1.ClientID IS NOT NULL 
	ORDER BY ClientID, TransactionID



;WITH TransactionHierarchy AS (
    -- Base case: Select the root transactions (those where TransactionID = ModifiedID)
    SELECT 
        TransactionID,
        ClientID,
        Client_Name,
        Value,
        Description,
        Date,
        ModifiedID,
		TransactionID AS OriginalID,
        1 AS Level  -- This is the root level of the recursion
    FROM #tempTransactions
    WHERE TransactionID = ModifiedID  -- Start with transactions where ModifiedID matches TransactionID
    
    UNION ALL
    
    -- Recursive case: Join the table with itself to find the next level of transactions
    SELECT 
        t.TransactionID,
        t.ClientID,
        t.Client_Name,
        t.Value,
        t.Description,
        t.Date,
        t.ModifiedID,
		th.OriginalID, -- Take OrinigalID from the join ensuring it will always be the first ID
        th.Level + 1 AS Level  -- Increment the level for each recursive step
    FROM #tempTransactions t
    INNER JOIN TransactionHierarchy th
        ON t.ModifiedID = th.TransactionID -- Join the table back on ModifiedID = TransactionID
	WHERE th.Level < 100 -- Limit recursion
)
-- Select from the result of the recursive CTE
SELECT 
	TransactionID,
	MAX(ClientID) as ClientID,
	MAX(Client_Name) as Client_Name,
	MAX(Value) as Value,
	MAX(Description) as Description,
	MAX(Date) as Date,
	MAX(ModifiedID) as ModifiedID,
	MAX(OriginalID) as OriginalID,
	MIN(Level) as Level -- Must be MIN to show the base level of the recursion
FROM TransactionHierarchy
GROUP BY TransactionID
ORDER BY MAX(ClientID), MAX(Level), TransactionID