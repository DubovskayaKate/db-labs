USE AdventureWorks2012;

-- Lab 3, Task 1, 1
ALTER TABLE dbo.Employee
	ADD Name NVARCHAR(60);

-- Lab 3, Task 1, 2
DECLARE @Employee TABLE
(
	BusinessEntityID	int NOT NULL,
	NationalIDNumber	nvarchar(15) NOT NULL,
	LoginID	nvarchar(256) NOT NULL,
	JobTitle	nvarchar(50) NOT NULL,
	BirthDate	date NOT NULL,
	MaritalStatus NVARCHAR(1) NULL, -- Discription was updated 
	Gender	nchar(1) NOT NULL,
	HireDate	date NOT NULL,
	VacationHours	smallint NOT NULL,
	SickLeaveHours	smallint NOT NULL,
	ModifiedDate	datetime NOT NULL,
	Name NVARCHAR(60)
);

INSERT INTO @Employee(
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	VacationHours,
	SickLeaveHours,
	ModifiedDate,
	Name
)
SELECT
	e.BusinessEntityID,
	e.NationalIDNumber,
	e.LoginID,
	e.JobTitle,
	e.BirthDate,
	e.MaritalStatus,
	e.Gender,
	e.HireDate,
	e.VacationHours,
	e.SickLeaveHours,
	e.ModifiedDate,
	CONCAT( (CASE WHEN p.Title IS NULL THEN 'M.' ELSE p.Title END ), p.FirstName)
FROM dbo.Employee as e
	LEFT JOIN Person.Person as p ON p.BusinessEntityID = e.BusinessEntityID;

-- Lab 3, Task 1, 3

UPDATE dbo.Employee
SET Name = eVar.Name
FROM dbo.Employee e
INNER JOIN @Employee eVar ON  e.BusinessEntityID=eVar.BusinessEntityID;

--SELECT * FROM dbo.Employee


-- Lab 3, Task 1, 4

DELETE FROM Employee
WHERE BusinessEntityID IN
(
	SELECT edh.BusinessEntityID
	FROM HumanResources.EmployeeDepartmentHistory edh
	WHERE edh.EndDate IS NOT NULL
)

SELECT * FROM dbo.Employee


-- Lab 3, Task 1, 5


ALTER TABLE dbo.Employee 
DROP COLUMN 
	Name;

--exec sp_help 'dbo.Employee'

DECLARE @query NVARCHAR(max) = N'' ;

SELECT 
	@query += N'ALTER TABLE dbo.Employee DROP CONSTRAINT ' + QUOTENAME(CONSTRAINT_NAME) + ';'
FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'Employee';

SELECT 
	@query += 'ALTER TABLE dbo.Employee DROP CONSTRAINT ' + QUOTENAME(d.name) + ';'
FROM sys.tables t
JOIN sys.schemas s	ON t.schema_id = s.schema_id
JOIN sys.default_constraints d	ON t.object_id = d.parent_object_id
WHERE s.name = 'dbo'
    AND t.name = 'Employee';

print (@query);
	
execute (@query);

exec sp_help 'dbo.Employee'


-- Lab 3, Task 1, 6
DROP TABLE
	dbo.Employee

