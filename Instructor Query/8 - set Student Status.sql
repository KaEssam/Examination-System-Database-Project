
go

--set Student Status

create or alter proc setStudentStatus @e_id int, @Course_Name nvarchar(50)
as
begin

	--check if Student Id and Exam Id and Course Name

	if exists(select * from [dbo].[Course] 
				where [Crs_Name] = @Course_Name
				and [Crs_Id] in (select [Crs_Id] from [dbo].[Exam] where [Exam_Id] = @e_id))
		
	begin

		declare @countExamQuesions int
		
		select @countExamQuesions = count ([Question_Id]) 
		from [dbo].[Student_Exam_Questions]
		where [Exam_Id] = 30
		and [Std_Id] = (
			SELECT min([Std_Id]) FROM [dbo].[Student_Exam_Questions] 
			WHERE [Exam_Id] = 30
		)
		
		-- update Status

		declare @C_T datetime , @E_T datetime 
		set @C_T = GETDATE()
		set @E_T = (Select [End_Time] from [dbo].[Exam] where Exam_Id = @e_id)
		
		
		if (@C_T>@E_T)
		begin


			declare @Id_S int

			DECLARE StudentsInExam CURSOR
			FOR SELECT [Std_Id] 
			FROM [dbo].[Student_Exam_Questions]
			where [Exam_Id] = @e_id
			and [Question_Id] = (
				SELECT min([Question_Id]) FROM [dbo].[Student_Exam_Questions] 
				WHERE [Exam_Id] = @e_id
			)				
				
			OPEN StudentsInExam
			FETCH NEXT FROM StudentsInExam INTO @Id_S
			WHILE @@FETCH_STATUS = 0
			BEGIN
				
				update [dbo].[Student_Course]
				set [Status] = case when [Degree]>=(@countExamQuesions*0.5) then 'Pass' else 'Corrective' end
				where [Student_Id] = @Id_S
				and [Course_Id] in (select [Crs_Id] from [dbo].[Course] where [Crs_Name] = @Course_Name)
			
				update [dbo].[Student_Course]
				set [Degree] = 0
				where [Student_Id] = @Id_S
				and [Course_Id] in (select [Crs_Id] from [dbo].[Course] where [Crs_Name] = @Course_Name)
				
				
				FETCH NEXT FROM StudentsInExam INTO @Id_S
			END;
			CLOSE StudentsInExam
			DEALLOCATE StudentsInExam


		end
		else
		begin
			RAISERROR ('The exam has not ended yet.' ,10,1)	
		end

	end

	else 
	begin
		RAISERROR ('Data is not exist, Please enter correct data' ,10,1)	
	end

end


exec setStudentStatus 37,'Data Analysis using Power BI'

