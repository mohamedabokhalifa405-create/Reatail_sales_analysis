USE RetailSalesDB;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
USE RetailSalesDB;

USE RetailSalesDB;

SELECT
    QUOTENAME(SCHEMA_NAME(schema_id)) AS SchemaName,
    QUOTENAME(name) AS TableName
FROM sys.tables;
SELECT TOP 10 *
FROM [retail_sales_dataset];
SELECT
    COUNT(*) AS TotalTransactions,
    SUM(Quantity) AS TotalQuantitySold,
    SUM([Total_Amount]) AS TotalSales,
    AVG([Total_Amount]) AS AverageTransactionAmount
FROM [retail_sales_dataset];
SELECT
    [Product_Category],
    SUM([Total_Amount]) AS TotalSales
FROM [retail_sales_dataset]
GROUP BY [Product_Category]
ORDER BY TotalSales DESC;

SELECT [Gender],SUM([Total_Amount]) AS TOTALSALES
FROM [retail_sales_dataset]
GROUP BY [Gender]
ORDER BY TOTALSALES DESC;

SELECT
    YEAR([Date]) AS SalesYear,
    MONTH([Date]) AS SalesMonth,
    SUM([Total_Amount]) AS TotalSales
FROM [retail_sales_dataset]
GROUP BY
    YEAR([Date]),
    MONTH([Date])
ORDER BY
    
    TotalSales DESC;

SELECT TOP 10
    [Customer_ID],
    SUM([Total_Amount]) AS TotalSpent,
    COUNT(*) AS TotalRecords
FROM [retail_sales_dataset]
GROUP BY [Customer_ID]
ORDER BY TotalSpent DESC;

SELECT
    CASE
        WHEN Age < 20 THEN 'Under 20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS AgeGroup,
    COUNT(*) AS TotalRecords,
    SUM([Total_Amount]) AS TotalSales,
    AVG([Total_Amount]) AS AverageAmount
FROM [retail_sales_dataset]
GROUP BY
    CASE
        WHEN Age < 20 THEN 'Under 20'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END
ORDER BY TotalSales DESC

SELECT
    CAST([Date] AS DATE) AS SalesDate,
    SUM([Total_Amount]) AS TotalSales,
    COUNT(*) AS TotalRecords
FROM [retail_sales_dataset]
GROUP BY CAST([Date] AS DATE)
ORDER BY TotalSales DESC;


SELECT
    [Product_Category],
    AVG([Price_per_unit]) AS AverageUnitPrice,
    MIN([Price_per_unit]) AS MinimumUnitPrice,
    MAX([Price_per_unit]) AS MaximumUnitPrice
FROM [retail_sales_dataset]
GROUP BY [Product_Category]
ORDER BY AverageUnitPrice DESC;
SELECT
    Gender,
    [Product_Category],
    SUM([Total_Amount]) AS TotalSales,
    SUM(Quantity) AS TotalQuantitySold
FROM [retail_sales_dataset]
GROUP BY
    Gender,
    [Product_Category]
ORDER BY
    Gender,
    TotalSales DESC;

SELECT
    [Transaction_ID],
    COUNT(*) AS Occurrences
FROM [retail_sales_dataset]
GROUP BY [Transaction_ID]
HAVING COUNT(*) > 1
ORDER BY Occurrences DESC;
SELECT
    SUM(CASE WHEN [Transaction_ID] IS NULL THEN 1 ELSE 0 END) AS MissingTransactionID,
    SUM(CASE WHEN [Date] IS NULL THEN 1 ELSE 0 END) AS MissingDate,
    SUM(CASE WHEN [Customer_ID] IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS MissingGender,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS MissingAge,
    SUM(CASE WHEN [Product_Category] IS NULL THEN 1 ELSE 0 END) AS MissingCategory,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS MissingQuantity,
    SUM(CASE WHEN [Price_per_unit] IS NULL THEN 1 ELSE 0 END) AS MissingPrice,
    SUM(CASE WHEN [Total_Amount] IS NULL THEN 1 ELSE 0 END) AS MissingTotalAmount
FROM [retail_sales_dataset];

WITH MonthlySales AS (
    SELECT
        YEAR([Date]) AS SalesYear,
        MONTH([Date]) AS SalesMonth,
        SUM([Total_Amount]) AS TotalSales
    FROM [retail_sales_dataset]
    GROUP BY
        YEAR([Date]),
        MONTH([Date])
)
SELECT TOP 1
    SalesYear,
    SalesMonth,
    TotalSales
FROM MonthlySales
ORDER BY TotalSales DESC;
WITH CategorySales AS (
    SELECT
        [Product_Category],
        SUM([Total_Amount]) AS TotalSales
    FROM [retail_sales_dataset]
    GROUP BY [Product_Category]
)
SELECT
    [Product_Category],
    TotalSales,
    RANK() OVER (
        ORDER BY TotalSales DESC
    ) AS SalesRank
FROM CategorySales
ORDER BY SalesRank;