USE AdventureWorks2012;

-- a) добавьте в таблицу dbo.Employee поле Name типа nvarchar размерностью 60 символов;

ALTER TABLE dbo.Employee
	ADD Name NVARCHAR(60);

-- b) объявите табличную переменную с такой же структурой как dbo.Employee и заполните ее данными из dbo.Employee. Поле Name заполните данными таблицы Person.Person, из полей Title и FirstName. Если Title содержит null значение, замените его на ‘M.’;

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
	
-- c) обновите поле Name в dbo.Employee данными из табличной переменной;

UPDATE dbo.Employee
SET Name =eVar.Name
FROM dbo.Employee e
INNER JOIN @Employee eVar ON  e.BusinessEntityID=eVar.BusinessEntityID;

Select * from dbo.Employee;

-- d) удалите из dbo.Employee сотрудников, которые хотя бы раз меняли отдел (таблица HumanResources.EmployeeDepartmentHistory);

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


-- e) удалите поле Name из таблицы, удалите все созданные ограничения и значения по умолчанию.
/*Имена ограничений вы можете найти в метаданных. Например:

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Employee';
Имена значений по умолчанию найдите самостоятельно, приведите код, которым пользовались для поиска;*/


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


-- f) удалите таблицу dbo.Employee.
DROP TABLE
	dbo.Employee