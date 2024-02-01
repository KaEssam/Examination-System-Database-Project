

--Test Case for Instructor




--Show Instructor and Course in All Intake
--input Instructor ID

exec ShowInstructorCourseinAllIntake 44

exec ShowInstructorCourseinAllIntake 45

exec ShowInstructorCourseinAllIntake 400

-----------------------------------------------------------------------------

--Show Instructor and Course in This Intake
--input Instructor ID and Intake Year

exec ShowInstructorCourseinThisIntake 44,2024

exec ShowInstructorCourseinThisIntake 3,2022

--Invalid Case - Instructor Id or Intake Year Does Not Exist
exec ShowInstructorCourseinThisIntake 4,2025

--Invalid Case - Instructor Id or Intake Year Does Not Exist
exec ShowInstructorCourseinThisIntake 400,2024


-----------------------------------------------------------------------------


--Show Questions In Course
--input Course Name

exec ShowQuestionsInCourse 'Data Analysis using Power BI'

exec ShowQuestionsInCourse 'Software Configuration'

--Invalid Course - Course Does Not Exist:
exec ShowQuestionsInCourse 'Logic'

-------------------------------------------------

--- Create Exam with Qusestions (Random)
--input Instructor ID and Course Name and Exam Type and Start Time and end Time and Number Of Questions (Random)



exec InsertExamRandom 44 ,'Data Analysis using Power BI','Regular',
'2024-01-11 13:00:00','2024-01-11 13:30:00',20

exec InsertExamRandom 45 ,'Software Configuration','Regular',
'2024-01-11 13:00:00','2024-01-11 13:30:00',15

--Invalid Case -- Start Time before current Time
exec InsertExamRandom 45 ,'Software Configuration','Regular',
'2024-01-09 13:00:00','2024-01-11 13:30:00',15

--Invalid Case -- Instructor ID do not has Course Name
exec InsertExamRandom 4 ,'Software Configuration','Regular',
'2024-01-09 13:00:00','2024-01-11 13:30:00',15

--------------------------------------------------------------------------

-- Create Exam with Qusestions (manual)
--input Instructor ID and Course Name and Exam Type and Start Time and end Time and Table Of Questions

declare @Questions_ids QuestionsTableType
insert into @Questions_ids 
select (1500)
insert into @Questions_ids 
select (1501)
insert into @Questions_ids 
select (1519)
insert into @Questions_ids 
select (1520)
insert into @Questions_ids 
select (1523)
insert into @Questions_ids 
select (1529)
insert into @Questions_ids 
select (1539)
insert into @Questions_ids 
select (1544)
insert into @Questions_ids 
select (1548)
insert into @Questions_ids 
select (1550)

exec InsertExam 44 ,'Data Analysis using Power BI','Regular',
'2024-01-11 13:00:00','2024-01-11 13:30:00',@Questions_ids


--------------------------------------------------------

declare @Questions_ids QuestionsTableType
insert into @Questions_ids 
select (1262)
insert into @Questions_ids 
select (1263)
insert into @Questions_ids 
select (1264)
insert into @Questions_ids 
select (1266)
insert into @Questions_ids 
select (1277)
insert into @Questions_ids 
select (1282)
insert into @Questions_ids 
select (1283)
insert into @Questions_ids 
select (1284)
insert into @Questions_ids 
select (1302)
insert into @Questions_ids 
select (1303)

exec InsertExam 45 ,'Software Configuration','Regular','2024-01-11 12:05:00',
'2024-01-11 13:30:00',@Questions_ids


----------------------------------------------------------------------------

--set Status to all Student in this exam
--input Exam ID,Course Name

exec setStudentStatus 8,'Data Analysis using Power BI'


-----------------------------------------------------------------------------------

--Show to Instructor, students and Course and Exam Result in last Intake
--input Instructor id ,Course Name

exec ShowStudentsCourse 44,'Data Analysis using Power BI'

--------------------------------------------------------------------------


exec InsertExamRandom 44 ,'Data Analysis using Power BI','corrective',
'2024-01-12 13:00:00','2024-01-12 15:30:00',10




