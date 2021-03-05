GO
PRINT N'Creating new table [xdb_collection].[UnlockContactIdentifiersIndex_Staging]...';

GO
IF NOT EXISTS (
  SELECT [name]
  FROM sys.tables 
  WHERE [name] = 'UnlockContactIdentifiersIndex_Staging'
)
BEGIN
	CREATE TABLE [xdb_collection].[UnlockContactIdentifiersIndex_Staging]
	(
		[Identifier] VARBINARY(700) NOT NULL,
		[Source] VARCHAR(50) COLLATE Latin1_General_BIN2 NOT NULL,
		[BatchId] UNIQUEIDENTIFIER NOT NULL
	)
END

GO
PRINT N'Create index [IX_UnlockContactIdentifiersIndex_Staging] for table [xdb_collection].[UnlockContactIdentifiersIndex_Staging]...';

GO
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_UnlockContactIdentifiersIndex_Staging' 
    AND object_id = OBJECT_ID('[xdb_collection].[UnlockContactIdentifiersIndex_Staging]'))
BEGIN
	CREATE CLUSTERED INDEX [IX_UnlockContactIdentifiersIndex_Staging]
	ON [xdb_collection].[UnlockContactIdentifiersIndex_Staging]
	(
		[BatchId] ASC
	)
END

GO
PRINT N'Finish creating new table [xdb_collection].[UnlockContactIdentifiersIndex_Staging]...';

GO
PRINT N'Start altering [xdb_collection].[Contacts]...';

GO
PRINT N'Add [Percentile] column for [xdb_collection].[Contacts] table...';

GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Contacts]') 
         AND name = 'Percentile'
)
BEGIN
	ALTER TABLE [xdb_collection].[Contacts]
	ADD [Percentile] FLOAT NOT NULL
	CONSTRAINT [ContactsPercentileDefault]
	DEFAULT -1
END

GO
PRINT N'Alter index [IX_Contacts_Created_ContactId] for [xdb_collection].[Contacts]...'

GO
DROP INDEX IF EXISTS [xdb_collection].[Contacts].[IX_Contacts_Created_ContactId]

GO
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Contacts_Created_ContactId' 
    AND object_id = OBJECT_ID('[xdb_collection].[Contacts]'))
BEGIN
	CREATE INDEX [IX_Contacts_Created_ContactId] ON [xdb_collection].[Contacts] 
	(
		[Created] ASC,
		[ContactId] ASC,
		[Percentile] ASC
	)
END


GO
PRINT N'Finish altering [xdb_collection].[Contacts]...';

GO
PRINT N'Start altering [xdb_collection].[Contacts_Staging]...';

GO
PRINT N'Add [Percentile] column for [xdb_collection][Contacts_Staging] table...';

GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Contacts_Staging]') 
         AND name = 'Percentile'
)
BEGIN
	ALTER TABLE [xdb_collection].[Contacts_Staging]
	ADD [Percentile] FLOAT NOT NULL
	CONSTRAINT [ContactsStagingPercentileDefault]
	DEFAULT -1
END

GO
PRINT N'Finish altering [xdb_collection].[Contacts_Staging]...';

GO
PRINT N'Start altering [xdb_collection].[Interactions]...';

GO
PRINT N'Add [Percentile] column for [xdb_collection].[Interactions] table...';

GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Interactions]') 
         AND name = 'Percentile'
)
BEGIN
	ALTER TABLE [xdb_collection].[Interactions]
	ADD [Percentile] FLOAT NOT NULL
	CONSTRAINT [InteractionsPercentileDefault]
	DEFAULT -1
END

GO
PRINT N'Alter index [IX_Interactions_StartDateTime_Created_InteractionId] for [xdb_collection].[Interactions]...'

GO
DROP INDEX IF EXISTS [xdb_collection].[Interactions].[IX_Interactions_StartDateTime_Created_InteractionId]

GO
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Interactions_StartDateTime_Created_InteractionId' 
    AND object_id = OBJECT_ID('[xdb_collection].[Interactions]'))
BEGIN
	CREATE INDEX [IX_Interactions_StartDateTime_Created_InteractionId] ON [xdb_collection].[Interactions] 
	(
		[StartDateTime] ASC,
		[Created] ASC,
		[InteractionId] ASC,
		[Percentile] ASC
	)
	INCLUDE
	(
		[LastModified]
	)
END

GO
PRINT N'Finish altering [xdb_collection].[Interactions]...';

GO
PRINT N'Start altering [xdb_collection].[Interactions_Staging]...';

GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Interactions_Staging]') 
         AND name = 'Percentile'
)
BEGIN
	ALTER TABLE [xdb_collection].Interactions_Staging
	ADD [Percentile] FLOAT NOT NULL
	CONSTRAINT [InteractionsStagingPercentileDefault]
	DEFAULT -1
END

GO
PRINT N'Finish altering [xdb_collection].[Interactions_Staging]...';

GO
PRINT N'Start altering [xdb_collection].[ContactIdentifiersIndex]...';

GO
PRINT N'Alter [LockTime] column for [xdb_collection].[ContactIdentifiersIndex] table, set it nullable...';

GO
ALTER TABLE [xdb_collection].[ContactIdentifiersIndex]
ALTER COLUMN [LockTime] DATETIME NULL;

GO
PRINT N'Finish altering [xdb_collection].[ContactIdentifiersIndex]...';

GO
PRINT N'Start altering [xdb_collection].[ContactIdentifiers_Staging]...';

GO
PRINT N'Drop index [ContactIdentifiers_Staging].[IX_ContactIdentifiers_Staging]';

GO
DROP INDEX IF EXISTS [IX_ContactIdentifiers_Staging] ON [xdb_collection].[ContactIdentifiers_Staging]

GO
PRINT N'Create index [ContactIdentifiers_Staging].[IX_ContactIdentifiers_Staging_BatchId_ChangeState]';

GO
IF NOT EXISTS (
	SELECT * 
	FROM sys.indexes  
	WHERE name='IX_ContactIdentifiers_Staging_BatchId_ChangeState' 
		AND object_id = OBJECT_ID('[xdb_collection].[ContactIdentifiers_Staging]'))
BEGIN
	CREATE CLUSTERED INDEX [IX_ContactIdentifiers_Staging_BatchId_ChangeState]
	ON [xdb_collection].[ContactIdentifiers_Staging]
	(
		[BatchId] ASC,
		[ChangeState] ASC
	)
END

GO
PRINT N'Finish altering [xdb_collection].[ContactIdentifiers_Staging]...';


GO

PRINT N'Altering [xdb_collection].[ContactFacets]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactFacets]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[ContactFacets]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[ContactFacets_Staging]...';
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactFacets_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[ContactFacets_Staging]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[ContactIdentifiers]...';
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiers]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[ContactIdentifiers]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[ContactIdentifiers_Staging]...';
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiers_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[ContactIdentifiers_Staging]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[ContactIdentifiersIndex]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiersIndex]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[ContactIdentifiersIndex]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[ContactIdentifiersIndex_Staging]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiersIndex_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[ContactIdentifiersIndex_Staging]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[Contacts]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Contacts]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[Contacts]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[Contacts_Staging]...';
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Contacts_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[Contacts_Staging]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[DeviceProfileFacets]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfileFacets]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[DeviceProfileFacets]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[DeviceProfileFacets_Staging]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfileFacets_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[DeviceProfileFacets_Staging]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[DeviceProfiles]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfiles]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[DeviceProfiles]
    ADD [ShardKey] BINARY (1) ;
GO
PRINT N'Altering [xdb_collection].[DeviceProfiles_Staging]...';
GO

IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfiles_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[DeviceProfiles_Staging]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[InteractionFacets]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[InteractionFacets]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[InteractionFacets]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[InteractionFacets_Staging]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[InteractionFacets_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[InteractionFacets_Staging]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[Interactions]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Interactions]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[Interactions]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[Interactions_Staging]...';
GO
IF NOT EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Interactions_Staging]') 
         AND name = 'ShardKey'
)
ALTER TABLE [xdb_collection].[Interactions_Staging]
    ADD [ShardKey] BINARY (1) ;
GO

PRINT N'Altering [xdb_collection].[SaveContactFacets]...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveContactFacets]
GO

CREATE PROCEDURE [xdb_collection].[SaveContactFacets]
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[ContactFacets_Staging] AS [SourceFacets] 
            WHERE
                [BatchId] = @BatchId -- Filter staging table records by the batch identifier.
                AND EXISTS 
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
                [xdb_collection].[ContactFacets_Staging]
            WHERE
                [BatchId] = @BatchId
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
                    [xdb_collection].[ContactFacets_Staging] AS [Source]
                    LEFT JOIN [xdb_collection].[ContactFacets] AS [Target]
                        ON [Source].[ContactId] = [Target].[ContactId]
                        AND [Source].[FacetKey] = [Target].[FacetKey]
                    LEFT JOIN [xdb_collection].[Contacts] AS [ReferenceTable]
                        ON [ReferenceTable].[ContactId] = [Source].[ContactId]
                    LEFT JOIN @MergeContactFacetsOutput AS [DeletedContactFacets]
                        ON [Source].[ContactId] = [DeletedContactFacets].[DeleteContactId]
                        AND [Source].[FacetKey] = [DeletedContactFacets].[DeleteFacetKey]
                WHERE
                    [Source].[BatchId] = @BatchId
            ) AS [Errors]
            WHERE [ErrorType] IS NOT NULL
        ELSE
            SELECT TOP 0 NULL -- Return an empty table if the number of affected records is the same as expected    

        DELETE
        FROM 
            [xdb_collection].[ContactFacets_Staging]
        WHERE
            [BatchId] = @BatchId;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish altering [xdb_collection].[SaveContactFacets] stored procedure...';
GO

PRINT N'Start altering [xdb_collection].[GetContactsByRange] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactsByRange]

GO
CREATE PROCEDURE [xdb_collection].[GetContactsByRange]
    @BatchSize INT,
    @LastRetrievedCreated DATETIME2,            -- The up batch bound: The last retrieved [Created] - exclusive, NULL when first read
    @LastRetrievedContactId UNIQUEIDENTIFIER,   -- The up batch bound: The last retrieved [ContactId] - exclusive, NULL when first read
    @UpBoundCreated DATETIME2,                  -- The up range bound - inclusive, the upper [Created]
    @UpBoundContactId UNIQUEIDENTIFIER,         -- The up range bound - inclusive, the upper [ContactId]
    @LowBoundCreated DATETIME2,                 -- The low range bound - inclusive, the low [Created]
    @LowBoundContactId UNIQUEIDENTIFIER,        -- The low range bound - inclusive, the low [ContactId]
    @StartPercentile FLOAT = NULL,              -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL,                -- The end percentile exclusive bound
    @FacetKeys NVARCHAR(MAX)
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION;

    WITH TopContacts_CTE
    (
        [ContactId],
        [LastModified],
        [Created],
        [ConcurrencyToken]
    )
    AS
    (
        SELECT TOP(@BatchSize)
            [ContactId],
            [LastModified],
            [Created],
            [ConcurrencyToken]
        FROM 
            [xdb_collection].[Contacts] AS [Source]
        WHERE
            ( 
                (
                    @LastRetrievedContactId IS NULL -- NULL, when very first read
                    AND 
                    (
                        [Source].[Created] < @UpBoundCreated
                        OR
                        (
                            [Source].[Created] = @UpBoundCreated
                            AND [Source].[ContactId] <= @UpBoundContactId
                        )
                    )
                )
                OR
                (
                    [Source].[Created] < @LastRetrievedCreated
                    OR
                    (
                        [Source].[Created] = @LastRetrievedCreated
                        AND [Source].[ContactId] < @LastRetrievedContactId
                    )
                )
            )
            AND
            (
                [Source].[Created] > @LowBoundCreated
                OR
                (
                    [Source].[Created] = @LowBoundCreated
                    AND [Source].[ContactId] >= @LowBoundContactId
                )
            )
            AND
            (
                @StartPercentile IS NULL
                OR 
                (
                    @EndPercentile IS NULL
                )
                OR
                (
                    [Percentile] >= @StartPercentile 
                    AND [Percentile] < @EndPercentile
                )
            )
        ORDER BY
            [Source].[Created] DESC,
            [Source].[ContactId] DESC
    )
    SELECT
        [Source].[ContactId] AS [Id],
        [Source].[LastModified],
        [Source].[Created],
        [Source].[ConcurrencyToken],
        [Identifiers].[Identifier],
        [Identifiers].[IdentifierType],
        [Identifiers].[Source],
        [Facets].[FacetKey],
        [Facets].[LastModified] AS [FacetLastModified],
        [Facets].[ConcurrencyToken] AS [FacetConcurrencyToken],
        [Facets].[FacetData]
    FROM 
        TopContacts_CTE AS [Source]
        LEFT JOIN [xdb_collection].[ContactFacets] AS [Facets]
            ON [Source].[ContactId] = [Facets].[ContactId]
            AND [Facets].[FacetKey] IN (SELECT value FROM STRING_SPLIT(@FacetKeys, ','))
        LEFT JOIN [xdb_collection].[ContactIdentifiers] AS [Identifiers]
            ON [Source].[ContactId] = [Identifiers].[ContactId]
    ORDER BY
        [Source].[Created] DESC,
        [Source].[ContactId] DESC

    COMMIT TRANSACTION
