-- Lab 2_2, V_10, Dubovskaya Kate, 751001
USE AdventureWorks2012;

-- exec sp_help 'HumanResources.Employee'

-- Lab 2, Task 2, 1
CREATE TABLE dbo.Employee(
	BusinessEntityID	int NOT NULL,
	NationalIDNumber	nvarchar(15) NOT NULL,
	LoginID	nvarchar(256) NOT NULL,
	JobTitle	nvarchar(50) NOT NULL,
	BirthDate	date NOT NULL,
	MaritalStatus	nchar(1) NOT NULL,
	Gender	nchar(1) NOT NULL,
	HireDate	date NOT NULL,
	VacationHours	smallint NOT NULL,
	SickLeaveHours	smallint NOT NULL,
	ModifiedDate	datetime NOT NULL
);

-- Lab 2, Task 2, 2
ALTER TABLE dbo.Employee
	ADD ID bigint identity (0, 2);

-- Lab 2, Task 2, 3
ALTER TABLE dbo.Employee
	ADD CONSTRAINT birth_date_check CHECK (BirthDate > CONVERT (datetime,'19000101', 112) and BirthDate < GETDATE())

-- Lab 2, Task 2, 4
ALTER TABLE dbo.Employee
	ADD CONSTRAINT default_type DEFAULT (GETDATE()) for HireDate



-- Lab 2, Task 2, 5
INSERT INTO dbo.Employee (	
	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	VacationHours,
	SickLeaveHours,
	ModifiedDate)
(SELECT 
	e.BusinessEntityID,
	e.NationalIDNumber,
	e.LoginID,
	e.JobTitle,
	e.BirthDate,
	e.MaritalStatus,
	e.Gender,
	e.VacationHours,
	e.SickLeaveHours,
	e.ModifiedDate 
FROM HumanResources.Employee e 
INNER JOIN Person.Person p on e.BusinessEntityID = p.BusinessEntityID  
WHERE p.EmailPromotion = 0 )

SELECT *
FROM dbo.Employee

-- Lab 2, Task 2, 6
ALTER TABLE dbo.Employee
	ALTER COLUMN MaritalStatus NVARCHAR(1) NULL

-- exec sp_help 'dbo.Employee'


 