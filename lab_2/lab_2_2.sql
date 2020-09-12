USE AdventureWorks2012;

exec sp_help 'HumanResources.Employee'

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

ALTER TABLE dbo.Employee
	ADD ID bigint identity (0, 2);

ALTER TABLE dbo.Employee
	ADD  CHECK (BirthDate > CONVERT (datetime,'19000101', 112) and BirthDate < GETDATE())

ALTER TABLE dbo.Employee
	ADD DEFAULT (GETDATE()) for HireDate

INSERT INTO dbo.Employee (	BusinessEntityID,
	NationalIDNumber,
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	VacationHours,
	SickLeaveHours,
	ModifiedDate)
(SELECT e.BusinessEntityID,
	e.NationalIDNumber,
	e.LoginID,
	e.JobTitle,
	e.BirthDate,
	e.MaritalStatus,
	e.Gender,
	e.VacationHours,
	e.SickLeaveHours,
	e.ModifiedDate FROM HumanResources.Employee e 
INNER JOIN Person.Person p on e.BusinessEntityID = p.BusinessEntityID  
WHERE p.EmailPromotion = 0 )

ALTER TABLE dbo.Employee
	ALTER COLUMN MaritalStatus NVARCHAR(1) NULL

exec sp_help 'dbo.Employee'


 