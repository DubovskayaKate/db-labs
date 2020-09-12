USE AdventureWorks2012;

-- a) �������� � ������� dbo.Employee ���� Name ���� nvarchar ������������ 60 ��������;

ALTER TABLE dbo.Employee
	ADD Name NVARCHAR(60);

-- b) �������� ��������� ���������� � ����� �� ���������� ��� dbo.Employee � ��������� �� ������� �� dbo.Employee. ���� Name ��������� ������� ������� Person.Person, �� ����� Title � FirstName. ���� Title �������� null ��������, �������� ��� �� �M.�;

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
	
-- c) �������� ���� Name � dbo.Employee ������� �� ��������� ����������;

UPDATE dbo.Employee
SET Name =eVar.Name
FROM dbo.Employee e
INNER JOIN @Employee eVar ON  e.BusinessEntityID=eVar.BusinessEntityID;

Select * from dbo.Employee;

-- d) ������� �� dbo.Employee �����������, ������� ���� �� ��� ������ ����� (������� HumanResources.EmployeeDepartmentHistory);

select 
	 e_edh1.DepartmentID, e_edh1.BusinessEntityID
FROM 
	(select 
		 edh1.DepartmentID, e1.BusinessEntityID
	FROM 
		dbo.Employee e1
	INNER JOIN HumanResources.EmployeeDepartmentHistory edh1 ON e1.BusinessEntityID= edh1.BusinessEntityID
	) as e_edh1,
	(select 
		 edh1.DepartmentID, e1.BusinessEntityID
	FROM 
		dbo.Employee e1
	INNER JOIN HumanResources.EmployeeDepartmentHistory edh1 ON e1.BusinessEntityID= edh1.BusinessEntityID
	) as e_edh2

WHERE 
	e_edh1.DepartmentID != e_edh2.DepartmentID AND e_edh1.BusinessEntityID=e_edh2.BusinessEntityID


-- e) ������� ���� Name �� �������, ������� ��� ��������� ����������� � �������� �� ���������.
/*����� ����������� �� ������ ����� � ����������. ��������:

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Employee';
����� �������� �� ��������� ������� ��������������, ��������� ���, ������� ������������ ��� ������;*/


ALTER TABLE 
	dbo.Employee 
DROP COLUMN 
	Name,
	ID;

-- ADD SCRIPT FOR LOOKING

ALTER TABLE
    dbo.Employee 
DROP CONSTRAINT
    CK_Employee_BirthD,
    DF_Employee_HireDa;


-- f) ������� ������� dbo.Employee.
DROP TABLE
	dbo.Employee