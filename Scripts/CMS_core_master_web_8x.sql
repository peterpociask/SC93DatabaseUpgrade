SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

-- RolesInRoles.sql
PRINT N'Dropping RolesInRoles.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('RolesInRoles'))
BEGIN
  DROP INDEX DAC_Clustered ON RolesInRoles
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'RolesInRoles'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE RolesInRoles DROP COLUMN DAC_Index
END

GO

-- AccessControl.sql
PRINT N'Dropping AccessControl.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('AccessControl'))
BEGIN
  DROP INDEX DAC_Clustered ON AccessControl
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'AccessControl'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE AccessControl DROP COLUMN DAC_Index
END

GO

-- Archive.sql
PRINT N'Dropping Archive.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Archive'))
BEGIN
  DROP INDEX DAC_Clustered ON Archive
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Archive'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Archive DROP COLUMN DAC_Index
END

GO

-- ArchivedFields.sql
PRINT N'Dropping ArchivedFields.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('ArchivedFields'))
BEGIN
  DROP INDEX DAC_Clustered ON ArchivedFields
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'ArchivedFields'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE ArchivedFields DROP COLUMN DAC_Index
END

GO

PRINT N'Creating ArchivedFields.ndx_VersionId index...'
IF NOT EXISTS(SELECT NULL FROM sys.indexes 
              WHERE name = 'ndx_VersionId' AND object_id = OBJECT_ID('ArchivedFields'))
BEGIN
  CREATE NONCLUSTERED INDEX [ndx_VersionId] ON [dbo].[ArchivedFields]([VersionId] ASC)
END

GO

-- ArchivedItems.sql
PRINT N'Dropping ArchivedItems.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('ArchivedItems'))
BEGIN
  DROP INDEX DAC_Clustered ON ArchivedItems
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'ArchivedItems'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE ArchivedItems DROP COLUMN DAC_Index
END

GO

-- ArchivedVersions.sql
PRINT N'Dropping ArchivedVersions.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('ArchivedVersions'))
BEGIN
  DROP INDEX DAC_Clustered ON ArchivedVersions
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'ArchivedVersions'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE ArchivedVersions DROP COLUMN DAC_Index
END

GO

PRINT N'Creating ArchivedVersions.ndx_ItemId index...'
IF NOT EXISTS(SELECT NULL FROM sys.indexes 
              WHERE name = 'ndx_ItemId' AND object_id = OBJECT_ID('ArchivedVersions'))
BEGIN
  CREATE NONCLUSTERED INDEX [ndx_ItemId] ON [dbo].[ArchivedVersions]([ItemId] ASC)
END

GO

-- Blobs.sql
PRINT N'Dropping Blobs.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Blobs'))
BEGIN
  DROP INDEX DAC_Clustered ON Blobs
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Blobs'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Blobs DROP COLUMN DAC_Index
END

GO

PRINT N'Altering [dbo].[Blobs]...';

GO

ALTER TABLE [dbo].[Blobs] ALTER COLUMN [Data] VARBINARY (MAX) NOT NULL;

GO

-- ClientData.sql
PRINT N'Dropping ClientData.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('ClientData'))
BEGIN
  DROP INDEX DAC_Clustered ON ClientData
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'ClientData'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE ClientData DROP COLUMN DAC_Index
END

GO

PRINT N'Altering [dbo].[ClientData]...';

GO

ALTER TABLE [dbo].[ClientData] ALTER COLUMN [Data] NVARCHAR (MAX) NOT NULL;

GO

-- Descendants.sql
PRINT N'Dropping Descendants.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Descendants'))
BEGIN
  DROP INDEX DAC_Clustered ON Descendants
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Descendants'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Descendants DROP COLUMN DAC_Index
END

GO

-- History.sql
PRINT N'Dropping History.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('History'))
BEGIN
  DROP INDEX DAC_Clustered ON History
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'History'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE History DROP COLUMN DAC_Index
END

GO

-- IDTable.sql
PRINT N'Dropping IDTable.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('IDTable'))
BEGIN
  DROP INDEX DAC_Clustered ON IDTable
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'IDTable'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE IDTable DROP COLUMN DAC_Index
END

GO

-- Items.sql
PRINT N'Dropping Items.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Items'))
BEGIN
  DROP INDEX DAC_Clustered ON Items
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Items'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Items DROP COLUMN DAC_Index
END

GO

-- Links.sql
PRINT N'Dropping Links.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Links'))
BEGIN
  DROP INDEX DAC_Clustered ON Links
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Links'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Links DROP COLUMN DAC_Index
END

GO

PRINT N'Altering [dbo].[Links]...';

GO

ALTER TABLE [dbo].[Links] ALTER COLUMN [TargetPath] NVARCHAR (MAX) NOT NULL;

