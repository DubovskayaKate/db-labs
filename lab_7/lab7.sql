USE AdventureWorks2012;

DECLARE @XMLPersonInfo XML = (
	SELECT TOP 100 p.FirstName, 
				   p.LastName, 
				   pass.ModifiedDate AS 'Password/Date',
				   pass.BusinessEntityID AS 'Password/ID'
	FROM Person.Person p
	JOIN Person.Password pass ON p.BusinessEntityID = pass.BusinessEntityID
	FOR XML PATH('Person'), ROOT('Persons')
)

SELECT @XMLPersonInfo;

EXECUTE Person.GetPasswordFromPersonInfo @XMLPersonInfo

-- DROP PROCEDURE Person.GetPasswordFromPersonInfo
IF (EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetPasswordFromPersonInfo') )
BEGIN
	DROP PROCEDURE Person.GetPasswordFromPersonInfo
END
GO

CREATE PROCEDURE Person.GetPasswordFromPersonInfo ( @XMLPerson XML)
AS
BEGIN
	SELECT p.query('.') [sql]
	FROM @XMLPerson.nodes('/Persons/Person/Password') T(p)
RETURN
END


-- EXECUTE Person.PasswordToXML @XMLPersonInfo

