-- Stored Procedure to See Exams in specific course for a Student
GO
CREATE OR ALTER PROC SeeExamesOfSpecificCourse 
    @St_Id INT, 
    @Crs_name NVARCHAR(50) 
AS
BEGIN
    -- Check if student and course exist
	IF EXISTS(SELECT * FROM [dbo].[student] WHERE Std_Id = @St_Id) 
	   AND EXISTS(SELECT * FROM [dbo].[Course] WHERE Crs_Name = @Crs_name)
	BEGIN
        -- Declare and initialize variables
	    DECLARE @Intake_Id INT
        SELECT @Intake_Id = [Intake_Id] FROM [dbo].[student] WHERE Std_Id = @St_Id

        -- Check if Intake_Id is 3
        IF @Intake_Id = 3
		BEGIN
			-- Fetch exam details
			SELECT
				CONCAT(S.Std_Fname, ' ', S.Std_Lname) AS [Student Name],
				I.Intake_Name AS [Intake Year],
				C.Crs_Name AS [Course Name],
				E.Exam_Id AS [Exam ID],
				E.E_Type AS [Exam Type],
				E.Start_Time AS [Start Time],
				E.End_Time AS [End Time],
				E.Total_time AS [Total Time]
			FROM 
				[dbo].[student] S 
				JOIN [dbo].[Intake] I ON I.Intake_Id = S.[Intake_Id]
				JOIN [dbo].[Exam] E ON E.[Intake_Id] = I.[Intake_Id]
				JOIN [dbo].[Course] C ON C.Crs_Id = E.Crs_Id 
			WHERE 
				S.Std_Id = @St_Id AND C.Crs_Name = @Crs_name
		END

		ELSE
        BEGIN
            -- Access denied if Intake_Id is not 3
            RAISERROR('Access denied, you do not have permission', 10, 1)
        END
	END

	ELSE IF NOT EXISTS(SELECT * FROM [dbo].[student] WHERE Std_Id = @St_Id) 
		AND NOT EXISTS(SELECT * FROM [dbo].[Course] WHERE Crs_Name = @Crs_name)
	BEGIN
		-- Both student and course do not exist
		RAISERROR('Student id and Course id do not exist. Please enter correct data', 10, 1)
	END

	ELSE IF NOT EXISTS(SELECT * FROM [dbo].[student] WHERE Std_Id = @St_Id)
	BEGIN
		-- Student does not exist
		RAISERROR('Student Id does not exist', 10, 1)
	END

	ELSE IF NOT EXISTS(SELECT * FROM [dbo].[Course] WHERE Crs_Name = @Crs_name)
	BEGIN
		-- Course does not exist
		RAISERROR('Course name does not exist', 10, 1)
	END
END



--Valid Case - Student and Course Exist in Intake 3
EXEC SeeExamesOfSpecificCourse 451 ,'Data Analysis using Power BI'
EXEC SeeExamesOfSpecificCourse 451 ,'Software Configuration'

--Invalid Student - Student Does Not Exist
EXEC SeeExamesOfSpecificCourse 650 ,'Data Analysis using Power BI'

--Invalid Course - Course Does Not Exist:
EXEC SeeExamesOfSpecificCourse 451 ,'Logic'

--Invalid Student and Course - Both Do Not Exist:
EXEC SeeExamesOfSpecificCourse 650 ,'Logic'

--Access Denied - Intake Id is Not 3:
EXEC SeeExamesOfSpecificCourse 50 ,'Data Analysis using Power BI'

