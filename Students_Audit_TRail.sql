-----------Audit table


CREATE TABLE tblStudentsAudit 
(
    AuditID INTEGER IDENTITY(1,1) CONSTRAINT PK_AuditID PRIMARY KEY (AuditID),
    AuditMessage NVARCHAR(300)
);
GO


CREATE TRIGGER udtr_StudentsAudit
ON tblStudents
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @OperationType NVARCHAR(10)
    DECLARE @StudentID INT
    DECLARE @ChangedBy NVARCHAR(100)
    DECLARE @ChangeDate NVARCHAR(20)
    DECLARE @AuditMessage NVARCHAR(300)

    -- Get the current user and formatted timestamp
    SET @ChangedBy = SYSTEM_USER
    SET @ChangeDate = CONVERT(NVARCHAR(20), GETDATE(), 120)

    -- Handle INSERT operation
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT @StudentID = StudentID FROM inserted
        SET @OperationType = 'INSERT'
        SET @AuditMessage = @OperationType + ': Student with ID ' + CAST(@StudentID AS NVARCHAR(5)) + 
                            ' added by ' + @ChangedBy + ' at ' + @ChangeDate

        INSERT INTO tblStudentsAudit (AuditMessage)
        VALUES(@AuditMessage)
    END

    -- Handle UPDATE operation
    ELSE IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT @StudentID = StudentID FROM inserted
        SET @OperationType = 'UPDATE'
        SET @AuditMessage = @OperationType + ': Student with ID ' + CAST(@StudentID AS NVARCHAR(5)) + 
                            ' updated by ' + @ChangedBy + ' at ' + @ChangeDate

        INSERT INTO tblStudentsAudit (AuditMessage)
        VALUES(@AuditMessage)
    END

    -- Handle DELETE operation
    ELSE IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        SELECT @StudentID = StudentID FROM deleted
        SET @OperationType = 'DELETE'
        SET @AuditMessage = @OperationType + ': Student with ID ' + CAST(@StudentID AS NVARCHAR(5)) + 
                            ' deleted by ' + @ChangedBy + ' at ' + @ChangeDate

        INSERT INTO tblStudentsAudit (AuditMessage)
        VALUES(@AuditMessage)
    END
END;

-------------Test Data-----------------------------------
select * from tblStudentsAudit
select * from tblStudents

update tblStudents
set Name = 'Ayomi Grace Oluwatomi'
where StudentID = 32

delete from tblStudents
where StudentID = 1053;




