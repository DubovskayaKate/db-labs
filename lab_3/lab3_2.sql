USE AdventureWorks2012;

-- begin transaction
--a) ��������� ���, ��������� �� ������ ������� ������ ������������ ������. 
-- �������� � ������� dbo.Employee ���� SumSubTotal MONEY. 
-- ����� �������� � ������� ����������� ���� LeaveHours, 
-- ����������� ����� ����� ������� � ���������� � ����� VacationHours � SickLeaveHours.

ALTER TABLE
    dbo.Employee
ADD
    SumSubTotal MONEY,
    LeaveHours as (VacationHours + SickLeaveHours);

--b) �������� ��������� ������� #Employee, � ��������� ������ �� ���� ID. 
-- ��������� ������� ������ �������� ��� ���� ������� dbo.Employee �� ����������� ���� LeaveHours.

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

--c) ��������� ��������� ������� ������� �� dbo.Employee. 
-- ���������� ����� ����� ��� ����� ������� � ��������� �������� (SubTotal), 
-- �� ������� ��������� (EmployeeID) ������� ������� � ������� Purchasing.PurchaseOrderHeader � 
-- ��������� ����� ���������� ���� SumSubTotal. ������� ����� ����������� � Common Table Expression (CTE).

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

--d) ������� �� ������� dbo.Employee ������, ��� LeaveHours > 160

DELETE 
FROM dbo.Employee
WHERE LeaveHours > 160


--e) �������� Merge ���������, ������������ dbo.Employee ��� target, � ��������� ������� ��� source. 
-- ��� ����� target � source ����������� ID. 
-- �������� ���� SumSubTotal, ���� ������ ������������ � source � target. 
-- ���� ������ ������������ �� ��������� �������, �� �� ���������� � target, �������� ������ � dbo.Employee. 
-- ���� � dbo.Employee ������������ ����� ������, ������� �� ���������� �� ��������� �������, ������� ������ �� dbo.Employee.

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
