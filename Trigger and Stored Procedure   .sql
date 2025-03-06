---------------TRIGGER AND STORED PROCEDURES---------------IMELDA UNIVERSITY-----------------------------


-- first trigger is created after tablefees has been created, created trigger to pick the fee id, session and studentid of students that paid for exams
--insertion of values should be done after the trigger has been updta
CREATE trigger trg_combinedtrigger
on tblfees
for insert
as
begin
  set nocount on;



declare feescursor cursor
  for
    select  feeid,   studentid,   courseid,
   FeeType,   PaymentStatus, SessionID
  from tblFees

  OPEN feescursor

  declare @FeeID INT;
  declare @studentID int;
  declare @courseid int;
  declare @feetype varchar(50);
  declare @paymentstatus varchar(50);
  declare @SessionID int;


fetch next from feescursor into @FeeID, @studentID, @courseid, @feetype, @paymentstatus, @SessionID

while @@FETCH_STATUS = 0 -- 2 if this condition is true 
begin
	--select @FeeID, @studentID, @courseid, @feetype, @paymentstatus , @SessionID
	
	  if @feetype = 'exam' AND @paymentstatus = 'paid'
	  begin
		  insert into tblexams(feeID, StudentID, CourseID, SessionID  )
		  Values (@FeeID, @studentID, @courseid, @SessionID);
	  end

	fetch next from feescursor into @FeeID, @studentID, @courseid, @feetype, @paymentstatus, @sessionID
end

close feescursor       --end it/close---------

deallocate feescursor ----destroy cursor-----

 end

 go

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 

 --------------------------------------------------------------------------------------------------------------------------------------------
 --Second trigger to update the instructor id, examdate,examtime,examroom, based on the trigger above


 create trigger trg_exams
 on tblexams
 for insert
 as
 begin
    set nocount on;

	declare @instructorid int, @courseid int, @examdate date, @examtime time, @examroom varchar(50), @examid int
	select @courseid = CourseID, @examid =ExamID from inserted
 
 select @instructorid =
  case
  when @courseid = 1 Then 2
  when @courseid = 2 Then 1
  when @courseid = 3 Then 3
  When @courseid = 4 Then 5
  When @courseid = 5 Then 4
  When @courseid = 6 Then 5
  When @courseid = 7 Then 2
  When @courseid = 8 Then 1
  When @courseid = 9 Then 4
  When @courseid =10 Then 3
  ELSE NULL
  end;

  select @examdate =
  case
  when @courseid = 1 then '2023-06-12'
  when @courseid = 2 then '2023-06-14'
  when @courseid = 3 then '2023-06-15'
  when @courseid = 4 then '2023-06-19'
  when @courseid = 5 then '2023-06-22'
  when @courseid = 6 then '2023-06-13'
  when @courseid = 7 then '2023-06-16'
  when @courseid = 8 then '2023-06-23'
  when @courseid = 9 then '2023-06-20'
  when @courseid = 10 then '2023-06-21'
  ELSE NULL
  end;

  select @examtime =
  case
  when @courseid = 1 then '09:00:00'
  when @courseid = 2 then '11:00:00'
  when @courseid = 3 then '13:00:00'
  when @courseid = 4 then '09:00:00'
  when @courseid = 5 then '11:00:00'
  when @courseid = 6 then '14:00:00'
  when @courseid = 7 then '09:00:00'
  when @courseid = 8 then '13:00:00'
  when @courseid = 9 then '10:00:00'
  when @courseid = 10 then '11:00:00'
  ELSE NULL
  end;

  select @examroom =
  case
  when @courseid = 1 then 'room 1'
  when @courseid = 2 then 'room 2'
  when @courseid = 3 then 'room 3'
  when @courseid = 4 then 'room 4'
  when @courseid = 5 then 'room 5'
  when @courseid = 6 then 'room 6'
  when @courseid = 7 then 'room 2'
  when @courseid = 8 then 'room 3'
  when @courseid = 9 then 'room 4'
  when @courseid = 10 then'room 5'
  ELSE NULL
  end;

   update tblexams
  set InstructorID = @instructorid, 
  examdate = (@examdate),  examtime = (@examtime), ExamRoom = (@examroom)
  where ExamID = @examid;

  end;

go
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  --STORED PROCEDURE TO POPULATE SCORE OF STUDENT THAT WROTE EXAMS
  create procedure prod_score
  @student_id INT,
  @new_score INT
  AS
     BEGIN
	      UPDATE tblExams
		  SET Score = @new_score
		  where Studentid = @student_id

    END
go
  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--trigger to populate grade table after a student score is updated into the exams table 

	create trigger trg_populategrade
	on tblexams
	after update
	          as
			  BEGIN
  declare @score int;
  declare @studentID int;
  declare @courseid int;
  declare @grade char(1);

     declare gradecursor cursor for
     select   studentid, courseid, Score
     from inserted;
 OPEN gradecursor;
  	 fetch next from gradecursor into  @studentID, @courseid, @score
