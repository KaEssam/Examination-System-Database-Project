

--Show Questions Exam

create or alter proc ShowQuestionsExam @Exam_Id int
as
begin
	-- check Exam Id EXIST or not

	IF EXISTS(SELECT * FROM [dbo].[Exam] WHERE [Exam_Id] = @Exam_Id) 
				
	BEGIN
		begin

			-- select Data Questions base on Exam

			SELECT [Question_Id], [Q_Type], [Question_Text],[Correct_Answer]
				FROM [dbo].[Questions] Q
				WHERE Q.[Question_Id] IN (
					SELECT SEQ.[Question_Id]
					FROM [dbo].[Student_Exam_Questions] SEQ
					where SEQ.Exam_Id in (
						SELECT E.[Exam_Id]
						FROM [dbo].[Exam] E
						WHERE E.[Exam_Id] = @Exam_Id
					)
				);
		end
	end
	else 
	begin

		--Error massage 

		RAISERROR ('Exam Id does not exist' ,10,1)
	end
end


--call proc Show Questions In Exam
--exec ShowQuestionsExam 31


