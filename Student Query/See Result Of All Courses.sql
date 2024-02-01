-- Retrieve the results of all courses.
GO
CREATE OR ALTER PROC SeeResultOfAllCourses 
    @St_id INT 
AS
BEGIN
    -- Check if the provided Student Id exists
    IF EXISTS (SELECT * FROM [dbo].[student] WHERE [Std_Id] = @St_id)
    BEGIN
        -- Retrieve student information along with course results
        BEGIN
            SELECT 
                CONCAT(S.Std_Fname , ' ' , S.Std_Lname) AS [Student name],
                [Crs_Name],
                [Status] = CASE WHEN [Status] IS NULL THEN 'The result has not yet appeared' ELSE [Status] END
            FROM 
                [dbo].[student] S
                JOIN [dbo].[Student_Course] SC ON S.Std_Id = SC.Student_Id
                JOIN [dbo].[Course] C ON SC.Course_Id = C.Crs_Id
            WHERE 
                S.Std_Id = @St_id;
        END
    END
    ELSE 
    BEGIN
        -- Student Id does not exist
        RAISERROR ('Student Id does not exist', 10, 1)
    END
END


--Valid Case - Student Exists with Course Results
EXEC SeeResultOfAllCoureses 451

--Invalid Case - Student Does Not Exist
EXEC SeeResultOfAllCoureses 600


--Invalid Case - NULL Student ID
EXEC SeeResultOfAllCoureses null

--Invalid Case - Negative Student ID
EXEC SeeResultOfAllCoureses -1

--Invalid Case - Alphabetic Student ID
EXEC SeeResultOfAllCoureses 'abc'

