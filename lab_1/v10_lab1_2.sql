-- Lab 1_2, V_10, Dubovskaya Kate, 751001

USE AdventureWorks2012;

-- Lab 1, Task 2, 1
SELECT COUNT(*) AS EmpCount 
FROM HumanResources.Employee 
WHERE OrganizationLevel=3;

-- Lab 1, Task 2, 2
SELECT DISTINCT (GroupName) 
FROM HumanResources.Department; 

-- Lab 1, Task 2, 3
SELECT 
	DISTINCT TOP 10 (JobTitle), 
	REVERSE(SUBSTRING(REVERSE(' ' + JobTitle), 1, CHARINDEX(' ', REVERSE(' ' + JobTitle)) - 1)) AS LastWord
FROM HumanResources.Employee 
ORDER BY JobTitle;
