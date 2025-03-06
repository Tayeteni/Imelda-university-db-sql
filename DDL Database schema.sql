
 --Name: SQL PROJECT NIIT GROUP1
 --Created:		22-05-2024
 --Description:	ImeldaUniversity Database Management System
 ---------------------------------
  
 --***********************
 --Creation of New Database
 --***********************
 CREATE DATABASE ImeldaUniversity

--************************************
--Table Creation Scripts (10 tables)
--************************************

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE tblStudents  
(
	StudentID INTEGER IDENTITY(1,1) CONSTRAINT PK_StudentID PRIMARY KEY (StudentID),
	Name VARCHAR(100) UNIQUE NOT NULL,
	Gender CHAR(1) CHECK(Gender IN('M', 'F')) not null,
	DateOfBirth DATE NOT NULL,
	Email VARCHAR(100) CONSTRAINT CHK_Student_Email CHECK (Email LIKE '%_@__%.__%') not null,
	ContactNumber VARCHAR(20) CONSTRAINT CHK_Student_Contact_Number CHECK (ContactNumber LIKE '+234 __ ____ ____') not null,
	[Address] VARCHAR(200) not null,
	Admission_Year INTEGER NOT NULL,
	Program VARCHAR(100) not null,
);
SELECT * FROM tblStudents
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE tblCourses --(10 courses)
(
	CourseID INTEGER IDENTITY(1,1) CONSTRAINT PK_CourseID PRIMARY KEY (CourseID),
	SessionID INTEGER NOT NULL,
	Title VARCHAR(100) NOT NULL,
	CreditUnit INTEGER NOT NULL,
	CreditHours INTEGER CHECK (CreditHours > 0) not null,
	CONSTRAINT FK_SessionID FOREIGN KEY (SessionID) REFERENCES tblSessions(SessionID)
);


select * from tblCourses
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------
CREATE TABLE tblEnrollment
(
	EnrollmentID INTEGER IDENTITY(1,1) CONSTRAINT PK_EnrollmentID PRIMARY KEY (EnrollmentID),
	StudentID INTEGER NOT NULL,
	CourseID INTEGER NOT NULL,
	SessionID INTEGER NOT NULL,
	EnrollmentDate DATE CONSTRAINT CHK_EnrollmentDate CHECK (EnrollmentDate <= GETDATE()) NOT NULL,
	DateOfBirth DATE NOT NULL, 
	CompletionDate DATE not null,
	Age AS DATEDIFF(YEAR, DateOfBirth, GETDATE()), 
	CONSTRAINT CHK_Age CHECK (DATEDIFF(YEAR, DateOfBirth, GETDATE()) >= 18),
	CONSTRAINT FK_StudentID FOREIGN KEY (StudentID) REFERENCES tblStudents(StudentID),
	CONSTRAINT FK_CourseID FOREIGN KEY (CourseID) REFERENCES tblCourses(CourseID),
	CONSTRAINT FK_SessionID_Enrollment FOREIGN KEY (SessionID) REFERENCES tblSessions(SessionID)
);
select * from tblEnrollment

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------

CREATE TABLE tblSessions
(
	SessionID INTEGER IDENTITY(1,1) CONSTRAINT PK_SessionID PRIMARY KEY (SessionID),
	Semester VARCHAR(50) NOT NULL,
	StartDate date,
	EndDate DATE,
	AcademicYear VARCHAR(9)
);

select * from tblSessions


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblInstructors 
(
	InstructorID INTEGER IDENTITY(1,1) CONSTRAINT PK_InstructorID PRIMARY KEY (InstructorID),
	Name VARCHAR(100) UNIQUE  NOT NULL,
	Gender CHAR(1) CHECK(Gender IN('M', 'F')),
	DateOfBirth DATE NOT NULL,
	HireDate DATE CHECK (HireDate <= GETDATE()),
	MaritalStatus VARCHAR(10),
	[Address] VARCHAR(200) NOT NULL,
	Email VARCHAR(100) CONSTRAINT CHK_Email CHECK (Email LIKE '%_@__%.__%'),
	ContactNumber VARCHAR(20) NOT NULL,
	CONSTRAINT CHK_Instructor_Contact_Number CHECK (ContactNumber LIKE '+234 __ ____ ____')
);

