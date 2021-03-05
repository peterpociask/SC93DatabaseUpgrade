/*
Deployment script for Sitecore.Marketingautomation
*/

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

PRINT N'Dropping index [IX_AutomationPool_Priority]...';

DROP INDEX [xdb_ma_pool].[AutomationPool].[IX_AutomationPool_Priority]
GO

PRINT N'Altering table [xdb_ma_pool].[AutomationPool]...';

ALTER TABLE [xdb_ma_pool].[AutomationPool]
	ALTER COLUMN [Created] DATETIME2(7) NOT NULL

ALTER TABLE [xdb_ma_pool].[AutomationPool]
	ALTER COLUMN [Scheduled] DATETIME2(7) NOT NULL

GO

PRINT N'Creating index [IX_AutomationPool_Priority]...';

CREATE CLUSTERED INDEX [IX_AutomationPool_Priority]
    ON [xdb_ma_pool].[AutomationPool]([Scheduled] ASC, [Priority] DESC);

GO

PRINT N'Dropping index [IX_ContactWorkerAffinity]...';

DROP INDEX [xdb_ma_pool].[ContactWorkerAffinity].[IX_ContactWorkerAffinity]

PRINT N'Altering table [xdb_ma_pool].[ContactWorkerAffinity]...';

ALTER TABLE [xdb_ma_pool].[ContactWorkerAffinity]
	ALTER COLUMN [LeaseExpiration] DATETIME2(7) NOT NULL

GO

PRINT N'Creating index [IX_AutomationPool_Priority]...';

CREATE CLUSTERED INDEX [IX_ContactWorkerAffinity]
    ON [xdb_ma_pool].[ContactWorkerAffinity] ([ContactId] ASC, [WorkerId] ASC, [LeaseExpiration] ASC)
GO

PRINT N'Dropping [xdb_ma_pool].[AutomationPool_Add]...';

DROP PROCEDURE [xdb_ma_pool].[AutomationPool_Add];
GO

PRINT N'Dropping [xdb_ma_pool].[WorkItems]...';

DROP TYPE [xdb_ma_pool].[WorkItems];
GO

PRINT N'Creating [xdb_ma_pool].[WorkItems]...';

CREATE TYPE [xdb_ma_pool].[WorkItems] AS TABLE (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [ContactId]         UNIQUEIDENTIFIER NOT NULL,
    [ExecutionData]     VARBINARY (MAX)  NOT NULL,
    [ExecutionDataType] NVARCHAR (512)   NOT NULL,
    [Priority]          TINYINT          NOT NULL,
    [Created]           DATETIME2 (7)    NOT NULL,
    [Scheduled]         DATETIME2 (7)    NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC));
GO

PRINT N'Creating [xdb_ma_pool].[AutomationPool_Add]...';
GO

