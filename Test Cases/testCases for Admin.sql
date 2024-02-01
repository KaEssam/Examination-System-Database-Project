--Admin
--Create Table on database
CREATE TABLE TEST (
 Test_id INT,
 Test_name nvarchar(20)
)


INSERT INTO [dbo].[TEST] VALUES(1,'Test1')

UPDATE [dbo].[TEST]
SET [Test_name] = 'Test2' WHERE [Test_id] = 1

DELETE FROM [dbo].[TEST] WHERE [Test_id] = 1

DROP TABLE [dbo].[TEST]





