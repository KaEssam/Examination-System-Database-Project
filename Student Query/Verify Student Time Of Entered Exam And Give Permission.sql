-- Checks the student's access to a specified exam and retrieves the exam questions if the student has access.
-- It verifies the existence of the exam, checks if the current time is within the exam period, and raises errors if conditions are not met.
GO
CREATE OR ALTER PROC VerifyStudentTimeOfEnteredExamAndGivePermission 
    @Exam_Id INT
AS
BEGIN
    -- Check if the provided Exam_Id exists
    IF EXISTS (SELECT 1 FROM [dbo].[Exam] WHERE Exam_Id = @Exam_Id)
    BEGIN
        -- Declare variables
        DECLARE @C_T DATETIME = GETDATE()
        DECLARE @S_T DATETIME
        DECLARE @E_T DATETIME

        -- Fetch exam start and end times
        SELECT @S_T = [Start_Time], @E_T = [End_Time]
        FROM [dbo].[Exam]
        WHERE Exam_Id = @Exam_Id

        -- Check if the current time is within the exam period
        IF @C_T BETWEEN @S_T AND @E_T
        BEGIN
            -- Fetch questions for the exam
            SELECT Q.[Question_Id], [Q_Type], [Question_Text]
            FROM [dbo].[Questions] Q
            WHERE Q.[Question_Id] IN (
                SELECT SEQ.[Question_Id]
                FROM [dbo].[Student_Exam_Questions] SEQ
                WHERE SEQ.Exam_Id = @Exam_Id
            );
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
        -- Exam does not exist
        RAISERROR('Exam does not exist', 10, 1);
    END
END



--Valid Case - Exam Exists, Within Exam Period
exec VerifyStudentTimeOfEnteredExamAndGivePermission 8

--Valid Case - Exam Exists, After Exam Period
exec VerifyStudentTimeOfEnteredExamAndGivePermission 7

--Valid Case - Exam Exists, Before Exam Period
exec VerifyStudentTimeOfEnteredExamAndGivePermission 6

--Invalid Case - Exam Does Not Exist
exec VerifyStudentTimeOfEnteredExamAndGivePermission 2100

--Invalid Case - NULL Exam ID
exec VerifyStudentTimeOfEnteredExamAndGivePermission null

--Invalid Case - Negative Exam ID
exec VerifyStudentTimeOfEnteredExamAndGivePermission -1

--Invalid Case - Exam ID with Letters
exec VerifyStudentTimeOfEnteredExamAndGivePermission 'abc'

