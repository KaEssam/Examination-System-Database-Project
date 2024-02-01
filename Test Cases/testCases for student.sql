

-- student see all his courses with instructors names.
--input: student id

--Valid Case - Student Exists with Course And Instructor name
EXEC SeeAllCoursesWithInstructorsNames 5

EXEC SeeAllCoursesWithInstructorsNames 451

--Invalid Case - Student Does Not Exist
EXEC SeeAllCoursesWithInstructorsNames 600








--See Exam Schedule of All Courses 
--input: student id

--Valid Case - Student in Intake 3
EXEC SeeExamesScheduleOfAllCourses 451

--Access Denied - Student Not in Intake 3
EXEC SeeExamesScheduleOfAllCourses 2

---nvalid Student - Student Does Not Exist
EXEC SeeExamesScheduleOfAllCourses 600










--Also he can see Exams of specific course 
--input: student id, course name

--Valid Case - Student and Course Exist in Intake 3
EXEC SeeExamesOfSpecificCourse 451 ,'Software Configuration'
EXEC SeeExamesOfSpecificCourse 451 ,'Data Analysis using Power BI'

--Invalid Student - Student Does Not Exist
EXEC SeeExamesOfSpecificCourse 650 ,'Data Analysis using Power BI'

--Invalid Course - Course Does Not Exist:
EXEC SeeExamesOfSpecificCourse 451 ,'Logic'

--Invalid Student and Course - Both Do Not Exist:
EXEC SeeExamesOfSpecificCourse 650 ,'Logic'

--Access Denied - Intake Id is Not 3:
EXEC SeeExamesOfSpecificCourse 50 ,'Data Analysis using Power BI'






--Student enter specific exam
-- Check the student's access to a specified exam and retrieves the exam questions if the student has access.
-- It verifies the existence of the exam, checks if the current time is within the exam period or raises errors.
--input: exam id

--Valid Case - Exam Exists, Within Exam Period
exec VerifyStudentTimeOfEnteredExamAndGivePermission 2


--Invalid Case - Exam Does Not Exist
exec VerifyStudentTimeOfEnteredExamAndGivePermission 2100






-- Student Insert or update his answers
--input: exam id, student id, question id , answer

--Valid Case - Question Exists, Exam Ongoing

--Student 451

exec InsertStudentAnswers 2,451,1500,'Data modeling in Power BI involves defining relationships,
creating calculated columns,
and establishing hierarchies to organize and enhance data for analysis.'

exec InsertStudentAnswers 2,451,1502,'Power Query is used for data transformation and shaping.
It allows users to connect to various data sources'

exec InsertStudentAnswers 2,451,1519,'B'

exec InsertStudentAnswers 2,451,1520,'A'

exec InsertStudentAnswers 2,451,1523,'B'

exec InsertStudentAnswers 2,451,1529,'D'

exec InsertStudentAnswers 2,451,1539,'FALSE'

exec InsertStudentAnswers 2,451,1544,'FALSE'

exec InsertStudentAnswers 2,451,1548,'FALSE'

exec InsertStudentAnswers 2,451,1550,'FALSE'


--Student 452

exec InsertStudentAnswers 2,452,1500,'Data modeling in Power BI involves defining relationships,
and establishing hierarchies to organize and enhance data for analysis.'

exec InsertStudentAnswers 2,452,1502,'Power Query is used for data transformation and shaping.
It allows users to connect to various data sources'

exec InsertStudentAnswers 2,452,1519,'B'

exec InsertStudentAnswers 2,452,1520,'C'

exec InsertStudentAnswers 2,452,1523,'B'

exec InsertStudentAnswers 2,452,1529,'C'

exec InsertStudentAnswers 2,452,1539,'TRUE'

exec InsertStudentAnswers 2,452,1544,'FALSE'

exec InsertStudentAnswers 2,452,1548,'TRUE'

exec InsertStudentAnswers 2,452,1550,'FALSE'


--Student 453

exec InsertStudentAnswers 2,453,1500,'Data modeling in Power BI involves defining relationships,
creating calculated columns,'

exec InsertStudentAnswers 2,453,1502,'Power Query is used for data transformation and shaping.'

exec InsertStudentAnswers 2,453,1519,'B'

exec InsertStudentAnswers 2,453,1520,'C'

exec InsertStudentAnswers 2,453,1523,'C'

exec InsertStudentAnswers 2,453,1529,'C'

exec InsertStudentAnswers 2,453,1539,'TRUE'

exec InsertStudentAnswers 2,453,1544,'TRUE'

exec InsertStudentAnswers 2,453,1548,'FALSE'

exec InsertStudentAnswers 2,453,1550,'TRUE'


--NULL Answer
exec InsertStudentAnswers 2,451,1523,''

--Valid Case - Question Exists, Exam Hasn't Started
exec InsertStudentAnswers 2,451,1523,'b'

--Valid Case - Question Exists, Exam Time Over
exec InsertStudentAnswers 2,451,1523,'b'

---------not important---------
--Invalid Case - Exam Does Not Exist
exec InsertStudentAnswers 10,451,1523,'b'

--Invalid Case - Question Does Not Exist
exec InsertStudentAnswers 2,451,2000,'b'





--student see result of exam
--see the result in a particular course.
--input: student id and course name

--Valid Case - Student Exists, No Result Yet
EXEC SeeResultOfSpecificCourse 451,'Oracle SQL';

--Valid Case - Student and Course Exist , Result Exists ==> pass or corrective 
EXEC SeeResultOfSpecificCourse 451,'Oracle SQL';

--invalid Case - Student Does Not Exist
EXEC SeeResultOfSpecificCourse 603,'Software Configuration';

--Invalid Case - Course Does Not Exist
EXEC SeeResultOfSpecificCourse 453,'Logic';

--Invalid Case - Student and Course Do Not Exist
EXEC SeeResultOfSpecificCourse 600,'Logic';





--see the results of all courses
--input: student id

--Valid Case - Student Exists with Course Results
EXEC SeeResultOfAllCourses 451

--Invalid Case - Student Does Not Exist
EXEC SeeResultOfAllCourses 600


--Invalid Case - NULL Student ID
EXEC SeeResultOfAllCourses null

--Invalid Case - Negative Student ID
EXEC SeeResultOfAllCourses -1








