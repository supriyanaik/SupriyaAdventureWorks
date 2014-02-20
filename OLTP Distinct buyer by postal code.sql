USE AdventureWorks2008R2;
Select distinct SOH.CustomerID, 
PA.PostalCode
From Sales.SalesOrderHeader SOH
JOIN Person.StateProvince SP
ON SP.TerritoryID = SOH.TerritoryID 
JOIN Person.Address PA
ON PA.StateProvinceID = SP.StateProvinceID
Where Sp.CountryRegionCode = 'US'
Order By PostalCode
