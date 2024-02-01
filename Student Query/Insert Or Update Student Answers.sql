-- Insert or update student answers for a specific question in an exam.
GO
CREATE OR ALTER PROC InsertStudentAnswers 
    @e_id INT,
    @s_id INT,
    @Q_id INT,
    @answer NVARCHAR(MAX)
AS
BEGIN
    -- Check if the student has access to the specified question in the given exam
    IF EXISTS (
        SELECT * 
        FROM [dbo].[Student_Exam_Questions] 
        WHERE [Std_Id] = @s_id
        AND [Exam_Id] = @e_id 
        AND [Question_Id] = @Q_id
    )
    BEGIN
        -- Declare variables for current time, exam start time, and exam end time
        DECLARE @C_T DATETIME = GETDATE()
        DECLARE @S_T DATETIME
        DECLARE @E_T DATETIME

        -- Fetch exam start and end times
        SELECT @S_T = [Start_Time], @E_T = [End_Time]
        FROM [dbo].[Exam]
        WHERE Exam_Id = @e_id

        -- Check if the current time is within the exam period
        IF @C_T BETWEEN @S_T AND @E_T
        BEGIN
            -- Update student's answer for the specified question in the exam
            UPDATE Student_Exam_Questions
            SET Answers = @answer
            WHERE [Std_Id] = @s_id
            AND [Exam_Id] = @e_id 
            AND [Question_Id] = @Q_id
        END
        ELSE IF @C_T < @S_T
        BEGIN
            -- Exam has not started yet
            RAISERROR('Exam has not started yet', 10, 1)
        END
        ELSE IF @C_T > @E_T
        BEGIN
            -- Exam time is over
            RAISERROR('Exam time is over', 10, 1)
        END
    END
    ELSE 
    BEGIN
        -- The specified question in the exam does not exist
        RAISERROR('Exam or question does not exist, please enter correct data', 10, 1)	
    END
END




--Valid Case - Question Exists, Exam Ongoing
exec InsertStudentAnswers 2,451,1523,'b'

exec InsertStudentAnswers 2,451,1502,'Calculated columns are created by defining custom formulas using DAX (Data Analysis Expressions) in Power BI.
They allow for the creation of new data based on existing columns.'

exec InsertStudentAnswers 2,451,1500,'Data modeling in Power BI involves defining relationships, creating calculated columns,
and establishing hierarchies to organize and enhance data for analysis.'

--Invalid Case - Exam Does Not Exist
exec InsertStudentAnswers 10,451,1523,'b'

--Invalid Case - Question Does Not Exist
exec InsertStudentAnswers 2,451,2000,'b'

--NULL Answer
exec InsertStudentAnswers 2,451,1523,''

--Valid Case - Question Exists, Exam Hasn't Started
--Valid Case - Question Exists, Exam Time Over