while @@FETCH_STATUS = 0 -- 2 if this condition is true 
begin
     insert into tblGrades(StudentID, CourseID,score)
	 values (@studentid,  @courseid, @score)
                fetch next from gradecursor into @studentID, @courseid, @score
		        END
			close gradecursor;
			deallocate gradecursor
		end


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO

--TRIGGER TO UPDATE GRADE AND GRADE POINTS BASED ON THE SCORES 

	create trigger trg_updategrade
	on tblexams
	for update
	  AS
	declare @grade CHAR(1), @gradepoint DECIMAL(3,2), @score INT
	select @score = score from inserted

	  select @grade =
	case
	when @score >=90 then 'A' 
	when @score >=80 then 'B' 
	when @score >=60 then 'C' 
	when @score >=50 then 'D' 
	when @score <=49 then 'F' 
	ELSE NULL
	END;

	  select @gradepoint =
	case
	when @score >=90 then 5.0
	when @score >=80 then 4.0 
	when @score >=60 then 3.0 
	when @score >=50 then 2.0 
	when @score <=49 then 0.0 
	ELSE NULL
	END;

	   update tblGrades
  set grade = @grade, 
  gradepoint = @gradepoint  
  where score = @score;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------Search Stored Procedure-----------------------------------
CREATE PROCEDURE usp_PowerSearchStudents
    @StudentID INT = NULL,
    @Name VARCHAR(100) = NULL,
    @Gender CHAR(1) = NULL,
    @DateOfBirth DATE = NULL,
    @Email VARCHAR(100) = NULL,
    @ContactNumber VARCHAR(20) = NULL,
    @Address VARCHAR(200) = NULL,
    @Admission_Year INT = NULL,
    @Program VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQL NVARCHAR(MAX) = 'SELECT * FROM tblStudents WHERE 1=1';
    DECLARE @Params NVARCHAR(MAX) = '';

    -- Append conditions for each parameter if they are not NULL
    IF @StudentID IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND StudentID = @StudentID';
        SET @Params = @Params + '@StudentID INT, ';
    END
    IF @Name IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND Name LIKE ''%'' + @Name + ''%''';
        SET @Params = @Params + '@Name VARCHAR(100), ';
    END
    IF @Gender IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND Gender = @Gender';
        SET @Params = @Params + '@Gender CHAR(1), ';
    END
    IF @DateOfBirth IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND DateOfBirth = @DateOfBirth';
        SET @Params = @Params + '@DateOfBirth DATE, ';
    END
    IF @Email IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND Email LIKE ''%'' + @Email + ''%''';
        SET @Params = @Params + '@Email VARCHAR(100), ';
    END
    IF @ContactNumber IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND ContactNumber LIKE ''%'' + @ContactNumber + ''%''';
        SET @Params = @Params + '@ContactNumber VARCHAR(20), ';
    END
    IF @Address IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND [Address] LIKE ''%'' + @Address + ''%''';
        SET @Params = @Params + '@Address VARCHAR(200), ';
    END
    IF @Admission_Year IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND Admission_Year = @Admission_Year';
        SET @Params = @Params + '@Admission_Year INT, ';
    END
    IF @Program IS NOT NULL
    BEGIN
        SET @SQL = @SQL + ' AND Program LIKE ''%'' + @Program + ''%''';
        SET @Params = @Params + '@Program VARCHAR(100), ';
    END

    -- Remove the trailing comma and space
    IF LEN(@Params) > 0
    BEGIN
        SET @Params = LEFT(@Params, LEN(@Params) - 2);
    END

    -- Add parameters for sp_executesql
    IF LEN(@Params) > 0
    BEGIN
        SET @Params = '@StudentID INT, @Name VARCHAR(100), @Gender CHAR(1), @DateOfBirth DATE, @Email VARCHAR(100), @ContactNumber VARCHAR(20), @Address VARCHAR(200), @Admission_Year INT, @Program VARCHAR(100)';
    END

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL, @Params,
        @StudentID = @StudentID,
        @Name = @Name,
        @Gender = @Gender,
        @DateOfBirth = @DateOfBirth,
        @Email = @Email,
        @ContactNumber = @ContactNumber,
        @Address = @Address,
        @Admission_Year = @Admission_Year,
        @Program = @Program;
END;
GO

--TO CALL THE STORED PROCEDURE
EXEC usp_PowerSearchStudents @Gender = 'M', @Program = 'Computer Science';
EXEC usp_PowerSearchStudents @StudentID = 53;
EXEC usp_PowerSearchStudents @Gender = 'F', @Program = 'Computer Science';


select * from tblStudents