CREATE PROCEDURE [xdb_ma_pool].[AutomationPool_Add]
(
    @WorkItems [xdb_ma_pool].[WorkItems] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON

    DECLARE
        @Results [xdb_ma_pool].[WorkItemResults],
        @Id UNIQUEIDENTIFIER,
        @ContactId UNIQUEIDENTIFIER,
        @ExecutionData VARBINARY(MAX),
        @ExecutionDataType NVARCHAR(512),
        @Priority TINYINT,
        @Created DATETIME2(7),
        @Scheduled DATETIME2(7)

    BEGIN TRY

        MERGE
            [xdb_ma_pool].[AutomationPool] WITH (HOLDLOCK) AS [target]
        USING
            @WorkItems AS [source]
        ON
        (
            [target].[ContactId] = [source].[ContactId] AND

            -- length should be checked as well (https://www.codykonior.com/2013/07/17/comparing-varbinary-data-types-in-sql-server/)
            DATALENGTH([target].[ExecutionData]) = DATALENGTH([source].[ExecutionData]) AND

            [target].[ExecutionData] = [source].[ExecutionData]
        )
        WHEN MATCHED AND [source].[Priority] > [target].[Priority] THEN
            UPDATE SET [Priority] = [source].[Priority]
        WHEN NOT MATCHED THEN
            INSERT
            (
                [Id],
                [ContactId],
                [ExecutionData],
                [ExecutionDataType],
                [Priority],
                [Created],
                [Scheduled],
                [Attempts]
            )
            VALUES
            (
                [source].[Id],
                [source].[ContactId],
                [source].[ExecutionData],
                [source].[ExecutionDataType],
                [source].[Priority],
                [source].[Created],
                [source].[Scheduled],
                0
            );

        INSERT INTO @Results
        (
            [Id],
            [StatusCode],
            [SystemMessage]
        )
        SELECT
            [Id],
            [xdb_ma].[StatusCode_Success](),
            NULL
        FROM
            @WorkItems;

    END TRY

    BEGIN CATCH

        -- An error occurred, so process each row to figure out the issue

        DECLARE
            WorkItemRow CURSOR FOR
            SELECT
                [Id], [ContactId], [ExecutionData], [ExecutionDataType], [Priority], [Created], [Scheduled]
            FROM
                @WorkItems

        OPEN WorkItemRow

        FETCH NEXT FROM
            WorkItemRow
        INTO
            @Id, @ContactId, @ExecutionData, @ExecutionDataType, @Priority, @Created, @Scheduled

        WHILE @@FETCH_STATUS = 0
        BEGIN

            BEGIN TRY

                MERGE
                    [xdb_ma_pool].[AutomationPool] WITH (HOLDLOCK) AS [target]
                USING
                (
                    SELECT
                        @Id,
                        @ContactId,
                        @ExecutionData,
                        @ExecutionDataType,
                        @Priority,
                        @Created,
                        @Scheduled
                )
                AS
                    [source]
                    (
                        [Id],
                        [ContactId],
                        [ExecutionData],
                        [ExecutionDataType],
                        [Priority],
                        [Created],
                        [Scheduled]
                    )
                ON
                (
                    [target].[ContactId] = [source].[ContactId] AND

                    -- length should be checked as well (https://www.codykonior.com/2013/07/17/comparing-varbinary-data-types-in-sql-server/)
                    DATALENGTH([target].[ExecutionData]) = DATALENGTH([source].[ExecutionData]) AND

                    [target].[ExecutionData] = [source].[ExecutionData]
                )
                WHEN MATCHED AND [source].[Priority] > [target].[Priority] THEN
                    UPDATE SET [Priority] = [source].[Priority]
                WHEN NOT MATCHED THEN
                    INSERT
                    (
                        [Id],
                        [ContactId],
                        [ExecutionData],
                        [ExecutionDataType],
                        [Priority],
                        [Created],
                        [Scheduled],
                        [Attempts]
                    )
                    VALUES
                    (
                        [source].[Id],
                        [source].[ContactId],
                        [source].[ExecutionData],
                        [source].[ExecutionDataType],
                        [source].[Priority],
                        [source].[Created],
                        [source].[Scheduled],
                        0
                    );

                INSERT INTO @Results
                (
                    [Id],
                    [StatusCode],
                    [SystemMessage]
                )
                VALUES
                (
                    @Id,
                    [xdb_ma].[StatusCode_Success](),
                    NULL
                )

            END TRY
            BEGIN CATCH
                INSERT INTO @Results
                (
                    [Id],
                    [StatusCode],
                    [SystemMessage]
                )
                VALUES
                (
                    @Id,
                    CASE ERROR_NUMBER()
                        WHEN 2627 THEN [xdb_ma].[StatusCode_TheEntryAlreadyExists]() -- Violation in unique constraint
                        WHEN 2601 THEN [xdb_ma].[StatusCode_TheEntryAlreadyExists]() -- Violation in unique index
                        ELSE [xdb_ma].[StatusCode_GeneralFailure]()
                    END,
                    ERROR_MESSAGE()
                )
            END CATCH

            FETCH NEXT FROM
                WorkItemRow
            INTO
                @Id, @ContactId, @ExecutionData, @ExecutionDataType, @Priority, @Created, @Scheduled

        END

        CLOSE WorkItemRow
        DEALLOCATE WorkItemRow

    END CATCH

    SELECT
        [Id],
        [StatusCode],
        [SystemMessage]
    FROM
        @Results
    AS
        Results
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE [type] = 'U' AND [name] = 'StalledAutomationPool')
BEGIN
	PRINT N'Creating [xdb_ma_pool].[StalledAutomationPool]...';

    CREATE TABLE [xdb_ma_pool].[StalledAutomationPool] (
        [Id]                UNIQUEIDENTIFIER NOT NULL,
        [ContactId]         UNIQUEIDENTIFIER NOT NULL,
        [ExecutionData]     VARBINARY (MAX)  NOT NULL,
        [ExecutionDataType] NVARCHAR (512)   NOT NULL,
        [Priority]          TINYINT          NOT NULL,
        [StalledDate]       DATETIME2 (0)    NOT NULL,
        [Attempts]          SMALLINT         NOT NULL,
        CONSTRAINT [PK_StalledAutomationPool] PRIMARY KEY NONCLUSTERED ([Id] ASC)
    )
END
GO

IF NOT EXISTS (SELECT * FROM sys.types WHERE [is_table_type] = 1 AND [name] = 'ContactMerges')
BEGIN
    PRINT N'Creating [xdb_ma_enrollment].[ContactMerges]...';

    CREATE TYPE [xdb_ma_enrollment].[ContactMerges] AS TABLE (
        [SourceContactId] UNIQUEIDENTIFIER NOT NULL,
        [TargetContactId] UNIQUEIDENTIFIER NOT NULL,
        PRIMARY KEY NONCLUSTERED ([SourceContactId] ASC, [TargetContactId] ASC));
END
GO

PRINT N'Altering [xdb_ma].[GrantLeastPrivilege]...';
GO

ALTER PROCEDURE [xdb_ma].[GrantLeastPrivilege]
(
    @Name SYSNAME
)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    IF (LEN(ISNULL(@Name, N'')) = 0)
    BEGIN
        RAISERROR( 'Parameter @Name cannot be null or empty', 16, 1) WITH NOWAIT
        RETURN
    END

    IF (@Name LIKE N'%[^a-zA-Z0-9_]%')
    BEGIN
        RAISERROR( 'Parameter @Name cannot contain special characters', 16, 1) WITH NOWAIT
        RETURN
    END

    EXECUTE ('
    -- Types
    grant execute on TYPE::[xdb_ma].[IDs] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_pool].[WorkItemAttempts] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_pool].[WorkItemResults] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_pool].[WorkItems] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentFormas] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentKeys] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentKeyResults] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentResults] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollments] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentTransitions] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentTransitionResults] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[PlanEnrollmentFilter] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentTimeouts] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentCustomValues] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityEnrollmentAttemptsResults] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ActivityStatisticsEntries] TO ' + @Name + '
    grant execute on TYPE::[xdb_ma_enrollment].[ContactMerges] TO ' + @Name + '

    -- Functions
    grant execute on [xdb_ma].[StatusCode_AttemptMismatch] to ' + @Name + '
    grant execute on [xdb_ma].[StatusCode_GeneralFailure] to ' + @Name + '
    grant execute on [xdb_ma].[StatusCode_Success] to ' + @Name + '
    grant execute on [xdb_ma].[StatusCode_TheEntryAlreadyExists] to ' + @Name + '
    grant execute on [xdb_ma].[StatusCode_WorkItemNotFound] to ' + @Name + '
    grant execute on [xdb_ma].[StatusCode_EnrollmentAlreadyExists] to ' + @Name + '
    grant execute on [xdb_ma].[StatusCode_EnrollmentNotFound] to ' + @Name + '
    grant execute on [xdb_ma].[TruncateDateTimeToMinute] to ' + @Name + '

    -- Procs
    grant execute on [xdb_ma_pool].[AutomationPool_Add] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[AutomationPool_Checkin] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[AutomationPool_Checkout] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[AutomationPool_PurgeContacts] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[AutomationPool_SetTimeout] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[AutomationPool_Stall] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[ContactWorkerAffinity_TakeLease] TO ' + @Name + '
    grant execute on [xdb_ma_pool].[ContactWorkerAffinity_ReleaseLease] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_Enroll] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_GetForContact] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_Get] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_GetTimedOut] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_Remove] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_Transition] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityStatistics_Aggregate] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityStalledEnrollments_Purge] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_IncrementAttempts] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_Stall] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_SetTimeout] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_SetCustomValues] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[PlanEntryStatistics_GetPlanStatistics] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityStatistics_GetPlanReport] TO ' + @Name + '
    grant execute on [xdb_ma_enrollment].[ActivityEnrollments_MergeContacts] TO ' + @Name);

