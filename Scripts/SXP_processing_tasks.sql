/*
Deployment script for Sitecore.Processing.Tasks
*/
GO

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

PRINT N'Dropping [xdb_processing_tasks].[FK_HistoryCursors_Task_HistoryTasks_Id]...';
GO

ALTER TABLE [xdb_processing_tasks].[HistoryCursors] DROP CONSTRAINT [FK_HistoryCursors_Task_HistoryTasks_Id];
GO

PRINT N'Dropping [xdb_processing_tasks].[FK_RebuildTargetStates_To_HistoryTaskStates_Id]...';
GO

ALTER TABLE [xdb_processing_tasks].[RebuildTargetStates] DROP CONSTRAINT [FK_RebuildTargetStates_To_HistoryTaskStates_Id];
GO

PRINT N'Starting rebuilding table [xdb_processing_tasks].[HistoryTasks]...';
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [xdb_processing_tasks].[tmp_ms_xx_HistoryTasks] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [StartedAt]        DATETIME2 (7)    NULL,
    [FinishedAt]       DATETIME2 (7)    NULL,
    [Cutoff]           DATETIME2 (7)    NOT NULL,
    [MinStartDateTime] DATETIME2 (7)    NOT NULL,
    [State]            SMALLINT         NOT NULL,
    [Processed]        BIGINT           NOT NULL,
    [Total]            BIGINT           NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_HistoryTasks1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

ALTER TABLE [xdb_processing_tasks].[tmp_ms_xx_HistoryTasks] ADD CONSTRAINT [DF_HistoryTasks_MinStartDateTime] DEFAULT '0001-01-01T12:00:00' FOR [MinStartDateTime];

IF EXISTS (SELECT TOP 1 1 
           FROM   [xdb_processing_tasks].[HistoryTasks])
    BEGIN
        INSERT INTO [xdb_processing_tasks].[tmp_ms_xx_HistoryTasks] ([Id], [StartedAt], [FinishedAt], [Cutoff], [State], [Processed], [Total])
        SELECT   [Id],
                 [StartedAt],
                 [FinishedAt],
                 [Cutoff],
                 [State],
                 [Processed],
                 [Total]
        FROM     [xdb_processing_tasks].[HistoryTasks]
        ORDER BY [Id] ASC;
    END

DROP TABLE [xdb_processing_tasks].[HistoryTasks];

EXECUTE sp_rename N'[xdb_processing_tasks].[tmp_ms_xx_HistoryTasks]', N'HistoryTasks';

EXECUTE sp_rename N'[xdb_processing_tasks].[tmp_ms_xx_constraint_PK_HistoryTasks1]', N'PK_HistoryTasks', N'OBJECT';

ALTER TABLE [xdb_processing_tasks].[HistoryTasks] DROP [DF_HistoryTasks_MinStartDateTime];

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

PRINT N'Starting rebuilding table [xdb_processing_tasks].[HistoryTaskStates]...';
GO

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [xdb_processing_tasks].[tmp_ms_xx_HistoryTaskStates] (
    [TaskStateId]           UNIQUEIDENTIFIER NOT NULL,
    [LastChanged]           DATETIME2 (7)    NOT NULL,
    [Started]               DATETIME2 (7)    NOT NULL,
    [Step]                  SMALLINT         NOT NULL,
    [CutOffDate]            DATETIME2 (7)    NOT NULL,
    [MinStartDateTime]      DATETIME2 (7)    NOT NULL,
    [TimeToClearStorage]    BIGINT           NOT NULL,
    [TimeToStopAggregation] BIGINT           NOT NULL,
    [Error]                 NVARCHAR (2048)  NULL,
    [ReportingConfigPath]   NVARCHAR (256)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_HistoryTaskStates1] PRIMARY KEY CLUSTERED ([TaskStateId] ASC)
);

ALTER TABLE [xdb_processing_tasks].[tmp_ms_xx_HistoryTaskStates] ADD CONSTRAINT [DF_HistoryTaskStates_MinStartDateTime] DEFAULT '0001-01-01T12:00:00' FOR [MinStartDateTime];

