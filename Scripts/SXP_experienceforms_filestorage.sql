/*
Deployment script for ExperienceForms File Upload Element feature
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

GO

SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
BEGIN TRANSACTION


GO
PRINT N'Creating [sitecore_forms_filestorage] schema...';
GO
CREATE SCHEMA [sitecore_forms_filestorage];


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileIds] type...';
GO
CREATE TYPE [sitecore_forms_filestorage].[FileIds] AS TABLE
(
    [Id] UNIQUEIDENTIFIER NOT NULL
);


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage] table...';
GO
CREATE TABLE [sitecore_forms_filestorage].[FileStorage]
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [FileName] NVARCHAR (256) NOT NULL,
    [Created] DATETIME2 (3) NOT NULL,
    [Committed] BIT NOT NULL,
    [FileContent] VARBINARY (MAX) NOT NULL,
    CONSTRAINT [PK_FileStorage] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage].[IX_FileStorage_Retrieval] non-clustered index...';
GO
CREATE NONCLUSTERED INDEX [IX_FileStorage_Retrieval]
    ON [sitecore_forms_filestorage].[FileStorage]([Id], [FileName], [Created]);


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage_Cleanup] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_filestorage].[FileStorage_Cleanup]
(
    @GracePeriod BIGINT
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    IF(@GracePeriod IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @GracePeriod cannot be null', 0
    END

    -- Get current date and subtract ticks (grace period) from it
    DECLARE @ExpiryDate datetime2 = GETDATE()
    SET @ExpiryDate = DATEADD(DAY, -@GracePeriod / 864000000000, @ExpiryDate)
    SET @ExpiryDate = DATEADD(SECOND, -(@GracePeriod % 864000000000) / 10000000, @ExpiryDate)
    SET @ExpiryDate = DATEADD(NANOSECOND, -(@GracePeriod % 10000000) * 100, @ExpiryDate)

    DELETE
        [sitecore_forms_filestorage].[FileStorage]
    WHERE
        [Committed] = 0 AND
        [Created] <= @ExpiryDate

    SELECT @@ROWCOUNT AS [DeletedEntryCount]
END


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage_Commit] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_filestorage].[FileStorage_Commit]
(
    @FileIds [sitecore_forms_filestorage].[FileIds] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    UPDATE
        [sitecore_forms_filestorage].[FileStorage]
    SET
        [Committed] = 1
    WHERE
        EXISTS
        (
            SELECT
                [Id]
            FROM
                @FileIds
            WHERE
                [Id] = [sitecore_forms_filestorage].[FileStorage].[Id]
        ) AND
        [Committed] = 0

    SELECT @@ROWCOUNT AS [CommittedEntryCount]
END


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage_Delete] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_filestorage].[FileStorage_Delete]
(
    @FileIds [sitecore_forms_filestorage].[FileIds] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    DELETE
        [sitecore_forms_filestorage].[FileStorage]
    WHERE
        EXISTS
        (
            SELECT
                [Id]
            FROM
                @FileIds
            WHERE
                [Id] = [sitecore_forms_filestorage].[FileStorage].[Id]
        )

    SELECT @@ROWCOUNT AS [DeletedEntryCount]
END


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage_Retrieve] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_filestorage].[FileStorage_Retrieve]
(
    @FileId UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    IF(@FileId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FileId cannot be null', 0
    END

    SELECT
        [Id],
        [FileName],
        [FileContent]
    FROM
        [sitecore_forms_filestorage].[FileStorage]
    WHERE
        [Id] = @FileId
END


GO
PRINT N'Creating [sitecore_forms_filestorage].[FileStorage_Store] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_filestorage].[FileStorage_Store]
(
    @FileName NVARCHAR(256),
    @Created DATETIME2(3),
    @FileContent VARBINARY(MAX)
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    IF(@FileName IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FileName cannot be null', 0
    END

    IF(@Created IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @Created cannot be null', 0
    END

    IF(@FileContent IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FileContent cannot be null', 0
    END

    DECLARE
        @FileId UNIQUEIDENTIFIER = NEWID()

    BEGIN TRY
        INSERT INTO
            [sitecore_forms_filestorage].[FileStorage]
        (
            [Id],
            [FileName],
            [Created],
            [Committed],
            [FileContent]
        )
        VALUES
        (
            @FileId,
            @FileName,
            @Created,
            0,
            @FileContent
        )

        SELECT @FileId AS [FileId]

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        ;THROW
    END CATCH
END


GO
PRINT N'Creating [sitecore_forms_filestorage].[GrantLeastPrivilege] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_filestorage].[GrantLeastPrivilege]
(
    @Name SYSNAME
)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    IF (LEN(ISNULL(@Name, N'')) = 0)
    BEGIN
        ;THROW 51000, 'Parameter @Name cannot be null or empty', 0
    END

    IF (@Name LIKE N'%[^a-zA-Z0-9_]%')
    BEGIN
        ;THROW 51000, 'Parameter @Name cannot contain special characters', 0
    END

    EXECUTE ('
    -- Types
    grant execute on TYPE::[sitecore_forms_filestorage].[FileIds] TO ' + @Name + '

    -- Procs
    grant execute on [sitecore_forms_filestorage].[FileStorage_Cleanup] TO ' + @Name + '
    grant execute on [sitecore_forms_filestorage].[FileStorage_Commit] TO ' + @Name + '
    grant execute on [sitecore_forms_filestorage].[FileStorage_Delete] TO ' + @Name + '
    grant execute on [sitecore_forms_filestorage].[FileStorage_Retrieve] TO ' + @Name + '
    grant execute on [sitecore_forms_filestorage].[FileStorage_Store] TO ' + @Name);

END


GO

IF @@TRANCOUNT > 0
BEGIN
    PRINT N'The transacted portion of the database update succeeded.'
    COMMIT TRANSACTION
END
ELSE
    PRINT N'The transacted portion of the database update failed.'


GO