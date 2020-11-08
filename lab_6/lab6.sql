USE AdventureWorks2012;

CREATE PROCEDURE dbo.SalesByRegions (@Regions NVARCHAR(400)) AS
BEGIN
	-- DECLARE @Regions NVARCHAR(1000) = '[AU],[CA],[DE],[FR],[GB],[US]';
	DECLARE @Script NVARCHAR(1000);
	SET @Script = 	'SELECT OrderYear,' + @Regions +' 
					 FROM
					 (
						SELECT YEAR(sho.OrderDate) as OrderYear, TotalDue, CountryRegionCode
						FROM Sales.SalesOrderHeader sho
						JOIN Sales.SalesTerritory st ON sho.TerritoryID = st.TerritoryID
					 ) p 
					 PIVOT
					 (
						SUM(TotalDue)
						FOR CountryRegionCode IN (' + @Regions + ')
					 ) as pT;';
	EXECUTE (@Script);
	RETURN;
END;

--DROP PROCEDURE dbo.SalesByRegions; 


SELECT m.definition 
FROM sys.all_sql_modules m 
INNER JOIN  sys.procedures t
ON m.object_id = t.object_id

EXECUTE dbo.SalesByRegions '[AU],[CA],[DE],[FR],[GB],[US]';