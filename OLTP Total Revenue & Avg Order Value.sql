USE AdventureWorks2008R2;
Select PA.PostalCode, 
SUM(SOD.LineTotal)AS 'Total_Revenue',
Sum(SOD.LineTotal)/ Sum(SOD.OrderQty) AS 'Avg_Order_Value'
From Sales.SalesOrderDetail SOD
JOIN Sales.SalesOrderHeader SOH
ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Person.StateProvince S
ON S.TerritoryID = SOH.TerritoryID
INNER JOIN Person.Address PA
ON S.StateProvinceID = PA.StateProvinceID
Where S.CountryRegionCode = 'US'
Group By PA.PostalCode
Order By Total_Revenue DESC
