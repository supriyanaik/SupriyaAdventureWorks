USE AdventureWorks2008R2;
with C1 AS 
(Select
		SOD.OrderQty AS OrderQty,
		PC.Name AS ProductCategory,
		SOH.CustomerID,
		SOD.LineTotal AS LineTotal,
		PA.PostalCode AS PostalCode
From	Sales.SalesOrderHeader SOH
		INNER JOIN Sales.SalesOrderDetail SOD			ON SOH.SalesOrderID = SOD.SalesOrderID
		INNER JOIN Production.Product PP				ON PP.ProductID = SOD.ProductID
		INNER JOIN Production.ProductSubcategory PS		ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
		INNER JOIN Person.Address PA					ON SOH.BillToAddressID = PA.AddressID
		INNER JOIN Production.ProductCategory PC		ON PC.ProductCategoryID = PS.ProductCategoryID
		INNER JOIN Person.StateProvince SP				ON SP.StateProvinceID = PA.StateProvinceID
		INNER JOIN Sales.Customer C						ON C.CustomerID = SOH.CustomerID
Where	SP.CountryRegionCode = 'US'
       )
Select	A1.PostalCode,
Count (Distinct CustomerID) as Distinct_Buyers,
AVG (A1.LineTotal/A1.OrderQty) AS Average_Order_Value,
SUM(A1.LineTotal) As Total_Revenue,
MAX(A2.ProductCategory) As MostPopular_ProductCategory
From C1 AS A1
JOIN 
(Select PostalCode,
C1.ProductCategory,
RANK () OVER (Partition By C1.PostalCode Order By SUM(C1.OrderQty)DESC) AS Quantity_Rank
From C1
Group By PostalCode, ProductCategory) 
AS A2
ON A1.PostalCode = A2.PostalCode
Where A2.Quantity_Rank = 1
Group By A1.PostalCode
Order By PostalCode
