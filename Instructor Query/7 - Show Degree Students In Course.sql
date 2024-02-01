

--Show students and Course and Exam Degree in last Intake

go
create or alter proc ShowDegreeStudentsInCourse @ins_id int,@Course_Name nvarchar(50)
as
begin
	-- check Instructor Id and Course Name EXIST or not

	IF EXISTS(SELECT * FROM [dbo].[Course] 
	   WHERE [Crs_Name] = @Course_Name
	   and[Ins_Id]=@ins_id )
	BEGIN
		begin
		declare @Intake_Id int
		select @Intake_Id=max([Intake_Id]) from [dbo].[Intake]
			
			
			-- select Instructor and Course in last Intake

			select 
				[Ins_Name] as [Instructor Name],
				C.Crs_Name as [Course Name],
				CONCAT(S.Std_Fname , ' ' , S.Std_Lname) as [Student name],
				[Degree],
				IT.[Intake_Name]
			from [dbo].[student] S
			join [dbo].[Student_Course] SC on SC.Student_Id = S.Std_Id
			join [dbo].[Course] C on C.Crs_Id = SC.Course_Id
			join [dbo].[Instructor] I on I.Ins_Id = C.Ins_Id
			join [dbo].[Intake] IT on IT.Intake_Id = S.Intake_Id

			where I.Ins_Id = @ins_id and S.Intake_Id = @Intake_Id  and C.Crs_Name = @Course_Name

		end
	end
	else 
	begin

		--Error massage 

		RAISERROR ('Instructor Id and Course Name or does not exist' ,10,1)
	end
end



--exec ShowDegreeStudentsInCourse 44,'Data Analysis using Power BI'