END

GO
PRINT N'Finish altering [GetContactsByRange] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetRangeContactsCount] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetRangeContactsCount]

GO
CREATE PROCEDURE [xdb_collection].[GetRangeContactsCount]
    @LowBoundCreated DATETIME2,                 -- The low range bound - inclusive, the low [Created]
    @LowBoundContactId UNIQUEIDENTIFIER,        -- The low range bound - inclusive, the low [ContactId]
    @UpBoundCreated DATETIME2,                  -- The up range bound - inclusive, the upper [Created]
    @UpBoundContactId UNIQUEIDENTIFIER,         -- The up range bound - inclusive, the upper [ContactId]
    @StartPercentile FLOAT = NULL,          -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL,            -- The end percentile exclusive bound
    @EstimatedRecordsCount BIGINT OUTPUT,
    @LastRetrievedCreated DATETIME2 = NULL,                -- [OPTIONAL] The up batch bound: The last retrieved [Created] - exclusive, NULL when first read
    @LastRetrievedContactId UNIQUEIDENTIFIER = NULL       -- [OPTIONAL] The up batch bound: The last retrieved [ContactId] - exclusive, NULL when first read
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    SELECT
        @EstimatedRecordsCount = COUNT_BIG(*)
    FROM 
        [xdb_collection].[Contacts]
    WHERE
    (
        (
            @LastRetrievedContactId IS NULL -- NULL, when very first read
            AND 
            (
                [Created] < @UpBoundCreated
                OR
                (
                    [Created] = @UpBoundCreated
                    AND [ContactId] <= @UpBoundContactId
                )
            )
        )
        OR
        (
            [Created] < @LastRetrievedCreated
            OR
            (
                [Created] = @LastRetrievedCreated
                AND [ContactId] < @LastRetrievedContactId
            )
        )
    )
    AND
    (
        [Created] > @LowBoundCreated
        OR
        (
            [Created] = @LowBoundCreated
            AND [ContactId] >= @LowBoundContactId
        )
    )
    AND
    (
        @StartPercentile IS NULL
        OR 
        (
            @EndPercentile IS NULL
        )
        OR
        (
            [Percentile] >= @StartPercentile 
            AND [Percentile] < @EndPercentile
        )
    )
    COMMIT TRANSACTION

RETURN
END

GO
PRINT N'Finish altering [xdb_collection].[GetRangeContactsCount] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetRangeInteractionsCount] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetRangeInteractionsCount]

GO
CREATE PROCEDURE [xdb_collection].[GetRangeInteractionsCount]
    @CutOffDateTime DATETIME2,
    @LowBoundStartDateTime DATETIME2,               -- The low range bound - inclusive, the low [StartDateTime]
    @LowBoundCreated DATETIME2,                     -- The low range bound - inclusive, the low [Created]
    @LowBoundInteractionId UNIQUEIDENTIFIER,        -- The low range bound - inclusive, the low [InteractionId]
    @UpBoundStartDateTime DATETIME2,                -- The up range bound - inclusive, the upper [StartDateTime]
    @UpBoundCreated DATETIME2,                      -- The up range bound - inclusive, the upper [Created]
    @UpBoundInteractionId UNIQUEIDENTIFIER,         -- The up range bound - inclusive, the upper [InteractionId]
    @StartPercentile FLOAT = NULL,                  -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL,                    -- The end percentile exclusive bound
    @EstimatedRecordsCount BIGINT OUTPUT,
    @LastRetrievedStartDateTime DATETIME2 = NULL,          -- [OPTIONAL] The up batch bound: The last retrieved [StartDateTime] - exclusive, NULL when first read
    @LastRetrievedCreated DATETIME2 = NULL,                -- [OPTIONAL] The up batch bound: The last retrieved [Created] - exclusive, NULL when first read
    @LastRetrievedInteractionId UNIQUEIDENTIFIER = NULL    -- [OPTIONAL] The up batch bound: The last retrieved [InteractionId] - exclusive, NULL when first read
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    SELECT
        @EstimatedRecordsCount = COUNT_BIG(*)
    FROM 
        [xdb_collection].[Interactions]
    WHERE
        (
            [StartDateTime] > @LowBoundStartDateTime 
            OR
            (
                [StartDateTime] = @LowBoundStartDateTime
                AND [Created] > @LowBoundCreated
            )
            OR
            (
                [StartDateTime] = @LowBoundStartDateTime
                AND [Created] = @LowBoundCreated
                AND [InteractionId] >= @LowBoundInteractionId
            )
        )
        AND
        (
            (
                @LastRetrievedStartDateTime IS NULL
                AND 
                ( 
                    [StartDateTime] < @UpBoundStartDateTime 
                    OR
                    (
                        [StartDateTime] = @UpBoundStartDateTime
                        AND [Created] < @UpBoundCreated
                    )
                    OR
                    (
                        [StartDateTime] = @UpBoundStartDateTime
                        AND [Created] = @UpBoundCreated
                        AND [InteractionId] <= @UpBoundInteractionId
                    )
                )
            )
            OR
            (
                [StartDateTime] < @LastRetrievedStartDateTime 
                OR
                (
                    [StartDateTime] = @LastRetrievedStartDateTime
                    AND [Created] < @LastRetrievedCreated
                )
                OR
                (
                    [StartDateTime] = @LastRetrievedStartDateTime
                    AND [Created] = @LastRetrievedCreated
                    AND [InteractionId] < @LastRetrievedInteractionId
                )
            )
        )
        AND
        (
            [LastModified] < @CutOffDateTime
        )
        AND
        (
            @StartPercentile IS NULL
            OR 
            (
                @EndPercentile IS NULL
            )
            OR
            (
                [xdb_collection].[Interactions].[Percentile] >= @StartPercentile 
                AND [xdb_collection].[Interactions].[Percentile] < @EndPercentile
            )
        )

    COMMIT TRANSACTION

RETURN
END

GO
PRINT N'Finish altering [xdb_collection].[GetRangeInteractionsCount] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetContactsSplitBounds] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactsSplitBounds]

