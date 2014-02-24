USE AdventureWorksDW2008R2;
With C1 AS
(Select			FRS.OrderQuantity,
                FRS.SalesAmount AS Revenue,
                PC.EnglishProductCategoryName AS ProductCategory,
				SUBSTRING(G.PostalCode,1,5) AS PostalCode,
				R.ResellerKey AS Buyerkey
	FROM		FactResellerSales FRS
                INNER JOIN DimProduct P  ON FRS.ProductKey = P.ProductKey
                INNER JOIN DimProductSubCategory PS ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
                INNER JOIN DimProductCategory PC ON PS.ProductCategoryKey = PC.ProductCategoryKey
                INNER JOIN DimReseller R ON R.ResellerKey = FRS.ResellerKey
                INNER JOIN DimGeography G ON R.GeographyKey = G.GeographyKey
                INNER JOIN DimSalesTerritory ST ON FRS.SalesTerritoryKey = ST.SalesTerritoryKey
     WHERE      G.CountryRegionCode  = 'US'
				AND ST.SalesTerritoryCountry = 'United States'
UNION ALL
	Select		FIS.OrderQuantity,
                FIS.SalesAmount AS Revenue  ,
                PC.EnglishProductCategoryName AS ProductCategory,
                SUBSTRING(G.PostalCode,1,5) AS PostalCode,
                C.CustomerKey AS BuyerKey
	FROM		FactInternetSales FIS
                INNER JOIN DimProduct P ON FIS.ProductKey = P.ProductKey
                INNER JOIN DimProductSubCategory PS ON P.ProductSubcategoryKey = PS.ProductSubcategoryKey
                INNER JOIN DimProductCategory PC ON PC.ProductCategoryKey = PS.ProductCategoryKey
                INNER JOIN DimCustomer C ON FIS.CustomerKey = C.CustomerKey
                INNER JOIN DimGeography G ON C.GeographyKey = G.GeographyKey
                INNER JOIN DimSalesTerritory ST ON FIS.SalesTerritoryKey = ST.SalesTerritoryKey
	WHERE		G.CountryRegionCode  = 'US'
				AND ST.SalesTerritoryCountry = 'United States'
          )
SELECT   A1.PostalCode,
         COUNT (DISTINCT A1.BuyerKey)	AS DistinctBuyers,
         AVG(A1.REVENUE/A1.OrderQuantity)         AS Average_Order_Value,
         SUM(A1.REVENUE)                AS Total_Revenue,
         MAX(A2.ProductCategory)		AS MostPopular_ProductCategory
FROM     C1 AS A1
JOIN 
(Select PostalCode, C1.ProductCategory,
		RANK () OVER (Partition By C1.PostalCode Order By SUM(C1.OrderQuantity)DESC) AS Quantity_Rank
From	C1
Group By PostalCode, ProductCategory) 
		AS A2
ON A1.PostalCode = A2.PostalCode
Where A2.Quantity_Rank = 1
Group By A1.PostalCode
Order By PostalCode