IF EXISTS (SELECT TOP 1 1 
           FROM   [xdb_processing_tasks].[HistoryTaskStates])
    BEGIN
        INSERT INTO [xdb_processing_tasks].[tmp_ms_xx_HistoryTaskStates] ([TaskStateId], [LastChanged], [Started], [Step], [CutOffDate], [TimeToClearStorage], [TimeToStopAggregation], [Error], [ReportingConfigPath])
        SELECT   [TaskStateId],
                 [LastChanged],
                 [Started],
                 [Step],
                 [CutOffDate],
                 [TimeToClearStorage],
                 [TimeToStopAggregation],
                 [Error],
                 [ReportingConfigPath]
        FROM     [xdb_processing_tasks].[HistoryTaskStates]
        ORDER BY [TaskStateId] ASC;
    END

DROP TABLE [xdb_processing_tasks].[HistoryTaskStates];

EXECUTE sp_rename N'[xdb_processing_tasks].[tmp_ms_xx_HistoryTaskStates]', N'HistoryTaskStates';

EXECUTE sp_rename N'[xdb_processing_tasks].[tmp_ms_xx_constraint_PK_HistoryTaskStates1]', N'PK_HistoryTaskStates', N'OBJECT';

ALTER TABLE [xdb_processing_tasks].[HistoryTaskStates] DROP [DF_HistoryTaskStates_MinStartDateTime]; 

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

PRINT N'Creating [xdb_processing_tasks].[FK_HistoryCursors_Task_HistoryTasks_Id]...';
GO

ALTER TABLE [xdb_processing_tasks].[HistoryCursors] WITH NOCHECK
    ADD CONSTRAINT [FK_HistoryCursors_Task_HistoryTasks_Id] FOREIGN KEY ([TaskId]) REFERENCES [xdb_processing_tasks].[HistoryTasks] ([Id]);
GO

PRINT N'Creating [xdb_processing_tasks].[FK_RebuildTargetStates_To_HistoryTaskStates_Id]...';
GO

ALTER TABLE [xdb_processing_tasks].[RebuildTargetStates] WITH NOCHECK
    ADD CONSTRAINT [FK_RebuildTargetStates_To_HistoryTaskStates_Id] FOREIGN KEY ([TaskStateId]) REFERENCES [xdb_processing_tasks].[HistoryTaskStates] ([TaskStateId]);
GO

PRINT N'Altering [xdb_processing_tasks].[History_AddTask]...';
GO

