
--Show Questions In Course

create or alter proc ShowQuestionsInCourse @Crs_name nvarchar(50)
as
begin
	-- check course Name EXIST or not

	IF EXISTS(SELECT * FROM [dbo].[Course] WHERE Course.Crs_Name = @Crs_name )
	BEGIN
		begin

			-- select Data Questions base on Course

			select Q.[Question_Id] , [Q_Type] , [Question_Text],[Correct_Answer]
			from [dbo].[Questions] Q 
			where Q.Crs_Id =(select [Crs_Id] from [dbo].[Course] C where [Crs_Name] = @Crs_name)
		end
	end
	else 
	begin

		--Error massage 

		RAISERROR ('Course name does not exist' ,10,1)
	end
end

--call proc Show Questions In Course
--exec ShowQuestionsInCourse 'CSS'