END
GO

PRINT N'Altering [xdb_ma_pool].[AutomationPool_Checkin]...';
GO

ALTER PROCEDURE [xdb_ma_pool].[AutomationPool_Checkin]
(
    @WorkItems [xdb_ma_pool].[WorkItemAttempts] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON

    DECLARE
        @Results [xdb_ma_pool].[WorkItemResults],
        @Now DATETIME2(7) = CAST( SYSUTCDATETIME() AS DATETIME2(7) )

    INSERT INTO @Results
    SELECT
        [Id],
        [xdb_ma].[StatusCode_WorkItemNotFound](),
        NULL
    FROM
        @WorkItems AS [source]
    WHERE
        NOT EXISTS
        (
            SELECT [Id]
            FROM [xdb_ma_pool].[AutomationPool]
            WHERE [Id] = [source].[Id]
        )

    INSERT INTO @Results
    SELECT
        [Id],
        [xdb_ma].[StatusCode_AttemptMismatch](),
        NULL
    FROM
        @WorkItems AS [source]
    WHERE
        EXISTS
        (
            SELECT [Id]
            FROM [xdb_ma_pool].[AutomationPool]
            WHERE
                [Id] = [source].[Id] AND
                [Attempts] != [source].[Attempts]
        )

    MERGE
        [xdb_ma_pool].[AutomationPool] WITH (HOLDLOCK) AS [target]
    USING
        @WorkItems AS [source]
    ON
    (
        [target].[Id] = [source].[Id] AND
        [target].[Attempts] = [source].[Attempts]
    )
    WHEN MATCHED THEN
        DELETE
    OUTPUT
        DELETED.[Id],
        [xdb_ma].[StatusCode_Success](),
        NULL
    INTO
        @Results;

    DELETE
        [xdb_ma_pool].[ContactWorkerAffinity]
    WHERE
        [LeaseExpiration] <= @Now OR NOT EXISTS
        (
            SELECT [ContactId]
            FROM [xdb_ma_pool].[AutomationPool]
            WHERE [xdb_ma_pool].[AutomationPool].[ContactId] = [xdb_ma_pool].[ContactWorkerAffinity].[ContactId]
        )

    SELECT
        [Id],
        [StatusCode],
        [SystemMessage]
    FROM
        @Results
END
GO

PRINT N'Altering [xdb_ma_pool].[AutomationPool_Checkout]...';
GO

ALTER PROCEDURE [xdb_ma_pool].[AutomationPool_Checkout]
(
    @Head SMALLINT,
    @Size SMALLINT,
    @TimeoutSeconds SMALLINT,
    @MinimumPriority TINYINT,
    @WorkerId UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON

    IF ( ( @Head IS NULL) OR ( @Head < 1 ) )
    BEGIN
        RAISERROR( 'Parameter @Head cannot be NULL or less than 1', 16, 1) WITH NOWAIT
        RETURN
    END

    IF ( ( @Size IS NULL) OR ( @Size < 1 ) )
    BEGIN
        RAISERROR( 'Parameter @Size cannot be NULL or less than 1', 16, 1) WITH NOWAIT
        RETURN
    END

    IF ( ( @TimeoutSeconds IS NULL) OR ( @TimeoutSeconds < 1 ) )
    BEGIN
        RAISERROR( 'Parameter @TimeoutSeconds cannot be NULL or less than 1', 16, 1) WITH NOWAIT
        RETURN
    END

    IF ( @MinimumPriority IS NULL)
    BEGIN
        RAISERROR( 'Parameter @MinimumPriority cannot be NULL', 16, 1) WITH NOWAIT
        RETURN
    END

    IF ( @WorkerId IS NULL)
    BEGIN
        RAISERROR( 'Parameter @WorkerId cannot be NULL', 16, 1) WITH NOWAIT
        RETURN
    END

    DECLARE
        @Now DATETIME2(7) = CAST( SYSUTCDATETIME() AS DATETIME2(7) )

    DECLARE
        @Timeout DATETIME2(7) = DATEADD(SECOND, @TimeoutSeconds, @Now)

    DECLARE @ConfirmedLease TABLE
    (
        [ContactId] UNIQUEIDENTIFIER NOT NULL
    )

    -- Clean up old leases before processing
    DELETE
        [xdb_ma_pool].[ContactWorkerAffinity]
    WHERE
        [LeaseExpiration] <= @Now

    DECLARE @Assigned TABLE
    (
        [Id] UNIQUEIDENTIFIER NOT NULL,
        [ContactId] UNIQUEIDENTIFIER NOT NULL,
        [ExecutionData] VARBINARY(MAX) NOT NULL,
        [ExecutionDataType] NVARCHAR(512) NOT NULL,
        [Priority] TINYINT NOT NULL,
        [Created] DATETIME2(7) NOT NULL,
        [Scheduled] DATETIME2(7) NOT NULL,
        [Attempts] SMALLINT NOT NULL
    )

    ;WITH [slice] AS
    (
        SELECT TOP (@Size * @Head)
            [Id],
            [ContactId],
            [ExecutionData],
            [ExecutionDataType],
            [Priority],
            [Created],
            [Scheduled],
            [Attempts],
            -- The randomizer helps avoid contention between workers for the top rows
            RAND() AS [Randomizer]
        FROM
            [xdb_ma_pool].[AutomationPool]
            WITH (READPAST, ROWLOCK)
        WHERE
            [Scheduled] <= @Now AND
            [Priority] >= @MinimumPriority AND
            [ContactId] NOT IN (
                SELECT [ContactId]
                FROM [xdb_ma_pool].[ContactWorkerAffinity] WITH (READUNCOMMITTED)
                WHERE [WorkerId] <> @WorkerId
            )
        ORDER BY [Priority] DESC, [Scheduled] ASC, [Randomizer] ASC
    )
    -- Optimistically take the work items, but we need to ensure we have a lease for each one
    UPDATE TOP (@Size)
        [slice]
    SET
        [Scheduled] = @Timeout
    OUTPUT
        INSERTED.[Id] AS [Id],
        INSERTED.[ContactId] AS [ContactId],
        INSERTED.[ExecutionData] AS [ExecutionData],
        INSERTED.[ExecutionDataType] AS [ExecutionDataType],
        INSERTED.[Priority] AS [Priority],
        INSERTED.[Created] AS [Created],
        DELETED.[Scheduled] AS [Scheduled],
        INSERTED.[Attempts] AS [Attempts]
    INTO @Assigned

    -- Separate update and insert statements are faster than a merge statement in this case
    -- Extend existing leases
    UPDATE
        [xdb_ma_pool].[ContactWorkerAffinity]
    SET
        [LeaseExpiration] = @Timeout
    OUTPUT
        INSERTED.[ContactId]
    INTO
        @ConfirmedLease
    WHERE
        [WorkerId] = @WorkerId AND
        [ContactId] IN (
            SELECT [ContactId] FROM @Assigned
        )

    -- Try and aquire leases for contacts we don't currently have a lease on
    ;WITH [dedupContactIds] AS
    (
        SELECT DISTINCT [ContactId] FROM @Assigned
    )
    INSERT INTO [xdb_ma_pool].[ContactWorkerAffinity]
    (
        [Id],
        [ContactId],
        [WorkerId],
        [LeaseExpiration]
    )
    OUTPUT
        INSERTED.[ContactId]
    INTO
        @ConfirmedLease
    SELECT
        NEWID(),
        [ContactId],
        @WorkerId,
        @Timeout
    FROM
        [dedupContactIds]
    WHERE
        NOT EXISTS (
            SELECT 1 FROM
                [xdb_ma_pool].[ContactWorkerAffinity]
                WITH (TABLOCK)
            WHERE
                [ContactId] = [dedupContactIds].[ContactId]
        )

    -- Remove any work items we didn't get a lease for (another worker beat us to it)
    DELETE @Assigned
    WHERE [ContactId] NOT IN (
        SELECT [ContactId] FROM @ConfirmedLease
    )

    -- Update the attempts of the work items we're about to return
    UPDATE
        [xdb_ma_pool].[AutomationPool]
    SET
        [Attempts] = [Attempts] + 1
    WHERE [Id] IN
    (
        SELECT [Id] FROM @Assigned
    )

    SELECT
        [Id],
        [ContactId],
        [ExecutionData],
        [ExecutionDataType],
        [Priority],
        [Created],
        [Scheduled],
        CAST([Attempts] + 1 AS SMALLINT) AS [Attempts]
    FROM
        @Assigned
END
GO

PRINT N'Altering [xdb_ma_pool].[AutomationPool_SetTimeout]...';
GO

ALTER PROCEDURE [xdb_ma_pool].[AutomationPool_SetTimeout]
(
    @WorkItems [xdb_ma_pool].[WorkItemAttempts] READONLY,
    @TimeoutSeconds SMALLINT
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON

    IF ( ( @TimeoutSeconds IS NULL) OR ( @TimeoutSeconds < 1 ) )
    BEGIN
        RAISERROR( 'Parameter @TimeoutSeconds cannot be NULL or less than 1', 16, 1) WITH NOWAIT
        RETURN
    END

    DECLARE
        @Reschedule DATETIME2(7) = DATEADD(SECOND, @TimeoutSeconds, CAST( SYSUTCDATETIME() AS DATETIME2(7) )),
        @Results [xdb_ma_pool].[WorkItemResults]

    MERGE
        [xdb_ma_pool].[AutomationPool] WITH (HOLDLOCK) AS [target]
    USING
        @WorkItems AS [source]
    ON
    (
        [target].[Id] = [source].[Id] AND
        [target].[Attempts] = [source].[Attempts]
    )
    WHEN MATCHED THEN
        UPDATE SET
            [target].[Scheduled] = @Reschedule
    OUTPUT
        INSERTED.[Id],
        [xdb_ma].[StatusCode_Success](),
        NULL
    INTO
        @Results
    ;

    UPDATE
        [xdb_ma_pool].[ContactWorkerAffinity]
    SET
        [LeaseExpiration] = @Reschedule
    WHERE
        [ContactId] IN (
            SELECT [ContactId]
            FROM @WorkItems AS [WorkItems]
            INNER JOIN [xdb_ma_pool].[AutomationPool] AS [Pool]
            ON [WorkItems].[Id] = [Pool].[Id]
        )

    INSERT INTO @Results
    SELECT
        [Id],
        [xdb_ma].[StatusCode_WorkItemNotFound](),
        NULL
    FROM
        @WorkItems AS [source]
    WHERE
        NOT EXISTS
        (
            SELECT [Id]
            FROM [xdb_ma_pool].[AutomationPool]
            WHERE [Id] = [source].[Id]
        )

    INSERT INTO @Results
    SELECT
        [Id],
        [xdb_ma].[StatusCode_AttemptMismatch](),
        NULL
    FROM
        @WorkItems AS [source]
    WHERE
        EXISTS
        (
            SELECT [Id]
            FROM [xdb_ma_pool].[AutomationPool]
            WHERE
                [Id] = [source].[Id] AND
                [Attempts] != [source].[Attempts]
        )

    SELECT
        [Id],
        [StatusCode],
        [SystemMessage]
    FROM
        @Results
END
GO

PRINT N'Altering/Creating [xdb_ma_enrollment].[AutomationPool_SetTimeout]...';

IF EXISTS (SELECT * FROM sys.objects WHERE [type] = 'P' AND [name] = 'ActivityEnrollments_MergeContacts')
BEGIN
	DROP PROCEDURE [xdb_ma_enrollment].[ActivityEnrollments_MergeContacts]
END
GO

CREATE PROCEDURE [xdb_ma_enrollment].[ActivityEnrollments_MergeContacts]
(
    @ContactMerges [xdb_ma_enrollment].[ContactMerges] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Results [xdb_ma_enrollment].[ActivityEnrollmentKeys]

    MERGE
        [xdb_ma_enrollment].[ActivityEnrollments] WITH (HOLDLOCK) AS [Target]
    USING
        @ContactMerges AS [Source]
    ON
        [Source].[SourceContactId] = [Target].[ContactId]
    WHEN MATCHED
        THEN UPDATE SET
            [Target].[ContactId] = [Source].[TargetContactId]
    OUTPUT
        INSERTED.[ContactId],
        INSERTED.[PlanDefinitionId],
        INSERTED.[ContextKey],
        INSERTED.[ActivityId]
    INTO
        @Results
        (
            [ContactId],
            [PlanDefinitionId],
            [ContextKey],
            [ActivityId]
        );

    SELECT
        [ContactId],
        [PlanDefinitionId],
        [ContextKey],
        [ActivityId]
    FROM
        @Results
    AS
        Results;
END
GO

PRINT N'Altering/Creating [xdb_ma_pool].[AutomationPool_Stall]...';

IF EXISTS (SELECT * FROM sys.objects WHERE [type] = 'P' AND [name] = 'AutomationPool_Stall')
BEGIN
	DROP PROCEDURE [xdb_ma_pool].[AutomationPool_Stall]
END
GO

CREATE PROCEDURE [xdb_ma_pool].[AutomationPool_Stall]
(
    @WorkItemIDs [xdb_ma].[IDs] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Now DATETIME2(0) = CAST( SYSUTCDATETIME() AS DATETIME2(0) ),
        @Results [xdb_ma_pool].[WorkItemResults],
        @Id UNIQUEIDENTIFIER

    -- Add results for work items which cannot be found
    INSERT INTO
        @Results
    SELECT
        [Id],
        [xdb_ma].[StatusCode_WorkItemNotFound](),
        NULL
    FROM
        @WorkItemIDs AS [source]
    WHERE
        NOT EXISTS
        (
            SELECT 1
            FROM [xdb_ma_pool].[AutomationPool]
            WHERE [Id] = [source].[Id]
        )

    -- Move the records to the stalled table
    BEGIN TRY

        -- Try as a batch operation, which will work if there are no errors
        DELETE
            [xdb_ma_pool].[AutomationPool]
        OUTPUT
            DELETED.[Id],
            DELETED.[ContactId],
            DELETED.[ExecutionData],
            DELETED.[ExecutionDataType],
            DELETED.[Priority],
            @Now,
            DELETED.[Attempts]
        INTO
            [xdb_ma_pool].[StalledAutomationPool]
        WHERE
            [Id] IN (
                SELECT [Id] FROM @WorkItemIDs
            )

        -- Add results for work items which have been moved
        INSERT INTO
            @Results
        SELECT
            [Id],
            [xdb_ma].[StatusCode_Success](),
            NULL
        FROM
            @WorkItemIDs AS [source]
        WHERE
            EXISTS
            (
                SELECT 1
                FROM [xdb_ma_pool].[StalledAutomationPool]
                WHERE [Id] = [source].[Id]
            ) AND
            NOT EXISTS (
                SELECT 1
                FROM @Results [results]
                WHERE [source].[Id] = [results].[Id]
            )
    END TRY

    BEGIN CATCH

        -- Something went wrong, so at least one of the IDs is bad. Process each individually so the good data succeeds
        DECLARE
            IdRow CURSOR FOR
            SELECT
                [Id]
            FROM
                @WorkItemIDs

        OPEN IdRow

        FETCH NEXT FROM
            IdRow
        INTO
            @Id

        WHILE @@FETCH_STATUS = 0
        BEGIN

            BEGIN TRY

                DELETE
                    [xdb_ma_pool].[AutomationPool]
                OUTPUT
                    DELETED.[Id],
                    DELETED.[ContactId],
                    DELETED.[ExecutionData],
                    DELETED.[ExecutionDataType],
                    DELETED.[Priority],
                    @Now,
                    DELETED.[Attempts]
                INTO
                    [xdb_ma_pool].[StalledAutomationPool]
                WHERE
                    [Id] = @Id

                IF @@ROWCOUNT = 1
                BEGIN
                    INSERT INTO
                        @Results
                    SELECT
                        @Id,
                        [xdb_ma].[StatusCode_Success](),
                        NULL
                END

            END TRY

            BEGIN CATCH

                INSERT INTO @Results
                (
                    [Id],
                    [StatusCode],
                    [SystemMessage]
                )
                VALUES
                (
                    @Id,
                    CASE ERROR_NUMBER()
                        WHEN 2627 THEN [xdb_ma].[StatusCode_TheEntryAlreadyExists]() -- Violation in unique constraint
                        WHEN 2601 THEN [xdb_ma].[StatusCode_TheEntryAlreadyExists]() -- Violation in unique index
                        ELSE [xdb_ma].[StatusCode_GeneralFailure]()
                    END,
                    ERROR_MESSAGE()
                )

            END CATCH

            FETCH NEXT FROM
            IdRow
        INTO
            @Id

        END

        CLOSE IdRow
        DEALLOCATE IdRow

    END CATCH

    SELECT
        [Id],
        [StatusCode],
        [SystemMessage]
    FROM
        @Results
    AS
        Results
END
GO

PRINT N'Altering/Creating [xdb_ma_pool].[ContactWorkerAffinity_ReleaseLease]...';

IF EXISTS (SELECT * FROM sys.objects WHERE [type] = 'P' AND [name] = 'ContactWorkerAffinity_ReleaseLease')
BEGIN
	DROP PROCEDURE [xdb_ma_pool].[ContactWorkerAffinity_ReleaseLease]
END
GO

CREATE PROCEDURE [xdb_ma_pool].[ContactWorkerAffinity_ReleaseLease]
(
    @ContactId UNIQUEIDENTIFIER,
    @WorkerId UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON

    IF (@ContactId IS NULL)
    BEGIN
        RAISERROR( 'Parameter @ContactId cannot be NULL', 16, 1) WITH NOWAIT
        RETURN
    END

    IF (@WorkerId IS NULL)
    BEGIN
        RAISERROR( 'Parameter @WorkerId cannot be NULL', 16, 1) WITH NOWAIT
        RETURN
    END

    DELETE
        [xdb_ma_pool].[ContactWorkerAffinity]
    WHERE
        [WorkerId] = @WorkerId AND
        [ContactId] = @ContactId
END
GO

PRINT N'Altering/Creating [xdb_ma_pool].[ContactWorkerAffinity_TakeLease]...';

IF EXISTS (SELECT * FROM sys.objects WHERE [type] = 'P' AND [name] = 'ContactWorkerAffinity_TakeLease')
BEGIN
	DROP PROCEDURE [xdb_ma_pool].[ContactWorkerAffinity_TakeLease]
END
GO

CREATE PROCEDURE [xdb_ma_pool].[ContactWorkerAffinity_TakeLease]
(
    @ContactId UNIQUEIDENTIFIER,
    @WorkerId UNIQUEIDENTIFIER,
    @TimeoutSeconds SMALLINT
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON

    IF (@ContactId IS NULL)
    BEGIN
        RAISERROR( 'Parameter @ContactId cannot be NULL', 16, 1) WITH NOWAIT
        RETURN
    END

    IF (@WorkerId IS NULL)
    BEGIN
        RAISERROR( 'Parameter @WorkerId cannot be NULL', 16, 1) WITH NOWAIT
        RETURN
    END

    IF ( (@TimeoutSeconds IS NULL) OR (@TimeoutSeconds <= 0) )
    BEGIN
        RAISERROR( 'Parameter @TimeoutSeconds cannot be NULL and must be greater than 0', 16, 1) WITH NOWAIT
        RETURN
    END

    DECLARE
        @Now DATETIME2(7) = CAST( SYSUTCDATETIME() AS DATETIME2(7) )

    DECLARE
        @Timeout DATETIME2(7) = DATEADD(SECOND, @TimeoutSeconds, @Now)

    -- Clean up old leases before processing
    DELETE
        [xdb_ma_pool].[ContactWorkerAffinity]
    WHERE
        [LeaseExpiration] <= @Now

    -- update an existing lease if it exists
    UPDATE
        [xdb_ma_pool].[ContactWorkerAffinity]
    SET
        [LeaseExpiration] = @Timeout
    WHERE
        [WorkerId] = @WorkerId AND
        [ContactId] = @ContactId

    IF @@ROWCOUNT >= 1
    BEGIN
        RETURN 1
    END

    -- add new leases
    INSERT INTO [xdb_ma_pool].[ContactWorkerAffinity]
    (
        [Id],
        [ContactId],
        [WorkerId],
        [LeaseExpiration]
    )
    SELECT
        NEWID(),
        @ContactId,
        @WorkerId,
        @Timeout
    WHERE
        NOT EXISTS (
            SELECT 1 FROM
                [xdb_ma_pool].[ContactWorkerAffinity]
                WITH (TABLOCK)
            WHERE
                [ContactId] = @ContactId
        )

    IF @@ROWCOUNT >= 1
    BEGIN
        RETURN 1
    END

    RETURN 0
END
GO

PRINT N'Update complete.';
