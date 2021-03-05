/*
Deployment script for Sitecore.Processing.Pools
*/
GO

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

PRINT N'Dropping [xdb_processing_pools].[PK_ContactProcessingPool]...';
GO

ALTER TABLE [xdb_processing_pools].[ContactProcessingPool] DROP CONSTRAINT [PK_ContactProcessingPool];
GO

PRINT N'Creating [xdb_processing_pools].[PK_ContactProcessingPool]...';
GO

ALTER TABLE [xdb_processing_pools].[ContactProcessingPool]
    ADD CONSTRAINT [PK_ContactProcessingPool] PRIMARY KEY CLUSTERED ([ContactId] ASC);
GO

PRINT N'Altering [xdb_processing_pools].[ContactProcessing_AddSingle]...';
GO

ALTER PROCEDURE [xdb_processing_pools].[ContactProcessing_AddSingle]
(
    @ContactId UNIQUEIDENTIFIER,
    @Created DATETIME2(0),
    @Scheduled DATETIME2(0),
    @Attempts SMALLINT,
    @Properties NVARCHAR(MAX)
)
WITH EXECUTE AS OWNER 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorNumber INT = ERROR_NUMBER();

    DECLARE @Retries SMALLINT = 10;

    WHILE( @Retries > 0 )
    BEGIN
         
        SET @Retries = @Retries - 1;

        BEGIN TRY

            INSERT INTO [xdb_processing_pools].[ContactProcessingPool]
            (
                [ContactId],
                [Created],
                [Scheduled],
                [Attempts],
                [Properties]
            )
            VALUES
            (
                @ContactId,
                @Created,
                @Scheduled,
                @Attempts,
                @Properties
            );

            RETURN;

        END TRY
        BEGIN CATCH

            SET @ErrorNumber = ERROR_NUMBER();

            IF( @ErrorNumber <> 2601 AND @ErrorNumber <> 2627) -- INSERT failed becuase of some unexpected exception. 
            BEGIN
                ;THROW
            END;

        END CATCH;
        
        -- INSERT above failed because this row already exists (codes 2601 or 2627). 

        SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
        BEGIN TRANSACTION;

        UPDATE  
            [xdb_processing_pools].[ContactProcessingPool]
        SET
            [Scheduled] = @Scheduled,
            [Attempts] = @Attempts,
            [Properties] = @Properties
        WHERE
            ([ContactId] = @ContactId);

        IF( @@ROWCOUNT > 0 ) 
        BEGIN
            COMMIT TRANSACTION;
            RETURN;
        END;

        ROLLBACK TRANSACTION;

        -- We will get here only if after failed INSERT attempt agent picked the contact and removed it from pool. Then there is nothing to update by UPDATE statement above and we have to retry. 
    END;

    -- This line will not be hit if ;THROW
    DECLARE @Id nvarchar(36) = convert(nvarchar(36), @ContactId);
    RAISERROR( N'After %d retries contact with unique identifier %s could not be added to the pool.', 16, 1, @Retries, @Id) WITH NOWAIT;

END;
GO

PRINT N'Altering [xdb_processing_pools].[ContactProcessing_RemoveBatch]...';
GO

ALTER PROCEDURE [xdb_processing_pools].[ContactProcessing_RemoveBatch]
(
    @Batch [xdb_processing_pools].[ContactProcessingCandidates] READONLY
)
WITH EXECUTE AS OWNER 
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Deleted AS TABLE
    (
        [ContactId] UNIQUEIDENTIFIER NOT NULL
    );

    SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
    BEGIN TRANSACTION;

    DELETE
        [Target]
    OUTPUT
        DELETED.[ContactId]
    INTO
        @Deleted
    FROM 
        [xdb_processing_pools].[ContactProcessingPool] AS [Target]
    JOIN  
        @Batch AS [Source]
    ON
        [Target].[ContactId] = [Source].[ContactId] AND
        [Target].[Attempts] = [Source].[Attempts];

    COMMIT TRANSACTION;

    SELECT 
        [Batch].[ContactId]
    FROM 
        @Batch AS [Batch]
    WHERE
        NOT EXISTS
        (
            SELECT
                1
            FROM
                @Deleted AS [Deleted]
            WHERE
                ([Deleted].[ContactId] = [Batch].[ContactId])
        );

END;
GO

PRINT N'Altering [xdb_processing_pools].[GenericProcessing_GetState]...';
GO

ALTER PROCEDURE [xdb_processing_pools].[GenericProcessing_GetState]
(
    @Pool UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER 
AS
BEGIN

    SET NOCOUNT ON;

    IF( @Pool IS NULL )
    BEGIN
        RAISERROR( N'Parameter @Pool is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN;
    END;

    SELECT
        COUNT_BIG( 1 ) AS [Count]
    FROM
        [xdb_processing_pools].[GenericProcessingPool] WITH (NOLOCK)
    WHERE 
        [Pool] = @Pool;

END;
GO

PRINT N'Altering [xdb_processing_pools].[GenericProcessing_RemoveAll]...';
GO

ALTER PROCEDURE [xdb_processing_pools].[GenericProcessing_RemoveAll]
(
    @Pool UNIQUEIDENTIFIER
)
WITH EXECUTE AS OWNER 
AS
BEGIN

    SET NOCOUNT ON;

    IF( @Pool IS NULL )
    BEGIN
        RAISERROR( N'Parameter @Pool is NULL.', 16, 1 ) WITH NOWAIT;
        RETURN;
    END;

    DELETE FROM 
        [xdb_processing_pools].[GenericProcessingPool]
    WHERE 
        [Pool] = @Pool;

END;
GO

PRINT N'Altering [xdb_processing_pools].[GrantLeastPrivilege]...';
GO

ALTER PROCEDURE [xdb_processing_pools].[GrantLeastPrivilege]
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

    -- Types
    EXECUTE ('
        grant execute on TYPE::[xdb_processing_pools].[InteractionProcessingCandidates] TO [' + @Name + ']
        grant execute on TYPE::[xdb_processing_pools].[ContactProcessingBatch] TO [' + @Name + ']
        grant execute on TYPE::[xdb_processing_pools].[ContactProcessingCandidates] TO [' + @Name + ']
        grant execute on TYPE::[xdb_processing_pools].[GenericProcessingBatch] TO [' + @Name + ']
        grant execute on TYPE::[xdb_processing_pools].[GenericProcessingCandidates] TO [' + @Name + ']
        grant execute on TYPE::[xdb_processing_pools].[InteractionProcessingBatch] TO [' + @Name + ']');

    -- Procedures
    EXECUTE ('
        grant execute on [xdb_processing_pools].[PoolDefinitions_RemoveDefinition] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_AddBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_AddSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_CheckoutBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_CheckoutSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_GetState] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_RemoveAll] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_RemoveBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[ContactProcessing_RemoveSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_AddBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_AddSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_CheckoutBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_CheckoutSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_GetState] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_RemoveAll] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_RemoveBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[GenericProcessing_RemoveSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_AddBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_AddSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_CheckoutBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_CheckoutSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_GetState] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_RemoveAll] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_RemoveBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionHistoryProcessing_RemoveSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_AddBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_AddSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_CheckoutBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_CheckoutSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_GetState] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_RemoveAll] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_RemoveBatch] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[InteractionLiveProcessing_RemoveSingle] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[PoolDefinitions_AddDefinition] TO [' + @Name + ']
        grant execute on [xdb_processing_pools].[PoolDefinitions_GetDefinition] TO [' + @Name + ']');

END
GO

PRINT N'Update complete.';
GO