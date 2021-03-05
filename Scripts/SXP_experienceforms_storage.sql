/*
Deployment script for ExperienceForms DB rework
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
PRINT N'Creating [sitecore_forms_storage] schema...';
GO
CREATE SCHEMA [sitecore_forms_storage];


GO
PRINT N'Creating [sitecore_forms_storage].[FormFieldData] type...';
GO
CREATE TYPE [sitecore_forms_storage].[FormFieldData] AS TABLE
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [FieldDefinitionId] UNIQUEIDENTIFIER NOT NULL,
    [FieldName] NVARCHAR(256) NOT NULL,
    [Value] NVARCHAR(MAX) NULL,
    [ValueType] NVARCHAR(256) NULL
);


GO
PRINT N'Creating [sitecore_forms_storage].[FieldData] table...';
GO
CREATE TABLE [sitecore_forms_storage].[FieldData]
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [FormEntryId] UNIQUEIDENTIFIER NOT NULL,
    [FieldDefinitionId] UNIQUEIDENTIFIER NOT NULL,
    [FieldName] NVARCHAR(256) NOT NULL,
    [Value] NVARCHAR(MAX) NULL,
    [ValueType] NVARCHAR(256) NULL,
    CONSTRAINT [PK_FieldData] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [sitecore_forms_storage].[FieldData].[IX_FieldData_FormEntryId] non-clustered index...';
GO
CREATE NONCLUSTERED INDEX [IX_FieldData_FormEntryId]
    ON [sitecore_forms_storage].[FieldData]([FormEntryId]);


GO
PRINT N'Creating [sitecore_forms_storage].[FormEntries] table...';
GO
CREATE TABLE [sitecore_forms_storage].[FormEntries]
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [FormDefinitionId] UNIQUEIDENTIFIER NOT NULL,
    [Created] DATETIME2(3) NOT NULL,
    CONSTRAINT [PK_FormEntry] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [sitecore_forms_storage].[FormEntries].[IX_FormEntry_Retrieval] non-clustered index...';
GO
CREATE NONCLUSTERED INDEX [IX_FormEntry_Retrieval]
    ON [sitecore_forms_storage].[FormEntries]([Id], [FormDefinitionId], [Created]);


GO
PRINT N'Inserting from [dbo].[FieldData] table to [sitecore_forms_storage].[FieldData] table...';
GO
INSERT INTO [sitecore_forms_storage].[FieldData]
(
    [Id],
    [FormEntryId],
    [FieldDefinitionId],
    [FieldName],
    [Value],
    [ValueType]
)
SELECT
    [ID],
    [FormEntryID],
    [FieldItemID],
    [FieldName],
    [Value],
    [ValueType]
FROM
    [dbo].[FieldData]


GO
PRINT N'Inserting from [dbo].[FormEntry] table to [sitecore_forms_storage].[FormEntries] table...';
GO
INSERT INTO [sitecore_forms_storage].[FormEntries]
(
    [Id],
    [FormDefinitionId],
    [Created]
)
SELECT
    [ID],
    [FormItemID],
    [Created]
FROM
    [dbo].[FormEntry]


GO
PRINT N'Creating [sitecore_forms_storage].[FK_FieldData_FormEntry] foreign key constraint...';
GO
ALTER TABLE [sitecore_forms_storage].[FieldData] WITH NOCHECK
    ADD CONSTRAINT [FK_FieldData_FormEntry] FOREIGN KEY ([FormEntryId]) REFERENCES [sitecore_forms_storage].[FormEntries] ([Id]);


GO
PRINT N'Dropping [dbo].[FK_FieldData_FormEntry] foreign key constraint...';
GO
ALTER TABLE [dbo].[FieldData] DROP CONSTRAINT [FK_FieldData_FormEntry];


GO
PRINT N'Dropping [dbo].[FieldData] table...';
GO
DROP TABLE [dbo].[FieldData];


GO
PRINT N'Dropping [dbo].[FormEntry] table...';
GO
DROP TABLE [dbo].[FormEntry];

GO
PRINT N'Updating [ValueType] column for [sitecore_forms_storage].[FieldData] table...';
GO
UPDATE 
    [sitecore_forms_storage].[FieldData]
SET 
    [ValueType] = 'System.Collections.Generic.List`1[System.String]' 
WHERE 
    [ValueType] LIKE 'System.Collections.Generic.List%system.string%'

GO
PRINT N'Creating [sitecore_forms_storage].[FormData_Count] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_storage].[FormData_Count]
(
    @FormDefinitionId UNIQUEIDENTIFIER,
    @StartDate DATETIME2(3) = NULL,
    @EndDate DATETIME2(3) = NULL
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    IF(@FormDefinitionId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FormDefinitionId cannot be null', 0
    END

    SELECT COUNT(*) AS [EntryCount]
    FROM [sitecore_forms_storage].[FormEntries]
    WHERE
        [FormDefinitionId] = @FormDefinitionId AND
        (@StartDate IS NULL OR [Created] >= @StartDate) AND
        (@EndDate IS NULL OR [Created] <= @EndDate)
END


GO
PRINT N'Creating [sitecore_forms_storage].[FormData_Delete] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_storage].[FormData_Delete]
(
    @FormDefinitionId UNIQUEIDENTIFIER,
    @StartDate DATETIME2(3) = NULL,
    @EndDate DATETIME2(3) = NULL
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    IF(@FormDefinitionId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FormDefinitionId cannot be null', 0
    END

    DECLARE @Entries TABLE
    (
        [Id] UNIQUEIDENTIFIER NOT NULL
    )

    INSERT INTO
        @Entries
    SELECT
        [Id]
    FROM
        [sitecore_forms_storage].[FormEntries]
    WHERE
        [FormDefinitionId] = @FormDefinitionId AND
        (@StartDate IS NULL OR [Created] >= @StartDate) AND
        (@EndDate IS NULL OR [Created] <= @EndDate)

    DELETE
        [sitecore_forms_storage].[FieldData]
    WHERE
        [FormEntryId] IN (SELECT [Id] FROM @Entries)

    DELETE
        [sitecore_forms_storage].[FormEntries]
    WHERE
        [Id] IN (SELECT [Id] FROM @Entries)

    SELECT @@ROWCOUNT AS [DeletedEntryCount]
END


GO
PRINT N'Creating [sitecore_forms_storage].[FormData_Retrieve] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_storage].[FormData_Retrieve]
(
    @FormDefinitionId UNIQUEIDENTIFIER,
    @StartDate DATETIME2(3) = NULL,
    @EndDate DATETIME2(3) = NULL
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    IF(@FormDefinitionId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FormDefinitionId cannot be null', 0
    END

    DECLARE @Entries TABLE
    (
        [Id] UNIQUEIDENTIFIER NOT NULL,
        [FormDefinitionId] UNIQUEIDENTIFIER NOT NULL,
        [Created] DATETIME2(3) NOT NULL
    )

    INSERT INTO
        @Entries
    SELECT
        [Id],
        [FormDefinitionId],
        [Created]
    FROM
        [sitecore_forms_storage].[FormEntries]
    WHERE
        [FormDefinitionId] = @FormDefinitionId AND
        (@StartDate IS NULL OR [Created] >= @StartDate) AND
        (@EndDate IS NULL OR [Created] <= @EndDate)

    SELECT
        [Id],
        [FormDefinitionId],
        [Created]
    FROM
        @Entries

    SELECT
        [Id],
        [FormEntryId],
        [FieldDefinitionId],
        [FieldName],
        [Value],
        [ValueType]
    FROM
        [sitecore_forms_storage].[FieldData]
    WHERE
        [FormEntryId] IN (SELECT [Id] FROM @Entries)
END


GO
PRINT N'Creating [sitecore_forms_storage].[FormData_RetrieveFieldValues] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_storage].[FormData_RetrieveFieldValues]
(
    @FormDefinitionId UNIQUEIDENTIFIER,
    @ValueType NVARCHAR(256),
    @StartDate DATETIME2(3) = NULL,
    @EndDate DATETIME2(3) = NULL
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON

    IF(@FormDefinitionId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FormDefinitionId cannot be null', 0
    END

    IF(@ValueType IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @ValueType cannot be null', 0
    END

    DECLARE @Entries TABLE
    (
        [Id] UNIQUEIDENTIFIER NOT NULL
    )

    INSERT INTO
        @Entries
    SELECT
        [Id]
    FROM
        [sitecore_forms_storage].[FormEntries]
    WHERE
        [FormDefinitionId] = @FormDefinitionId AND
        (@StartDate IS NULL OR [Created] >= @StartDate) AND
        (@EndDate IS NULL OR [Created] <= @EndDate)

    SELECT
        [Value]
    FROM
        [sitecore_forms_storage].[FieldData]
    WHERE
        [FormEntryId] IN (SELECT [Id] FROM @Entries) AND
        [ValueType] = @ValueType
END


GO
PRINT N'Creating [sitecore_forms_storage].[FormData_Store] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_storage].[FormData_Store]
(
    @FormEntryId UNIQUEIDENTIFIER,
    @FormDefinitionId UNIQUEIDENTIFIER,
    @Created DATETIME2(3),
    @Fields [sitecore_forms_storage].[FormFieldData] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON
    SET XACT_ABORT ON

    IF(@FormEntryId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FormEntryId cannot be null', 0
    END

    IF(@FormDefinitionId IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @FormDefinitionId cannot be null', 0
    END

    IF(@Created IS NULL)
    BEGIN
        ;THROW 51000, N'Parameter @Created cannot be null', 0
    END

    DECLARE
        @UpdatedEntryCount INT = 0

    BEGIN TRY
        BEGIN TRANSACTION
        
        IF EXISTS
        (
            SELECT [Id] FROM [sitecore_forms_storage].[FormEntries] WHERE [Id] = @FormEntryId
        )
        BEGIN
            UPDATE
                [sitecore_forms_storage].[FormEntries]
            SET
                [FormDefinitionId] = @FormDefinitionId,
                [Created] = @Created
            WHERE
                [Id] = @FormEntryId
        END
        ELSE
        BEGIN
            INSERT INTO
                [sitecore_forms_storage].[FormEntries]
            (
                [Id],
                [FormDefinitionId],
                [Created]
            )
            VALUES
            (
                @FormEntryId,
                @FormDefinitionId,
                @Created
            )
        END

        SELECT
            @UpdatedEntryCount = @@ROWCOUNT

        MERGE
            [sitecore_forms_storage].[FieldData] WITH (TABLOCK, HOLDLOCK) AS [Target]
        USING
            @Fields AS [Source]
        ON
        (
            [Target].[Id] = [Source].[Id]
        )
        WHEN MATCHED THEN
            UPDATE SET
                [FormEntryId] = @FormEntryId,
                [FieldDefinitionId] = [Source].[FieldDefinitionId],
                [FieldName] = [Source].[FieldName],
                [Value] = [Source].[Value],
                [ValueType] = [Source].[ValueType]
        WHEN NOT MATCHED THEN
            INSERT
            (
                [Id],
                [FormEntryId],
                [FieldDefinitionId],
                [FieldName],
                [Value],
                [ValueType]
            )
            VALUES
            (
                [Source].[Id],
                @FormEntryId,
                [Source].[FieldDefinitionId],
                [Source].[FieldName],
                [Source].[Value],
                [Source].[ValueType]
            )
        ;

        COMMIT TRANSACTION

        SELECT @UpdatedEntryCount AS [UpdatedEntryCount]

    END TRY
    BEGIN CATCH
        IF @@trancount > 0 ROLLBACK TRANSACTION
        ;THROW
    END CATCH
END


GO
PRINT N'Creating [sitecore_forms_storage].[GrantLeastPrivilege] stored procedure...';
GO
CREATE PROCEDURE [sitecore_forms_storage].[GrantLeastPrivilege]
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
    grant execute on TYPE::[sitecore_forms_storage].[FormFieldData] TO ' + @Name + '

    -- Procs
    grant execute on [sitecore_forms_storage].[FormData_Count] TO ' + @Name + '
    grant execute on [sitecore_forms_storage].[FormData_Delete] TO ' + @Name + '
    grant execute on [sitecore_forms_storage].[FormData_Retrieve] TO ' + @Name + '
    grant execute on [sitecore_forms_storage].[FormData_RetrieveFieldValues] TO ' + @Name + '
    grant execute on [sitecore_forms_storage].[FormData_Store] TO ' + @Name);

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