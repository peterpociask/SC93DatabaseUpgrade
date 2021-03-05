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
PRINT N'Altering ShardKey columns as not null';
PRINT N'Altering [xdb_collection].[ContactFacets]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactFacets]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[ContactFacets]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[ContactFacets_Staging]adding not null constraint to shardkey...';
GO

IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactFacets_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[ContactFacets_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[ContactIdentifiers]adding not null constraint to shardkey...';
GO

IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiers]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[ContactIdentifiers]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[ContactIdentifiers_Staging]adding not null constraint to shardkey...';
GO

IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiers_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[ContactIdentifiers_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[ContactIdentifiersIndex]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiersIndex]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[ContactIdentifiersIndex]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[ContactIdentifiersIndex_Staging]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[ContactIdentifiersIndex_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[ContactIdentifiersIndex_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[Contacts]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Contacts]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[Contacts]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[Contacts_Staging]adding not null constraint to shardkey...';
GO

IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Contacts_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[Contacts_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[DeviceProfileFacets]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfileFacets]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[DeviceProfileFacets]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[DeviceProfileFacets_Staging]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfileFacets_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[DeviceProfileFacets_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[DeviceProfiles]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfiles]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[DeviceProfiles]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Altering [xdb_collection].[DeviceProfiles_Staging]adding not null constraint to shardkey...';
GO

IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[DeviceProfiles_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[DeviceProfiles_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[InteractionFacets]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[InteractionFacets]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[InteractionFacets]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[InteractionFacets_Staging]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[InteractionFacets_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[InteractionFacets_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[Interactions]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Interactions]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[Interactions]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO

PRINT N'Altering [xdb_collection].[Interactions_Staging]adding not null constraint to shardkey...';
GO
IF EXISTS (
  SELECT * 
  FROM   sys.columns 
  WHERE  object_id = OBJECT_ID(N'[xdb_collection].[Interactions_Staging]') 
         AND name = 'ShardKey' and is_nullable = 1
)
ALTER TABLE [xdb_collection].[Interactions_Staging]
    ALTER COLUMN [ShardKey] BINARY (1) NOT NULL ;
GO
PRINT N'Finish altering ShardKey columns as not null';
GO