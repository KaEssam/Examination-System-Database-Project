--Show Instructor and Course in All Intake
go
create or alter proc ShowInstructorCourseinAllIntake @ins_id int
as
begin
	-- check Instructor Id EXIST or not

	IF EXISTS(SELECT * FROM [dbo].[Instructor] WHERE [Ins_Id] = @ins_id )
	BEGIN
		begin

			-- select Instructor and Course in All Intake

			select [Ins_Name] , [Crs_Name] , [Intake_Name]
			from [dbo].[Instructor] I
			join [dbo].[Course] C on I.Ins_Id =C.Ins_Id
			join [dbo].[Intake_Instructor] II on I.Ins_Id =II.Ins_Id
			join [dbo].[Intake] IT on IT.Intake_Id = II.Intake_Id
			where I.Ins_Id = @ins_id
		end
	end
	else 
	begin

		--Error massage 
		RAISERROR ('Instructor Id does not exist' ,10,1)

	end
end

--call proc Show Questions In Course
--exec ShowInstructorCourseinAllIntake 5