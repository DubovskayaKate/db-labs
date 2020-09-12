USE master
GO 

CREATE DATABASE NewDatabase;

USE NewDatabase;
GO

CREATE SCHEMA sales;
GO 

CREATE SCHEMA person;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
