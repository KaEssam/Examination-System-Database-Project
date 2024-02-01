-- Create Login
USE master;
CREATE LOGIN Admin WITH PASSWORD = 'AdminPassword';
CREATE LOGIN Manger WITH PASSWORD = 'MangerPassword';
CREATE LOGIN Instructor WITH PASSWORD = 'InstructorPassword';
CREATE LOGIN Student WITH PASSWORD = 'StudentPassword';



-- Create Database User
USE Examinatin_System;
CREATE USER Admin FOR LOGIN Admin;
CREATE USER Manger FOR LOGIN Manger;
CREATE USER Instructor FOR LOGIN Instructor;
CREATE USER Student FOR LOGIN Student;


-- Create Roles
USE Examinatin_System;
CREATE ROLE RoleAdmin;
CREATE ROLE RoleManger;
CREATE ROLE RoleInstructor;
CREATE ROLE RoleStudent;

-- Assign User to Roles
USE Examinatin_System;
ALTER ROLE RoleAdmin ADD MEMBER Admin;
ALTER ROLE RoleManger ADD MEMBER Manger;
ALTER ROLE RoleInstructor ADD MEMBER Instructor;
ALTER ROLE RoleStudent ADD MEMBER Student;


-- Grant Permissions
USE Examinatin_System;

-- Admin Permissions


ALTER ROLE db_owner ADD MEMBER RoleAdmin;

-- Training Manager Permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Instructor] TO RoleManger;
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Course] TO RoleManger;
GRANT SELECT, INSERT, UPDATE ON [dbo].[Branch]TO RoleManger;
GRANT SELECT, INSERT, UPDATE ON [dbo].[Track] TO RoleManger;
GRANT SELECT, INSERT ON [dbo].[Intake] TO RoleManger;
GRANT SELECT, INSERT ON [dbo].[student] TO RoleManger;



-- Instructor Permissions


GRANT EXECUTE ON ShowInstructorCourseinAllIntake TO RoleInstructor;
GRANT EXECUTE ON ShowInstructorCourseinThisIntake TO RoleInstructor;
GRANT EXECUTE ON ShowQuestionsInCourse TO RoleInstructor;
GRANT EXECUTE ON InsertExamRandom TO RoleInstructor;
GRANT EXECUTE ON InsertExam TO RoleInstructor;
GRANT EXECUTE ON setStudentStatus TO RoleInstructor;
GRANT EXECUTE ON ShowStudentsCourse TO RoleInstructor;
GRANT EXECUTE ON ShowDegreeStudentsInCourse TO RoleInstructor;
GRANT EXECUTE ON [dbo].[ShowQuestionsExam] TO RoleInstructor;


GRANT EXECUTE ON TYPE::[dbo].[QuestionsTableType] TO RoleInstructor;

--Student Permissions

GRANT EXECUTE ON [dbo].[SeeExamesOfSpecificCourse] TO RoleStudent;
GRANT EXECUTE ON [dbo].[SeeExamesScheduleOfAllCourses] TO RoleStudent;
GRANT EXECUTE ON [dbo].[SeeResultOfAllCourses] TO RoleStudent;
GRANT EXECUTE ON [dbo].[SeeResultOfSpecificCourse] TO RoleStudent;
GRANT EXECUTE ON [dbo].[VerifyStudentTimeOfEnteredExamAndGivePermission] TO RoleStudent;
GRANT EXECUTE ON [dbo].[InsertStudentAnswers] TO RoleStudent;
GRANT EXECUTE ON [dbo].[SeeAllCoursesWithInstructorsNames] TO RoleStudent;







