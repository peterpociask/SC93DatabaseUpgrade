/*
Deployment script for Sitecore.Processing.Engine.Tasks
*/
GO

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

PRINT N'Altering [sitecore_processing_tasks].[UpdateTaskStatusById]...';
GO

ALTER PROCEDURE [sitecore_processing_tasks].[UpdateTaskStatusById]
(
    @Id UNIQUEIDENTIFIER,
    @Status SMALLINT,
    @Error NVARCHAR(MAX),
    @ConcurrencyToken UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

    IF( (@Id IS NULL) )
    BEGIN
        RAISERROR( N'Parameter @Id is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( (@Status IS NULL) )
    BEGIN
        RAISERROR( N'Parameter @Status is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( (@ConcurrencyToken IS NULL) )
    BEGIN
        RAISERROR( N'Parameter @ConcurrencyToken is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    DECLARE @Added DATETIME2;
    DECLARE @Updated DATETIME2;
    DECLARE @NewConcurrencyToken UNIQUEIDENTIFIER;
    DECLARE @Expiration DATETIME2;
    DECLARE @Type SMALLINT;
    DECLARE @Progress BIGINT;
    DECLARE @Total BIGINT;
    DECLARE @Description NVARCHAR(256);
    DECLARE @Options VARBINARY(MAX);
    DECLARE @RaiseModified BIT = 0;
    DECLARE @RaiseAlreadyExists BIT = 0;
    DECLARE @DependentTaskId UNIQUEIDENTIFIER = NULL;
    DECLARE @DependentTaskConcurrencyToken UNIQUEIDENTIFIER = NULL;

    BEGIN TRY
        BEGIN TRANSACTION;

        SET @Updated = SYSUTCDATETIME();
        SET @NewConcurrencyToken = NEWID();

        SELECT
            @Added = [Added],
            @Expiration = [Expiration],
            @Type = [Type],
            @Progress = [Progress],
            @Total = [Total],
            @Description = [Description],
            @Options = [Options]
        FROM
            [sitecore_processing_tasks].[Tasks]
        WHERE
            [Id] = @Id AND
            [ConcurrencyToken] = @ConcurrencyToken;

        DECLARE @rowCount INT = @@ROWCOUNT;

        IF( @rowCount > 0 )
        BEGIN
            UPDATE
                [sitecore_processing_tasks].[Tasks]
            SET
                [Updated] = @Updated,
                [ConcurrencyToken] = @NewConcurrencyToken,
                [Status] = @Status,
                [Error] = @Error
            WHERE
                [Id] = @Id AND
                [ConcurrencyToken] = @ConcurrencyToken;

            SET @rowCount = @@ROWCOUNT;
        END;

        IF( @rowCount = 0 )
        BEGIN
            IF( NOT EXISTS( SELECT 1 FROM [sitecore_processing_tasks].[Tasks] WHERE ( [Id] = @Id) ) )
            BEGIN
                SET @RaiseAlreadyExists = 1;
                ROLLBACK TRANSACTION;
            END;
            ELSE
            BEGIN
                SET @RaiseModified = 1;
                ROLLBACK TRANSACTION;
            END
        END;
        ELSE
        BEGIN
            COMMIT TRANSACTION;
        END
    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

    IF( @RaiseAlreadyExists = 1)
    BEGIN
        RAISERROR( N'A processing task with the specified unique identifier does not exist.', 16, 1 ) WITH NOWAIT;
        RETURN -3;
    END;
    ELSE IF( @RaiseModified = 1)
    BEGIN
        RAISERROR( N'The processing task has been concurrently modified.', 16, 1 ) WITH NOWAIT;
        RETURN -6;
    END

    -- Update dependent tasks for failures
    IF @Status IN (3, 4, 5) -- ProcessingTaskStatus.Failed, ProcessingTaskStatus.Expired, ProcessingTaskStatus.Canceled
    BEGIN
        DECLARE [DependentTasks] CURSOR LOCAL FOR
        SELECT
            [TaskId],
            [ConcurrencyToken]
        FROM
            [sitecore_processing_tasks].[TaskDependencies]
        INNER JOIN
            [sitecore_processing_tasks].[Tasks]
        ON
            [sitecore_processing_tasks].[TaskDependencies].[TaskId] = [sitecore_processing_tasks].[Tasks].[Id]
        WHERE
            [PrerequisiteTaskId] = @Id

        OPEN [DependentTasks]

        FETCH NEXT FROM [DependentTasks] INTO @DependentTaskId, @DependentTaskConcurrencyToken

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [sitecore_processing_tasks].[UpdateTaskStatusById]
                @Id = @DependentTaskId,
                @Status = @Status,
                @Error = @Error,
                @ConcurrencyToken = @DependentTaskConcurrencyToken

            FETCH NEXT FROM [DependentTasks] INTO @DependentTaskId, @DependentTaskConcurrencyToken
        END

        CLOSE [DependentTasks]
        DEALLOCATE [DependentTasks]
    END

    SELECT @Id AS [Id],
           @Added AS [Added],
           @Updated AS [Updated],
           @NewConcurrencyToken AS [ConcurrencyToken],
           @Expiration AS [Expiration],
           @Status AS [Status],
           @Type AS [Type],
           @Progress AS [Progress],
           @Total AS [Total],
           @Error AS [Error],
           @Description AS [Description],
           @Options AS [Options];

    SELECT
        [PrerequisiteTaskId]
    FROM
        [sitecore_processing_tasks].[TaskDependencies]
    WHERE
        ([TaskId] = @Id);

    RETURN 0;
END;
GO

PRINT N'Altering [sitecore_processing_tasks].[UpdateTaskTotalById]...';
GO

ALTER PROCEDURE [sitecore_processing_tasks].[UpdateTaskTotalById]
(
    @Id UNIQUEIDENTIFIER,
    @Total BIGINT,
    @ConcurrencyToken UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;
    -- Next line is commented as a workaround for the following SQL Server bug:
    -- https://feedback.azure.com/forums/908035-sql-server/suggestions/34960006-sql-server-stored-procedure-selecting-encrypted-da
    -- SET XACT_ABORT ON;

    IF( (@Id IS NULL) )
    BEGIN
        RAISERROR( N'Parameter @Id is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( (@ConcurrencyToken IS NULL) )
    BEGIN
        RAISERROR( N'Parameter @ConcurrencyToken is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    DECLARE @Added DATETIME2;
    DECLARE @Updated DATETIME2;
    DECLARE @NewConcurrencyToken UNIQUEIDENTIFIER;
    DECLARE @Expiration DATETIME2;
    DECLARE @Status SMALLINT;
    DECLARE @Type SMALLINT;
    DECLARE @Progress BIGINT;
    DECLARE @Error NVARCHAR(MAX);
    DECLARE @Description NVARCHAR(256);
    DECLARE @Options VARBINARY(MAX);

    DECLARE @RaiseConcurrentlyModified BIT = 0;
    DECLARE @RaiseNotExists BIT = 0;
    DECLARE @RaiseInvalidTaskType BIT = 0;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        BEGIN TRANSACTION;

        SET @Updated = SYSUTCDATETIME();
        SET @NewConcurrencyToken = NEWID();

        SELECT
            @Added = [Added],
            @Expiration = [Expiration],
            @Status = [Status],
            @Type = [Type],
            @Progress = [Progress],
            @Error = [Error],
            @Description = [Description],
            @Options = [Options]
        FROM
            [sitecore_processing_tasks].[Tasks]
        WHERE
            [Id] = @Id AND
            [ConcurrencyToken] = @ConcurrencyToken

        DECLARE @rowCount INT = @@ROWCOUNT;

        IF( @rowCount = 0 )
        BEGIN
            IF( NOT EXISTS( SELECT 1 FROM [sitecore_processing_tasks].[Tasks] WHERE ( [Id] = @Id) ) )
                BEGIN
                    SET @RaiseNotExists = 1;
                END;
            ELSE
                BEGIN
                    SET @RaiseConcurrentlyModified = 1;
                END
        END
        ELSE
            BEGIN
                IF ( @Type = 0 )
                    BEGIN
                        SET @RaiseInvalidTaskType = 1;
                    END
                ELSE
                    BEGIN
                        UPDATE
                            [sitecore_processing_tasks].[Tasks]
                        SET
                            [Updated] = @Updated,
                            [ConcurrencyToken] = @NewConcurrencyToken,
                            [Total] = @Total
                        WHERE
                            [Id] = @Id AND
                            [ConcurrencyToken] = @ConcurrencyToken
                    END
            END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        ;THROW
    END CATCH

    IF( @RaiseNotExists = 1)
    BEGIN
        RAISERROR( N'A processing task with the specified unique identifier does not exist.', 16, 1 ) WITH NOWAIT;
        RETURN -3;
    END;
    ELSE IF( @RaiseConcurrentlyModified = 1)
    BEGIN
        RAISERROR( N'The processing task has been concurrently modified.', 16, 1 ) WITH NOWAIT;
        RETURN -6;
    END
    ELSE IF( @RaiseInvalidTaskType = 1)
    BEGIN
        RAISERROR( N'Update total is applicable for DistributedProcessing tasks only.', 16, 1 ) WITH NOWAIT;
        RETURN -7;
    END

    SELECT @Id AS [Id],
           @Added AS [Added],
           @Updated AS [Updated],
           @NewConcurrencyToken AS [ConcurrencyToken],
           @Expiration AS [Expiration],
           @Status AS [Status],
           @Type AS [Type],
           @Progress AS [Progress],
           @Total AS [Total],
           @Error AS [Error],
           @Description AS [Description],
           @Options AS [Options];

    RETURN 0;
END;
GO

PRINT N'Altering [sitecore_processing_tasks].[GetDependentTaskIds]...';
GO

-- GetDependentTaskIds does not exist in 9.1.0. Create it in case of upgrade from 9.1.0.
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sitecore_processing_tasks].[GetDependentTaskIds]') AND type in (N'P', N'PC'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [sitecore_processing_tasks].[GetDependentTaskIds] AS'
END
GO

ALTER PROCEDURE [sitecore_processing_tasks].[GetDependentTaskIds]
(
    @TaskId UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF (@TaskId IS NULL)
    BEGIN
        RAISERROR( N'Parameter @TaskId is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    DECLARE @CurrentPosition INT = -1;
    DECLARE @CurrentTaskId UNIQUEIDENTIFIER = @TaskId;
    DECLARE @DependentTasksCount INT = 0;

    -- List of all task IDs that are dependent on @TaskId (explicitly or transitively).
    DECLARE @DependentTaskIds TABLE
    (
        [RowNumber] INT IDENTITY(0, 1) NOT NULL,
        [Id] UNIQUEIDENTIFIER NOT NULL
    );

    WHILE (@CurrentPosition < @DependentTasksCount)
    BEGIN
        INSERT INTO @DependentTaskIds([Id])
            SELECT
                DISTINCT
                taskDeps.[TaskId]
            FROM
                [sitecore_processing_tasks].[TaskDependencies] AS taskDeps
            WHERE
                taskDeps.[PrerequisiteTaskId] = @CurrentTaskId AND
                -- checks to prevent circular dependencies
                taskDeps.[TaskId] <> @TaskId AND
                taskDeps.[TaskId] NOT IN
                (
                    SELECT [Id] FROM @DependentTaskIds
                );

        SET @DependentTasksCount = @DependentTasksCount + @@ROWCOUNT;
        SET @CurrentPosition = @CurrentPosition + 1;
        SET @CurrentTaskId = (SELECT [Id] FROM @DependentTaskIds WHERE [RowNumber] = @CurrentPosition);
    END;

    SELECT
        DISTINCT
        [Id]
    FROM
        @DependentTaskIds;

    RETURN 0;
END;
GO

PRINT N'Altering [sitecore_processing_tasks].[PickDistributedTaskInProgress]...';
GO

ALTER PROCEDURE [sitecore_processing_tasks].[PickDistributedTaskInProgress]
(
  @SplitThreshold INT,
  @OwnershipTimeout INT
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF( (@SplitThreshold IS NULL) OR (@SplitThreshold <= 0 ) )
    BEGIN
        RAISERROR( N'Parameter @SplitThreshold is NULL or less than 1.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( (@OwnershipTimeout IS NULL) OR (@OwnershipTimeout <= 0 ) )
    BEGIN
        RAISERROR( N'Parameter @OwnershipTimeout is NULL or less than 1.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    BEGIN TRY

        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

        DECLARE @Candidates TABLE
        (
            [Id] UNIQUEIDENTIFIER NOT NULL,
            [Position] BIGINT NOT NULL PRIMARY KEY
        );

        BEGIN TRANSACTION;

        INSERT INTO
            @Candidates
        SELECT
            [Tasks].[Id], ROW_NUMBER() OVER( ORDER BY [Added] ASC )
        FROM
            [sitecore_processing_tasks].[Tasks] as Tasks
        LEFT JOIN
            [sitecore_processing_tasks].[Cursors] as Cursors
        ON
            Tasks.[Id] = Cursors.[TaskId]
        WHERE
            [Status] = 1 AND                                                            -- ProcessingTaskStatus.Processing
            [Type] = 1 AND                                                              -- ProcessingTaskType.DistributedRangeProcessing
            [IsSplitSupported] = 1 AND
            (
                [Total] - [Progress] > @SplitThreshold OR                               -- Total - Progress is bigger than threshold for split to ensure that we return task in progress only if split is possible.
                DATEDIFF(second, [Updated], SYSUTCDATETIME()) > @OwnershipTimeout       -- Ensure that if agent died in the end of the task, when split is not possible, the task will be picked up by the other agent.
            );

        DECLARE @Count INTEGER = (SELECT COUNT( 1 ) FROM @Candidates);
        DECLARE @Picked BIGINT = CAST( (FLOOR( (RAND( ) * @Count) ) + 1) AS BIGINT );
        DECLARE @Id UNIQUEIDENTIFIER;

        SELECT
            @Id = [Id]
        FROM
            @Candidates
        WHERE
            ([Position] = @Picked);

        IF (@Id IS NOT NULL)
        BEGIN
-- Updating expired task to make it not expired, to prevent multiple agents taking the task. See #300458.
            UPDATE
                [sitecore_processing_tasks].[Tasks]
            SET
                [Updated] = SYSUTCDATETIME()
            WHERE
                [Id] = @Id AND
                DATEDIFF(second, [Updated], SYSUTCDATETIME()) > @OwnershipTimeout
        END

        SELECT
            [Id],
            [Added],
            [Updated],
            [ConcurrencyToken],
            [Expiration],
            [Status],
            [Type],
            [Progress],
            [Total],
            [Error],
            [Description],
            [Options]
        FROM
            [sitecore_processing_tasks].[Tasks]
        WHERE
            [Id] = @Id;

        COMMIT TRANSACTION;

        RETURN 0;
    END TRY
    BEGIN CATCH

        IF @@trancount > 0
            ROLLBACK TRANSACTION;

        ;THROW
    END CATCH
END;
GO

-- IMPORTANT!
-- GrantLeastPrivilege should be updated at the last step, to ensure that all stored procs,
-- that are used to grant permissions to, are available.
PRINT N'Altering [sitecore_processing_tasks].[GrantLeastPrivilege]...';
GO

ALTER PROCEDURE [sitecore_processing_tasks].[GrantLeastPrivilege]
(
    @Name SYSNAME
)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    IF (LEN(ISNULL(@Name, N'')) = 0)
    BEGIN
        RAISERROR( 'Parameter @Name cannot be null or empty', 16, 1 ) WITH NOWAIT;
        RETURN
    END;

    IF (@Name LIKE N'%[^a-zA-Z0-9_$\-\ \\]%' ESCAPE '\')
    BEGIN
        RAISERROR( 'Parameter @Name cannot contain special characters', 16, 1) WITH NOWAIT
        RETURN
    END

    IF (NOT EXISTS (SELECT [name] FROM [sys].[database_principals] WHERE [name] = @Name))
    BEGIN
        RAISERROR( 'Parameter @Name should contain name of the existing user.', 16, 1) WITH NOWAIT
        RETURN
    END

    EXECUTE ('
        grant execute on [sitecore_processing_tasks].[AddCursor] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[AddTask] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[CheckAllCursorsCompleted] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[DeleteCursorsByTaskId] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[GetCursorsCountByTaskId] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[GetDependentTaskIds] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[GetTaskById] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[GetTotalNumberOfConsumedItemsByTaskId] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[IncrementTaskProgressById] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[MarkCursorCompleted] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[PickDeferredTask] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[PickDistributedTaskInProgress] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[PickDistributedTaskPending] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[RemoveExpiredTasks] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[RemoveTaskById] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[TryAcquireCursor] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[TryRegisterCursorSplitRequest] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[UpdateCursorAfterSplit] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[UpdateCursorProgress] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[UpdateCursorSize] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[UpdateCursorSplitSupported] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[UpdateTaskStatusById] TO [' + @Name + ']
        grant execute on [sitecore_processing_tasks].[UpdateTaskTotalById] TO [' + @Name + ']');
END
GO

PRINT N'Update complete.';
GO
