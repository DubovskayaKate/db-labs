USE AdventureWorks2012;

-- Task 5, 1

CREATE FUNCTION Person.GetPhonesCountByType(@TypeId INT)  
RETURNS INT AS 
BEGIN
	DECLARE @Count INT
	SELECT @Count = COUNT(DISTINCT PhoneNumber)
	FROM Person.PersonPhone
	WHERE PhoneNumberTypeID = @TypeId

	RETURN @Count;
END

SELECT pnt.PhoneNumberTypeID, Person.GetPhonesCountByType(pnt.PhoneNumberTypeID) PhonesCount
FROM Person.PhoneNumberType pnt;

SELECT pp.PhoneNumberTypeID, COUNT(DISTINCT pp.PhoneNumber)  PhonesCount
FROM Person.PersonPhone pp
JOIN Person.PhoneNumberType pnt ON pnt.PhoneNumberTypeID=pp.PhoneNumberTypeID
GROUP BY pp.PhoneNumberTypeID

-- Task 5, 2

CREATE FUNCTION Person.funPersonsList(@TypeId INT)
RETURNS TABLE AS
RETURN (
	SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
	FROM Person.Person p
	JOIN Person.PersonPhone pp ON P.BusinessEntityID = pp.BusinessEntityID
	WHERE pp.PhoneNumberTypeID = @TypeId AND P.PersonType = 'EM'
);

SELECT * 
FROM Person.funPersonsList(3)

-- Task 5, 3

SELECT PT.PhoneNumberTypeID, f.FirstName, f.LastName
FROM Person.PhoneNumberType pt
CROSS APPLY Person.funPersonsList(pt.PhoneNumberTypeID) f
ORDER BY f.LastName;

-- Task 5, 4

SELECT PT.PhoneNumberTypeID, f.FirstName, f.LastName
FROM Person.PhoneNumberType pt
OUTER APPLY Person.funPersonsList(pt.PhoneNumberTypeID) f
ORDER BY f.LastName;

-- Task 5, 5

CREATE FUNCTION Person.funPersonsListNew(@TypeId INT)
RETURNS @result TABLE(
	BusinessEntityID INT,
	FirstName NVARCHAR(200),
	MiddleName NVARCHAR(200),
	LastName NVARCHAR(200)
) 
AS
BEGIN
	INSERT INTO @result (BusinessEntityID, FirstName, MiddleName, LastName)
	SELECT p.BusinessEntityID, p.FirstName, p.MiddleName, p.LastName
	FROM Person.Person p
	JOIN Person.PersonPhone pp ON P.BusinessEntityID = pp.BusinessEntityID
	WHERE pp.PhoneNumberTypeID = @TypeId AND P.PersonType = 'EM';
	RETURN;
END;

SELECT  * FROM  Person.funPersonsListNew(3);