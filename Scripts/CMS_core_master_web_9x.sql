SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

-- Blobs.sql
IF EXISTS
(
    SELECT DATA_TYPE
    FROM Information_Schema.Columns
    WHERE TABLE_NAME = 'Blobs' AND COLUMN_NAME = 'Data' AND DATA_TYPE = 'image'
)
BEGIN
    PRINT N'Altering [dbo].[Blobs]...';
    ALTER TABLE [dbo].[Blobs] ALTER COLUMN [Data] VARBINARY (MAX) NOT NULL;
END

GO

-- ClientData.sql
IF EXISTS
(
    SELECT DATA_TYPE
    FROM Information_Schema.Columns
    WHERE TABLE_NAME = 'ClientData' AND COLUMN_NAME = 'Data' AND DATA_TYPE = 'ntext'
)
BEGIN
    PRINT N'Altering [dbo].[ClientData]...';
    ALTER TABLE [dbo].[ClientData] ALTER COLUMN [Data] NVARCHAR (MAX) NOT NULL;
END

GO

-- Links.sql
IF EXISTS
(
    SELECT DATA_TYPE
    FROM Information_Schema.Columns
    WHERE TABLE_NAME = 'Links' AND COLUMN_NAME = 'TargetPath' AND DATA_TYPE = 'ntext'
)
BEGIN
    PRINT N'Altering [dbo].[Links]...';
    ALTER TABLE [dbo].[Links] ALTER COLUMN [TargetPath] NVARCHAR (MAX) NOT NULL;
END

GO

-- Properties.sql
IF EXISTS
(
    SELECT DATA_TYPE
    FROM Information_Schema.Columns
    WHERE TABLE_NAME = 'Properties' AND COLUMN_NAME = 'Value' AND DATA_TYPE = 'ntext'
)
BEGIN
    PRINT N'Altering [dbo].[Properties]...';
    ALTER TABLE [dbo].[Properties] ALTER COLUMN [Value] NVARCHAR (MAX) NOT NULL;
END

GO

-- Tasks.sql
IF EXISTS
(
    SELECT DATA_TYPE
    FROM Information_Schema.Columns
    WHERE TABLE_NAME = 'Tasks' AND COLUMN_NAME = 'Parameters' AND DATA_TYPE = 'ntext'
)
BEGIN
    PRINT N'Altering [dbo].[Tasks]...';
    ALTER TABLE [dbo].[Tasks] ALTER COLUMN [Parameters] NVARCHAR (MAX) NOT NULL;
END

GO

PRINT N'Update complete.';

GO