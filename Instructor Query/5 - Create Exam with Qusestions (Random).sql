

--- Create Exam with Qusestions (Random)

go

--Insert Exam base on Instructor id and course Name and Number of Qusestions (Random)

create or alter proc InsertExamRandom @ins_id int,@Crs_name nvarchar(50) , 
								@Exam_Type varchar(10),@Start_Time Datetime ,@end_Time Datetime,@NumberOfQ int
as
begin

begin try

	declare @Intake_Id int,@Crs_id int, @IdentityExam int ,@hour int,@minute int,@Total_Time nvarchar(30)

	--set data Intake Id and Course id 

	select @Intake_Id=max([Intake_Id]) from [dbo].[Intake] 
	select @Crs_id=[Crs_Id] from [dbo].[Course] where [Crs_Name] = @Crs_name
	
	-- check Instructor id and course Name and Intake Year are EXIST or not

	IF EXISTS(SELECT * FROM [dbo].[Course] WHERE Course.Crs_Name = @Crs_name and [Ins_Id]= @ins_id 
				and[Ins_Id] in (SELECT [Ins_Id] FROM [dbo].[Intake_Instructor] WHERE [Intake_Id] = @Intake_Id)
				and [Crs_Id] in (SELECT [Course_Id] FROM [dbo].[Student_Course] WHERE [Student_Id] in
					(SELECT [Std_Id] FROM [dbo].[student] WHERE [Intake_Id]=@Intake_Id)
				)
			)
	BEGIN
			
		--Calculate Total Time

		set @hour = DATEDIFF(hour,@Start_Time,@end_Time)
		set @minute = DATEDIFF(minute,@Start_Time,@end_Time)-(@hour*60)
		set @Total_Time = CONCAT(@hour,' hour, ',@minute,' minute')

		--Calculate Identity for table Exam

		select @IdentityExam= max([Exam_Id]) from [dbo].[Exam] 
		if(@IdentityExam IS NULL)
		BEGIN
			set @IdentityExam = 0
		end

		insert into [dbo].[Exam]
		values (@IdentityExam+1,@Exam_Type,@Start_Time,@end_Time,@Total_Time,@Intake_Id,@Crs_id,@ins_id)


		DECLARE @Id_Q  int , @Id_S int


		-- insert questions in exam 

		DECLARE QuestionsInExam CURSOR
		
		-- select questions random base on Number Of questions

		FOR SELECT TOP (@NumberOfQ) [Question_Id] FROM [dbo].[Questions]
		where [Crs_Id] in (SELECT [Crs_Id] FROM [dbo].[Course] where [Crs_Id] = @Crs_id)
		ORDER BY NEWID();
		
		
		OPEN QuestionsInExam
		FETCH NEXT FROM QuestionsInExam INTO @Id_Q
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
				if(lower(@Exam_Type) = 'corrective')
				begin

				DECLARE StudentsInExam CURSOR
				FOR SELECT [Std_Id] 
				FROM [dbo].[student]
				where [Intake_Id]=@Intake_Id
				and [Std_Id] in (
					SELECT [Student_Id] 
					FROM [dbo].[Student_Course]
					where [Course_Id]=@Crs_id
					and [Status] = 'Corrective')

				end
				else
				begin

				DECLARE StudentsInExam CURSOR
				FOR SELECT [Std_Id] 
				FROM [dbo].[student]
				where [Intake_Id]=@Intake_Id
				and [Std_Id] in (
					SELECT [Student_Id] 
					FROM [dbo].[Student_Course]
					where [Course_Id]=@Crs_id)


				end
				
				
				OPEN StudentsInExam
				FETCH NEXT FROM StudentsInExam INTO @Id_S
				WHILE @@FETCH_STATUS = 0
					BEGIN

						insert into [dbo].[Student_Exam_Questions]
						values (@IdentityExam+1,@Id_Q,@Id_S,null,null) 
						FETCH NEXT FROM StudentsInExam INTO @Id_S

					END;
				CLOSE StudentsInExam
				DEALLOCATE StudentsInExam
			
			FETCH NEXT FROM QuestionsInExam INTO @Id_Q
		END;
		CLOSE QuestionsInExam
		DEALLOCATE QuestionsInExam

		select @IdentityExam + 1 [Exam ID]
	end
		
	else
	begin
		--massage error
		RAISERROR ('Data are not exist, Please enter correct data' ,10,1)
	end
	end try
	begin catch
		--massage error
		RAISERROR ('Data are not exist, Please enter correct data' ,10,1)
	end catch
	
end


------------------------------------------------------------------------------
go
--instead of Insert Exam 
create or alter trigger  TriggerInsertExam
on [dbo].[Exam]
instead of Insert
as begin
	--check Start Time and End Time is exist or not
	if(GETDATE()<(select [Start_Time] from inserted) and (select [Start_Time] from inserted)<(select [End_Time] from inserted))
	BEGIN
		insert into [dbo].[Exam]
		select * from inserted
	end
	else
	BEGIN
		RAISERROR ('Start Time or End Time is not exist, Please enter correct data' ,10,1)
	end
end



--exec InsertExamRandom 44 ,'Data Analysis using Power BI','Regular','2024-01-10 21:07:00','2024-01-11 14:30:00',15
--exec InsertExamRandom 45 ,'Software Configuration','Regular','2024-01-09 23:30:00','2024-01-11 14:30:00',10