GO

-- Notifications.sql
PRINT N'Dropping Notifications.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Notifications'))
BEGIN
  DROP INDEX DAC_Clustered ON Notifications
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Notifications'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Notifications DROP COLUMN DAC_Index
END

GO

-- Properties.sql
PRINT N'Dropping Properties.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Properties'))
BEGIN
  DROP INDEX DAC_Clustered ON Properties
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Properties'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Properties DROP COLUMN DAC_Index
END

GO

PRINT N'Altering [dbo].[Properties]...';

GO

ALTER TABLE [dbo].[Properties] ALTER COLUMN [Value] NVARCHAR (MAX) NOT NULL;

GO

-- PublishQueue.sql
PRINT N'Dropping PublishQueue.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('PublishQueue'))
BEGIN
  DROP INDEX DAC_Clustered ON PublishQueue
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'PublishQueue'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE PublishQueue DROP COLUMN DAC_Index
END

GO

-- Shadows.sql
PRINT N'Dropping Shadows.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Shadows'))
BEGIN
  DROP INDEX DAC_Clustered ON Shadows
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Shadows'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Shadows DROP COLUMN DAC_Index
END

GO

-- SharedFields.sql
PRINT N'Dropping SharedFields.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('SharedFields'))
BEGIN
  DROP INDEX DAC_Clustered ON SharedFields
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'SharedFields'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE SharedFields DROP COLUMN DAC_Index
END

GO

-- Tasks.sql
PRINT N'Dropping Tasks.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('Tasks'))
BEGIN
  DROP INDEX DAC_Clustered ON Tasks
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'Tasks'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE Tasks DROP COLUMN DAC_Index
END

GO

PRINT N'Altering [dbo].[Tasks]...';

GO

ALTER TABLE [dbo].[Tasks] ALTER COLUMN [Parameters] NVARCHAR (MAX) NOT NULL;

GO

-- UnversionedFields.sql
PRINT N'Dropping UnversionedFields.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('UnversionedFields'))
BEGIN
  DROP INDEX DAC_Clustered ON UnversionedFields
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'UnversionedFields'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE UnversionedFields DROP COLUMN DAC_Index
END

GO

-- VersionedFields.sql
PRINT N'Dropping VersionedFields.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('VersionedFields'))
BEGIN
  DROP INDEX DAC_Clustered ON VersionedFields
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'VersionedFields'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE VersionedFields DROP COLUMN DAC_Index
END

GO

-- WorkflowHistory.sql
PRINT N'Dropping WorkflowHistory.DAC_Index...'
IF EXISTS(SELECT NULL
          FROM sys.indexes
          WHERE name='DAC_Clustered' AND object_id = OBJECT_ID('WorkflowHistory'))
BEGIN
  DROP INDEX DAC_Clustered ON WorkflowHistory
END

GO

IF EXISTS(SELECT NULL
          FROM INFORMATION_SCHEMA.COLUMNS
          WHERE
            TABLE_NAME = 'WorkflowHistory'
            AND COLUMN_NAME = 'DAC_Index')
BEGIN
  ALTER TABLE WorkflowHistory DROP COLUMN DAC_Index
END

GO

--CopyDataFromOldOutcomeFields.sql
PRINT N'Copying data from old outcome fields...'
UPDATE [dbo].[VersionedFields]
SET
[FieldId] = 'AC6BA888-4213-43BD-B787-D8DA2B6B881F'
WHERE
[FieldId] = '2A8D9AB0-B1C1-4DA3-B17D-1610AD23D697'

GO

UPDATE [dbo].[VersionedFields]
SET
[FieldId] = '797466F5-763B-4299-B6AD-E4192BF21222'
WHERE
[FieldId] = '55ADA481-438A-4CA3-ADC9-62DE68D42363'

GO

INSERT INTO [dbo].[SharedFields]
SELECT TOP 1 [Id], [ItemId], '0CF2654B-6E8B-44EB-9555-D2458B8092A5', [Value], [Created], [Updated]
FROM
[dbo].[VersionedFields]
WHERE [FieldId] = '65329376-32D9-4B9E-8067-757B9FB75B7D' AND [ItemId] NOT IN (SELECT [ItemId] FROM [SharedFields] WHERE [FieldId] = '0CF2654B-6E8B-44EB-9555-D2458B8092A5')
ORDER BY [Updated] DESC

GO

-- RolesInRoles.sql
PRINT N'Dropping Shadows table...'
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Shadows_ID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Shadows] DROP CONSTRAINT [DF_Shadows_ID]
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Shadows]') AND type in (N'U'))
DROP TABLE [dbo].[Shadows]

GO

PRINT N'Update complete.';