GO
CREATE PROCEDURE [xdb_collection].[GetContactsSplitBounds]
    @LastRetrievedCreated DATETIME2,            -- The up batch bound: The last retrieved [Created] - exclusive, NULL when first read
    @LastRetrievedContactId UNIQUEIDENTIFIER,   -- The up batch bound: The last retrieved [ContactId] - exclusive, NULL when first read
    @UpBoundCreated DATETIME2,                  -- The up range bound - inclusive, the upper [Created]
    @UpBoundContactId UNIQUEIDENTIFIER,         -- The up range bound - inclusive, the upper [ContactId]
    @LowBoundCreated DATETIME2,                 -- The low range bound - inclusive, the low [Created]
    @LowBoundContactId UNIQUEIDENTIFIER,        -- The low range bound - inclusive, the low [ContactId]
    @StartPercentile FLOAT = NULL,              -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL,                -- The end percentile exclusive bound
    @PreferredCount INT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF (@UpBoundCreated IS NULL OR @UpBoundContactId IS NULL)
    BEGIN
        RAISERROR('@UpBoundCreated and @UpBoundContactId cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    IF (@LowBoundCreated IS NULL OR @LowBoundContactId IS NULL)
    BEGIN
        RAISERROR('@LowBoundCreated and @LowBoundContactId cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION;

     DECLARE @EstimatedRecordsCount BIGINT;

    DECLARE @SplitBoundsTable TABLE
        (
            [Created] DATETIME2 NOT NULL,
            [ContactId] UNIQUEIDENTIFIER NOT NULL,
            [RowNumber] INT NOT NULL
        );

    WITH TopContacts_CTE
    (
        [Created],
        [ContactId],
        [RowNumber]
    )
    AS
    (
        SELECT TOP (@PreferredCount + 1)
            [Created],
            [ContactId],
            ROW_NUMBER() OVER
                (
                    ORDER BY
                        [Source].[Created] DESC,
                        [Source].[ContactId] DESC
                ) as [RowNumber]
        FROM 
            [xdb_collection].[Contacts] AS [Source]
        WHERE
            ( 
                (
                    @LastRetrievedContactId IS NULL -- NULL, when very first read
                    AND 
                    (
                        [Source].[Created] < @UpBoundCreated
                        OR
                        (
                            [Source].[Created] = @UpBoundCreated
                            AND [Source].[ContactId] <= @UpBoundContactId
                        )
                    )
                )
                OR
                (
                    [Source].[Created] < @LastRetrievedCreated
                    OR
                    (
                        [Source].[Created] = @LastRetrievedCreated
                        AND [Source].[ContactId] < @LastRetrievedContactId
                    )
                )
            )
            AND
            (
                [Source].[Created] > @LowBoundCreated
                OR
                (
                    [Source].[Created] = @LowBoundCreated
                    AND [Source].[ContactId] >= @LowBoundContactId
                )
            )
            AND
            (
               @StartPercentile IS NULL
               OR 
               (
                   @EndPercentile IS NULL
               )
               OR
               (
                   [Percentile] >= @StartPercentile 
                   AND [Percentile] < @EndPercentile
               )
            )
        ORDER BY
            [Source].[Created] DESC,
            [Source].[ContactId] DESC
    )

    -- Select split boundaries and insert into the temp table
    INSERT INTO @SplitBoundsTable
    SELECT
        [С].[Created] AS [Created],
        [С].[ContactId] AS [ContactId],
        [С].[RowNumber] AS [RowNumber]
    FROM TopContacts_CTE AS [С]
    WHERE
        [RowNumber] >= @PreferredCount
        AND [RowNumber] <= @PreferredCount + 1

    -- @@ROWCOUNT Returns the number of rows affected by the last statement
    -- If number of rows equal two, it means that the split is possible and
    -- it is required to calculate estimated record count for remaining cursor.
    IF (@@ROWCOUNT = 2)
    BEGIN
        DECLARE @RemainingCursorUpBoundCreated DATETIME2;
        DECLARE @RemainingCursorUpBoundContactId UNIQUEIDENTIFIER;

        -- Get the estimated count for remaining cursor, we can get the specific [StartDateTime] based
        -- on the @PreferredCount + 1 value.
        SELECT 
            @RemainingCursorUpBoundCreated = [Created],
            @RemainingCursorUpBoundContactId = [ContactId]
        FROM
            @SplitBoundsTable
        WHERE
            [RowNumber] = @PreferredCount + 1

        EXEC [xdb_collection].[GetRangeContactsCount]
            @LowBoundCreated,                       -- >=, Created low boundary, for the cursor that was split.
            @LowBoundContactId,                     -- >=, InteractionId low boundary, for the cursor that was split.
            @RemainingCursorUpBoundCreated,         -- <=, Created up boundary, for the remaining cursor, it was calculated based on preffered count.
            @RemainingCursorUpBoundContactId,       -- <=, InteractionId up boundary, for the remaining cursor, it was calculated based on preffered count.
            @StartPercentile,
            @EndPercentile,
            @EstimatedRecordsCount OUTPUT
    END
    ELSE
        -- Get the estimated count for the overal cursor, the cursor wasn't split,
        -- most probably there are not enough records for split.
        EXEC [xdb_collection].[GetRangeContactsCount]
            @LowBoundCreated,       -- >=, initial Created low boundary for the cursor that wasn't split.
            @LowBoundContactId,     -- >=, initial InteractionId low boundary for the cursor that wasn't split.
            @UpBoundCreated,        -- <=, initial Created up boundary for the cursor that wasn't split.
            @UpBoundContactId,      -- <=, initial InteractionId up boundary for the cursor that wasn't split.
            @StartPercentile,
            @EndPercentile,
            @EstimatedRecordsCount OUTPUT

    SELECT
        [Created],
        [ContactId]
    FROM
        @SplitBoundsTable

    SELECT @EstimatedRecordsCount AS [EstimatedRecordsCount];

    COMMIT TRANSACTION
END

GO
PRINT N'Finish altering [xdb_collection].[GetContactsSplitBounds] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetInteractionsByRange] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetInteractionsByRange]

GO
CREATE PROCEDURE [xdb_collection].[GetInteractionsByRange]
    @BatchSize INT,
    @LastRetrievedStartDateTime DATETIME2,          -- The up batch bound: The last retrieved [StartDateTime] - exclusive, NULL when first read
    @LastRetrievedCreated DATETIME2,                -- The up batch bound: The last retrieved [Created] - exclusive, NULL when first read
    @LastRetrievedInteractionId UNIQUEIDENTIFIER,   -- The up batch bound: The last retrieved [InteractionId] - exclusive, NULL when first read
    @UpBoundStartDateTime DATETIME2,                -- The up range bound - inclusive, the upper [StartDateTime]
    @UpBoundCreated DATETIME2,                      -- The up range bound - inclusive, the upper [Created]
    @UpBoundInteractionId UNIQUEIDENTIFIER,         -- The up range bound - inclusive, the upper [InteractionId]
    @LowBoundStartDateTime DATETIME2,               -- The low range bound - inclusive, the low [StartDateTime]
    @LowBoundCreated DATETIME2,                     -- The low range bound - inclusive, the low [Created]
    @LowBoundInteractionId UNIQUEIDENTIFIER,        -- The low range bound - inclusive, the low [InteractionId]
    @CutOffDateTime DATETIME2,
    @StartPercentile FLOAT = NULL,              -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL,                -- The end percentile exclusive bound
    @FacetKeys NVARCHAR(MAX)
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF (@UpBoundInteractionId IS NULL OR @UpBoundStartDateTime IS NULL OR @UpBoundCreated IS NULL)
    BEGIN
        RAISERROR('@UpBoundInteractionId and @UpBoundStartDateTime and @UpBoundCreated cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    IF (@LowBoundInteractionId IS NULL OR @LowBoundStartDateTime IS NULL OR @LowBoundCreated IS NULL)
    BEGIN
        RAISERROR('@LowBoundInteractionId and @LowBoundStartDateTime and @LowBoundCreated cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    IF (@LastRetrievedInteractionId IS NULL AND @LastRetrievedStartDateTime IS NOT NULL AND @LastRetrievedCreated IS NOT NULL) OR
       (@LastRetrievedInteractionId IS NOT NULL AND @LastRetrievedStartDateTime IS NULL AND @LastRetrievedCreated IS NULL)
    BEGIN
        RAISERROR('@LastRetrievedInteractionId, @LastRetrievedStartDateTime and @LastRetrievedCreated must be either all NULL or all NOT NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION;

    WITH TopInteractions_CTE
    (
        [InteractionId],
        [LastModified],
        [Created],
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
        [EngagementValue]
    )
    AS
    (
        SELECT TOP(@BatchSize)
            [InteractionId],
            [LastModified],
            [Created],
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
            [EngagementValue]
        FROM 
            [xdb_collection].[Interactions] AS [Source]
        WHERE
            (
                (
                    @LastRetrievedStartDateTime IS NULL -- NULL, when very first read
                    AND 
                    ( 
                        [Source].[StartDateTime] < @UpBoundStartDateTime 
                        OR
                        (
                            [Source].[StartDateTime] = @UpBoundStartDateTime
                            AND [Source].[Created] < @UpBoundCreated
                        )
                        OR
                        (
                            [Source].[StartDateTime] = @UpBoundStartDateTime
                            AND [Source].[Created] = @UpBoundCreated
                            AND [Source].[InteractionId] <= @UpBoundInteractionId
                        )
                    )
                )
                OR
                (
                    [Source].[StartDateTime] < @LastRetrievedStartDateTime 
                    OR
                    (
                        [Source].[StartDateTime] = @LastRetrievedStartDateTime
                        AND [Source].[Created] < @LastRetrievedCreated
                    )
                    OR
                    (
                        [Source].[StartDateTime] = @LastRetrievedStartDateTime
                        AND [Source].[Created] = @LastRetrievedCreated
                        AND [Source].[InteractionId] < @LastRetrievedInteractionId
                    )
                )
            )
            AND
            (
                [Source].[StartDateTime] > @LowBoundStartDateTime 
                OR
                (
                    [Source].[StartDateTime] = @LowBoundStartDateTime
                    AND [Source].[Created] > @LowBoundCreated
                )
                OR
                (
                    [Source].[StartDateTime] = @LowBoundStartDateTime
                    AND [Source].[Created] = @LowBoundCreated
                    AND [Source].[InteractionId] >= @LowBoundInteractionId
                )
            )
            AND
            (
                [Source].[LastModified] < @CutOffDateTime
            )
            AND
            (
               @StartPercentile IS NULL
               OR 
               (
                   @EndPercentile IS NULL
               )
               OR
               (
                   [Percentile] >= @StartPercentile 
                   AND [Percentile] < @EndPercentile
               )
            )
        ORDER BY
            [Source].[StartDateTime] DESC,
            [Source].[Created] DESC,
            [Source].[InteractionId] DESC
    )

    SELECT
        [Source].[InteractionId] AS [Id],
        [Source].[LastModified],
        [Source].[Created],
        [Source].[ConcurrencyToken],
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
        [Facets].[FacetKey],
        [Facets].[LastModified] AS [FacetLastModified],
        [Facets].[ConcurrencyToken] AS [FacetConcurrencyToken],
        [Facets].[FacetData]
    FROM 
        TopInteractions_CTE AS [Source]
        LEFT JOIN [xdb_collection].[InteractionFacets] AS [Facets]
            ON [Source].[InteractionId] = [Facets].[InteractionId]
                AND [Facets].[FacetKey] IN (SELECT value FROM STRING_SPLIT(@FacetKeys, ','))
    ORDER BY
        [Source].[StartDateTime] DESC,
        [Source].[Created] DESC,
        [Source].[InteractionId] DESC

    COMMIT TRANSACTION
END

GO
PRINT N'Finish altering [xdb_collection].[GetInteractionsByRange] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetInteractionsSplitBounds] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetInteractionsSplitBounds]

GO
CREATE PROCEDURE [xdb_collection].[GetInteractionsSplitBounds]
    @LastRetrievedStartDateTime DATETIME2,          -- The up batch bound: The last retrieved [StartDateTime] - exclusive, NULL when first read
    @LastRetrievedCreated DATETIME2,                -- The up batch bound: The last retrieved [Created] - exclusive, NULL when first read
    @LastRetrievedInteractionId UNIQUEIDENTIFIER,   -- The up batch bound: The last retrieved [InteractionId] - exclusive, NULL when first read
    @UpBoundStartDateTime DATETIME2,                -- The up range bound - inclusive, the upper [StartDateTime]
    @UpBoundCreated DATETIME2,                      -- The up range bound - inclusive, the upper [Created]
    @UpBoundInteractionId UNIQUEIDENTIFIER,         -- The up range bound - inclusive, the upper [InteractionId]
    @LowBoundStartDateTime DATETIME2,               -- The low range bound - inclusive, the low [StartDateTime]
    @LowBoundCreated DATETIME2,                     -- The low range bound - inclusive, the low [Created]
    @LowBoundInteractionId UNIQUEIDENTIFIER,        -- The low range bound - inclusive, the low [InteractionId]
    @CutOffDateTime DATETIME2,
    @StartPercentile FLOAT = NULL,              -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL,                -- The end percentile exclusive bound
    @PreferredCount INT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF (@UpBoundInteractionId IS NULL OR @UpBoundStartDateTime IS NULL OR @UpBoundCreated IS NULL)
    BEGIN
        RAISERROR('@UpBoundInteractionId and @UpBoundStartDateTime and @UpBoundCreated cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    IF (@LowBoundInteractionId IS NULL OR @LowBoundStartDateTime IS NULL OR @LowBoundCreated IS NULL)
    BEGIN
        RAISERROR('@LowBoundInteractionId and @LowBoundStartDateTime and @LowBoundCreated cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    IF (@LastRetrievedInteractionId IS NULL AND @LastRetrievedStartDateTime IS NOT NULL AND @LastRetrievedCreated IS NOT NULL) OR
       (@LastRetrievedInteractionId IS NOT NULL AND @LastRetrievedStartDateTime IS NULL AND @LastRetrievedCreated IS NULL)
    BEGIN
        RAISERROR('@LastRetrievedInteractionId, @LastRetrievedStartDateTime and @LastRetrievedCreated must be either all NULL or all NOT NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRAN;

    DECLARE @EstimatedRecordsCount BIGINT;

    DECLARE @SplitBoundsTable TABLE
        (
            [StartDateTime] DATETIME2 NOT NULL,
            [Created] DATETIME2 NOT NULL,
            [InteractionId] UNIQUEIDENTIFIER NOT NULL,
            [RowNumber] INT NOT NULL
        );

    WITH TopInteractions_CTE
    (
        [InteractionId],
        [StartDateTime],
        [Created],
        [RowNumber]
    )
    AS
    (
        SELECT TOP(@PreferredCount + 1)
            [InteractionId],
            [StartDateTime],
            [Created],
            ROW_NUMBER() OVER
                (
                    ORDER BY
                        [Source].[StartDateTime] DESC,
                        [Source].[Created] DESC,
                        [Source].[InteractionId] DESC
                ) as [RowNumber]
        FROM 
            [xdb_collection].[Interactions] AS [Source]
        WHERE
            (
                (
                    @LastRetrievedStartDateTime IS NULL -- NULL, when very first read
                    AND
                    (
                        [Source].[StartDateTime] < @UpBoundStartDateTime 
                        OR
                        (
                            [Source].[StartDateTime] = @UpBoundStartDateTime
                            AND [Source].[Created] < @UpBoundCreated
                        )
                        OR
                        (
                            [Source].[StartDateTime] = @UpBoundStartDateTime
                            AND [Source].[Created] = @UpBoundCreated
                            AND [Source].[InteractionId] <= @UpBoundInteractionId
                        )
                    )
                )
                OR
                (
                    [Source].[StartDateTime] < @LastRetrievedStartDateTime 
                    OR
                    (
                        [Source].[StartDateTime] = @LastRetrievedStartDateTime
                        AND [Source].[Created] < @LastRetrievedCreated
                    )
                    OR
                    (
                        [Source].[StartDateTime] = @LastRetrievedStartDateTime
                        AND [Source].[Created] = @LastRetrievedCreated
                        AND [Source].[InteractionId] < @LastRetrievedInteractionId
                    )
                )
            )
            AND
            (
                [Source].[StartDateTime] > @LowBoundStartDateTime 
                OR
                (
                    [Source].[StartDateTime] = @LowBoundStartDateTime
                    AND [Source].[Created] > @LowBoundCreated
                )
                OR
                (
                    [Source].[StartDateTime] = @LowBoundStartDateTime
                    AND [Source].[Created] = @LowBoundCreated
                    AND [Source].[InteractionId] >= @LowBoundInteractionId
                )
            )
            AND
            (
                [Source].[LastModified] < @CutOffDateTime
            )
            AND
            (
               @StartPercentile IS NULL
               OR 
               (
                   @EndPercentile IS NULL
               )
               OR
               (
                   [Percentile] >= @StartPercentile 
                   AND [Percentile] < @EndPercentile
               )
            )
        ORDER BY
            [Source].[StartDateTime] DESC,
            [Source].[Created] DESC,
            [Source].[InteractionId] DESC
    )

    -- Select split boundaries and insert into the temp table
    INSERT INTO @SplitBoundsTable
    SELECT
        [I].[StartDateTime] AS [StartDateTime],
        [I].[Created] AS [Created],
        [I].[InteractionId] AS [InteractionId],
        [I].[RowNumber] AS [RowNumber]
    FROM TopInteractions_CTE AS [I]
    WHERE
        [I].[RowNumber] >= @PreferredCount
        AND [I].[RowNumber] <= @PreferredCount + 1

    -- @@ROWCOUNT Returns the number of rows affected by the last statement
    -- If number of rows equal two, it means that the split is possible and
    -- it is required to calculate estimated record count for remaining cursor.
    IF (@@ROWCOUNT = 2)
    BEGIN
        DECLARE @RemainingCursorUpBoundStartDateTime DATETIME2;
        DECLARE @RemainingCursorUpBoundCreated DATETIME2;
        DECLARE @RemainingCursorUpBoundInteractionId UNIQUEIDENTIFIER;

        -- Get the estimated count for remaining cursor, we can get the specific [StartDateTime] based
        -- on the @PreferredCount + 1 value.
        SELECT 
            @RemainingCursorUpBoundStartDateTime = [StartDateTime],
            @RemainingCursorUpBoundCreated = [Created],
            @RemainingCursorUpBoundInteractionId = [InteractionId]
        FROM
            @SplitBoundsTable
        WHERE
            [RowNumber] = @PreferredCount + 1

        EXEC [xdb_collection].[GetRangeInteractionsCount]
            @CutOffDateTime,
            @LowBoundStartDateTime,                 -- >=, StartDateTime low boundary, for the cursor that was split.
            @LowBoundCreated,                       -- >=, Created low boundary, for the cursor that was split.
            @LowBoundInteractionId,                 -- >=, InteractionId low boundary, for the cursor that was split.
            @RemainingCursorUpBoundStartDateTime,   -- <=, StartDateTime up boundary, for the remaining cursor, it was calculated based on preffered count.
            @RemainingCursorUpBoundCreated,         -- <=, Created up boundary, for the remaining cursor, it was calculated based on preffered count.
            @RemainingCursorUpBoundInteractionId,   -- <=, InteractionId up boundary, for the remaining cursor, it was calculated based on preffered count.
            @StartPercentile,
            @EndPercentile,
            @EstimatedRecordsCount OUTPUT
    END
    ELSE
        -- Get the estimated count for the overal cursor, the cursor wasn't split,
        -- most probably there are not enough records for split.
        EXEC [xdb_collection].[GetRangeInteractionsCount]
            @CutOffDateTime,
            @LowBoundStartDateTime, -- >=, initial StartDateTime low boundary for the cursor that wasn't split.
            @LowBoundCreated,       -- >=, initial Created low boundary for the cursor that wasn't split.
            @LowBoundInteractionId, -- >=, initial InteractionId low boundary for the cursor that wasn't split.
            @UpBoundStartDateTime,  -- <=, initial StartDateTime up boundary for the cursor that wasn't split.
            @UpBoundCreated,        -- <=, initial Created up boundary for the cursor that wasn't split.
            @UpBoundInteractionId,  -- <=, initial InteractionId up boundary for the cursor that wasn't split.
            @StartPercentile,
            @EndPercentile,
            @EstimatedRecordsCount OUTPUT

    SELECT
        [StartDateTime],
        [Created],
        [InteractionId]
    FROM
        @SplitBoundsTable

    SELECT @EstimatedRecordsCount AS [EstimatedRecordsCount];

    COMMIT TRANSACTION
END

GO
PRINT N'Finish altering [xdb_collection].[GetInteractionsSplitBounds] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetRangeBoundsAndContactsCount] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetRangeBoundsAndContactsCount]

GO
CREATE PROCEDURE [xdb_collection].[GetRangeBoundsAndContactsCount]
    @StartPercentile FLOAT = NULL,              -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL                 -- The end percentile exclusive bound
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    -- Get up bound parameters
    DECLARE
        @UpBoundCreated AS DATETIME2,
        @UpBoundRecordId AS UNIQUEIDENTIFIER

    SELECT TOP 1
        @UpBoundCreated = [Created],
        @UpBoundRecordId = [ContactId]
    FROM
        [xdb_collection].[Contacts]
    WHERE
        @StartPercentile IS NULL
        OR 
        (
            @EndPercentile IS NULL
        )
        OR
        (
            [xdb_collection].[Contacts].[Percentile] >= @StartPercentile 
            AND [xdb_collection].[Contacts].[Percentile] < @EndPercentile
        )
    ORDER BY
        [Created] DESC,
        [ContactId] DESC

    -- Get low bound parameters
    DECLARE
        @LowBoundCreated AS DATETIME2,
        @LowBoundRecordId AS UNIQUEIDENTIFIER

    SELECT TOP 1
        @LowBoundCreated = [Created],
        @LowBoundRecordId = [ContactId]
    FROM
        [xdb_collection].[Contacts]
    WHERE 
         @StartPercentile IS NULL
        OR 
        (
            @EndPercentile IS NULL
        )
        OR
        (
            [xdb_collection].[Contacts].[Percentile] >= @StartPercentile 
            AND [xdb_collection].[Contacts].[Percentile] < @EndPercentile
        )
    ORDER BY
        [Created] ASC,
        [ContactId] ASC

    -- Select records count.
    DECLARE @EstimatedRecordCount BIGINT

    SELECT
        @EstimatedRecordCount = COUNT_BIG(*)
    FROM
        [xdb_collection].[Contacts]
    WHERE 
         @StartPercentile IS NULL
        OR 
        (
            @EndPercentile IS NULL
        )
        OR
        (
            [xdb_collection].[Contacts].[Percentile] >= @StartPercentile 
            AND [xdb_collection].[Contacts].[Percentile] < @EndPercentile
        )

    SELECT
        @UpBoundCreated AS [UpBoundCreated],
        @UpBoundRecordId AS [UpBoundRecordId],
        @LowBoundCreated AS [LowBoundCreated],
        @LowBoundRecordId AS [LowBoundRecordId],
        @EstimatedRecordCount AS [EstimatedRecordCount]

    COMMIT TRANSACTION
END

GO
PRINT N'Finish altering [xdb_collection].[GetRangeBoundsAndContactsCount] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetRangeBoundsAndInteractionsCount] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetRangeBoundsAndInteractionsCount]

GO
CREATE PROCEDURE [xdb_collection].[GetRangeBoundsAndInteractionsCount]
    @CutOffDateTime DATETIME2,
    @MinDateTime DATETIME2,
    @MaxDateTime DATETIME2,
    @StartPercentile FLOAT = NULL,              -- The start percentile inclusive bound
    @EndPercentile FLOAT = NULL                 -- The end percentile exclusive bound

-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @errorMsg NVARCHAR(MAX);
    DECLARE @CuttOffDateTimeStr VARCHAR(30);
    DECLARE @MinDateTimeStr VARCHAR(30);
    DECLARE @MaxDateTimeStr VARCHAR(30);

    IF (@CutOffDateTime IS NULL)
    BEGIN
        RAISERROR('@CutOffDateTime cannot be NULL.', 16, 1) WITH NOWAIT;
        RETURN;
    END

    -- Verify the validity of the min date time.
    -- Raise an error if cut-off date time is less than min date time.
    IF ((@MinDateTime IS NOT NULL) AND (@MinDateTime > @CutOffDateTime))
    BEGIN
        SET @CuttOffDateTimeStr = CAST(@CutOffDateTime as varchar(30));
        SET @MinDateTimeStr = CAST(@MinDateTime as varchar(30));
        
        SET @errorMsg = '@CutOffDateTime - %s is less than @MinDateTime - %s.'
        RAISERROR(@errorMsg, 16, 1, @CuttOffDateTimeStr, @MinDateTimeStr) WITH NOWAIT;
        RETURN;
    END

    -- Verify the validity of the min/max range.
    -- Raise an error if cut-off date time is less than max date time.
    IF ((@MaxDateTime IS NOT NULL) AND (@MinDateTime IS NOT NULL) AND (@MaxDateTime < @MinDateTime))
    BEGIN
        SET @MinDateTimeStr = CAST(@MinDateTime as varchar(30));
        SET @MaxDateTimeStr = CAST(@MaxDateTime as varchar(30));

        SET @errorMsg = '@MaxDateTime - %s is less than @MinDateTime - %s.'
        RAISERROR(@errorMsg, 16, 1, @MaxDateTimeStr, @MinDateTimeStr) WITH NOWAIT;
        RETURN;
    END

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    -- Get up bound parameters
    DECLARE
        @UpBoundStartDateTime AS DATETIME2,
        @UpBoundCreated AS DATETIME2,
        @UpBoundRecordId AS UNIQUEIDENTIFIER

        SELECT TOP 1 
        @UpBoundStartDateTime = [StartDateTime],
        @UpBoundCreated = [Created],
        @UpBoundRecordId = [InteractionId]
    FROM 
        [xdb_collection].[Interactions]
    WHERE
        (
            (@MinDateTime IS NULL OR [StartDateTime] >= @MinDateTime)
        )
        AND
        (
            (@MaxDateTime IS NULL OR [StartDateTime] < @MaxDateTime)
        )
        AND
        (
            [LastModified] < @CutOffDateTime
        )
        AND
        (
           @StartPercentile IS NULL
           OR 
           (
               @EndPercentile IS NULL
           )
           OR
           (
               [Percentile] >= @StartPercentile 
               AND [Percentile] < @EndPercentile
           )
        )
    ORDER BY
        [StartDateTime] DESC,
        [Created] DESC,
        [InteractionId] DESC

    -- Get low bound parameters
    DECLARE
        @LowBoundStartDateTime AS DATETIME2,
        @LowBoundCreated AS DATETIME2,
        @LowBoundRecordId AS UNIQUEIDENTIFIER

    SELECT TOP 1 
        @LowBoundStartDateTime = [StartDateTime],
        @LowBoundCreated = [Created],
        @LowBoundRecordId = [InteractionId]
    FROM 
        [xdb_collection].[Interactions]
    WHERE
        (
            (@MinDateTime IS NULL OR [StartDateTime] >= @MinDateTime)
        )
        AND
        (
            (@MaxDateTime IS NULL OR [StartDateTime] < @MaxDateTime)
        )
        AND
        (
            [LastModified] < @CutOffDateTime
        )
        AND
        (
           @StartPercentile IS NULL
           OR 
           (
               @EndPercentile IS NULL
           )
           OR
           (
               [xdb_collection].[Interactions].[Percentile] >= @StartPercentile 
               AND [xdb_collection].[Interactions].[Percentile] < @EndPercentile
           )
        )
    ORDER BY
        [StartDateTime] ASC,
        [Created] ASC,
        [InteractionId] ASC

    -- Get records count.
    DECLARE @EstimatedRecordCount BIGINT

    SELECT
        @EstimatedRecordCount = COUNT_BIG(*)
    FROM 
        [xdb_collection].[Interactions]
    WHERE
        (
            (@MinDateTime IS NULL OR [StartDateTime] >= @MinDateTime)
        )
        AND
        (
            (@MaxDateTime IS NULL OR [StartDateTime] < @MaxDateTime)
        )
        AND
        (
            [LastModified] < @CutOffDateTime
        )
        AND
        (
           @StartPercentile IS NULL
           OR 
           (
               @EndPercentile IS NULL
           )
           OR
           (
               [xdb_collection].[Interactions].[Percentile] >= @StartPercentile 
               AND [xdb_collection].[Interactions].[Percentile] < @EndPercentile
           )
        )

    SELECT
        @UpBoundStartDateTime AS [UpBoundStartDateTime],
        @UpBoundCreated AS [UpBoundCreated],
        @UpBoundRecordId AS [UpBoundRecordId],
        @LowBoundStartDateTime AS [LowBoundStartDateTime],
        @LowBoundCreated AS [LowBoundCreated],
        @LowBoundRecordId AS [LowBoundRecordId],
        @EstimatedRecordCount AS [EstimatedRecordCount]

    COMMIT TRANSACTION
END

GO
PRINT N'Finish altering [xdb_collection].[GetRangeBoundsAndInteractionsCount] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[SaveContactIdentifiersIndex] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveContactIdentifiersIndex]

GO
CREATE PROCEDURE [xdb_collection].[SaveContactIdentifiersIndex]
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[ContactIdentifiersIndex_Staging]
            WHERE
                [BatchId] = @BatchId -- Filter staging table records by the batch identifier.
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
                    [xdb_collection].[ContactIdentifiersIndex_Staging]
                WHERE
                    [BatchId] = @BatchId
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
                [xdb_collection].[ContactIdentifiersIndex_Staging] AS [Source_CII]
                LEFT JOIN [xdb_collection].[ContactIdentifiersIndex] AS [Target_CII]
                    ON [Target_CII].[IdentifierHash] = DATALENGTH([Source_CII].[Identifier])
                    AND [Source_CII].[Identifier] = [Target_CII].[Identifier]
                    AND [Source_CII].[Source] = [Target_CII].[Source] COLLATE Latin1_General_BIN2
            WHERE
                [Source_CII].[BatchId] = @BatchId 
                AND [Target_CII].[Version] <> @CurrentVersion
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

        DELETE
        FROM 
            [xdb_collection].[ContactIdentifiersIndex_Staging]
        WHERE
            [BatchId] = @BatchId;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

END
GO
PRINT N'Finish altering [xdb_collection].[SaveContactIdentifiersIndex] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[SaveContacts] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveContacts]

GO
CREATE PROCEDURE [xdb_collection].[SaveContacts] 
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[Contacts_Staging]
            WHERE
                [BatchId] = @BatchId
                AND [ChangeState] <> 0
        );

        SET @ExpectedIdentifiersChangeCount =
        (
            SELECT 
                COUNT(*)
            FROM 
                [xdb_collection].[ContactIdentifiers_Staging]
            WHERE
                [BatchId] = @BatchId
        );

        ------------------------------------------------------------------------------------
        -- Merge staging data from [Contacts_Staging] table into the [Contacts] table.
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
                [xdb_collection].[Contacts_Staging]
            WHERE
                [BatchId] = @BatchId -- Filter staging table records by the batch identifier.
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
            FROM [xdb_collection].[ContactIdentifiers_Staging] AS [CI]
            INNER JOIN [xdb_collection].[Contacts_Staging] AS [CS]
                ON [CS].[BatchId] = @BatchId
                    AND [CS].[ContactId] = [CI].[ContactId]
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
                [CI].[BatchId] = @BatchId -- Filter staging table records by the batch identifier.
                AND [CI].[ChangeState] = 3 -- Delete contact identifier
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
        -- Merge staging data from [ContactIdentifiers_Staging] table into the [ContactIdentifiers] table.
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
            FROM [xdb_collection].[ContactIdentifiers_Staging] as [CI]
            INNER JOIN [xdb_collection].[Contacts_Staging] as [CS]
                ON [CS].[BatchId] = @BatchId
                    AND [CS].[ContactId] = [CI].[ContactId]
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
                [CI].[BatchId] = @BatchId -- Filter staging table records by the batch identifier.
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
                [xdb_collection].[Contacts_Staging] AS [Source]
                LEFT JOIN [xdb_collection].[Contacts] AS [Target]
                    ON [Source].[ContactId] = [Target].[ContactId]
            WHERE
                [Source].[BatchId] = @BatchId
                AND [Source].[ChangeState] <> 0
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
                    [xdb_collection].[ContactIdentifiers_Staging] AS [Source]
                    LEFT JOIN [xdb_collection].[ContactIdentifiers] AS [Target]
                        ON [Source].[ContactId] = [Target].[ContactId]
                            AND [Target].[IdentifierHash] = DATALENGTH([Source].[Identifier])
                            AND [Target].[Identifier] = [Source].[Identifier]
                            AND [Target].[Source] = [Source].[Source] COLLATE Latin1_General_BIN2
                    LEFT JOIN [xdb_collection].[Contacts] AS [CT]
                        ON [CT].[ContactId] = [Source].[ContactId]
                    LEFT JOIN [xdb_collection].[Contacts_Staging] as [CS]
                        ON [CS].[BatchId] = @BatchId
                            AND [CS].[ContactId] = [Source].[ContactId] 
                WHERE
                    [Source].[BatchId] = @BatchId
            ) AS [Errors]
            WHERE
                [ErrorType] IS NOT NULL -- This ignores any failure that does not match conditions. Such failures (for instance NotFound) are not valuable for the client.
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

        -- Clean up staging table for the contacts for specified batch
        DELETE
        FROM 
            [xdb_collection].[Contacts_Staging]
        WHERE
            [BatchId] = @BatchId;

        -- Clean up staging table for the contact identifiers for specified batch
        DELETE
        FROM 
            [xdb_collection].[ContactIdentifiers_Staging]
        WHERE
            [BatchId] = @BatchId;

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
PRINT N'Finish altering [xdb_collection].[SaveContacts] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[SaveInteractions] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveInteractions]

GO
CREATE PROCEDURE [xdb_collection].[SaveInteractions] 
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[Interactions_Staging] AS [Source] 
            WHERE
                [BatchId] = @BatchId
                AND  EXISTS
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
                [xdb_collection].[Interactions_Staging]
            WHERE
                [BatchId] = @BatchId
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
                [xdb_collection].[Interactions_Staging] AS [Source]
                LEFT JOIN [xdb_collection].[Interactions] AS [Target]
                    ON [Source].[InteractionId] = [Target].[InteractionId]
            WHERE
                [Source].[BatchId] = @BatchId
                AND 
                (
                    [Target].[InteractionId] IS NULL -- Select just rows that are not exist in [Target] table
                    OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
                )
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected   
 
        DELETE
        FROM 
            [xdb_collection].[Interactions_Staging]
        WHERE
            [BatchId] = @BatchId

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
 END
GO
PRINT N'Finish altering [xdb_collection].[SaveInteractions] stored procedure...';


GO
PRINT N'Start creating [xdb_collection].[UnlockContactIdentifiersIndex] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[UnlockContactIdentifiersIndex]

GO
CREATE PROCEDURE [xdb_collection].[UnlockContactIdentifiersIndex]
    @BatchId UNIQUEIDENTIFIER -- The unique batch identifier.
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
            INNER JOIN [xdb_collection].[UnlockContactIdentifiersIndex_Staging] AS [Staging]
                ON
                    DATALENGTH([Staging].[Identifier]) = [CII].[IdentifierHash]
                    AND [Staging].[Identifier] = [CII].[Identifier]
                    AND [Staging].[Source] = [CII].[Source] COLLATE Latin1_General_BIN2

        WHERE
            [Staging].[BatchId] = @BatchId

        DELETE
        FROM 
            [xdb_collection].[UnlockContactIdentifiersIndex_Staging]
        WHERE
            [BatchId] = @BatchId;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

END

GO
PRINT N'Finish creating [xdb_collection].[UnlockContactIdentifiersIndex] stored procedure...';

GO
PRINT N'Start creating [xdb_collection].[GetContactsByIds] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactsByIds]

GO
CREATE PROCEDURE [xdb_collection].[GetContactsByIds] 
    @Ids NVARCHAR(MAX),
    @FacetKeys NVARCHAR(MAX)
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    DECLARE @ContactsIdentifiers TABLE
    (
        [value] Uniqueidentifier
    )
    
    INSERT INTO @ContactsIdentifiers SELECT [value] FROM STRING_SPLIT(@Ids, ',')
    
    DECLARE @FacetsIdentifiers TABLE
    (
        [value] nvarchar(50)
    )
    
    INSERT INTO @FacetsIdentifiers SELECT [value] FROM STRING_SPLIT(@FacetKeys, ',')

    -- Although the get by ids query can be written in the single SQL statement
    -- it is not performance efficient comparable to the two separate statements with
    -- the UNION ALL. 
    -- The first statement SELECTs the Contacts and their Identifiers filtered by the @Ids parameter.
    -- The second statement SELECTs the Contact Facets filtered by the @Ids and @FacetKeys.
    -- The difference between two approaches was measured and the average improvement is
    -- in several times.
    -- As far as UNION ALL requires equal number of columns we have to return NULL columns in
    -- both SELECT statements.
    SELECT 
        [Source].[ContactId] AS [Id], 
        [Source].[LastModified] AS [LastModified],
        [Source].[Created],
        [Source].[ConcurrencyToken] AS [ConcurrencyToken],
        [Identifiers].[Identifier],
        [Identifiers].[IdentifierType],
        [Identifiers].[Source],
        NULL AS [FacetKey]
    FROM 
        @ContactsIdentifiers AS [Ids] 
        INNER JOIN [xdb_collection].[Contacts] AS [Source]
            ON [Source].[ContactId] = [Ids].[value]
        LEFT JOIN [xdb_collection].[ContactIdentifiers] AS [Identifiers]
            ON [Source].[ContactId] = [Identifiers].[ContactId]
      
    SELECT
        [ContactFacets].[ContactId] AS [Id],
        NULL AS [Identifier],
        [ContactFacets].[FacetKey] AS [FacetKey],
        [ContactFacets].[LastModified] AS [FacetLastModified],
        [ContactFacets].[ConcurrencyToken] AS [FacetConcurrencyToken],
        [ContactFacets].[FacetData] AS [FacetData]
    FROM @ContactsIdentifiers AS [Ids]
        INNER JOIN [xdb_collection].[ContactFacets]
            ON [Ids].[value] = [ContactFacets].[ContactId]
        INNER JOIN @FacetsIdentifiers f on [ContactFacets].[FacetKey] = f.value

    COMMIT TRANSACTION
END

GO
PRINT N'Finish creating [xdb_collection].[GetContactsByIds] stored procedure...';

GO
PRINT N'Start creating [xdb_collection].[GetInteractionsByIds] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetInteractionsByIds]

GO
CREATE PROCEDURE [xdb_collection].[GetInteractionsByIds] 
    @Ids NVARCHAR(MAX),
    @FacetKeys NVARCHAR(MAX)
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    DECLARE @InteractionIdentifiers TABLE
    (
        [value] Uniqueidentifier
    )
    
    INSERT INTO @InteractionIdentifiers SELECT [value] FROM STRING_SPLIT(@Ids, ',')
    
    DECLARE @FacetsIdentifiers TABLE
    (
        [value] nvarchar(50)
    )
    
    INSERT INTO @FacetsIdentifiers SELECT [value] FROM STRING_SPLIT(@FacetKeys, ',')

    -- Although the get by ids query can be written in the single SQL statement
    -- it is not performance efficient comparable to the two separate statements with
    -- the UNION ALL. 
    -- The first statement SELECTs the Interactions filtered by the @Ids parameter.
    -- The second statement SELECTs the Interaction Facets filtered by the @Ids and @FacetKeys.
    -- The difference between two approaches was measured and the average improvement is
    -- in several times.
    -- As far as UNION ALL requires equal number of columns we have to return NULL columns in
    -- both SELECT statements.
    SELECT
        [Source].[InteractionId] AS [Id],
        [Source].[LastModified],
        [Source].[Created],
        [Source].[ConcurrencyToken],
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
        NULL AS [FacetKey],
        NULL AS [FacetLastModified],
        NULL AS [FacetConcurrencyToken],
        NULL AS [FacetData]
    FROM
        @InteractionIdentifiers AS [Ids]
        INNER JOIN [xdb_collection].[Interactions] AS [Source]
            ON [Source].[InteractionId] = [Ids].[value]

    SELECT
        [Facets].[InteractionId] AS [Id],
        NULL AS [LastModified],
        NULL AS [Created],
        NULL AS [ConcurrencyToken],
        NULL AS [ContactId],
        NULL AS [StartDateTime],
        NULL AS [EndDateTime],
        NULL AS [Initiator],
        NULL AS [DeviceProfileId],
        NULL AS [ChannelId],
        NULL AS [VenueId],
        NULL AS [CampaignId],
        NULL AS [Events],
        NULL AS [UserAgent],
        NULL AS [EngagementValue],
        [Facets].[FacetKey],
        [Facets].[LastModified] AS [FacetLastModified],
        [Facets].[ConcurrencyToken] AS [FacetConcurrencyToken],
        [Facets].[FacetData]
    FROM @InteractionIdentifiers AS [Ids]
        INNER JOIN [xdb_collection].[InteractionFacets] AS [Facets]
            ON [Ids].[value] = [Facets].[InteractionId]
        INNER JOIN @FacetsIdentifiers AS [FacetKeys]
            ON [FacetKeys].[value] = [Facets].[FacetKey]

    COMMIT TRANSACTION
END

GO
PRINT N'Finish creating [xdb_collection].[GetInteractionsByIds] stored procedure...';

GO
PRINT N'Start creating [xdb_collection].[GetDeviceProfilesByIds] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetDeviceProfilesByIds]

GO
CREATE PROCEDURE [xdb_collection].[GetDeviceProfilesByIds]
    @Ids NVARCHAR(MAX),
    @FacetKeys NVARCHAR(MAX)
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    DECLARE @DeviceIdentifiers TABLE
    (
        [value] Uniqueidentifier
    )
    
    INSERT INTO @DeviceIdentifiers SELECT [value] FROM STRING_SPLIT(@Ids, ',')
    
    DECLARE @FacetsIdentifiers TABLE
    (
        [value] nvarchar(50)
    )
    
    INSERT INTO @FacetsIdentifiers SELECT [value] FROM STRING_SPLIT(@FacetKeys, ',')

    -- Although the get by ids query can be written in the single SQL statement
    -- it is not performance efficient comparable to the two separate statements with
    -- the UNION ALL. 
    -- The first statement SELECTs the Device Profiles filtered by the @Ids parameter.
    -- The second satement SELECTs the Device Profile Facets filtered by the @Ids and @FacetKeys.
    -- The difference between two approaches was measured and the average improvement is
    -- in several times.
    -- As far as UNION ALL requires equal number of columns we have to return NULL columns in
    -- both SELECT statements.
    SELECT 
        [Source].[DeviceProfileId] AS [Id],
        [Source].[LastModified] AS [LastModified],
        [Source].[ConcurrencyToken] AS [ConcurrencyToken],
        [Source].[LastKnownContactId],
        NULL AS [FacetKey],
        NULL AS [FacetLastModified],
        NULL AS [FacetConcurrencyToken],
        NULL AS [FacetData]
    FROM
        @DeviceIdentifiers AS [Ids]
        INNER JOIN [xdb_collection].[DeviceProfiles] AS [Source]
            ON [Source].[DeviceProfileId] = [Ids].[value]

    SELECT 
        [Facets].[DeviceProfileId] AS [Id],
        NULL AS [LastModified],
        NULL AS [ConcurrencyToken],
        NULL AS [LastKnownContactId],
        [Facets].[FacetKey],
        [Facets].[LastModified] AS [FacetLastModified],
        [Facets].[ConcurrencyToken] AS [FacetConcurrencyToken],
        [Facets].[FacetData]
    FROM
        @DeviceIdentifiers AS [Ids]
        INNER JOIN [xdb_collection].[DeviceProfileFacets] AS [Facets]
            ON [Ids].[value] = [Facets].[DeviceProfileId]
        INNER JOIN (SELECT value FROM STRING_SPLIT(@FacetKeys, ',')) AS [FacetKeys]
            ON [FacetKeys].[value] = [Facets].[FacetKey]

    COMMIT TRANSACTION
END

GO
PRINT N'Finish creating [xdb_collection].[GetDeviceProfilesByIds] stored procedure...';


GO
PRINT N'Start altering [xdb_collection].[GrantLeastPrivilege] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GrantLeastPrivilege]

GO
CREATE PROCEDURE [xdb_collection].[GrantLeastPrivilege]
    @UserName SYSNAME
-- Assign execution context to CALLER of the module (stored procedure)
WITH EXECUTE AS CALLER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;

    DECLARE @Command NVARCHAR(MAX)

    IF (NOT EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [name] = @UserName))
    BEGIN
        RAISERROR( 'Parameter @UserName should contain name of the existing user.', 16, 1) WITH NOWAIT
        RETURN
    END

    SET @Command = '

    GRANT EXECUTE TO [' + @UserName + ']

    GRANT SELECT ON [xdb_collection].[CheckContacts_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[ContactFacets_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[ContactIdentifiers_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[ContactIdentifiersIndex_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[Contacts_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[DeviceProfileFacets_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[DeviceProfiles_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[GetContactIdsByIdentifiers_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[UnlockContactIdentifiersIndex_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[GetContactsByIdentifiers_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[InteractionFacets_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[Interactions_Staging] TO [' + @UserName + ']
    GRANT SELECT ON [xdb_collection].[UnlockContactIdentifiersIndex_Staging] TO [' + @UserName + ']

    GRANT INSERT ON [xdb_collection].[CheckContacts_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[ContactFacets_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[ContactIdentifiers_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[ContactIdentifiersIndex_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[Contacts_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[DeviceProfileFacets_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[DeviceProfiles_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[GetContactIdsByIdentifiers_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[UnlockContactIdentifiersIndex_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[GetContactsByIdentifiers_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[InteractionFacets_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[Interactions_Staging] TO [' + @UserName + ']
    GRANT INSERT ON [xdb_collection].[UnlockContactIdentifiersIndex_Staging] TO [' + @UserName + ']

    GRANT SELECT ON SCHEMA :: __ShardManagement TO [' + @UserName + ']'

    PRINT @Command
    EXEC (@Command)
END
GO
PRINT N'Finish altering [xdb_collection].[GrantLeastPrivilege] stored procedure...';

GO
PRINT N'Start altering tables to remove default percentile constraints';

GO
IF  EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE name = N'ContactsPercentileDefault')

	ALTER TABLE [xdb_collection].[Contacts] 
	DROP CONSTRAINT [ContactsPercentileDefault]

GO
IF  EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE name = N'ContactsStagingPercentileDefault')

	ALTER TABLE [xdb_collection].[Contacts_Staging] 
	DROP CONSTRAINT [ContactsStagingPercentileDefault]

GO
IF  EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE name = N'InteractionsPercentileDefault')

	ALTER TABLE [xdb_collection].[Interactions] 
	DROP CONSTRAINT [InteractionsPercentileDefault]

GO
IF  EXISTS (
	SELECT * 
	FROM sys.objects 
	WHERE name = N'InteractionsStagingPercentileDefault')

	ALTER TABLE [xdb_collection].[Interactions_Staging] 
	DROP CONSTRAINT [InteractionsStagingPercentileDefault]

GO
PRINT N'Finish altering tables to remove default percentile constraints';

GO
PRINT N'Start creating [xdb_collection].[DeleteContacts] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[DeleteContacts]

GO
CREATE PROCEDURE [xdb_collection].[DeleteContacts]
    @Ids NVARCHAR(MAX) -- ContactIds to be deleted.
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets, to stop the message that shows the count of
    -- the number of rows affected by a statement, in order to improve performance.
    -- The @@ROWCOUNT function is updated even when SET NOCOUNT is ON. 
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- Specifies whether SQL Server automatically rolls back the current transaction when a Transact-SQL statement raises a run-time error. 

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    DECLARE @ContactsToDelete TABLE
    (
        [value] UNIQUEIDENTIFIER
    )
    
    INSERT INTO @ContactsToDelete SELECT [value] FROM STRING_SPLIT(@Ids, ',')

    -- Declares temp table to store the list of interaction ids that have to be deleted.
    DECLARE @InteractionsToDelete TABLE
    (
        [InteractionId] UNIQUEIDENTIFIER
    )

    -- Not all the tables have indexes by [ContactId] column, thus we need to read interaction ids
    -- by contact id and store them in the temp table for futher joins to prevent table scans in 
    -- the [InteractionFacets].
    INSERT INTO @InteractionsToDelete
    SELECT 
        [C].[InteractionId]
    FROM
        @ContactsToDelete AS [CTD]
        INNER JOIN [xdb_collection].[Interactions] AS [C]
            ON [CTD].[value] = [C].[ContactId]

    DELETE [Source]
    FROM
        @InteractionsToDelete AS [ITD]
        INNER JOIN [xdb_collection].[InteractionFacets] AS [Source]
            ON [ITD].[InteractionId] = [Source].[InteractionId] -- Primary key [InteractionFacets] -> starts from [InteractionId]

    DELETE [Source]
    FROM
        @InteractionsToDelete AS [ITD]
        INNER JOIN [xdb_collection].[Interactions] AS [Source]
            ON [ITD].[InteractionId] = [Source].[InteractionId]-- Primary key [Interactions] -> starts from [InteractionId]

    DELETE [Source]
    FROM
        @ContactsToDelete AS [CTD]
        INNER JOIN [xdb_collection].[ContactFacets] AS [Source]
            ON [CTD].[value] = [Source].[ContactId]

    DELETE
        [Source]
    FROM
        @ContactsToDelete AS [CTD]
        INNER JOIN [xdb_collection].[ContactIdentifiers] AS [Source]
            ON [CTD].[value] = [Source].[ContactId]

    DECLARE @DeletedContacts TABLE
    (  
        [ContactId] UNIQUEIDENTIFIER
    );

    DELETE
        [Source]
    OUTPUT
        [DELETED].[ContactId] INTO @DeletedContacts
    FROM
        @ContactsToDelete AS [CTD]
        INNER JOIN [xdb_collection].[Contacts] AS [Source]
            ON [CTD].[value] = [Source].[ContactId]

    DECLARE @DeletedContactsCount INT;
    SET @DeletedContactsCount = @@ROWCOUNT;

    IF (@DeletedContactsCount <> (SELECT COUNT(0) FROM @ContactsToDelete))
        SELECT
            [Id],
            [ErrorType]
        FROM
        (
            SELECT
                [CTD].[value] AS [Id],
                2 AS [ErrorType] -- Delete, Not Found
            FROM
                @ContactsToDelete AS [CTD]
                LEFT JOIN @DeletedContacts AS [DC]
                ON [CTD].[value] = [DC].[ContactId]
                WHERE [DC].[ContactId] IS NULL
        ) AS [Errors]
    ELSE
    SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

    COMMIT TRANSACTION
END

GO
PRINT N'Finish creating [xdb_collection].[DeleteContacts] stored procedure...';

GO
PRINT N'Start creating [xdb_collection].[DeleteInteractions] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[DeleteInteractions]

GO
CREATE PROCEDURE [xdb_collection].[DeleteInteractions]
    @Ids NVARCHAR(MAX) -- Interaction Ids to be deleted.
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets, to stop the message that shows the count of
    -- the number of rows affected by a statement, in order to improve performance.
    -- The @@ROWCOUNT function is updated even when SET NOCOUNT is ON. 
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- Specifies whether SQL Server automatically rolls back the current transaction when a Transact-SQL statement raises a run-time error. 

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT
    BEGIN TRANSACTION

    DECLARE @InteractionsToDelete TABLE
    (
        [value] UNIQUEIDENTIFIER
    )
    
    INSERT INTO @InteractionsToDelete SELECT [value] FROM STRING_SPLIT(@Ids, ',')

    DELETE [Source]
    FROM
        @InteractionsToDelete AS [ITD]
        INNER JOIN [xdb_collection].[InteractionFacets] AS [Source]
            ON [ITD].[value] = [Source].[InteractionId] -- Primary key [InteractionFacets] -> starts from [InteractionId]

    DECLARE @DeletedInteractions TABLE
    (  
        [InteractionId] UNIQUEIDENTIFIER
    );

    DELETE [Source]
    OUTPUT
        [DELETED].[InteractionId] INTO @DeletedInteractions
    FROM
        @InteractionsToDelete AS [ITD]
        INNER JOIN [xdb_collection].[Interactions] AS [Source]
            ON [ITD].[value] = [Source].[InteractionId]-- Primary key [Interactions] -> starts from [InteractionId]

    DECLARE @@DeletedInteractionsCount INT;
    SET @@DeletedInteractionsCount = @@ROWCOUNT;

    IF (@@DeletedInteractionsCount <> (SELECT COUNT(0) FROM @InteractionsToDelete))
        SELECT
            [Id],
            [ErrorType]
        FROM
        (
            SELECT
                [ITD].[value] AS [Id],
                2 AS [ErrorType] -- Delete, Not Found
            FROM
                @InteractionsToDelete AS [ITD]
                LEFT JOIN @DeletedInteractions AS [DI]
                ON [ITD].[value] = [DI].[InteractionId]
                WHERE [DI].[InteractionId] IS NULL
        ) AS [Errors]
    ELSE
    SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected

    COMMIT TRANSACTION
END

GO
PRINT N'Finish creating [xdb_collection].[DeleteInteractions] stored procedure...';

GO
PRINT N'Start creating [xdb_collection].[DeleteContactIdentifiersIndex] stored procedure...';
PRINT N'The stored procedure [DeleteOrphanIdentifiers_Index] was renamed to [DeleteContactIdentifiersIndex]...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[DeleteOrphanIdentifiers_Index]

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[DeleteContactIdentifiersIndex]

GO
CREATE PROCEDURE  [xdb_collection].[DeleteContactIdentifiersIndex]
   @BatchId UNIQUEIDENTIFIER -- The unique batch identifier.
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
                [xdb_collection].[ContactIdentifiersIndex_Staging]
            WHERE
                [BatchId] = @BatchId -- Filter staging table records by the batch identifier.
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

        DELETE
        FROM 
            [xdb_collection].[ContactIdentifiersIndex_Staging]
        WHERE
            [BatchId] = @BatchId;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END

GO
PRINT N'Finish creating [xdb_collection].[DeleteContactIdentifiersIndex] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetContactsChanges] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactsChanges]

GO
-- Create stored procedure that returns changes for the [Contacts] table
CREATE PROCEDURE [xdb_collection].[GetContactsChanges]
    @NumberOfChangeVersions INT,
    @SyncVersion BIGINT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        -- Obtain the min valid sync token for the [Contacts] table
        DECLARE @MinValidVersion BIGINT = CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID('[xdb_collection].[Contacts]'));

        -- Verify the validity of the sync token for the [Contacts] table.
        -- Raise error if sync token is no longer valid for the [Contacts] table.
        IF ((@SyncVersion IS NOT NULL) AND (@SyncVersion < @MinValidVersion))
        BEGIN
          RAISERROR('Sync token is no longer valid for [Contacts] table.', 16, 1) WITH NOWAIT;
          RETURN;
        END

        -- Obtain the current sync token.
        DECLARE @CurrentVersion BIGINT = (SELECT CHANGE_TRACKING_CURRENT_VERSION());

        -- Raise an error if change tracking current version is less than the sync token
        -- that is stored in the system. 
        -- This is an indicator that the system is unhealthy.
        IF ((@SyncVersion IS NOT NULL) AND (@CurrentVersion < @SyncVersion))
        BEGIN
            RAISERROR('Current sync version for the [Contacts] table is less than sync token.', 16, 1) WITH NOWAIT;
            RETURN;
        END

        -- Defines the upper bound for getting changes
        DECLARE @UpBoundChangeVersion BIGINT;

        IF (@SyncVersion IS NULL)
            -- When @SyncVersion is NULL, the changes has to be returned from the 
            -- very beginning. The upper bound has to be calculated as minimum available 
            -- sync token version for the [Contacts] table + specified number of change versions.
            SET @UpBoundChangeVersion = @MinValidVersion + @NumberOfChangeVersions;
        ELSE
            -- When @SyncVersion is specified, the changes has to be returned starting from
            -- the specified sync value. The upper bound has to be calculated as @SyncVersion
            -- value + specified number of change versions.
            SET @UpBoundChangeVersion = @SyncVersion + @NumberOfChangeVersions;

        SELECT
            [ContactId],
            NULL AS [FacetKey],
            [SYS_CHANGE_OPERATION] AS [Operation],
            [SYS_CHANGE_VERSION] AS [Version] 
        FROM 
            CHANGETABLE (CHANGES [xdb_collection].[Contacts], @SyncVersion) AS [CHANGES]
        WHERE
            [SYS_CHANGE_VERSION] <= @UpBoundChangeVersion
        ORDER BY 
            [SYS_CHANGE_VERSION];

        SELECT CHANGE_TRACKING_CURRENT_VERSION();

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRANSACTION;

        DECLARE
            @ErrorMessage NVARCHAR(MAX),
            @ErrorSeverity INT,
            @ErrorState INT,
            @ErrorNumber INT,
            @ErrorLine INT,
            @ErrorProcedure SYSNAME;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState  = ERROR_STATE(),
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE()

        IF @ErrorMessage NOT LIKE N'***%'
        BEGIN
            SELECT
                @ErrorMessage =
                    '*** '  + COALESCE(QUOTENAME(@ErrorProcedure), '<dynamic SQL>')
                    + ', Line ' + LTRIM(STR(@ErrorLine))
                    + '. Errno ' + LTRIM(STR(@ErrorNumber))
                    + ': ' + @ErrorMessage
        END

        RAISERROR('%s', @ErrorSeverity, @ErrorState, @ErrorMessage);

    END CATCH

GO
PRINT N'Finish altering [xdb_collection].[GetContactsChanges] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetContactFacetsChanges] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetContactFacetsChanges]

GO
-- Create stored procedure that returns changes for the [ContactFacets] table
CREATE PROCEDURE [xdb_collection].[GetContactFacetsChanges]
    @NumberOfChangeVersions INT,
    @SyncVersion BIGINT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        -- Obtain the min valid sync token for the [ContactFacets] table
        DECLARE @MinValidVersion BIGINT = CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID('[xdb_collection].[ContactFacets]'));

        -- Verify the validity of the sync token for the [ContactFacets] table.
        -- Raise error if sync token is no longer valid for the [ContactFacets] table.
        IF ((@SyncVersion IS NOT NULL) AND (@SyncVersion < @MinValidVersion))
        BEGIN
          RAISERROR('Sync token is no longer valid for the [ContactFacets] table.', 16, 1) WITH NOWAIT;
          RETURN;
        END

        -- Obtain the current sync token. This will be used next time that changes are obtained.
        DECLARE @CurrentVersion BIGINT = (SELECT CHANGE_TRACKING_CURRENT_VERSION());

        -- Raise an error if change tracking current version is less than the sync token
        -- that is stored in the system. 
        -- This is an indicator that the system is unhealthy.
        IF ((@SyncVersion IS NOT NULL) AND (@CurrentVersion < @SyncVersion))
        BEGIN
            RAISERROR('Current sync version for the [ContactFacets] table is less than the sync token.', 16, 1) WITH NOWAIT;
            RETURN;
        END

        -- Defines the upper bound for getting changes
        DECLARE @UpBoundChangeVersion BIGINT;

        IF (@SyncVersion IS NULL)
            -- When @SyncVersion is NULL, the changes has to be returned from the 
            -- very beginning. The upper bound has to be calculated as minimum available 
            -- sync token version for the [ContactFacets] table + specified number of change versions.
            SET @UpBoundChangeVersion = @MinValidVersion + @NumberOfChangeVersions;
        ELSE
            -- When @SyncVersion is specified, the changes has to be returned starting from
            -- the specified sync value. The upper bound has to be calculated as @SyncVersion
            -- value + specified number of change versions.
            SET @UpBoundChangeVersion = @SyncVersion + @NumberOfChangeVersions;

        SELECT
            [ContactId],
            [FacetKey],
            [SYS_CHANGE_OPERATION] AS [Operation],
            [SYS_CHANGE_VERSION] AS [Version] 
        FROM 
            CHANGETABLE (CHANGES [xdb_collection].[ContactFacets], @SyncVersion) AS [CHANGES]
        WHERE
            [SYS_CHANGE_VERSION] <= @UpBoundChangeVersion
        ORDER BY 
            [SYS_CHANGE_VERSION];

        SELECT CHANGE_TRACKING_CURRENT_VERSION();

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRANSACTION;

        DECLARE
            @ErrorMessage NVARCHAR(MAX),
            @ErrorSeverity INT,
            @ErrorState INT,
            @ErrorNumber INT,
            @ErrorLine INT,
            @ErrorProcedure SYSNAME;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState  = ERROR_STATE(),
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE()

        IF @ErrorMessage NOT LIKE N'***%'
        BEGIN
            SELECT
                @ErrorMessage =
                    '*** '  + COALESCE(QUOTENAME(@ErrorProcedure), '<dynamic SQL>')
                    + ', Line ' + LTRIM(STR(@ErrorLine))
                    + '. Errno ' + LTRIM(STR(@ErrorNumber))
                    + ': ' + @ErrorMessage
        END

        RAISERROR('%s', @ErrorSeverity, @ErrorState, @ErrorMessage);

    END CATCH


GO
PRINT N'Finish altering [xdb_collection].[GetContactFacetsChanges] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetInteractionsChanges] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetInteractionsChanges]

GO
-- Create stored procedure that returns changes for the [Interactions] table.
CREATE PROCEDURE [xdb_collection].[GetInteractionsChanges]
    @NumberOfChangeVersions INT,
    @SyncVersion BIGINT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        -- Obtain the min valid sync token for the table
        DECLARE @MinValidVersion BIGINT = CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID('[xdb_collection].[Interactions]'));

        -- Verify the validity of the sync token for the entity table.
        -- Raise error if sync token is no longer valid for entity table.
        IF ((@SyncVersion IS NOT NULL) AND (@SyncVersion < @MinValidVersion))
        BEGIN
          RAISERROR('Sync token is no longer valid for the [Interactions] table.', 16, 1) WITH NOWAIT;
          RETURN;
        END

        -- Obtain the current sync token. This will be used next time that changes are obtained.
        DECLARE @CurrentVersion BIGINT = (SELECT CHANGE_TRACKING_CURRENT_VERSION());

        -- Raise an error if change tracking current version is less than the sync token
        -- that is stored in the system. 
        -- This is an indicator that the system is unhealthy.
        IF ((@SyncVersion IS NOT NULL) AND (@CurrentVersion < @SyncVersion))
        BEGIN
            RAISERROR('Current sync version for the [Interactions] table is less than the sync token.', 16, 1) WITH NOWAIT;
            RETURN;
        END

        -- Defines the upper bound for getting changes
        DECLARE @UpBoundChangeVersion BIGINT;

        IF (@SyncVersion IS NULL)
            -- When @SyncVersion is NULL, the changes has to be returned from the 
            -- very beginning. The upper bound has to be calculated as minimum available 
            -- sync token version for the [Interactions] table + specified number of change versions.
            SET @UpBoundChangeVersion = @MinValidVersion + @NumberOfChangeVersions;
        ELSE
            -- When @SyncVersion is specified, the changes has to be returned starting from
            -- the specified sync value. The upper bound has to be calculated as @SyncVersion
            -- value + specified number of change versions.
            SET @UpBoundChangeVersion = @SyncVersion + @NumberOfChangeVersions;

        SELECT
            [ContactId],
            [InteractionId],
            NULL AS [FacetKey],
            [SYS_CHANGE_OPERATION] AS [Operation],
            [SYS_CHANGE_VERSION] AS [Version] 
        FROM 
            CHANGETABLE (CHANGES [xdb_collection].[Interactions], @SyncVersion) AS [CHANGES]
        WHERE
            [SYS_CHANGE_VERSION] <= @UpBoundChangeVersion
        ORDER BY 
            [SYS_CHANGE_VERSION];

        SELECT CHANGE_TRACKING_CURRENT_VERSION();

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRANSACTION;

        DECLARE
            @ErrorMessage NVARCHAR(MAX),
            @ErrorSeverity INT,
            @ErrorState INT,
            @ErrorNumber INT,
            @ErrorLine INT,
            @ErrorProcedure SYSNAME;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState  = ERROR_STATE(),
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE()

        IF @ErrorMessage NOT LIKE N'***%'
        BEGIN
            SELECT
                @ErrorMessage =
                    '*** '  + COALESCE(QUOTENAME(@ErrorProcedure), '<dynamic SQL>')
                    + ', Line ' + LTRIM(STR(@ErrorLine))
                    + '. Errno ' + LTRIM(STR(@ErrorNumber))
                    + ': ' + @ErrorMessage
        END

        RAISERROR('%s', @ErrorSeverity, @ErrorState, @ErrorMessage);

    END CATCH

GO
PRINT N'Finish altering [xdb_collection].[GetInteractionsChanges] stored procedure...';

GO
PRINT N'Start altering [xdb_collection].[GetInteractionFacetsChanges] stored procedure...';

GO
DROP PROCEDURE IF EXISTS [xdb_collection].[GetInteractionFacetsChanges]

GO
-- Create stored procedure that returns changes for the [InteractionFacets] table.
CREATE PROCEDURE [xdb_collection].[GetInteractionFacetsChanges]
    @NumberOfChangeVersions INT,
    @SyncVersion BIGINT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT
        BEGIN TRANSACTION

        -- Obtain the min valid sync token for the [InteractionFacets] table.
        DECLARE @MinValidVersion BIGINT = CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID('[xdb_collection].[InteractionFacets]'));

        -- Verify the validity of the sync token for the [InteractionFacets] table.
        -- Raise error if sync token is no longer valid for the [InteractionFacets] table.
        IF ((@SyncVersion IS NOT NULL) AND (@SyncVersion < @MinValidVersion))
        BEGIN
          RAISERROR('Sync token for the [InteractionFacets] table is no longer valid.', 16, 1) WITH NOWAIT;
          RETURN;
        END

        -- Obtain the current sync token. This will be used next time that changes are obtained.
        DECLARE @CurrentVersion BIGINT = (SELECT CHANGE_TRACKING_CURRENT_VERSION());

        -- Raise an error if change tracking current version is less than the sync token
        -- that is stored in the system. 
        -- This is an indicator that the system is unhealthy.
        IF ((@SyncVersion IS NOT NULL) AND (@CurrentVersion < @SyncVersion))
        BEGIN
            RAISERROR('Current sync version for the [InteractionFacets] table is less than the sync token.', 16, 1) WITH NOWAIT;
            RETURN;
        END

        -- Defines the upper bound for getting changes
        DECLARE @UpBoundChangeVersion BIGINT;

        IF (@SyncVersion IS NULL)
            -- When @SyncVersion is NULL, the changes has to be returned from the 
            -- very beginning. The upper bound has to be calculated as minimum available 
            -- sync token version for the [InteractionFacets] table + specified number of change versions.
            SET @UpBoundChangeVersion = @MinValidVersion + @NumberOfChangeVersions;
        ELSE
            -- When @SyncVersion is specified, the changes has to be returned starting from
            -- the specified sync value. The upper bound has to be calculated as @SyncVersion
            -- value + specified number of change versions.
            SET @UpBoundChangeVersion = @SyncVersion + @NumberOfChangeVersions;

        SELECT
            [ContactId],
            [InteractionId],
            [FacetKey],
            [SYS_CHANGE_OPERATION] AS [Operation],
            [SYS_CHANGE_VERSION] AS [Version] 
        FROM 
            CHANGETABLE (CHANGES [xdb_collection].[InteractionFacets], @SyncVersion) AS [CHANGES]
        WHERE
            [SYS_CHANGE_VERSION] <= @UpBoundChangeVersion
        ORDER BY 
            [SYS_CHANGE_VERSION];

        SELECT CHANGE_TRACKING_CURRENT_VERSION();

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRANSACTION;

        DECLARE
            @ErrorMessage NVARCHAR(MAX),
            @ErrorSeverity INT,
            @ErrorState INT,
            @ErrorNumber INT,
            @ErrorLine INT,
            @ErrorProcedure SYSNAME;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState  = ERROR_STATE(),
            @ErrorNumber = ERROR_NUMBER(),
            @ErrorProcedure = ERROR_PROCEDURE(),
            @ErrorLine = ERROR_LINE()

        IF @ErrorMessage NOT LIKE N'***%'
        BEGIN
            SELECT
                @ErrorMessage =
                    '*** '  + COALESCE(QUOTENAME(@ErrorProcedure), '<dynamic SQL>')
                    + ', Line ' + LTRIM(STR(@ErrorLine))
                    + '. Errno ' + LTRIM(STR(@ErrorNumber))
                    + ': ' + @ErrorMessage
        END

        RAISERROR('%s', @ErrorSeverity, @ErrorState, @ErrorMessage);

    END CATCH

GO
PRINT N'Finish altering [xdb_collection].[GetInteractionFacetsChanges] stored procedure...';
PRINT N'Altering [xdb_collection].[SaveDeviceProfileFacets]...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveDeviceProfileFacets]
GO
CREATE PROCEDURE [xdb_collection].[SaveDeviceProfileFacets]
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[DeviceProfileFacets_Staging] AS [SourceFacets]
            WHERE
                [BatchId] = @BatchId
                AND EXISTS
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
                [xdb_collection].[DeviceProfileFacets_Staging]
            WHERE
                [BatchId] = @BatchId
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
                [xdb_collection].[DeviceProfileFacets_Staging] AS [Source]
                LEFT JOIN [xdb_collection].[DeviceProfileFacets] AS [Target]
                    ON [Source].[DeviceProfileId] = [Target].[DeviceProfileId]
                    AND [Source].[FacetKey] = [Target].[FacetKey]
                LEFT JOIN [xdb_collection].[DeviceProfiles] AS [ReferenceTable] 
                    ON [ReferenceTable].[DeviceProfileId] = [Source].[DeviceProfileId]
            WHERE
                [Source].[BatchId] = @BatchId
                AND
                (
                    [Target].[DeviceProfileId] IS NULL -- Select just rows that are not exist in [Target] table
                    OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
                )
        ELSE
            SELECT TOP 0 NULL -- Return an empty table if the number of affected records is the same as expected

        DELETE
        FROM
            [xdb_collection].[DeviceProfileFacets_Staging]
        WHERE
            [BatchId] = @BatchId;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish altering [xdb_collection].[SaveDeviceProfileFacets] stored procedure...';
GO

PRINT N'Altering [xdb_collection].[SaveDeviceProfiles]...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveDeviceProfiles]
GO
CREATE PROCEDURE [xdb_collection].[SaveDeviceProfiles]
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[DeviceProfiles_Staging]
            WHERE
                [BatchId] = @BatchId
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
                [xdb_collection].[DeviceProfiles_Staging]
            WHERE
                [BatchId] = @BatchId
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
                [xdb_collection].[DeviceProfiles_Staging] AS [Source]
                LEFT JOIN [xdb_collection].[DeviceProfiles] AS [Target]
                    ON [Source].[DeviceProfileId] = [Target].[DeviceProfileId]
            WHERE
                [BatchId] = @BatchId
                AND
                (
                    [Target].[DeviceProfileId] IS NULL -- Select just rows that are not exist in [Target] table
                    OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
                )
        ELSE
            SELECT TOP 0 NULL -- An empty table is returned if the number of affected records is the same as expected   

        DELETE
        FROM
            [xdb_collection].[DeviceProfiles_Staging]
        WHERE
            [BatchId] = @BatchId;

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish altering [xdb_collection].[SaveDeviceProfiles] stored procedure...';
GO


PRINT N'Altering [xdb_collection].[SaveInteractionFacets]...';
GO
DROP PROCEDURE IF EXISTS [xdb_collection].[SaveInteractionFacets]
GO
CREATE PROCEDURE [xdb_collection].[SaveInteractionFacets]
    @BatchId UNIQUEIDENTIFIER, -- The unique batch identifier.
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
                [xdb_collection].[InteractionFacets_Staging] AS [SourceFacets] 
            WHERE
                [BatchId] = @BatchId
                AND EXISTS 
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
                [xdb_collection].[InteractionFacets_Staging]
            WHERE
                [BatchId] = @BatchId
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
                [xdb_collection].[InteractionFacets_Staging] AS [Source]
                LEFT JOIN [xdb_collection].[InteractionFacets] AS [Target]
                    ON [Source].[InteractionId] = [Target].[InteractionId]
                    AND [Source].[FacetKey] = [Target].[FacetKey]
                    LEFT JOIN [xdb_collection].[Interactions] AS [ReferenceTable]
                    ON [ReferenceTable].[InteractionId] = [Source].[InteractionId]
            WHERE
                [Source].[BatchId] = @BatchId
                AND
                (
                    [Target].[InteractionId] IS NULL -- Select just rows that are not exist in [Target] table
                    OR [Target].ConcurrencyToken <> @NextConcurrencyToken -- Or, Select not updated rows
                )
        ELSE
            SELECT TOP 0 NULL -- Return an empty table if the number of affected records is the same as expected   

        DELETE
        FROM 
            [xdb_collection].[InteractionFacets_Staging]
        WHERE
            [BatchId] = @BatchId

        COMMIT TRANSACTION

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH
END
GO
PRINT N'Finish altering [xdb_collection].[SaveInteractionFacets] stored procedure...';

GO
PRINT N'Creating UserDefinedTableType [xdb_collection].[CheckContactsTableType]...';
GO
IF TYPE_ID(N'[xdb_collection].[CheckContactsTableType]') IS NULL
BEGIN
    CREATE TYPE [xdb_collection].[CheckContactsTableType] AS TABLE(
        [ContactId] [uniqueidentifier] NOT NULL,
        [Identifier] [varbinary](700) NOT NULL,
        [Source] [varchar](50) COLLATE Latin1_General_BIN2 NOT NULL
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