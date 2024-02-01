-- valid casese

--SELECT from [dbo].[Instructor]

SELECT * FROM [dbo].[Instructor];

--

INSERT INTO dbo.Instructor
(
    Ins_Id,
    Ins_Name,
    Ins_Age,
    Ins_Address,
    Ins_Phone
)
VALUES
(   110,       -- Ins_Id - int
    N'Karim',     -- Ins_Name - nvarchar(50)
    27,    -- Ins_Age - int
    DEFAULT, -- Ins_Address - nvarchar(50)
    '01024757521'       -- Ins_Phone - char(11)
    )



DELETE FROM [dbo].[Instructor] WHERE Ins_Id = 110

--
SELECT * FROM dbo.Course;

INSERT INTO dbo.Course
(
    Crs_Id,
    Crs_Name,
    Crs_Description,
    MinDegree,
    MaxDegree,
    Ins_Id
)
VALUES
(   60,    -- Crs_Id - int
    N'FAGAGAGAG',  -- Crs_Name - nvarchar(50)
    NULL, -- Crs_Description - nvarchar(max)
    NULL, -- MinDegree - int
    NULL, -- MaxDegree - int
    NULL  -- Ins_Id - int
    )


DELETE FROM dbo.Course WHERE Crs_Id= 60



-- Invalid Cases 


CREATE TABLE TEST (
 Test_id INT,
 Test_name nvarchar(20)
)


INSERT INTO [dbo].[TEST] VALUES(1,'Test1')

UPDATE [dbo].[TEST]
SET [Test_name] = 'Test2' WHERE [Test_id] = 1

DELETE FROM [dbo].[TEST] WHERE [Test_id] = 1

DROP TABLE [dbo].[TEST]



--
INSERT INTO dbo.Intake
(
    Intake_Id,
    Intake_Name
)
VALUES
(   9, -- Intake_Id - int
    '2010' -- Intake_Name - varchar(20)
    )

DELETE FROM dbo.Intake WHERE Intake_Id = 7


