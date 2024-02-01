-- Retrieve the result in a particular course.
GO
CREATE OR ALTER PROC SeeResultOfSpecificCourse 
    @St_id INT,
    @Course_Name NVARCHAR(50)
AS
BEGIN
    -- Check if the student and course exist
	IF EXISTS (SELECT * FROM [dbo].[student] WHERE [Std_Id] = @St_id)
		AND EXISTS (SELECT * FROM [dbo].[Course] WHERE [Crs_Name] = @Course_Name)
	BEGIN
		-- Retrieve student details and course result
		BEGIN
			SELECT 
				CONCAT(S.Std_Fname, ' ', S.Std_Lname) AS [Student name],
				[Crs_Name],
				[Status] = CASE WHEN [Status] IS NULL THEN 'The result has not yet appeared' ELSE [Status] END
			FROM 
				[dbo].[student] S
				JOIN [dbo].[Student_Course] SC ON S.Std_Id = SC.Student_Id
				JOIN [dbo].[Course] C ON SC.Course_Id = C.Crs_Id
			WHERE 
				S.Std_Id = @St_id AND C.Crs_Name = @Course_Name;
		END
	END

	ELSE IF NOT EXISTS (SELECT * FROM [dbo].[student] WHERE [Std_Id] = @St_id)
		AND NOT EXISTS (SELECT * FROM [dbo].[Course] WHERE [Crs_Name] = @Course_Name)
	BEGIN
		-- Raise an error if the student or course does not exist
		RAISERROR('Student id and course name are not exist , enter correct data', 10, 1);
	END

	ELSE IF NOT EXISTS (SELECT * FROM [dbo].[student] WHERE [Std_Id] = @St_id)
	BEGIN
		-- Raise an error if the student or course does not exist
		RAISERROR('Student id does not exist , enter correct data', 10, 1);
	END

	ELSE IF NOT EXISTS (SELECT * FROM [dbo].[Course] WHERE [Crs_Name] = @Course_Name)
	BEGIN
		-- Raise an error if the student or course does not exist
		RAISERROR('Course name does not exist , enter correct data', 10, 1);
	END
END




--Valid Case - Student and Course Exist
EXEC SeeResultOfSpecificCourse 451,'Oracle SQL';

--invalid Case - Student Does Not Exist
EXEC SeeResultOfSpecificCourse 603,'Software Configuration';

--Invalid Case - Course Does Not Exist
EXEC SeeResultOfSpecificCourse 453,'Logic';

--Invalid Case - Student and Course Do Not Exist
EXEC SeeResultOfSpecificCourse 600,'Logic';

--Valid Case - Student Exists, No Result Yet
EXEC SeeResultOfSpecificCourse 451,'Oracle SQL';

--Valid Case - Student Exists, Result Exists ==> pass or corrective 