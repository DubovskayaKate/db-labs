USE AdventureWorks2012;

-- begin transaction
--a) выполните код, созданный во втором задании второй лабораторной работы. 
-- ƒобавьте в таблицу dbo.Employee поле SumSubTotal MONEY. 
-- “акже создайте в таблице вычисл€емое поле LeaveHours, 
-- вычисл€ющее сумму часов отпуска и больничных в пол€х VacationHours и SickLeaveHours.

ALTER TABLE
    dbo.Employee
ADD
    SumSubTotal MONEY,
    LeaveHours as (VacationHours + SickLeaveHours);

--b) создайте временную таблицу #Employee, с первичным ключом по полю ID. 
-- ¬ременна€ таблица должна включать все пол€ таблицы dbo.Employee за исключением пол€ LeaveHours.

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

--c) заполните временную таблицу данными из dbo.Employee. 
-- ѕосчитайте общую сумму без учета налогов и стоимости доставки (SubTotal), 
-- на которую сотрудник (EmployeeID) оформил заказов в таблице Purchasing.PurchaseOrderHeader и 
-- заполните этими значени€ми поле SumSubTotal. ѕодсчет суммы осуществите в Common Table Expression (CTE).

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

--d) удалите из таблицы dbo.Employee строки, где LeaveHours > 160

DELETE 
FROM dbo.Employee
WHERE LeaveHours > 160


--e) напишите Merge выражение, использующее dbo.Employee как target, а временную таблицу как source. 
-- ƒл€ св€зи target и source используйте ID. 
-- ќбновите поле SumSubTotal, если запись присутствует в source и target. 
-- ≈сли строка присутствует во временной таблице, но не существует в target, добавьте строку в dbo.Employee. 
-- ≈сли в dbo.Employee присутствует така€ строка, которой не существует во временной таблице, удалите строку из dbo.Employee.

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
