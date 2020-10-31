USE AdventureWorks2012;

-- Task 3,2 1
ALTER TABLE
    dbo.Employee
ADD
    SumSubTotal MONEY,
    LeaveHours as (VacationHours + SickLeaveHours);

exec sp_help 'dbo.Employee'

-- Task 3,2 2
CREATE TABLE #Employee 
(
	ID bigint,
	BusinessEntityID	int NOT NULL,
	NationalIDNumber	nvarchar(15) NOT NULL,
	LoginID	nvarchar(256) NOT NULL,
	JobTitle	nvarchar(50) NOT NULL,
	BirthDate	date NOT NULL,
	MaritalStatus nchar(1) NOT NULL,
	Gender	nchar(1) NOT NULL,
	HireDate	date NOT NULL,
	VacationHours	smallint NOT NULL,
	SickLeaveHours	smallint NOT NULL,
	ModifiedDate	datetime NOT NULL,
	SumSubTotal MONEY,
);

-- Task 3,2 3

WITH SumSubTotal_CTE(EmployeeID, SumSubTotal) as(
	Select EmployeeID, SUM(SubTotal) 
	From Purchasing.PurchaseOrderHeader
	GROUP BY EmployeeID
)

INSERT INTO #Employee(
    ID,
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
	SumSubTotal
)
SELECT
	e.ID,
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
	sst.SumSubTotal
FROM 
	dbo.Employee e
INNER JOIN SumSubTotal_CTE sst ON e.BusinessEntityID=sst.EmployeeID

SELECT * from #Employee;

-- Task 3,2 4
DELETE 
FROM dbo.Employee
WHERE LeaveHours > 160


-- Task 3,2 5
SET IDENTITY_INSERT dbo.Employee ON
MERGE
    dbo.Employee as targ
	USING #Employee as src
	ON (targ.ID = src.ID)
WHEN MATCHED THEN
    UPDATE 
	SET targ.SumSubTotal  = src.SumSubTotal
WHEN NOT MATCHED BY TARGET THEN
	INSERT
	(
		ID,
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
		SumSubTotal
	)
	VALUES
	(
		ID,
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
		SumSubTotal
	)
WHEN NOT MATCHED BY SOURCE THEN 
	DELETE;

-- Select * FROM dbo.Employee;

-- Select * FROM #Employee;

-- Drop table #Employee,dbo.Employee; 
