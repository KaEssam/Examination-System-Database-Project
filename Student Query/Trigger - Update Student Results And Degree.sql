-- This trigger updates student results and degree based on the changes in the [Student_Exam_Questions] table after answer insertion or update
CREATE OR ALTER TRIGGER SetStudentResultAndDegree
ON [dbo].[Student_Exam_Questions]
AFTER UPDATE
AS
BEGIN
    -- Declare variables
	declare @Q_Type varchar(10), @Correct_Answer nvarchar(max), @Answers nvarchar(max), @Result int
	declare @Q_id int, @E_id int, @S_id int, @oldResult int

	-- Set values to variables from the 'inserted' table
	select @Result = (case when (Q.Correct_Answer = I.Answers) then 1 else 0 end),
		@Q_Type = Q.[Q_Type], @Correct_Answer = Q.Correct_Answer, @Answers = I.Answers,
		@Q_id = I.Question_Id, @E_id = I.Exam_Id, @S_id = I.Std_Id 
	from inserted I
	join Questions Q on I.Question_Id = Q.Question_Id;
	
	-- Fetch the old result for comparison
	select @oldResult = Result
	from [dbo].[Student_Exam_Questions]
	where [Exam_Id] = @E_id and [Question_Id] = @Q_id and [Std_Id] = @S_id
	
	-- Handle the case when the old result is NULL
	if (@oldResult IS NULL)
	BEGIN
		set @oldResult = 0
	end

	-- Update Result for MCQ and T/F questions
	update [dbo].[Student_Exam_Questions] 
	set Result = @Result
	where [Exam_Id] = @E_id and [Question_Id] = @Q_id and [Std_Id] = @S_id

	-- Check if Question Type is Text
	if (@Q_Type = 'Text')
	begin
		DECLARE @numOfMatchrows INT, @numOfCorrectrows INT

		-- Set the number of matching words between Correct Answer and Answers
		SELECT @numOfMatchrows = COUNT(*) 
		FROM (
			SELECT TRIM(value) AS word
			FROM STRING_SPLIT(lower(@Correct_Answer), ' ')
			INTERSECT
			SELECT TRIM(value) AS word
			FROM STRING_SPLIT(lower(@Answers), ' ')
		) AS CommonWords;

		-- Set the number of words in the Correct Answer
		SELECT @numOfCorrectrows = COUNT(*) 
		FROM (
			SELECT TRIM(value) AS word
			FROM STRING_SPLIT(@Correct_Answer, ' ')
		) AS CommonWords;
		
		-- Update Result for Text questions
		update [dbo].[Student_Exam_Questions] 
		set Result = (case when (@numOfMatchrows > (@numOfCorrectrows * 0.50)) then 1 else 0 end)
		where [Exam_Id] = @E_id and [Question_Id] = @Q_id and [Std_Id] = @S_id
	end
	
	-- Declare and initialize @Degree variable
	declare @Degree int
	select @Degree = [Degree] 
	from [dbo].[Student_Course] 
	where [Student_Id] = @S_id
		and [Course_Id] in (Select [Crs_Id] from [dbo].[Exam] where [Exam_Id] = @E_id)

	-- Handle the case when @Degree is NULL
	if (@Degree IS NULL)
	BEGIN
		set @Degree = 0
	end
	
	-- Update Student_Course Degree based on the changes in the [Student_Exam_Questions] table
	update [dbo].[Student_Course] 
	set [dbo].[Student_Course].[Degree] = 
		case 
			when SEQ.Result = 1 and @oldResult = 1 then (@Degree)
			when SEQ.Result = 0 and @oldResult = 0 then (@Degree)
			when SEQ.Result = 1 and @oldResult = 0 then (@Degree + 1)
			when SEQ.Result = 0 and @oldResult = 1 then (@Degree - 1)
		end
	from [dbo].[Student_Exam_Questions] SEQ
	join [dbo].[Student_Course] SC on SC.Student_Id = SEQ.Std_Id
	join [dbo].[Course] C on C.[Crs_Id] = SC.Course_Id
	join [dbo].[Exam] E on E.Crs_Id = C.Crs_Id
	where SEQ.[Exam_Id] = @E_id and SEQ.[Question_Id] = @Q_id and SEQ.[Std_Id] = @S_id 
			and SC.Student_Id = @S_id and E.Exam_Id = @E_id
END