select * from tblInstructors

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblQualifications
(
	QualificationID INTEGER IDENTITY(1,1) CONSTRAINT PK_QualificationID PRIMARY KEY (QualificationID),
	InstructorID INTEGER,
	Degree VARCHAR(50) NOT NULL,
	Institution VARCHAR(50)NOT NULL,
	YearObtained DATE NOT NULL,
	FieldOfStudy VARCHAR(200) NOT NULL,
	AdditionalCertification VARCHAR(100), 
	YearOfExperience INTEGER,
	FOREIGN KEY (InstructorID) REFERENCES tblInstructors(InstructorID)
);

select * from tblQualifications

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblCourseAssignment  
(
	InstructorID INT CONSTRAINT PK_InstructorCourse PRIMARY KEY (InstructorID, CourseID),
	CourseID INT NOT NULL,
	CONSTRAINT FK_Instructor FOREIGN KEY (InstructorID) REFERENCES tblInstructors(InstructorID),
	CONSTRAINT FK_Course FOREIGN KEY (CourseID) REFERENCES tblCourses(CourseID)
);

select * from tblCourseAssignment

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

create TABLE tblFees 
(
	FeeID INTEGER IDENTITY(1,1) CONSTRAINT PK_FeeID PRIMARY KEY (FeeID),
	StudentID INTEGER NOT NULL,
	FeeType VARCHAR(50) NOT NULL,
	Amount DECIMAL(10, 2) NOT NULL,
	PaymentDue DATE NOT NULL,
	PaymentStatus VARCHAR(20) NOT NULL,
	SessionID INTEGER NOT NULL,
	CourseID Integer not null,
	CONSTRAINT FK_feesStudentID FOREIGN KEY (StudentID) REFERENCES tblStudents(StudentID),
	CONSTRAINT FK_feesCourseID FOREIGN KEY (CourseID) REFERENCES tblCourses(CourseID),
	CONSTRAINT FK_feesSessionID FOREIGN KEY (SessionID) REFERENCES tblSessions(SessionID),
	CONSTRAINT CHK_PaymentStatus CHECK (PaymentStatus IN ('Paid', 'Unpaid')), -- ONLY EXAMS SHOULD SHOW UNPAID
	CONSTRAINT CHK_FeeType CHECK (Feetype IN ('Tuition', 'Hostel', 'Exam'))
);

select * from tblFees

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------


CREATE TABLE tblExams 
(
	ExamID INTEGER IDENTITY(1,1) CONSTRAINT PK_ExamID PRIMARY KEY (ExamID),
	FeeID INTEGER NOT NULL, 
	StudentID INTEGER not null, 
	ExamDate DATE null,
	ExamTime TIME NULL,
	ExamRoom VARCHAR(50) NULL,
	InstructorID INTEGER  NULL,
	Score DECIMAL(5,2) CHECK (Score BETWEEN 0 AND 100), 
	CourseID INT,CONSTRAINT FK_EXAMScourseID FOREIGN KEY (COURSEID) REFERENCES tblCOURSES(CourseID),
	SessionID INT,
		CONSTRAINT FK_ExamsStudentID FOREIGN KEY (StudentID) REFERENCES tblStudents(StudentID),
		CONSTRAINT FK_examsFeeID FOREIGN KEY (FeeID) REFERENCES tblFees(FeeID)
);
select * from tblExams


 exec prod_score
    @student_id = 14,
    @new_score =100.0
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------

CREATE TABLE tblGrades 
(
	GradeID INTEGER IDENTITY(1,1) CONSTRAINT PK_GradeID PRIMARY KEY (GradeID),
	StudentID INTEGER NOT NULL,
	CourseID INTEGER NOT NULL,
	GradePoint DECIMAL(3,2),
	grade varchar(2),
	score int,
	CONSTRAINT FK_GradesStudentID FOREIGN KEY (StudentID) REFERENCES tblStudents(StudentID),
	CONSTRAINT FK_gradesCourseID FOREIGN KEY (CourseID) REFERENCES tblCourses(CourseID)
);

select * from tblGrades

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
