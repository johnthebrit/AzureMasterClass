/*Get basic info */
SELECT @@VERSION
/*5 is SQL Database, 8 is MI, 6 is Synapse*/
/*https://docs.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver15*/
SELECT SERVERPROPERTY('EngineEdition')
SELECT * FROM sys.dm_user_db_resource_governance

SELECT *
  FROM [justice].[Roster]

/*I set through Azure portal*/
ALTER TABLE [ROSTER] ALTER COLUMN [CodeName]
ADD MASKED WITH (FUNCTION = 'default(0,xxxx,01-01-1900)')

CREATE USER AquaMan WITH PASSWORD = 'Ih3artF1sh!'
ALTER ROLE db_datareader ADD MEMBER AquaMan
ALTER ROLE db_datawriter ADD MEMBER AquaMan

EXECUTE AS USER = 'AquaMan';
SELECT FirstName, LastName, CodeName
  FROM [justice].[Roster];
REVERT;

GRANT UNMASK TO AquaMan;
REVOKE UNMASK TO AquaMan;

CREATE USER AquaMan WITH PASSWORD = 'Somethingelse'