ALTER PROCEDURE [xdb_processing_tasks].[History_AddTask]
(
  @Id UNIQUEIDENTIFIER,
  @StartedAt DATETIME2,
  @FinishedAt DATETIME2,
  @Cutoff DATETIME2,
  @MinStartDateTime DATETIME2,
  @State SMALLINT,
  @Processed BIGINT,
  @Total BIGINT
)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  IF( (@Id IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Id is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@Cutoff IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Cutoff is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@MinStartDateTime IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @MinStartDateTime is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@State IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @State is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@Processed IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Processed is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@Total IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Total is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  INSERT INTO [xdb_processing_tasks].[HistoryTasks]
  (
    [Id],
    [StartedAt],
    [FinishedAt],
    [Cutoff],
    [MinStartDateTime],
    [State],
    [Processed],
    [Total]
  )
  VALUES
  (
    @Id,
    @StartedAt,
    @FinishedAt,
    @Cutoff,
    @MinStartDateTime,
    @State,
    @Processed,
    @Total
  );

  RETURN 0;

END;
GO

PRINT N'Altering [xdb_processing_tasks].[History_GetTaskById]...';
GO

ALTER PROCEDURE [xdb_processing_tasks].[History_GetTaskById]
(
  @Id UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  IF( (@Id IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Id is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  SELECT 
    [Id],
    [StartedAt],
    [FinishedAt],
    [Cutoff],
    [MinStartDateTime],
    [State],
    [Processed],
    [Total]
  FROM
    [xdb_processing_tasks].[HistoryTasks]
  WHERE
    [Id] = @Id;

    RETURN 0;
END;
GO

PRINT N'Altering [xdb_processing_tasks].[History_TryUpdateTaskById]...';
GO

ALTER PROCEDURE [xdb_processing_tasks].[History_TryUpdateTaskById]
(
  @Id UNIQUEIDENTIFIER,
  @StartedAt DATETIME2,
  @FinishedAt DATETIME2,
  @Cutoff DATETIME2,
  @MinStartDateTime DATETIME2,
  @State SMALLINT,
  @Processed BIGINT,
  @Total BIGINT
)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  IF( (@Id IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Id is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@StartedAt IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @StartedAt is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@Cutoff IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Cutoff is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@MinStartDateTime IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @MinStartDateTime is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@State IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @State is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@Processed IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Processed is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  IF( (@Total IS NULL) )
  BEGIN
    RAISERROR( N'Parameter @Total is NULL.', 16, 1 ) WITH NOWAIT;
    RETURN -1;
  END;

  UPDATE
    [xdb_processing_tasks].[HistoryTasks]
  SET
    [StartedAt] = @StartedAt,
    [FinishedAt] = @FinishedAt,
    [Cutoff] = @Cutoff,
    [MinStartDateTime] = @MinStartDateTime,
    [State] = @State,
    [Processed] = @Processed,
    [Total] = @Total
  WHERE
    [Id] = @Id;

  DECLARE @rowCount INT = @@ROWCOUNT;

  IF @rowCount = 0 
    RETURN -3;
  ELSE
    RETURN 0;

END;
GO

PRINT N'Altering [xdb_processing_tasks].[History_AddTaskState]...';
GO

ALTER PROCEDURE [xdb_processing_tasks].[History_AddTaskState]
(
    @TaskStateId UNIQUEIDENTIFIER,
    @LastChanged DATETIME2,
    @Started DATETIME2,
    @Step SMALLINT,
    @CutOffDate DATETIME2,
    @MinStartDateTime DATETIME2,
    @TimeToClearStorage BIGINT,
    @TimeToStopAggregation BIGINT,
    @Error NVARCHAR(2048),
    @ReportingConfigPath NVARCHAR(256)
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    IF( @TaskStateId IS NULL )
    BEGIN
        RAISERROR( N'The @TaskStateId parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @LastChanged IS NULL )
    BEGIN
        RAISERROR( N'The @LastChanged parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @Started IS NULL )
    BEGIN
        RAISERROR( N'The @Started parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @Step IS NULL )
    BEGIN
        RAISERROR( N'The @Step parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @CutOffDate IS NULL )
    BEGIN
        RAISERROR( N'The @CutOffDate parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @MinStartDateTime IS NULL )
    BEGIN
        RAISERROR( N'The @MinStartDateTime parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @TimeToClearStorage IS NULL )
    BEGIN
        RAISERROR( N'The @TimeToClearStorage parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @TimeToStopAggregation IS NULL )
    BEGIN
        RAISERROR( N'The @TimeToStopAggregation parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    IF( @ReportingConfigPath IS NULL )
    BEGIN
        RAISERROR( N'The @ReportingConfigPath parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    DECLARE @Raise BIT = 0;

    BEGIN TRY

        BEGIN TRANSACTION;

        IF( EXISTS( SELECT 1 FROM [xdb_processing_tasks].[HistoryTaskStates] WHERE ([TaskStateId] = @TaskStateId) ) )
        BEGIN
            SET @Raise = 1;
            ROLLBACK TRANSACTION;
        END;
        ELSE
        BEGIN 
            INSERT INTO [xdb_processing_tasks].[HistoryTaskStates]
            (
                [TaskStateId],
                [LastChanged],
                [Started],
                [Step],
                [CutOffDate],
                [MinStartDateTime],
                [TimeToClearStorage],
                [TimeToStopAggregation],
                [Error],
                [ReportingConfigPath]
            )
            VALUES
            (
                @TaskStateId,
                @LastChanged,
                @Started,
                @Step,
                @CutOffDate,
                @MinStartDateTime,
                @TimeToClearStorage,
                @TimeToStopAggregation,
                @Error,
                @ReportingConfigPath
            );

            COMMIT TRANSACTION;

            RETURN 0;
        END
    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

    IF(@Raise = 1 )
    BEGIN
        RAISERROR( N'A rebuild process state with the specified unique identifier already exists.', 16, 1 ) WITH NOWAIT;
        RETURN -2;
    END;

END;
GO

PRINT N'Altering [xdb_processing_tasks].[History_GetTaskStateById]...';
GO

ALTER PROCEDURE [xdb_processing_tasks].[History_GetTaskStateById]
(
    @TaskStateId UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER
AS
BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

    IF( @TaskStateId IS NULL )
    BEGIN
        RAISERROR( N'The @TaskStateId parameter is not set.', 16, 1 ) WITH NOWAIT;
        RETURN -1;
    END;

    DECLARE @Raise BIT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF( NOT EXISTS( SELECT 1 FROM [xdb_processing_tasks].[HistoryTaskStates] WHERE ([TaskStateId] = @TaskStateId) ) )
        BEGIN
            SET @Raise = 1;
            ROLLBACK TRANSACTION;
        END;
        ELSE
        BEGIN 
            SELECT
                [TaskStateId],
                [LastChanged],
                [Started],
                [Step],
                [CutOffDate],
                [MinStartDateTime],
                [TimeToClearStorage],
                [TimeToStopAggregation],
                [Error],
                [ReportingConfigPath]
            FROM
                [xdb_processing_tasks].[HistoryTaskStates]
            WHERE
                ([TaskStateId] = @TaskStateId);

            SELECT
                [TaskStateId],
                [Type],
                [State],
                [EstimatedTotalRecords],
                [ProcessedRecords],
                [StartedAt],
                [FinishedAt],
                [Exception]
            FROM
                [xdb_processing_tasks].[RebuildTargetStates]
            WHERE
                ([TaskStateId] = @TaskStateId);

            COMMIT TRANSACTION;

            RETURN 0;
        END;
    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        ;THROW

    END CATCH

    IF(@Raise = 1)
    BEGIN
        RAISERROR( N'A rebuild process with the specified unique identifier does not exist.', 16, 1 ) WITH NOWAIT;
        RETURN -3;
    END;
END;
GO

PRINT N'Refreshing [xdb_processing_tasks].[History_TryDeleteTaskById]...';
GO

EXECUTE sp_refreshsqlmodule N'[xdb_processing_tasks].[History_TryDeleteTaskById]';
GO

PRINT N'Refreshing [xdb_processing_tasks].[History_DeleteTaskStateById]...';
GO

EXECUTE sp_refreshsqlmodule N'[xdb_processing_tasks].[History_DeleteTaskStateById]';
GO

PRINT N'Refreshing [xdb_processing_tasks].[History_UpdateTaskState]...';
GO

EXECUTE sp_refreshsqlmodule N'[xdb_processing_tasks].[History_UpdateTaskState]';
GO

PRINT N'Checking existing data against newly created constraints';
GO

ALTER TABLE [xdb_processing_tasks].[HistoryCursors] WITH CHECK CHECK CONSTRAINT [FK_HistoryCursors_Task_HistoryTasks_Id];
ALTER TABLE [xdb_processing_tasks].[RebuildTargetStates] WITH CHECK CHECK CONSTRAINT [FK_RebuildTargetStates_To_HistoryTaskStates_Id];
GO

PRINT N'Altering [xdb_processing_tasks].[GrantLeastPrivilege]...';
GO

ALTER PROCEDURE [xdb_processing_tasks].[GrantLeastPrivilege]
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
        grant execute on [xdb_processing_tasks].[History_AddCursor] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_AddTargetState] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_AddTask] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_AddTaskState] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_AreAllCursorsCompleted] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_DeleteCursorsByTaskId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_DeleteTargetStatesByTaskStateId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_DeleteTaskStateById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_GetCursorsCountByTaskId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_GetTaskById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_GetTaskStateById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_GetTotalNumberOfConsumedItemsByTaskId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_MarkCursorCompleted] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_TryAcquireCursor] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_TryDeleteTaskById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_TryRegisterCursorSplitRequest] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_TryUpdateTaskById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_UpdateCursor] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_UpdateCursorProgress] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[History_UpdateTaskState] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_AddCursor] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_AddTask] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_AreAllCursorsCompleted] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_DeleteCursorsByTaskId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_GetCursorsCountByTaskId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_GetTaskById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_GetTotalNumberOfConsumedItemsByTaskId] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_IncrementTaskProgressById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_MarkCursorCompleted] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_PickDeferredTask] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_PickDistributedTaskInProgress] TO ['+ @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_PickDistributedTaskPending] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_RemoveExpiredTasks] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_RemoveTaskById] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_TryAcquireCursor] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_TryRegisterCursorSplitRequest] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_UpdateCursor] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_UpdateCursorProgress] TO [' + @Name + ']
        grant execute on [xdb_processing_tasks].[Processing_UpdateTaskStatusById] TO [' + @Name + ']');
END
GO

PRINT N'Update complete.';
GO
