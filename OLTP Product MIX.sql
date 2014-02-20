USE AdventureWorks2008R2;
with c1 as 
(
Select
PP.ProductID,
PC.ProductCategoryID,
PP.ProductSubCategoryID,
PA.PostalCode,
SUM(SOD.OrderQty) AS Total_OrderQty,
SUM(SOD.LineTotal) AS Total_Revenue,
RANK () OVER (Partition By PA.PostalCode Order By SUM(SOD.LineTotal) DESC) AS Revenue_Rank
From Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN Production.Product PP ON PP.ProductID = SOD.ProductID
JOIN Production.ProductSubcategory PS ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PC.ProductCategoryID = PS.ProductCategoryID
INNER JOIN Person.StateProvince S ON S.TerritoryID = SOH.TerritoryID
INNER JOIN Person.Address PA ON S.StateProvinceID = PA.StateProvinceID
Where S.CountryRegionCode = 'US'
Group By PA.PostalCode, PP.ProductID,PC.ProductCategoryID, PS.ProductSubcategoryID, PP.ProductSubcategoryID
)
Select c1.ProductID,
c1.ProductCategoryID,
c1.ProductSubCategoryID,
c1.PostalCode,
c1.Total_Revenue,
c1.Total_OrderQty
From c1 
where c1.Revenue_Rank = 1
Order By Total_Revenue DESC