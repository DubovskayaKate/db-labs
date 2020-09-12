USE AdventureWorks2012;

SELECT COUNT(*) as EmpCount 
FROM HumanResources.Employee 
WHERE OrganizationLevel=3;

SELECT DISTINCT (GroupName) 
FROM HumanResources.Department; 


SELECT DISTINCT TOP 10 (JobTitle), REVERSE(SUBSTRING(REVERSE(' ' + JobTitle), 1, CHARINDEX(' ', REVERSE(' ' + JobTitle)) - 1)) AS LastWord
FROM HumanResources.Employee 
ORDER BY JobTitle;
