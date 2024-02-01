GO
CREATE DATABASE Examinatin_System
on PRIMARY
(
	NAME = ExaminatinSystem,
    FILENAME = 'D:\SQL Project\ExaminatinSystem.mdf',
    SIZE = 10,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 20
)

LOG on
(
	NAME = ExaminatinSystem_log,
    FILENAME = 'D:\SQL Project\ExaminatinSystem_log.ldf',
    SIZE = 10,
    MAXSIZE = 64,
    FILEGROWTH = 10%
)

USE Examinatin_System

Go
CREATE TABLE student(
	Std_Id int,
	Std_Fname nvarchar(20) NOT NULL,
	Std_Lname nvarchar(20) NOT NULL,
	Std_Age int NOT NULL,
	Std_Address nvarchar(50) default 'Cairo',
	Std_Phone char(11) NOT NULL,
	CONSTRAINT StudentPK PRIMARY KEY (Std_Id),
	CONSTRAINT StdPhoneCheck CHECK(len(Std_Phone) = 11)
	CONSTRAINT IntakeStudentFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id)
)
alter table student
alter column Intake_Id int NOT NULL;
alter table student
add CONSTRAINT IntakeStudentFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id)


GO 
CREATE TABLE Track(
	Track_Id int,
	Track_Name varchar(100) NOT NULL,
	CONSTRAINT TrackPK PRIMARY KEY (Track_Id )
)


Go
CREATE TABLE Intake(
	Intake_Id int,
	Intake_Name varchar(20) NOT NULL,
	CONSTRAINT IntakePK PRIMARY KEY (Intake_Id )
)


Go
CREATE TABLE Department(
	Dept_ID int,
	Dept_Name varchar(50) NOT NULL,
	Dept_Location nvarchar(50),
	CONSTRAINT DepartmentPK PRIMARY KEY (Dept_ID )
)


Go
CREATE TABLE Branch(
	Branch_Id int,
	Branch_Name varchar(50) NOT NULL,
	Branch_Address nvarchar(50),
	Branch_Phone char(11) NOT NULL UNIQUE,
	Dept_ID int NOT NULL,
	CONSTRAINT BranchPK PRIMARY KEY (Branch_Id),
	CONSTRAINT BranchPhoneCheck CHECK(len(Branch_Phone) = 11),
	CONSTRAINT BranchDepartmentFK FOREIGN KEY (Dept_ID) REFERENCES Department (Dept_ID)
)


Go
CREATE TABLE Instructor(
	Ins_Id int,
	Ins_Name nvarchar(50) NOT NULL,
	Ins_Age int,
	Ins_Address nvarchar(50) default 'Cairo',
	Ins_Phone char(11) NOT NULL,
	CONSTRAINT InstructorPK PRIMARY KEY (Ins_Id),
	CONSTRAINT InsPhoneCheck CHECK(len(Ins_Phone) = 11)
)


Go
CREATE TABLE Course(
	Crs_Id int,
	Crs_Name nvarchar(50) NOT NULL,
	Crs_Description nvarchar(max),
	MinDegree int,
	MaxDegree int,
	Ins_Id int,
	CONSTRAINT CoursePK PRIMARY KEY (Crs_Id),
	CONSTRAINT CourseInstructorFK FOREIGN KEY (Ins_Id) REFERENCES Instructor (Ins_Id)
	--CONSTRAINT CrsMinDegree CHECK (MinDegree = 50),
	--CONSTRAINT CrsMaxDegree CHECK (MaxDegree = 100)
)
GO
CREATE TABLE Track_Course(
	Crs_Id int,
	Track_Id int,
	CONSTRAINT Track_CoursePK PRIMARY KEY (Crs_Id,Track_Id),
	CONSTRAINT Course_Track_CourseFK FOREIGN KEY (Crs_Id) REFERENCES Course (Crs_Id),
	CONSTRAINT Track_Track_CourseFK FOREIGN KEY (Track_Id) REFERENCES Track (Track_Id)
	
)

Go
CREATE TABLE Questions(
	Question_Id int,
	Q_Type varchar(10) NOT NULL,
	Correct_Answer nvarchar(max),
	Question_Text nvarchar(max),
	--Accepted_Answer nvarchar(max),
	Text_Keywords nvarchar(max),
	--Question_Degree char(1),
	Crs_Id int not null,
	CONSTRAINT QuestionsPK PRIMARY KEY (Question_Id),
	CONSTRAINT QuestionType CHECK (Q_Type in ('T/F','MCQ','Text')),
	CONSTRAINT QuestionsCourseFK FOREIGN KEY (Crs_Id) REFERENCES Course (Crs_Id)
)

