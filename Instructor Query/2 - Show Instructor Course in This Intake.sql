
--Show Instructor and Course in This Intake
go
create or alter proc ShowInstructorCourseinThisIntake @ins_id int,@Intake_Year varchar(20)
as
begin
	-- check Instructor Id and Intake Year EXIST or not

	IF EXISTS(SELECT * FROM [dbo].[Instructor] WHERE [Ins_Id] = @ins_id )
	   and EXISTS(SELECT * FROM [dbo].[Intake] WHERE [Intake_Name] = @Intake_Year )
	BEGIN
		begin

			-- select Instructor and Course in this Intake

			select [Ins_Name] , [Crs_Name] , [Intake_Name]
			from [dbo].[Instructor] I
			join [dbo].[Course] C on I.Ins_Id =C.Ins_Id
			join [dbo].[Intake_Instructor] II on I.Ins_Id =II.Ins_Id
			join [dbo].[Intake] IT on IT.Intake_Id = II.Intake_Id
			where I.Ins_Id = @ins_id and IT.[Intake_Name] = @Intake_Year
		end
	end
	else 
	begin

		--Error massage 

		RAISERROR ('Instructor Id or Intake Year does not exist' ,10,1)
	end
end

--call proc Show Questions In Course
--exec ShowInstructorCourseinThisIntake 1,2022