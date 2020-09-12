-- Lab 2_1, V_10, Dubovskaya Kate, 751001

USE AdventureWorks2012;

-- Lab 2, Task 1, 1
SELECT e.BusinessEntityID, JobTitle, ROUND(eph.Rate, 0, 0) as RoundRate, eph.Rate 
FROM HumanResources.Employee e
INNER JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID=e.BusinessEntityID;

-- Lab 2, Task 1, 2
--  порядковый номер изменения почасовой ставки
SELECT edh.BusinessEntityID, JobTitle, Rate FROM HumanResources.EmployeeDepartmentHistory edh
INNER JOIN HumanResources.Shift s ON s.ShiftID=edh.ShiftID 
INNER JOIN HumanResources.Employee e ON e.BusinessEntityID=edh.BusinessEntityID
INNER JOIN HumanResources.EmployeePayHistory eph ON eph.BusinessEntityID=e.BusinessEntityID ORDER BY s.ModifiedDate;

-- Lab 2, Task 1, 3
SELECT d.Name, e.JobTitle, e.HireDate, e.BirthDate FROM HumanResources.EmployeeDepartmentHistory edh
INNER JOIN HumanResources.Employee e ON e.BusinessEntityID=edh.BusinessEntityID
INNER JOIN HumanResources.Department d ON d.DepartmentID=edh.DepartmentID 
ORDER BY e.JobTitle, 
	CASE WHEN CHARINDEX( ' ', JobTitle) = 0 
		THEN e.HireDate 
		ELSE e.BirthDate 
		END 
	DESC
