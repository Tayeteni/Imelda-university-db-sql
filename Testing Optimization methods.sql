----------------------------------------TASK 3-----------------------------------
-- Index on Student Name
CREATE INDEX idx_student_name
ON tblStudents (Name);

-- Index on Instructor Name
CREATE INDEX idx_instructor_name
ON tblInstructors (Name);

-- Index on Course Title
CREATE INDEX idx_course_title
ON tblCourses (Title);

-- Index on Student Address
CREATE INDEX idx_student_address
ON tblStudents ([Address]);

-- Index on Instructor Address
CREATE INDEX idx_instructor_address
ON tblInstructors ([Address]);

----------test-------------
-- Query to search for a student name
SELECT * FROM tblStudents WHERE Name = 'Bashir fadil Jamiu';

-- Query to search for an instructor name
SELECT * FROM tblInstructors WHERE Name = 'Rachel Grace Okoye';

-- Query to search for a course title
SELECT * FROM tblCourses WHERE Title = 'Web Development';

-- Query to search for a student address
SELECT * FROM tblStudents WHERE [Address] = 'block 3A 6th venue adamawa';

-- Query to search for an instructor address
SELECT * FROM tblInstructors WHERE [Address] = 'No 10 Mada close Ungwan dosa';



--------------------------------------Task 4---------------------------------------------------------------------

------full text search ----------
--TO retrieve the required details by using full text search, we configured full text search on the database first by
--       creating a full text catalog
--       creating a unique index
--       creating a full text index 
--       populate the full text index (fulltextsearch)
create fulltext catalog  CAT1 as default
create unique index Ix_Itr on tblInstructors(InstructorID)
create fulltext index on  tblInstructors
( Name, Gender, MaritalStatus, [Address], Email, ContactNumber )
KEY INDEX Ix_Itr on CAT1
 
create fulltext catalog  CAT2 
create unique index Ix_cos on tblCourses(CourseID)
create fulltext index on  tblCourses
(Title)
KEY INDEX Ix_cos on CAT2

create fulltext catalog  CAT3 
create unique index Ix_qlf on tblQualifications(QualificationID)
create fulltext index on  tblQualifications
(Degree, Institution, FieldOfStudy, AdditionalCertification)
KEY INDEX  Ix_qlf on CAT3
 
 
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 --TEST
 --------------------------------------------TASK 4A------------------------------------------ 
 --Full text search to extract information members information based on specific keywords related to their courses 
 select * from tblInstructors where InstructorID in(
   select InstructorID from tblCourseAssignment where CourseID in(
      select CourseID from tblCourses where contains ( Title, 'sql')  ) )
 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--TEST
--------------------------------------------TASK 4B------------------------------------------ 
 --Full text search to extract instructor members information based on specific keywords related to their academic qualifications
 select * from tblInstructors
 where InstructorID in ( select InstructorID from tblQualifications
	   where contains ((degree, Institution, FieldOfStudy,AdditionalCertification), 'Networking'))





  

