USE AdventureWorks2012;

-- Task 4,1 1
CREATE TABLE Sales.SalesReasonHst (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Action NVARCHAR(20) NOT NULL,
    ModifiedDate DateTime NOT NULL,
    SourceID NVARCHAR(10) NOT NULL,
    UserName NVARCHAR(120)
);

exec sp_help 'Sales.SalesReasonHst'

-- DROP TRIGGER Insert_TRG_SalesReason;
-- DROP TRIGGER Update_TRG_SalesReason;
-- DROP TRIGGER Delete_TRG_SalesReason;

-- Task 4,1 2
CREATE TRIGGER Insert_TRG_SalesReason
ON Sales.SalesReason
AFTER INSERT AS
INSERT INTO Sales.SalesReasonHst 
(
	Action,
	ModifiedDate,
	SourceID,
	UserName)
SELECT 
    'INSERT', 
    GETDATE(), 
    SalesReasonID,
    SYSTEM_USER
FROM inserted;

CREATE TRIGGER Update_TRG_SalesReason
ON Sales.SalesReason
AFTER UPDATE AS
INSERT INTO Sales.SalesReasonHst (
	Action,
	ModifiedDate,
	SourceID,
	UserName)
SELECT
	'UPDATE', 
	GETDATE(), 
	SalesReasonID,
	SYSTEM_USER
FROM inserted;

CREATE TRIGGER Delete_TRG_SalesReason
ON Sales.SalesReason
AFTER DELETE AS
INSERT INTO Sales.SalesReasonHst (
	Action,
	ModifiedDate,
	SourceID,
	UserName)
SELECT 
	'DELETE', 
	GETDATE(),
	SalesReasonID,
	SYSTEM_USER
FROM deleted;

-- exec sp_help 'Sales.SalesReason'

/*SELECT m.definition 
FROM sys.all_sql_modules m 
INNER JOIN  sys.triggers t
ON m.object_id = t.object_id */


-- Task 4,1 3

CREATE VIEW Sales.vSalesReason 
WITH ENCRYPTION AS
SELECT * 
FROM Sales.SalesReason;

/*SELECT m.*
FROM sys.all_sql_modules m 
INNER JOIN  sys.views t
ON m.object_id = t.object_id*/


SELECT *
FROM Sales.vSalesReason;

SELECT *
FROM Sales.SalesReason;

-- Task 4,1 4
INSERT INTO Sales.vSalesReason 
(Name, ReasonType, ModifiedDate)
VALUES 
('KateDubovskaya', 'Marketing', GETDATE())

UPDATE Sales.vSalesReason 
SET Name = 'KateDubovskayaV2',
	ReasonType='Promotion',
	ModifiedDate=GETDATE()
WHERE SalesReasonID = 12

DELETE FROM Sales.vSalesReason
WHERE SalesReasonID = 12

SELECT *
FROM Sales.SalesReasonHst