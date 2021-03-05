/*
© 2019 Sitecore Corporation A/S. All rights reserved. Sitecore® is a registered trademark of Sitecore Corporation A/S.
Deployment script for Sitecore.ReferenceData (part 1).
Database schema and data migration.
*/

SET NOCOUNT ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U'))
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_DefinitionTypes]') AND type in (N'U'))
    BEGIN
        CREATE TABLE [xdb_refdata].[tmp_DefinitionTypes] (
            [ID] UNIQUEIDENTIFIER NOT NULL,
            [Name] NVARCHAR (128) COLLATE Latin1_General_CS_AS NOT NULL ,
            CONSTRAINT [PK_tmp_DefinitionTypes] PRIMARY KEY CLUSTERED ([ID] ASC)
        );

        CREATE UNIQUE NONCLUSTERED INDEX [IX_tmp_DefinitionTypes_Name]
            ON [xdb_refdata].[tmp_DefinitionTypes]([Name] ASC);
    END;

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_Definitions]') AND type in (N'U'))
    BEGIN
        CREATE TABLE [xdb_refdata].[tmp_Definitions] (
            [ID] UNIQUEIDENTIFIER NOT NULL,
            [Version] SMALLINT NOT NULL,
            [TypeID] UNIQUEIDENTIFIER NOT NULL,
            [IsActive] BIT CONSTRAINT [DF_tmp_Definitions_IsActive] DEFAULT ((1)) NOT NULL,
            [LastModified] DATETIME2(0) CONSTRAINT [DF_tmp_Definitions_LastModified] DEFAULT (GETUTCDATE()) NOT NULL,
            [DataTypeRevision] SMALLINT CONSTRAINT [DF_tmp_Definitions_DataTypeRevision] DEFAULT 1 NOT NULL,
            [Data] VARBINARY (MAX) NULL,
            [Moniker] NVARCHAR(300) COLLATE Latin1_General_CS_AS NOT NULL,
            CONSTRAINT [PK_tmp_Definitions] PRIMARY KEY CLUSTERED ([ID] ASC),
            CONSTRAINT [FK_tmp_Definitions_DefinitionTypes] FOREIGN KEY ([TypeID]) REFERENCES [xdb_refdata].[tmp_DefinitionTypes] ([ID])
        );

        CREATE NONCLUSTERED INDEX [IX_tmp_Definitions_TypeID_IsActive]
            ON [xdb_refdata].[tmp_Definitions]([TypeID] ASC, [IsActive] ASC);

        CREATE UNIQUE NONCLUSTERED INDEX [IX_tmp_Definitions_Moniker_TypeID_Version]
            ON [xdb_refdata].[tmp_Definitions] ([TypeID], [Moniker], [Version]);
    END;

    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_DefinitionCultures]') AND type in (N'U'))
    BEGIN
        CREATE TABLE [xdb_refdata].[tmp_DefinitionCultures] (
            [ID] UNIQUEIDENTIFIER NOT NULL,
            [DefinitionVersionID] UNIQUEIDENTIFIER NOT NULL,
            [Culture] VARCHAR (84) NOT NULL,
            [Data] VARBINARY (MAX) NULL,
            CONSTRAINT [PK_tmp_DefinitionCultures] PRIMARY KEY CLUSTERED ([ID] ASC),
            CONSTRAINT [FK_tmp_DefinitionCultures_Definitions] FOREIGN KEY ([DefinitionVersionID]) REFERENCES [xdb_refdata].[tmp_Definitions] ([ID]) ON DELETE CASCADE
        );

        CREATE UNIQUE NONCLUSTERED INDEX [IX_tmp_DefinitionCultures_DefinitionVersionID_Culture]
            ON [xdb_refdata].[tmp_DefinitionCultures] ([DefinitionVersionID], [Culture]);
    END;
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U'))
BEGIN
    PRINT 'Migrating definition types...'

    INSERT INTO [xdb_refdata].[tmp_DefinitionTypes]([ID], [Name])
        SELECT [ID], [Name]
        FROM [xdb_refdata].[DefinitionTypes]
        WHERE [ID] NOT IN (SELECT [ID] FROM [xdb_refdata].[tmp_DefinitionTypes]);

    PRINT CAST(ROWCOUNT_BIG() AS NVARCHAR) + ' have been migrated.'

    PRINT 'Migrating definitions...'

    DECLARE
        @OldID UNIQUEIDENTIFIER,
        @NewID UNIQUEIDENTIFIER,
        @Version SMALLINT,
        @Moniker NVARCHAR(300),
        @TypeID UNIQUEIDENTIFIER,
        @IsActive BIT,
        @LastModified DATETIME2(0),
        @DataTypeRevision SMALLINT,
        @Data VARBINARY(MAX),
        @MigratedDefinitionsCount BIGINT = 0

    DECLARE @OldDefinitions TABLE
    (
        [ID] UNIQUEIDENTIFIER,
        [Version] SMALLINT,
        [TypeID] UNIQUEIDENTIFIER,
        [Moniker] NVARCHAR(MAX),
        [IsActive] BIT,
        [LastModified] DATETIME2(0),
        [DataTypeRevision] SMALLINT,
        [Data] VARBINARY(MAX)
    )

    INSERT INTO @OldDefinitions([ID], [Version], [TypeID], [Moniker], [IsActive], [LastModified], [DataTypeRevision], [Data])
        SELECT [defs].[ID], [Version], [TypeID], [Moniker], [IsActive], [LastModified], [DataTypeRevision], [Data] FROM [xdb_refdata].[Definitions] [defs]
        INNER JOIN [xdb_refdata].[DefinitionMonikers] [monikers] ON [monikers].[ID] = [defs].[ID]
        WHERE LEN([Moniker]) <= 300;

    DECLARE OldDefinitionsCursor CURSOR FAST_FORWARD FOR
        SELECT [ID], [Version], [TypeID], [Moniker], [IsActive], [LastModified], [DataTypeRevision], [Data] FROM @OldDefinitions

    OPEN OldDefinitionsCursor

    FETCH NEXT FROM OldDefinitionsCursor INTO @OldID, @Version, @TypeID, @Moniker, @IsActive, @LastModified, @DataTypeRevision, @Data

    WHILE @@FETCH_STATUS = 0
    BEGIN

        SET @NewID = (SELECT TOP 1 [ID] FROM [xdb_refdata].[tmp_Definitions] WHERE [TypeID] = @TypeID AND [Moniker] = @Moniker AND [Version] = @Version);

        IF @NewID IS NULL
        BEGIN
            SET @NewID = NEWID();

            INSERT INTO [xdb_refdata].[tmp_Definitions]
                ([ID], [Version], [TypeID], [IsActive], [LastModified], [DataTypeRevision], [Data], [Moniker])
            VALUES
                (@NewID, @Version, @TypeID, @IsActive, @LastModified, @DataTypeRevision, @Data, @Moniker);
        END

        INSERT INTO [xdb_refdata].[tmp_DefinitionCultures]
            ([ID], [DefinitionVersionID], [Culture], [Data])
            SELECT NEWID(), @NewID, [Culture], [Data]
            FROM [xdb_refdata].[DefinitionCultures]
            WHERE [ID] = @OldID AND [Version] = @Version AND [Culture] NOT IN (
                SELECT [Culture] FROM [xdb_refdata].[tmp_DefinitionCultures] WHERE [DefinitionVersionID] = @NewID
            );

        DELETE FROM [xdb_refdata].[DefinitionCultures]
        WHERE [ID] = @OldID AND [Version] = @Version;

        DELETE FROM [xdb_refdata].[Definitions]
        WHERE [ID] = @OldID AND [Version] = @Version;

        IF (ROWCOUNT_BIG() > 0)
        BEGIN
            SET @MigratedDefinitionsCount = @MigratedDefinitionsCount + 1
        END

        FETCH NEXT FROM OldDefinitionsCursor INTO @OldID, @Version, @TypeID, @Moniker, @IsActive, @LastModified, @DataTypeRevision, @Data
    END

    CLOSE OldDefinitionsCursor
    DEALLOCATE OldDefinitionsCursor

    DELETE FROM [xdb_refdata].[DefinitionMonikers] WHERE [ID] NOT IN (SELECT [ID] FROM [xdb_refdata].[Definitions]);
    DELETE FROM [xdb_refdata].[DefinitionTypes] WHERE [ID] NOT IN (SELECT [TypeID] FROM [xdb_refdata].[Definitions]);

    PRINT CAST(@MigratedDefinitionsCount AS NVARCHAR) + ' definitions have been migrated.'
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U'))
BEGIN
    DECLARE
        @TotalRemainedCount BIGINT,
        @RemainedDefinitionsCount BIGINT,
        @LongMonikerCount BIGINT

    SELECT @RemainedDefinitionsCount = COUNT_BIG(*) FROM [xdb_refdata].[Definitions];
    IF (@RemainedDefinitionsCount > 0)
    BEGIN
        PRINT CAST(@RemainedDefinitionsCount AS NVARCHAR) + ' definitions cannot be migrated.'
        SELECT @LongMonikerCount = COUNT_BIG(*) FROM [xdb_refdata].[DefinitionMonikers] WHERE LEN([Moniker]) > 300;
        IF (@LongMonikerCount > 0)
        BEGIN
            PRINT 'Length of ' + CAST(@LongMonikerCount AS NVARCHAR) + ' definition monikers exceeds 300 characters. Consider truncate, change or remove them.'
        END
        PRINT 'Upgrade stopped. Fix all the issues and run this script again.'
    END

    SET @TotalRemainedCount =
        @RemainedDefinitionsCount +
        (SELECT COUNT_BIG(*) FROM [xdb_refdata].[DefinitionTypes]) +
        (SELECT COUNT_BIG(*) FROM [xdb_refdata].[DefinitionCultures]) +
        (SELECT COUNT_BIG(*) FROM [xdb_refdata].[DefinitionMonikers]);

    IF (@TotalRemainedCount = 0)
    BEGIN
        DROP TABLE IF EXISTS [xdb_refdata].[DefinitionCultures];
        DROP TABLE IF EXISTS [xdb_refdata].[Definitions];
        DROP TABLE IF EXISTS [xdb_refdata].[DefinitionTypes];
        DROP TABLE IF EXISTS [xdb_refdata].[DefinitionMonikers];
    END
