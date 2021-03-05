GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[CheckContactsTableType]...';

GO
IF TYPE_ID(N'[xdb_collection].[CheckContactsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[CheckContactsTableType] AS TABLE(
        [ContactId] [uniqueidentifier] NOT NULL,
        [Identifier] [varbinary](700) NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[CheckContactsTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[ContactFacetsTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[ContactFacetsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[ContactFacetsTableType] AS TABLE(
        [ContactId] [uniqueidentifier] NOT NULL,
        [FacetKey] [nvarchar](50) NOT NULL,
        [LastModified] [datetime2](7) NOT NULL,
        [ConcurrencyToken] [uniqueidentifier] NOT NULL,
        [FacetData] [nvarchar](max) NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[ContactFacetsTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[ContactIdentifiersIndexTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[ContactIdentifiersIndexTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[ContactIdentifiersIndexTableType] AS TABLE(
        [Identifier] [varbinary](700) NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL,
        [ContactId] [uniqueidentifier] NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[ContactIdentifiersIndexTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[ContactIdentifiersTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[ContactIdentifiersTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[ContactIdentifiersTableType] AS TABLE(
        [ContactId] [uniqueidentifier] NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL,
        [Identifier] [varbinary](700) NOT NULL,
        [IdentifierType] [smallint] NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[ContactIdentifiersTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[ContactsTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[ContactsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[ContactsTableType] AS TABLE(
        [ContactId] [uniqueidentifier] NOT NULL,
        [LastModified] [datetime2](7) NOT NULL,
        [ConcurrencyToken] [uniqueidentifier] NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [Percentile] [float] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[ContactsTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[DeviceProfileFacetsTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[DeviceProfileFacetsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[DeviceProfileFacetsTableType] AS TABLE(
        [DeviceProfileId] [uniqueidentifier] NOT NULL,
        [FacetKey] [nvarchar](50) NOT NULL,
        [LastModified] [datetime2](7) NOT NULL,
        [ConcurrencyToken] [uniqueidentifier] NOT NULL,
        [FacetData] [nvarchar](max) NOT NULL,
        [ChangeState] [int] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[DeviceProfileFacetsTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[DeviceProfilesTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[DeviceProfilesTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[DeviceProfilesTableType] AS TABLE(
        [DeviceProfileId] [uniqueidentifier] NOT NULL,
        [LastModified] [datetime2](7) NOT NULL,
        [ConcurrencyToken] [uniqueidentifier] NOT NULL,
        [LastKnownContactId] [uniqueidentifier] NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[DeviceProfilesTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[GetContactIdsByIdentifiersTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[GetContactIdsByIdentifiersTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[GetContactIdsByIdentifiersTableType] AS TABLE(
        [Identifier] [varbinary](700) NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[GetContactIdsByIdentifiersTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[GetContactsByIdentifiersTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[GetContactsByIdentifiersTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[GetContactsByIdentifiersTableType] AS TABLE(
        [ContactId] [uniqueidentifier] NOT NULL,
        [Identifier] [varbinary](700) NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[GetContactsByIdentifiersTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[InteractionFacetsTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[InteractionFacetsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[InteractionFacetsTableType] AS TABLE(
        [InteractionId] [uniqueidentifier] NOT NULL,
        [FacetKey] [nvarchar](50) NOT NULL,
        [ContactId] [uniqueidentifier] NOT NULL,
        [LastModified] [datetime2](7) NOT NULL,
        [ConcurrencyToken] [uniqueidentifier] NOT NULL,
        [FacetData] [nvarchar](max) NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[InteractionFacetsTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[InteractionsTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[InteractionsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[InteractionsTableType] AS TABLE(
        [InteractionId] [uniqueidentifier] NOT NULL,
        [LastModified] [datetime2](7) NOT NULL,
        [ConcurrencyToken] [uniqueidentifier] NOT NULL,
        [ContactId] [uniqueidentifier] NOT NULL,
        [StartDateTime] [datetime2](7) NOT NULL,
        [EndDateTime] [datetime2](7) NOT NULL,
        [Initiator] [smallint] NOT NULL,
        [DeviceProfileId] [uniqueidentifier] NULL,
        [ChannelId] [uniqueidentifier] NOT NULL,
        [VenueId] [uniqueidentifier] NULL,
        [CampaignId] [uniqueidentifier] NULL,
        [Events] [nvarchar](max) NOT NULL,
        [UserAgent] [nvarchar](900) NOT NULL,
        [EngagementValue] [int] NOT NULL,
        [ChangeState] [smallint] NOT NULL,
        [Percentile] [float] NOT NULL,
        [ShardKey] [binary](1) NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[InteractionsTableType]...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[UnlockContactIdentifiersIndexTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[UnlockContactIdentifiersIndexTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[UnlockContactIdentifiersIndexTableType] AS TABLE(
        [Identifier] [varbinary](700) NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL
    )
END
GO
PRINT N'Finish creating UserDefinedTableType [xdb_collection].[UnlockContactIdentifiersIndexTableType]...';

GO
PRINT N'Creating [xdb_collection].[CheckContactsTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[CheckContactsTvp]
GO
CREATE PROCEDURE [xdb_collection].[CheckContactsTvp]
    @CheckContacts CheckContactsTableType READONLY
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        SELECT 
            [Contacts_ST].[Identifier] AS [Identifier],
            [Contacts_ST].[Source] AS [Source],
            [Contacts].[ContactId] AS [ContactIdInDb]
        FROM 
          @CheckContacts AS [Contacts_ST]
          LEFT JOIN [xdb_collection].[ContactIdentifiers] AS [ContactIdentifiers]
            ON  DATALENGTH([Contacts_ST].[Identifier]) = [ContactIdentifiers].[IdentifierHash]
                AND [Contacts_ST].[Identifier] = [ContactIdentifiers].[Identifier]
                AND [Contacts_ST].[Source] = [ContactIdentifiers].[Source] COLLATE Latin1_General_BIN2
          LEFT JOIN [xdb_collection].[Contacts] AS [Contacts]
            ON [ContactIdentifiers].[ContactId] = [Contacts].[ContactId]

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[CheckContactsTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[DeleteContactIdentifiersIndexTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[DeleteContactIdentifiersIndexTvp]
GO
CREATE PROCEDURE [xdb_collection].[DeleteContactIdentifiersIndexTvp]
   	@ContactIdentifiersIndex ContactIdentifiersIndexTableType READONLY
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        MERGE INTO [xdb_collection].[ContactIdentifiersIndex] AS [Target_CII]
        USING 
        (
            SELECT 
                [Identifier],
                [Source],
                [ContactId],
                [ChangeState]
            FROM 
                @ContactIdentifiersIndex
        ) AS [Source_CII]
        ON 
            [Target_CII].[IdentifierHash] = DATALENGTH([Source_CII].[Identifier])
            AND [Target_CII].[Identifier] = [Source_CII].[Identifier]
            AND [Target_CII].[Source] = [Source_CII].[Source] COLLATE Latin1_General_BIN2
            AND [Target_CII].[ContactId] = [Source_CII].[ContactId]

        -- Delete contact identifier index record.
        WHEN MATCHED
        THEN
            DELETE;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[DeleteContactIdentifiersIndexTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[GetContactIdsByIdentifiersTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactIdsByIdentifiersTvp]
GO
CREATE PROCEDURE [xdb_collection].[GetContactIdsByIdentifiersTvp]
	@GetContactIdsByIdentifiers GetContactIdsByIdentifiersTableType READONLY
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        SELECT 
            [CII].[ContactId],
            [CII].[Identifier],
            [CII].[Source]
        FROM
            @GetContactIdsByIdentifiers AS [FilterIdentifiers]
            INNER JOIN [xdb_collection].[ContactIdentifiersIndex] AS [CII]
                ON [CII].[IdentifierHash] = DATALENGTH([FilterIdentifiers].[Identifier])
                   AND [CII].[Identifier] = [FilterIdentifiers].[Identifier]
                   AND [CII].[Source] = [FilterIdentifiers].[Source] COLLATE Latin1_General_BIN2

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[GetContactIdsByIdentifiersTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[GetContactsByIdentifiersTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactsByIdentifiersTvp]
GO
CREATE PROCEDURE [xdb_collection].[GetContactsByIdentifiersTvp]
    @FacetKeys NVARCHAR(MAX),
    @GetContactsByIdentifiers GetContactsByIdentifiersTableType READONLY
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        SELECT 
            [Source].[ContactId] AS [Id], 
            [Source].[LastModified] AS [LastModified],
            [Source].[Created],
            [Source].[ConcurrencyToken] AS [ConcurrencyToken],
            [Identifiers].[Identifier],
            [Identifiers].[IdentifierType],
            [Identifiers].[Source],
            [Facets].[FacetKey],
            [Facets].[LastModified] AS [FacetLastModified],
            [Facets].[ConcurrencyToken] AS [FacetConcurrencyToken],
            [Facets].[FacetData]
        FROM
            @GetContactsByIdentifiers AS [FilterIdentifiers]
            INNER JOIN [xdb_collection].[Contacts] AS [Source]
                ON [Source].[ContactId] = [FilterIdentifiers].[ContactId]
            INNER JOIN [xdb_collection].[ContactIdentifiers] AS [ContactIdentifiers]
                ON [ContactIdentifiers].[ContactId] = [FilterIdentifiers].[ContactId]
                   AND [ContactIdentifiers].[IdentifierHash] = DATALENGTH([FilterIdentifiers].[Identifier])
                   AND [ContactIdentifiers].[Identifier] = [FilterIdentifiers].[Identifier]
                   AND [ContactIdentifiers].[Source] = [FilterIdentifiers].[Source] COLLATE Latin1_General_BIN2
            LEFT JOIN
                (
                    SELECT
                        [ContactFacets].[ContactId],
                        [ContactFacets].[FacetKey],
                        [ContactFacets].[LastModified],
                        [ContactFacets].[ConcurrencyToken],
                        [ContactFacets].[FacetData]
                    FROM (SELECT [value] FROM STRING_SPLIT(@FacetKeys, ',')) AS [FacetKeys]
                    INNER JOIN [xdb_collection].[ContactFacets]
                        ON [FacetKeys].[value] = [ContactFacets].[FacetKey]
                ) AS [Facets]
                    ON [Source].[ContactId] = [Facets].[ContactId]
            LEFT JOIN [xdb_collection].[ContactIdentifiers] AS [Identifiers]
                ON [Source].[ContactId] = [Identifiers].[ContactId]
        ORDER BY
            [Id] ASC

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[GetContactsByIdentifiersTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveContactFacetsTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveContactFacetsTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveContactFacetsTvp]
    @ContactFacets ContactFacetsTableType READONLY,
    @NextConcurrencyToken UNIQUEIDENTIFIER
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION
    
        DECLARE @MergeContactFacetsOutput TABLE
        (
          DeleteContactId UNIQUEIDENTIFIER,
          DeleteFacetKey NVARCHAR(50)
        );

        MERGE INTO [xdb_collection].[ContactFacets] AS [Target]
        -- Only merge facets where the contact exists
        USING 
        (
            SELECT 
                [ContactId],
                [FacetKey],
                [LastModified],
                [ConcurrencyToken],
                [FacetData],
                [ChangeState],
                [ShardKey]
            FROM 
                @ContactFacets AS [SourceFacets] 
            WHERE
                EXISTS 
                    (
                        SELECT 1 
                        FROM [xdb_collection].[Contacts] AS [ParentTarget]
                        WHERE [ParentTarget].[ContactId] = [SourceFacets].[ContactId]
                    )
        )
        AS [Source]
        ON 
            [Target].[ContactId] = [Source].[ContactId] 
            AND [Target].[FacetKey] = [Source].[FacetKey]

        -- Changed contact facet. Fact Data is not null.
        WHEN MATCHED 
            AND [Source].[ChangeState] = 1
            AND [Target].[ConcurrencyToken] = [Source].[ConcurrencyToken] 
        THEN
            UPDATE SET
                [ConcurrencyToken] = @NextConcurrencyToken,
                [LastModified] = [Source].[LastModified],
                [FacetData] = [Source].[FacetData]

        -- Delete contact facet.
        WHEN MATCHED
            AND [Source].[ChangeState] = 3 -- Deleted
            AND [Target].[ConcurrencyToken] = [Source].[ConcurrencyToken]
        THEN
            DELETE

        -- New contact facet. Facet doesn't exist.
        WHEN NOT MATCHED 
            AND [Source].[ChangeState] = 2
        THEN
            INSERT 
            (
                [ContactId], 
                [FacetKey], 
                [LastModified], 
                [ConcurrencyToken],
                [FacetData],
                [ShardKey]
            ) 
            VALUES 
            (
                [Source].[ContactId],
                [Source].[FacetKey],
                [Source].[LastModified],
                @NextConcurrencyToken,
                [Source].[FacetData],
                [Source].[ShardKey]
            )
        OUTPUT DELETED.[ContactId], DELETED.[FacetKey]
        INTO @MergeContactFacetsOutput
        OPTION (LOOP JOIN);
    
        -- Check failures
        -- Check the number of newly added facets and compare with expected
        DECLARE @ExpectedChangeCount INT;
        DECLARE @ChangeCount INT;

        SET @ChangeCount = @@ROWCOUNT;
        SET @ExpectedChangeCount = 
        (
            SELECT 
                COUNT(*) 
            FROM 
                @ContactFacets
        );

        IF (@ChangeCount <> @ExpectedChangeCount)
            SELECT
                [Id],
                [FacetKey],
                [ErrorType]
            FROM
            (
                SELECT 
                    [Source].[ContactId] AS [Id],
                    [Source].[FacetKey] AS [FacetKey],
                    CASE
                        WHEN [Source].[ChangeState] = 1 
                            AND [Target].[ContactId] IS NULL 
                            AND [ReferenceTable].[ContactId] IS NULL
                            THEN 3 -- Update, Reference Not Found
    
                        WHEN [Source].[ChangeState] = 1 
                            AND [Target].[ContactId] IS NULL 
                            THEN 2 -- Update, Not Found
    
                        WHEN [Source].[ChangeState] = 1 
                            AND [Target].[ContactId] IS NOT NULL 
                            AND [Target].[ConcurrencyToken] <> @NextConcurrencyToken
                            THEN 0 -- Update, Conflict 
    
                        WHEN [Source].[ChangeState] = 2 
                            AND [Target].[ContactId] IS NULL 
                            AND [ReferenceTable].[ContactId] IS NULL
                            THEN 3 -- New, Reference Not Found
    
                        WHEN [Source].[ChangeState] = 2 
                            AND [Target].[ContactId] IS NOT NULL
                            AND [Target].[ConcurrencyToken] <> @NextConcurrencyToken
                            THEN 1 -- New, Already Exists
    
                        WHEN [Source].[ChangeState] = 3 
                            AND [Target].[ContactId] IS NULL 
                            AND [ReferenceTable].[ContactId] IS NULL
                            THEN 3 -- Delete, Reference Not Found
    
                        WHEN [Source].[ChangeState] = 3
                            AND [Target].[ContactId] IS NULL 
                            AND [DeletedContactFacets].[DeleteContactId] IS NULL
                            AND [DeletedContactFacets].[DeleteFacetKey] IS NULL
                            THEN 2 -- Delete, Not Found
    
                        WHEN [Source].[ChangeState] = 3 
                            AND [Target].[ContactId] IS NOT NULL 
                            AND [Target].[ConcurrencyToken] <> @NextConcurrencyToken
                            THEN 0 -- Delete, Conflict 
    
                    END AS [ErrorType]
                FROM 
                    @ContactFacets AS [Source]
                    LEFT JOIN [xdb_collection].[ContactFacets] AS [Target]
                        ON [Source].[ContactId] = [Target].[ContactId]
                        AND [Source].[FacetKey] = [Target].[FacetKey]
                    LEFT JOIN [xdb_collection].[Contacts] AS [ReferenceTable]
                        ON [ReferenceTable].[ContactId] = [Source].[ContactId]
                    LEFT JOIN @MergeContactFacetsOutput AS [DeletedContactFacets]
                        ON [Source].[ContactId] = [DeletedContactFacets].[DeleteContactId]
                        AND [Source].[FacetKey] = [DeletedContactFacets].[DeleteFacetKey]
            ) AS [Errors]
            WHERE [ErrorType] IS NOT NULL
        ELSE
            SELECT TOP 0 NULL -- Return an empty table if the number of affected records is the same as expected    

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[SaveContactFacetsTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveContactIdentifiersIndexTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveContactIdentifiersIndexTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveContactIdentifiersIndexTvp]
	@ContactIdentifiersIndex ContactIdentifiersIndexTableType READONLY,
    @LockDateTime DATETIME -- A moment in time after which a given Contact Identifier Index lock is considered as expired
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        -- Get the current date time that will be used to check soft locks
        -- for contact identifiers in the index table.
        DECLARE @CurrentDateTime DATETIME
        SET @CurrentDateTime = GETUTCDATE();

        DECLARE @CurrentVersion UNIQUEIDENTIFIER
        SET @CurrentVersion = NEWID();

        MERGE INTO [xdb_collection].[ContactIdentifiersIndex] AS [Target_CII]
        USING 
        (
            SELECT 
                [Identifier],
                [Source],
                [ContactId],
                [ChangeState],
                [ShardKey]
            FROM 
                @ContactIdentifiersIndex
        ) AS [Source_CII]
        ON 
            [Target_CII].[IdentifierHash] = DATALENGTH([Source_CII].[Identifier])
            AND [Target_CII].[Identifier] = [Source_CII].[Identifier]
            AND [Target_CII].[Source] = [Source_CII].[Source] COLLATE Latin1_General_BIN2
    
        -- New contact identifier.
        WHEN NOT MATCHED
            AND [Source_CII].[ChangeState] = 2 -- New
        THEN
            INSERT 
            (
                [Identifier],
                [IdentifierHash],
                [Source],
                [ContactId],
                [ShardKey],
                [LockTime],
                [Version]
            ) 
            VALUES 
            (
                [Source_CII].[Identifier],
                DATALENGTH([Source_CII].[Identifier]),
                [Source_CII].[Source],
                [Source_CII].[ContactId], 
                [Source_CII].[ShardKey],
                @LockDateTime, -- Insert lock date time for the record
                @CurrentVersion -- Insert the current version of the record to be able
                                -- to distinguish newly added records or already existed
            )

        -- Delete contact identifier.
        WHEN MATCHED
            AND [Source_CII].[ContactId] = [Target_CII].[ContactId]
            AND [Source_CII].[ChangeState] = 3 -- Deleted
            AND ([Target_CII].[LockTime] IS NULL -- Hard lock is unlocked, OR
                 OR [Target_CII].[LockTime] <= @CurrentDateTime) -- Soft Lock is expired
        THEN
            DELETE;

        DECLARE @ChangeCount INT;
        DECLARE @ExpectedChangeCount INT;

        SET @ChangeCount = @@ROWCOUNT; -- Get actual change count
        SET @ExpectedChangeCount = -- Get expected change count
            (
                SELECT 
                    COUNT(*)
                FROM 
                    @ContactIdentifiersIndex
            );

        IF (@ChangeCount <> @ExpectedChangeCount)
                SELECT 
                [Source_CII].[Identifier] AS [Identifier],
                [Source_CII].[Source] AS [Source],
                [Source_CII].[ContactId] AS [ContactId],
                [Target_CII].[ContactId] AS [ContactIdInIndex],
                [Source_CII].[ChangeState] AS [ChangeState],
                CASE
                    WHEN [Source_CII].[ChangeState] = 2 -- New
                         AND [Target_CII].[LockTime] IS NULL -- The index was explicitly unlocked.
                        THEN 1 -- New, AlreadyExist save result
                    
                    WHEN ([Source_CII].[ChangeState] = 2 -- New
                          OR [Source_CII].[ChangeState] = 3) -- Deleted
                         AND [Target_CII].[LockTime] > @CurrentDateTime -- Soft Lock
                        THEN 0 -- New, Deleted -> SoftLock save result

                    WHEN ([Source_CII].[ChangeState] = 2) -- New
                          --OR [Source_CII].[ChangeState] = 3) -- Deleted
                         AND [Target_CII].[LockTime] <= @CurrentDateTime -- The index is hard locked, but lock time has been expired.
                        THEN 3 -- New, RequireCheck save result
                    WHEN ([Source_CII].[ChangeState] = 3) -- Deleted
                        AND [Source_CII].[ContactId] != [Target_CII].[ContactId]
                        THEN 4 -- Deleted, NotFound
                END AS [SaveResult]
            FROM 
                @ContactIdentifiersIndex AS [Source_CII]
                LEFT JOIN [xdb_collection].[ContactIdentifiersIndex] AS [Target_CII]
                    ON [Target_CII].[IdentifierHash] = DATALENGTH([Source_CII].[Identifier])
                    AND [Source_CII].[Identifier] = [Target_CII].[Identifier]
                    AND [Source_CII].[Source] = [Target_CII].[Source] COLLATE Latin1_General_BIN2
            WHERE
                [Target_CII].[Version] <> @CurrentVersion
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

END
GO
PRINT N'Finish creating [xdb_collection].[SaveContactIdentifiersIndexTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveContactsTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveContactsTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveContactsTvp] 
	@Contacts ContactsTableType READONLY,
	@ContactIdentifiers ContactIdentifiersTableType READONLY,
    @NextConcurrencyToken UNIQUEIDENTIFIER,
    @NextLastModified DATETIME2,
    @LockDateTime DATETIME = NULL -- A moment in time after which a given Contact Identifier Index lock is considered as expired
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        -----------------------------------------------------------------------------
        -- Get the number of expected changes.
        -----------------------------------------------------------------------------

        DECLARE @RecordsChangeCount INT; -- The number of changes for contacts.
        DECLARE @IdentifiersChangeCount INT; -- The number of changes for contact identifiers.
        DECLARE @ExpectedRecordsChangeCount INT; -- The number of expected changes for contacts.
        DECLARE @ExpectedIdentifiersChangeCount INT; -- The number of expected changs for contact identifiers.

        SET @ExpectedRecordsChangeCount =
        (
            SELECT 
                COUNT(*)
            FROM 
                @Contacts
            WHERE
                [ChangeState] <> 0
        );

        SET @ExpectedIdentifiersChangeCount =
        (
            SELECT 
                COUNT(*)
            FROM 
                @Contacts
        );

        ------------------------------------------------------------------------------------
        -- Merge @Contacts table value data into the [Contacts] table.
        ------------------------------------------------------------------------------------
        MERGE INTO [xdb_collection].[Contacts] AS [Target]
        USING 
        (
            SELECT 
                [ContactId],
                [LastModified],
                [ConcurrencyToken],
                [ChangeState],
                [Percentile],
                [ShardKey]
            FROM 
                @Contacts
        ) AS [Source]
        ON 
            [Target].[ContactId] = [Source].[ContactId]

        -- New contact. Record doesn't exists
        WHEN NOT MATCHED 
            AND [Source].[ChangeState] = 2 
        THEN
            INSERT 
            (
                [ContactId], 
                [LastModified],
                [ConcurrencyToken],
                [Percentile],
                [ShardKey]
            ) 
            VALUES 
            (
                [Source].[ContactId],
                @NextLastModified,
                @NextConcurrencyToken,
                [Source].[Percentile],
                [Source].[ShardKey]
            );

        IF(@LockDateTime IS NOT NULL AND @LockDateTime <= GETUTCDATE())
        BEGIN
            ;THROW 50001, 'The lock time has expired.', 1;
        END

        -----------------------------------------------------------------------------
        -- Check the number of newly added records to compare with expected
        -----------------------------------------------------------------------------
        SET @RecordsChangeCount = @@ROWCOUNT; -- Get actuall change count

        ---------------------------------------------------------------------------------------------
        -- Select not found [ContactIdentifiers].
        ----------------------------------------------------------------------------------------------
        SELECT
            [SourceIdentifiers].[ContactId] AS [Id],
            [SourceIdentifiers].[Identifier] AS [Identifier],
            [SourceIdentifiers].[Source] AS [Source],
            2 AS [ErrorType] -- Deleted, Not Found
        FROM [xdb_collection].[ContactIdentifiers] AS [TargetIdentifiers]
        RIGHT JOIN
        (
            SELECT 
                [CI].[ContactId],
                [CI].[Source],
                [CI].[Identifier],
                [CI].[IdentifierType],
                [CI].[ChangeState]
            FROM @ContactIdentifiers AS [CI]
            INNER JOIN @Contacts AS [CS]
                ON [CS].[ContactId] = [CI].[ContactId]
            INNER JOIN [xdb_collection].[Contacts] AS [CT]
                ON [CT].[ContactId] = [CI].[ContactId]
                    AND
                    (
                        (
                            [CS].[ChangeState] = 2 -- New contact
                            AND [CT].[ConcurrencyToken] = @NextConcurrencyToken
                        )
                        OR
                        (
                            [CS].[ChangeState] <> 2 -- Not New contact
                            AND [CT].[ConcurrencyToken] = [CS].[ConcurrencyToken]
                        )
                    )
            WHERE
                [CI].[ChangeState] = 3 -- Delete contact identifier
        ) AS [SourceIdentifiers]
        ON 
            [TargetIdentifiers].[ContactId] = [SourceIdentifiers].[ContactId]
            AND [TargetIdentifiers].[IdentifierHash] = DATALENGTH([SourceIdentifiers].[Identifier])
            AND [TargetIdentifiers].[Identifier] = [SourceIdentifiers].[Identifier]
            AND [TargetIdentifiers].[Source] = [SourceIdentifiers].[Source] COLLATE Latin1_General_BIN2
        WHERE
            [TargetIdentifiers].[ContactId] IS NULL -- Not found
        UNION ALL
        SELECT TOP 0 NULL, NULL, NULL, NULL -- An empty table is returned if there is no not found identifiers

        IF(@LockDateTime IS NOT NULL AND @LockDateTime <= GETUTCDATE())
        BEGIN
            ;THROW 50001, 'The lock time has expired.', 1;
        END

        ---------------------------------------------------------------------------------------------
        -- Merge @ContactIdentifiers table value data into the [ContactIdentifiers] table.
        ----------------------------------------------------------------------------------------------
   
        DECLARE @MergeIdentifiersOutput TABLE
        (
          DeleteContactId UNIQUEIDENTIFIER,
          InsertContactId UNIQUEIDENTIFIER
        );

        MERGE INTO [xdb_collection].[ContactIdentifiers] AS [TargetIdentifiers]
        USING 
        (
            SELECT 
                [CI].[ContactId],
                [CI].[Source],
                [CI].[Identifier],
                [CI].[IdentifierType],
                [CI].[ChangeState],
                [CI].[ShardKey]
            FROM @ContactIdentifiers as [CI]
            INNER JOIN @Contacts as [CS]
                ON [CS].[ContactId] = [CI].[ContactId]
            INNER JOIN [xdb_collection].[Contacts] AS [CT]
                ON [CT].[ContactId] = [CI].[ContactId]
                    AND
                    (
                        (
                            [CS].[ChangeState] = 2 -- New contact
                            AND [CT].[ConcurrencyToken] = @NextConcurrencyToken
                        )
                        OR
                        (
                            [CS].[ChangeState] <> 2 -- Not New contact
                            AND [CT].[ConcurrencyToken] = [CS].[ConcurrencyToken]
                        )
                    )
        ) AS [SourceIdentifiers]
        ON 
            [TargetIdentifiers].[ContactId] = [SourceIdentifiers].[ContactId]
            AND [TargetIdentifiers].[IdentifierHash] = DATALENGTH([SourceIdentifiers].[Identifier])
            AND [TargetIdentifiers].[Identifier] = [SourceIdentifiers].[Identifier]
            AND [TargetIdentifiers].[Source] = [SourceIdentifiers].[Source] COLLATE Latin1_General_BIN2
        
        -- Delete contact identifier
        WHEN MATCHED 
            AND [SourceIdentifiers].[ChangeState] = 3
        THEN
            DELETE

        -- New contact identifier
        WHEN NOT MATCHED 
            AND [SourceIdentifiers].[ChangeState] = 2
        THEN
            INSERT 
            (
                [ContactId],
                [Source],
                [Identifier],
                [IdentifierHash],
                [IdentifierType],
                [ShardKey]
            ) 
            VALUES 
            (
                [SourceIdentifiers].[ContactId], 
                [SourceIdentifiers].[Source],
                [SourceIdentifiers].[Identifier],
                DATALENGTH([SourceIdentifiers].[Identifier]),
                [SourceIdentifiers].[IdentifierType],
                [SourceIdentifiers].[ShardKey]
            )
        OUTPUT INSERTED.[ContactId], DELETED.[ContactId]
        INTO @MergeIdentifiersOutput
        OPTION (LOOP JOIN);

        IF(@LockDateTime IS NOT NULL AND @LockDateTime <= GETUTCDATE())
        BEGIN
            ;THROW 50001, 'The lock time has expired.', 1;
        END

        -----------------------------------------------------------------------------
        -- Check the number of newly added identifiers to compare with expected
        -----------------------------------------------------------------------------
        SET @IdentifiersChangeCount = @@ROWCOUNT; -- Get actuall change count

        UPDATE [xdb_collection].[Contacts]
        SET
            [ConcurrencyToken] = @NextConcurrencyToken,
            [LastModified] = @NextLastModified
        FROM
            @MergeIdentifiersOutput AS [Output]
            INNER JOIN [xdb_collection].[Contacts] AS [CT]
                ON
                [CT].[ContactId] = [Output].[DeleteContactId] OR
                [CT].[ContactId] = [Output].[InsertContactId]

        IF(@LockDateTime IS NOT NULL AND @LockDateTime <= GETUTCDATE())
        BEGIN
            ;THROW 50001, 'The lock time has expired.', 1;
        END

        -----------------------------------------------------------------------------
        -- Check failures
        -----------------------------------------------------------------------------
        -- Compare the actual number of changes with expected
        IF (@RecordsChangeCount <> @ExpectedRecordsChangeCount)
           SELECT 
                [Source].[ContactId] AS [Id],
                CASE
                    WHEN [Source].[ChangeState] = 2 
                        THEN 1 -- New, Already Exists
                END AS [ErrorType]
            FROM 
                @Contacts AS [Source]
                LEFT JOIN [xdb_collection].[Contacts] AS [Target]
                    ON [Source].[ContactId] = [Target].[ContactId]
            WHERE
                [Source].[ChangeState] <> 0
                AND [Target].[ConcurrencyToken] <> @NextConcurrencyToken
                AND [Target].[LastModified] <> @NextLastModified
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

        IF (@IdentifiersChangeCount <> @ExpectedIdentifiersChangeCount)
            SELECT
                [Id],
                [Identifier],
                [Source],
                [ErrorType]
            FROM
            (
                SELECT 
                    [Source].[ContactId] AS [Id],
                    [Source].[Identifier] AS [Identifier],
                    [Source].[Source] AS [Source],
                    CASE
                        WHEN [Source].[ChangeState] <> 0 -- Not Unchanged
                             AND [CS].[ChangeState] <> 2 -- Not New contact
                             AND [CT].[ContactId] IS NOT NULL
                             AND [CT].[ConcurrencyToken] <> @NextConcurrencyToken
                             AND [CT].[ConcurrencyToken] <> [CS].[ConcurrencyToken]
                            THEN 0 -- ChangeConflict
                        WHEN [Source].[ChangeState] = 2
                             AND [Target].[ContactId] IS NULL
                             AND [CT].[ContactId] IS NULL
                            THEN 3 -- New, Reference Not Found
                    END AS [ErrorType]
                FROM 
                    @ContactIdentifiers AS [Source]
                    LEFT JOIN [xdb_collection].[ContactIdentifiers] AS [Target]
                        ON [Source].[ContactId] = [Target].[ContactId]
                            AND [Target].[IdentifierHash] = DATALENGTH([Source].[Identifier])
                            AND [Target].[Identifier] = [Source].[Identifier]
                            AND [Target].[Source] = [Source].[Source] COLLATE Latin1_General_BIN2
                    LEFT JOIN [xdb_collection].[Contacts] AS [CT]
                        ON [CT].[ContactId] = [Source].[ContactId]
                    LEFT JOIN @Contacts as [CS]
                        ON [CS].[ContactId] = [Source].[ContactId] 
                ) AS [Errors]
            WHERE
                [ErrorType] IS NOT NULL -- This ignores any failure that does not match conditions. Such failures (for instance NotFound) are not valuable for the client.
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

        IF(@LockDateTime IS NOT NULL AND @LockDateTime <= GETUTCDATE())
        BEGIN
            ;THROW 50001, 'The lock time has expired.', 1;
        END

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[SaveContactsTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveDeviceProfileFacetsTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveDeviceProfileFacetsTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveDeviceProfileFacetsTvp]
    @DeviceProfileFacets DeviceProfileFacetsTableType READONLY,
    @NextConcurrencyToken UNIQUEIDENTIFIER
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        MERGE INTO [xdb_collection].[DeviceProfileFacets] AS [Target]
        -- Only merge facets where the record exists
        USING 
        (
            SELECT
                [DeviceProfileId],
                [FacetKey],
                [LastModified],
                [ConcurrencyToken],
                [FacetData],
                [ChangeState],
                [ShardKey]
            FROM 
                @DeviceProfileFacets AS [SourceFacets]
            WHERE
                EXISTS
                (
                    SELECT 1 
                    FROM [xdb_collection].[DeviceProfiles] AS [ParentTarget]
                    WHERE [ParentTarget].[DeviceProfileId] = [SourceFacets].[DeviceProfileId]
                )
        )
        AS [Source]
        ON
            [Target].[DeviceProfileId] = [Source].[DeviceProfileId] 
            AND [Target].[FacetKey] = [Source].[FacetKey]

        -- New content is not null. Update
        WHEN MATCHED 
            AND [Source].[ChangeState] = 1
            AND [Target].[ConcurrencyToken] = [Source].[ConcurrencyToken] 
        THEN
            UPDATE SET 
                [LastModified] = [Source].[LastModified], 
                [ConcurrencyToken] = @NextConcurrencyToken,
                [FacetData] = [Source].[FacetData]

        -- The facets is new. Add.
        WHEN NOT MATCHED 
            AND [Source].[ChangeState] = 2 
        THEN
            INSERT
            (
                [DeviceProfileId], 
                [FacetKey], 
                [LastModified], 
                [ConcurrencyToken], 
                [FacetData],
                [ShardKey]
            ) 
            VALUES           
            (
                [Source].[DeviceProfileId], 
                [Source].[FacetKey], 
                [Source].[LastModified], 
                @NextConcurrencyToken,
                [Source].[FacetData],
                [Source].[ShardKey]
            )
        OPTION (LOOP JOIN);

        -- Check failures
        -- Check the number of newly added facets and compare with expected
        DECLARE @ExpectedChangeCount INT;
        DECLARE @ChangeCount INT;

        SET @ChangeCount = @@ROWCOUNT;
        SET @ExpectedChangeCount =
        (
            SELECT
                COUNT(*)
            FROM
                @DeviceProfileFacets
        );
    
        IF (@ChangeCount <> @ExpectedChangeCount)
            SELECT 
                [Source].[DeviceProfileId] AS [Id],
                [Source].[FacetKey] AS [FacetKey],
                CASE
                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[DeviceProfileId] IS NULL 
                        AND [ReferenceTable].[DeviceProfileId] IS NULL
                        THEN 3 -- Update, Reference Not Found

                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[DeviceProfileId] IS NULL 
                        THEN 2 -- Update, Not Found

                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[DeviceProfileId] IS NOT NULL 
                        THEN 0 -- Update, Conflict 

                    WHEN [Source].[ChangeState] = 2 
                        AND [Target].[DeviceProfileId] IS NULL 
                        AND [ReferenceTable].[DeviceProfileId] IS NULL
                        THEN 3 -- New, Reference Not Found

                    WHEN [Source].[ChangeState] = 2 
                        THEN 1 -- New, Already Exists
                END AS [ErrorType]
            FROM 
                @DeviceProfileFacets AS [Source]
                LEFT JOIN [xdb_collection].[DeviceProfileFacets] AS [Target]
                    ON [Source].[DeviceProfileId] = [Target].[DeviceProfileId]
                    AND [Source].[FacetKey] = [Target].[FacetKey]
                LEFT JOIN [xdb_collection].[DeviceProfiles] AS [ReferenceTable] 
                    ON [ReferenceTable].[DeviceProfileId] = [Source].[DeviceProfileId]
            WHERE
                [Target].[DeviceProfileId] IS NULL -- Select just rows that are not exist in [Target] table
                OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
        ELSE
            SELECT TOP 0 NULL -- Return an empty table if the number of affected records is the same as expected

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[SaveDeviceProfileFacetsTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveDeviceProfilesTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveDeviceProfilesTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveDeviceProfilesTvp]
	@DeviceProfiles DeviceProfilesTableType READONLY,
    @NextConcurrencyToken UNIQUEIDENTIFIER
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION
                               
        MERGE INTO [xdb_collection].[DeviceProfiles] AS [Target] 
        USING 
        (
            SELECT 
                [DeviceProfileId], 
                [LastModified], 
                [ConcurrencyToken],
                [LastKnownContactId],
                [ChangeState],
                [ShardKey]
            FROM 
                @DeviceProfiles
        )
        AS [Source]
        ON 
            [Target].[DeviceProfileId] = [Source].[DeviceProfileId]
        
        --Update Device Profile data
        WHEN MATCHED 
            AND [Source].[ChangeState] = 1
            AND [Target].[ConcurrencyToken] = [Source].[ConcurrencyToken] 
        THEN
            UPDATE SET 
                [LastModified] = [Source].[LastModified], 
                [ConcurrencyToken] = @NextConcurrencyToken,
                [LastKnownContactId] = [Source].[LastKnownContactId]

        --New Device Profile
        WHEN NOT MATCHED 
            AND [Source].[ChangeState] = 2 
        THEN
            INSERT 
            (
                [DeviceProfileId], 
                [LastModified], 
                [ConcurrencyToken],
                [LastKnownContactId],
                [ShardKey]
            ) 
            VALUES 
            (
                [Source].[DeviceProfileId], 
                [Source].[LastModified], 
                @NextConcurrencyToken,
                [Source].[LastKnownContactId],
                [Source].[ShardKey]
            );

        -- Check failures
        -- Check the number of newly added records and compare with expected
        DECLARE @ExpectedChangeCount INT;
        DECLARE @ChangeCount INT;

        SET @ChangeCount = @@ROWCOUNT;
        SET @ExpectedChangeCount = 
        (
            SELECT
                COUNT(*)
            FROM 
                @DeviceProfiles
        )
    
        IF (@ChangeCount <> @ExpectedChangeCount)
            SELECT 
                [Source].[DeviceProfileId] AS [Id],
                CASE
                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[DeviceProfileId] IS NULL 
                        THEN 2 -- Update, Not Found

                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[DeviceProfileId] IS NOT NULL 
                        THEN 0 -- Update, Conflict 

                    WHEN [Source].[ChangeState] = 2 
                        THEN 1 -- New, Already Exists

                END AS [ErrorType]
            FROM 
                @DeviceProfiles AS [Source]
                LEFT JOIN [xdb_collection].[DeviceProfiles] AS [Target]
                    ON [Source].[DeviceProfileId] = [Target].[DeviceProfileId]
            WHERE
                [Target].[DeviceProfileId] IS NULL -- Select just rows that are not exist in [Target] table
                OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected   

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[SaveDeviceProfilesTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveInteractionFacetsTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveInteractionFacetsTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveInteractionFacetsTvp]
    @InteractionFacets InteractionFacetsTableType READONLY,
    @NextConcurrencyToken UNIQUEIDENTIFIER
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION
    
        MERGE INTO [xdb_collection].[InteractionFacets] AS [Target]
        -- Only merge facets where the interaction exists
        USING 
        (
            SELECT 
                [InteractionId],
                [FacetKey],
                [ContactId],
                [LastModified],
                [ConcurrencyToken],
                [FacetData],
                [ChangeState],
                [ShardKey]                
            FROM 
                @InteractionFacets AS [SourceFacets] 
            WHERE
                EXISTS 
                (
                    SELECT 1 
                    FROM [xdb_collection].[Interactions] AS [ParentTarget]
                    WHERE [ParentTarget].[InteractionId] = [SourceFacets].[InteractionId]
                )
        )
        AS [Source]
        ON 
            [Target].[InteractionId] = [Source].[InteractionId] 
            AND [Target].[FacetKey] = [Source].[FacetKey]

        -- Changed interaction facet. Fact Data is not null.
        WHEN MATCHED 
            AND [Source].[ChangeState] = 1
            AND [Target].[ConcurrencyToken] = [Source].[ConcurrencyToken] 
        THEN    
            UPDATE SET                
                [LastModified] = [Source].[LastModified],
                [ConcurrencyToken] = @NextConcurrencyToken,
                [FacetData] = [Source].[FacetData]

        -- New interaction facet. Facet data is not null.
        WHEN NOT MATCHED 
            AND [Source].[ChangeState] = 2
        THEN
            INSERT 
            (
                [InteractionId], 
                [FacetKey], 
                [ContactId],
                [LastModified], 
                [ConcurrencyToken],
                [FacetData],
                [ShardKey]                
            ) 
            VALUES 
            (
                [Source].[InteractionId],
                [Source].[FacetKey], 
                [Source].[ContactId],
                [Source].[LastModified], 
                @NextConcurrencyToken,
                [Source].[FacetData],
                [Source].[ShardKey]
            )
        OPTION (LOOP JOIN);
    
        -- Check failures
        -- Check the number of newly added facets and compare with expected
        DECLARE @ExpectedChangeCount INT;
        DECLARE @ChangeCount INT;

        SET @ChangeCount = @@ROWCOUNT;
        SET @ExpectedChangeCount = 
        (
            SELECT
                COUNT(*)
            FROM
                @InteractionFacets
        );
    
        IF (@ChangeCount <> @ExpectedChangeCount)
            SELECT 
                [Source].[InteractionId] AS [Id],
                [Source].[FacetKey] AS [FacetKey],
                CASE
                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[InteractionId] IS NULL 
                        AND [ReferenceTable].[InteractionId] IS NULL
                        THEN 3 -- Update, Reference Not Found

                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[InteractionId] IS NULL 
                        THEN 2 -- Update, Not Found

                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[InteractionId] IS NOT NULL 
                        THEN 0 -- Update, Conflict 

                    WHEN [Source].[ChangeState] = 2 
                        AND [Target].[InteractionId] IS NULL 
                        AND [ReferenceTable].[InteractionId] IS NULL
                        THEN 3 -- New, Reference Not Found

                    WHEN [Source].[ChangeState] = 2 
                        THEN 1 -- New, Already Exists

                END AS [ErrorType]
            FROM 
                @InteractionFacets AS [Source]
                LEFT JOIN [xdb_collection].[InteractionFacets] AS [Target]
                    ON [Source].[InteractionId] = [Target].[InteractionId]
                    AND [Source].[FacetKey] = [Target].[FacetKey]
                    LEFT JOIN [xdb_collection].[Interactions] AS [ReferenceTable]
                    ON [ReferenceTable].[InteractionId] = [Source].[InteractionId]
            WHERE
                [Target].[InteractionId] IS NULL -- Select just rows that are not exist in [Target] table
                OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
        ELSE
            SELECT TOP 0 NULL -- Return an empty table if the number of affected records is the same as expected   

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[SaveInteractionFacetsTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[SaveInteractionsTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveInteractionsTvp]
GO
CREATE PROCEDURE [xdb_collection].[SaveInteractionsTvp] 
    @Interactions InteractionsTableType READONLY,
    @NextConcurrencyToken UNIQUEIDENTIFIER -- The next concurrency token that will be used for new/updated records.
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        MERGE INTO [xdb_collection].[Interactions] AS [Target] 
        USING 
        (
            SELECT 
                [InteractionId], 
                [LastModified], 
                [ConcurrencyToken],
                [ContactId], 
                [StartDateTime], 
                [EndDateTime], 
                [Initiator], 
                [DeviceProfileId],
                [ChannelId], 
                [VenueId],
                [CampaignId],
                [Events],
                [UserAgent],
                [EngagementValue],
                [ChangeState],
                [Percentile],
                [ShardKey]
            FROM 
                @Interactions AS [Source] 
            WHERE
                EXISTS
                (
                    SELECT 1 
                    FROM [xdb_collection].[Contacts] AS [ParentTarget]
                    WHERE [ParentTarget].[ContactId] = [Source].[ContactId]
                )
        )
        AS [Source]
        ON 
            [Target].[InteractionId] = [Source].[InteractionId]
    
        -- New interaction. ID must not exists.
        WHEN NOT MATCHED 
            AND [Source].[ChangeState] = 2 
        THEN
            INSERT 
            (
                [InteractionId], 
                [LastModified], 
                [ConcurrencyToken],
                [ContactId], 
                [StartDateTime], 
                [EndDateTime], 
                [Initiator], 
                [DeviceProfileId],
                [ChannelId], 
                [VenueId],
                [CampaignId],
                [Events],
                [UserAgent],
                [EngagementValue],
                [Percentile],
                [ShardKey]
            ) 
            VALUES 
            (
                [Source].[InteractionId], 
                [Source].[LastModified], 
                @NextConcurrencyToken,
                [Source].[ContactId], 
                [Source].[StartDateTime], 
                [Source].[EndDateTime], 
                [Source].[Initiator], 
                [Source].[DeviceProfileId],
                [Source].[ChannelId],
                [Source].[VenueId],
                [Source].[CampaignId],
                [Source].[Events],
                [Source].[UserAgent],
                [Source].[EngagementValue],
                [Source].[Percentile],
                [Source].[ShardKey]
            )
        OPTION (LOOP JOIN);

        -- Check failures
        -- Check the number of newly added records and compare with expected
        DECLARE @ExpectedChangeCount INT;
        DECLARE @ChangeCount INT;

        SET @ChangeCount = @@ROWCOUNT;
        SET @ExpectedChangeCount =
        (
            SELECT
                COUNT(*)
            FROM
                @Interactions
        );
    
        IF (@ChangeCount <> @ExpectedChangeCount)
            SELECT 
                [Source].[InteractionId] AS [Id],
                CASE
                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[InteractionId] IS NULL 
                        THEN 2 -- Update, Not Found

                    WHEN [Source].[ChangeState] = 1 
                        AND [Target].[InteractionId] IS NOT NULL 
                        THEN 0 -- Update, Conflict 

                        WHEN [Source].[ChangeState] = 2
                        AND [Target].[InteractionId] IS NULL 
                        AND NOT EXISTS(SELECT 1 
                                    FROM [xdb_collection].[Contacts] AS [ReferenceTable]
                                    WHERE [ReferenceTable].[ContactId] = [Source].[ContactId])
                        THEN 3 -- New, Reference Not Found

                    WHEN [Source].[ChangeState] = 2 
                        THEN 1 -- New, Already Exists

                END AS [ErrorType]
            FROM 
                @Interactions AS [Source]
                LEFT JOIN [xdb_collection].[Interactions] AS [Target]
                    ON [Source].[InteractionId] = [Target].[InteractionId]
            WHERE
                [Target].[InteractionId] IS NULL -- Select just rows that are not exist in [Target] table
                OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected   
 
        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish creating [xdb_collection].[SaveInteractionsTvp] stored procedure...';

GO
PRINT N'Creating [xdb_collection].[UnlockContactIdentifiersIndexTvp] stored procedure...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[UnlockContactIdentifiersIndexTvp]
GO
CREATE PROCEDURE [xdb_collection].[UnlockContactIdentifiersIndexTvp]
	@UnlockContactIdentifiersIndex UnlockContactIdentifiersIndexTableType READONLY
    -- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        UPDATE [ContactIdentifiersIndex]
        SET
            [LockTime] = NULL -- LockTime == NULL means the contact identifier is inserted correctly before the lock time has expired.
        FROM
            [xdb_collection].[ContactIdentifiersIndex] AS [CII]
            INNER JOIN @UnlockContactIdentifiersIndex AS [TVP]
                ON
                    DATALENGTH([TVP].[Identifier]) = [CII].[IdentifierHash]
                    AND [TVP].[Identifier] = [CII].[Identifier]
                    AND [TVP].[Source] = [CII].[Source] COLLATE Latin1_General_BIN2

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

END
GO
PRINT N'Finish creating [xdb_collection].[UnlockContactIdentifiersIndexTvp] stored procedure...';