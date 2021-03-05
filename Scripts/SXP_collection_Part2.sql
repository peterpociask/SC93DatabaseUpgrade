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