Go
CREATE TABLE Exam(
	Exam_Id int,
	E_Type varchar(10) NOT NULL,
	Start_Time DATETIME NOT NULL,
	End_Time DATETIME NOT NULL,
	Total_time DATETIME NOT NULL,
	Intake_Id int NOT NULL,
	Crs_Id int NOT NULL,
	Ins_Id int NOT NULL,
	CONSTRAINT ExamPK PRIMARY KEY (Exam_Id),
	CONSTRAINT ExamIntakeFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id),
	CONSTRAINT ExamCourseFK FOREIGN KEY (Crs_Id) REFERENCES Course (Crs_Id),
	CONSTRAINT ExamInstructorFK FOREIGN KEY (Ins_Id) REFERENCES Instructor (Ins_Id),
	CONSTRAINT ExamType CHECK (E_Type in ('Regular','Corrective'))
)
alter table Exam
alter column  Total_time varchar(30) NOT NULL

Go
CREATE TABLE Student_Course(
	Course_Id int,
	Student_Id int,
	CONSTRAINT StudentCoursePK PRIMARY KEY (Course_Id,Student_Id),
	CONSTRAINT Std_StudentCourseFK FOREIGN KEY (Student_Id) REFERENCES Student (Std_Id),
	CONSTRAINT Crs_StudentCourseFK FOREIGN KEY (Course_Id) REFERENCES Course (Crs_Id)
)

alter table Student_Course
add  Degree int 

alter table Student_Course
add  [Status]  varchar(10) default 'Pass'

Go
CREATE TABLE Branch_Track_Intake(
	Branch_Id int NOT NULL,
	Track_Id int,
	Intake_Id int,
	CONSTRAINT BranchTrackIntakePK PRIMARY KEY (Branch_Id,Track_Id,Intake_Id),
	CONSTRAINT Branch_BranchTrackIntakeFK FOREIGN KEY (Branch_Id) REFERENCES Branch (Branch_Id),
	CONSTRAINT Track_BranchTrackIntakeFK FOREIGN KEY (Track_Id) REFERENCES Track (Track_Id),
	CONSTRAINT Intake_BranchTrackIntakeFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id)
)
alter table Branch_Track_Intake
drop CONSTRAINT BranchTrackIntakePK 
alter table Branch_Track_Intake
add CONSTRAINT BranchTrackIntakePK PRIMARY KEY (Branch_Id,Track_Id,Intake_Id)



Go
CREATE TABLE Student_Exam_Questions(
	Exam_Id int,
	Question_Id int,
	Std_Id int ,
	Answers nvarchar(max),
	Result int,
	CONSTRAINT StudentExamQuestionsPK PRIMARY KEY (Exam_Id,Question_Id,Std_Id),
	CONSTRAINT Exam_StudentExamQuestionsFK FOREIGN KEY (Exam_Id) REFERENCES Exam (Exam_Id),
	CONSTRAINT Question_StudentExamQuestionsFK FOREIGN KEY (Question_Id) REFERENCES Questions (Question_Id),
	CONSTRAINT Std_StudentExamQuestionsFK FOREIGN KEY (Std_Id) REFERENCES Student (Std_Id),
)
alter table Student_Exam_Questions
drop CONSTRAINT StudentExamQuestionsPK
go
alter table Student_Exam_Questions
alter column Question_Id int not null
go
alter table Student_Exam_Questions
add CONSTRAINT StudentExamQuestionsPK PRIMARY KEY (Exam_Id,Question_Id,Std_Id)

Go
CREATE TABLE Intake_Instructor(
	Intake_Id int,
	Ins_Id int,
	CONSTRAINT IntakeInstructorPK PRIMARY KEY (Intake_Id,Ins_Id),
	CONSTRAINT Intake_IntakeInstructorFK FOREIGN KEY (Intake_Id) REFERENCES Intake (Intake_Id),
	CONSTRAINT Ins_IntakeInstructorFK FOREIGN KEY (Ins_Id) REFERENCES Instructor (Ins_Id)
)