END
GO

IF (NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U')) AND
    EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_DefinitionTypes]') AND type in (N'U')))
BEGIN
    EXEC sp_rename '[xdb_refdata].[PK_tmp_DefinitionTypes]', 'PK_DefinitionTypes'
    EXEC sp_rename '[xdb_refdata].[tmp_DefinitionTypes].[IX_tmp_DefinitionTypes_Name]', 'IX_DefinitionTypes_Name', 'INDEX';
    EXEC sp_rename '[xdb_refdata].[tmp_DefinitionTypes]', 'DefinitionTypes'
END
GO

IF (NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U')) AND
    EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_Definitions]') AND type in (N'U')))
BEGIN
    EXEC sp_rename '[xdb_refdata].[PK_tmp_Definitions]', 'PK_Definitions'
    EXEC sp_rename '[xdb_refdata].[FK_tmp_Definitions_DefinitionTypes]', 'FK_Definitions_DefinitionTypes';
    EXEC sp_rename '[xdb_refdata].[DF_tmp_Definitions_DataTypeRevision]', 'DF_Definitions_DataTypeRevision';
    EXEC sp_rename '[xdb_refdata].[DF_tmp_Definitions_IsActive]', 'DF_Definitions_IsActive';
    EXEC sp_rename '[xdb_refdata].[DF_tmp_Definitions_LastModified]', 'DF_Definitions_LastModified';
    EXEC sp_rename '[xdb_refdata].[tmp_Definitions].[IX_tmp_Definitions_Moniker_TypeID_Version]', 'IX_Definitions_Moniker_TypeID_Version', 'INDEX';
    EXEC sp_rename '[xdb_refdata].[tmp_Definitions].[IX_tmp_Definitions_TypeID_IsActive]', 'IX_Definitions_TypeID_IsActive', 'INDEX';
    EXEC sp_rename '[xdb_refdata].[tmp_Definitions]', 'Definitions'
END
GO

IF (NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U')) AND
    EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_DefinitionCultures]') AND type in (N'U')))
BEGIN
    EXEC sp_rename '[xdb_refdata].[PK_tmp_DefinitionCultures]', 'PK_DefinitionCultures'
    EXEC sp_rename '[xdb_refdata].[FK_tmp_DefinitionCultures_Definitions]', 'FK_DefinitionCultures_Definitions';
    EXEC sp_rename '[xdb_refdata].[tmp_DefinitionCultures].[IX_tmp_DefinitionCultures_DefinitionVersionID_Culture]', 'IX_DefinitionCultures_DefinitionVersionID_Culture', 'INDEX';
    EXEC sp_rename '[xdb_refdata].[tmp_DefinitionCultures]', 'DefinitionCultures'
END
GO

IF (
    NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DefinitionMonikers]') AND type in (N'U')) AND
    NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_DefinitionTypes]') AND type in (N'U')) AND
    NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_Definitions]') AND type in (N'U')) AND
    NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[tmp_DefinitionCultures]') AND type in (N'U'))
)
    PRINT 'Upgrade (part 1) has been done successfully.'
ELSE
    PRINT 'Upgrade (part 1) has not been completed.'
GO
