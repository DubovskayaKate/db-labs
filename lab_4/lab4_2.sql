USE AdventureWorks2012;

-- Task 4,2 1
CREATE VIEW Sales.vSalesOrderReason
WITH SCHEMABINDING AS
SELECT 
    sohsr.SalesOrderID,
	sohsr.SalesReasonID,
	sr.Name,
	sr.ReasonType,
	sr.ModifiedDate,
	soh.CustomerID
FROM Sales.SalesOrderHeaderSalesReason sohsr
JOIN Sales.SalesReason sr 
	ON (sr.SalesReasonID = sohsr.SalesReasonID)
JOIN Sales.SalesOrderHeader soh
    ON (soh.SalesOrderID = sohsr.SalesOrderID);


CREATE UNIQUE CLUSTERED INDEX Index_vSalesOrderReason
	ON Sales.vSalesOrderReason (SalesOrderID, SalesReasonID);

exec sp_help 'Sales.vSalesOrderReason'

-- Task 4,2 2
CREATE TRIGGER TRG_vSalesOrderReason
ON Sales.vSalesOrderReason
INSTEAD OF UPDATE, INSERT, DELETE
AS
IF EXISTS(SELECT * FROM inserted) 
	AND EXISTS (SELECT * FROM deleted)
BEGIN
    UPDATE Sales.SalesReason
    SET Name = I.Name,
		ReasonType = I.ReasonType,
		ModifiedDate = I.ModifiedDate
    FROM Sales.SalesReason SR
    INNER JOIN inserted I
        ON I.SalesReasonId = sr.SalesReasonId;    
END

IF EXISTS(SELECT * FROM inserted) 
	AND NOT EXISTS (SELECT * FROM deleted)
BEGIN
    INSERT INTO Sales.SalesReason 
	(Name, ReasonType, ModifiedDate)
    SELECT Name, ReasonType, GETDATE()
    FROM inserted;
    
    INSERT INTO Sales.SalesOrderHeaderSalesReason 
	(SalesOrderId, SalesReasonID, ModifiedDate)
    SELECT I.SalesOrderID, I.SalesReasonID, I.ModifiedDate
    FROM inserted I;
END

IF NOT EXISTS (SELECT * FROM inserted) 
	AND EXISTS (SELECT * FROM deleted)
BEGIN
    DELETE FROM Sales.SalesOrderHeaderSalesReason
	WHERE SalesOrderID IN (SELECT SalesOrderID FROM deleted	)
		AND SalesReasonID IN (SELECT SalesReasonId FROM deleted	)

    DELETE FROM Sales.SalesReason 
    WHERE SalesReasonId = (SELECT SalesReasonId FROM deleted)
        AND SalesReasonId NOT IN (SELECT SalesReasonId FROM Sales.SalesOrderHeaderSalesReason)
END;

/*SELECT m.definition 
FROM sys.all_sql_modules m 
INNER JOIN  sys.triggers t
ON m.object_id = t.object_id */

-- Task 4,2 3
SELECT * FROM Sales.SalesOrderHeaderSalesReason
WHERE SalesOrderID = 43703
SELECT * FROM Sales.SalesReason 
WHERE SalesReasonID in (6)
SELECT * FROM Sales.vSalesOrderReason
WHERE CustomerID = 16624

INSERT INTO Sales.vSalesOrderReason (SalesOrderID, SalesReasonID, Name, ReasonType, CustomerID, ModifiedDate)
VALUES (43703, 6, 'Review', 'Other', 16624, GETDATE())

UPDATE Sales.vSalesOrderReason 
SET Name = 'Other', 
	ReasonType = 'Other'
WHERE SalesOrderID = 43703
    AND SalesReasonID = 6

DELETE FROM Sales.vSalesOrderReason 
WHERE SalesOrderID = 43703
    AND SalesReasonID = 6

--select * from Sales.vSalesOrderReason WHERE SalesOrderID = 43703

--	select * from Sales.SalesReason where ModifiedDate > '2020-06-01 00:00:00.000' order by ModifiedDate desc
--	select * from Sales.SalesOrderHeaderSalesReason where ModifiedDate > '2020-06-01 00:00:00.000' order by ModifiedDate desc



	