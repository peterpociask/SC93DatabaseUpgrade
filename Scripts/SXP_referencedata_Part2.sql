/*
© 2019 Sitecore Corporation A/S. All rights reserved. Sitecore® is a registered trademark of Sitecore Corporation A/S.
Deployment script for Sitecore.ReferenceData (part 2).
Upgrade programmability database objects.
*/

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

PRINT N'Deleting [xdb_refdata].[SaveDefinitions]...';
GO

DROP PROCEDURE IF EXISTS [xdb_refdata].[SaveDefinitions]
GO

PRINT N'Deleting [xdb_refdata].[SaveDefinitionCultures]...';
GO

DROP PROCEDURE IF EXISTS [xdb_refdata].[SaveDefinitionCultures]
GO

PRINT N'Deleting [xdb_refdata].[GetDefinitions]...';
GO

DROP PROCEDURE IF EXISTS [xdb_refdata].[GetDefinitions]
GO

PRINT N'Deleting [xdb_refdata].[GetByDefinitionTypes]...';
GO

DROP PROCEDURE IF EXISTS [xdb_refdata].[GetByDefinitionTypes]
GO

PRINT N'Deleting [xdb_refdata].[DeleteDefinitions]...';
GO

DROP PROCEDURE IF EXISTS [xdb_refdata].[DeleteDefinitions]
GO

PRINT N'Altering [xdb_refdata].[DefinitionBatch]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[DefinitionBatch]
GO

CREATE TYPE [xdb_refdata].[DefinitionBatch] AS TABLE (
    [ID] UNIQUEIDENTIFIER NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NOT NULL,
    [IsActive] BIT NOT NULL,
    [LastModified] DATETIME2(0) NOT NULL,
    [DataTypeRevision] SMALLINT NOT NULL,
    [Data] VARBINARY (MAX) NULL,
    [Moniker] NVARCHAR(300) NOT NULL
);
GO

PRINT N'Altering [xdb_refdata].[DefinitionCriteria]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[DefinitionCriteria]
GO

CREATE TYPE [xdb_refdata].[DefinitionCriteria] AS TABLE (
    [Moniker] NVARCHAR (300) COLLATE Latin1_General_CS_AS NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NULL,
    [Culture] VARCHAR (84) NULL
);
GO

PRINT N'Altering [xdb_refdata].[DefinitionCultureBatch]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[DefinitionCultureBatch]
GO

CREATE TYPE [xdb_refdata].[DefinitionCultureBatch] AS TABLE
(
    [DefinitionInstanceID] UNIQUEIDENTIFIER NOT NULL,
    [Moniker] NVARCHAR (300) COLLATE Latin1_General_CS_AS NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NOT NULL,
    [Culture] VARCHAR (84) NOT NULL,
    [Data]    VARBINARY (MAX) NULL
);
GO

PRINT N'Altering [xdb_refdata].[DefinitionCultureResults]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[DefinitionCultureResults]
GO

CREATE TYPE [xdb_refdata].[DefinitionCultureResults] AS TABLE
(
    [DefinitionInstanceID] UNIQUEIDENTIFIER NOT NULL,
    [Moniker] NVARCHAR (300) COLLATE Latin1_General_CS_AS NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NOT NULL,
    [Culture] VARCHAR (84) NOT NULL,
    [Success] BIT NOT NULL,
    [Message] NVARCHAR (MAX) NULL
);
GO

PRINT N'Altering [xdb_refdata].[DefinitionKeys]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[DefinitionKeys]
GO

CREATE TYPE [xdb_refdata].[DefinitionKeys] AS TABLE (
    [Moniker] NVARCHAR (300) COLLATE Latin1_General_CS_AS NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NOT NULL
);
GO

PRINT N'Altering [xdb_refdata].[DefinitionResults]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[DefinitionResults]
GO

CREATE TYPE [xdb_refdata].[DefinitionResults] AS TABLE
(
    [DefinitionInstanceID] UNIQUEIDENTIFIER NOT NULL,
    [Moniker] NVARCHAR (300) COLLATE Latin1_General_CS_AS NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NOT NULL,
    [Success] BIT NOT NULL,
    [Message] NVARCHAR (MAX) NULL
);
GO

PRINT N'Altering [xdb_refdata].[MonikerDefinitions]...';
GO

DROP TYPE IF EXISTS [xdb_refdata].[MonikerDefinitions]
GO

CREATE TYPE [xdb_refdata].[MonikerDefinitions] AS TABLE
(
    [DefinitionInstanceID] UNIQUEIDENTIFIER NOT NULL,
    [Moniker] NVARCHAR (300) COLLATE Latin1_General_CS_AS NOT NULL,
    [TypeID] UNIQUEIDENTIFIER NOT NULL,
    [Version] SMALLINT NOT NULL,
    [IsActive] BIT NOT NULL,
    [LastModified] DATETIME2(0) NOT NULL,
    [DataTypeRevision] SMALLINT NOT NULL,
    [Data] VARBINARY (MAX) NULL
);
GO

PRINT N'Creating [xdb_refdata].[DeleteDefinitions]...';
GO

CREATE PROCEDURE [xdb_refdata].[DeleteDefinitions]
(
    @Keys [xdb_refdata].[DefinitionKeys] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Results [xdb_refdata].[DefinitionResults]

    DECLARE @DefinitionsToProcess TABLE
    (
        [DefinitionInstanceID] UNIQUEIDENTIFIER,
        [ID] UNIQUEIDENTIFIER,
        [Moniker] NVARCHAR(300),
        [TypeID] UNIQUEIDENTIFIER,
        [Version] SMALLINT,
        [IsActive] BIT
    )

    INSERT INTO
        @DefinitionsToProcess
    (
        [DefinitionInstanceID],
        [ID],
        [Moniker],
        [TypeID],
        [Version],
        [IsActive]
    )
    SELECT
        NEWID(),
        [defs].[ID],
        [keys].[Moniker],
        [keys].[TypeID],
        [keys].[Version],
        [defs].[IsActive]
    FROM
        @Keys [keys]
    LEFT JOIN
        [xdb_refdata].[Definitions] [defs]
    ON
        [defs].[TypeID] = [keys].[TypeID] AND
        [defs].[Moniker] = [keys].[Moniker] AND
        [defs].[Version] = [keys].[Version]

    -- Filter definitions which cannot be found or is active
    INSERT INTO
        @Results
    (
        [DefinitionInstanceID],
        [Moniker],
        [TypeID],
        [Version],
        [Success],
        [Message]
    )
    SELECT
        [DefinitionInstanceID],
        [Moniker],
        [TypeID],
        [Version],
        0,
        CASE
            WHEN [ID] IS NULL THEN  'The definition version was not found.'
            WHEN [IsActive] = 1 THEN 'The definition is still active.'
        END
    FROM
        @DefinitionsToProcess
    WHERE
        ([ID] IS NULL) OR ([IsActive] = 1)

    DELETE
        @DefinitionsToProcess
    WHERE
        ([ID] IS NULL) OR ([IsActive] = 1)

    -- Delete definitions
    DELETE
        [Target]
    OUTPUT
        [ToProcess].[DefinitionInstanceID],
        [ToProcess].[Moniker],
        [ToProcess].[TypeID],
        [ToProcess].[Version],
        1,
        NULL
    INTO
        @Results
    FROM
        [xdb_refdata].[Definitions] AS [Target]
    INNER JOIN
        @DefinitionsToProcess AS [ToProcess]
    ON
        [Target].[ID] = [ToProcess].[ID]

    -- return results
    SELECT
        [DefinitionInstanceID],
        [Moniker],
        [TypeID],
        [Version],
        [Success],
        [Message]
    FROM
        @Results;
END
GO

PRINT N'Creating [xdb_refdata].[GetByDefinitionTypes]...';
GO

CREATE PROCEDURE [xdb_refdata].[GetByDefinitionTypes]
(
    @TypeID UNIQUEIDENTIFIER,
    @PageNumber INT,
    @PageSize INT,
    @LatestActiveOnly BIT,
    -- Used for selecting only one of the result sets. 1 = Total, 2 = Definitions, 3 = DefinitionCultures, anything else = all
    @ResultSetSelector SMALLINT = 0
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF @TypeID IS NULL
    BEGIN
        RAISERROR('Parameter @TypeID is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @PageNumber IS NULL
    BEGIN
        RAISERROR('Parameter @PageNumber is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @PageNumber <= 0
    BEGIN
        RAISERROR('Parameter @PageNumber must be greater than 0', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @PageSize IS NULL
    BEGIN
        RAISERROR('Parameter @PageSize is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @PageSize <= 0
    BEGIN
        RAISERROR('Parameter @PageSize must be greater than 0', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @LatestActiveOnly IS NULL
    BEGIN
        RAISERROR('Parameter @LatestActiveOnly is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    DECLARE
        @Definitions [xdb_refdata].[DefinitionBatch],
        @Total INT

    DECLARE @MappedCriteria TABLE
    (
        [Moniker] NVARCHAR(300),
        [Version] SMALLINT,
        [Culture] VARCHAR(84)
    )

    -- define page boundaries
    DECLARE
        @StartRow BIGINT = (@PageNumber - 1) * @PageSize + 1;

    DECLARE
        @EndRow BIGINT = @StartRow + @PageSize - 1;

    -- Filter all definitions by type and active
    IF @LatestActiveOnly = 1
    BEGIN
        INSERT INTO
            @MappedCriteria
            (
                [Moniker],
                [Version]
            )
            SELECT
                [Moniker],
                MAX([Version]) AS MaxVersion
            FROM
                [xdb_refdata].[Definitions]
            WHERE
                [TypeID] = @TypeID AND
                [IsActive] = 1
            GROUP BY
                [Moniker]
    END
    ELSE
    BEGIN
        INSERT INTO
            @MappedCriteria
            (
                [Moniker],
                [Version]
            )
            SELECT
                [Moniker],
                [Version]
            FROM
                [Definitions]
            WHERE
                [TypeID] = @TypeID
    END

    -- Store total results
    SELECT @Total = COUNT(*) FROM @MappedCriteria;

    -- fill in definitions
    WITH [OrderedCriteria]
    AS
    (
        SELECT
            [Moniker],
            [Version],
            ROW_NUMBER() OVER (ORDER BY [Moniker], [Version]) AS [RowNumber]
        FROM
            @MappedCriteria
    )
    INSERT INTO @Definitions
    (
        [ID],
        [Version],
        [TypeID],
        [IsActive],
        [LastModified],
        [DataTypeRevision],
        [Data],
        [Moniker]
    )
    SELECT
        [Definitions].[ID],
        [Definitions].[Version],
        [Definitions].[TypeID],
        [Definitions].[IsActive],
        [Definitions].[LastModified],
        [Definitions].[DataTypeRevision],
        [Definitions].[Data],
        [Definitions].[Moniker]
    FROM
        [xdb_refdata].[Definitions]
    INNER JOIN
        [OrderedCriteria]
    ON
        @TypeID = [Definitions].[TypeID] AND
        [OrderedCriteria].[Moniker] = [Definitions].[Moniker] AND
        [OrderedCriteria].[Version] = [Definitions].[Version]
    WHERE
        [OrderedCriteria].[RowNumber] BETWEEN @StartRow AND @EndRow;

    IF @ResultSetSelector NOT IN (2, 3)
    BEGIN
        SELECT @Total AS Total
    END

    IF @ResultSetSelector NOT IN (1, 3)
    BEGIN
        SELECT
            [Moniker],
            [TypeID],
            [Version],
            [IsActive],
            [LastModified],
            [DataTypeRevision],
            [Data]
        FROM
            @Definitions AS [definitions]
    END

    IF @ResultSetSelector NOT IN (1, 2)
    BEGIN
        -- Find cultures for definitions
        SELECT
            [Moniker],
            [TypeID],
            [Version],
            [DefinitionCultures].[Culture],
            [DefinitionCultures].[Data]
        FROM
            [xdb_refdata].[DefinitionCultures]
        INNER JOIN
            @Definitions AS [MatchingDefinitions]
        ON
            [MatchingDefinitions].[ID] = [DefinitionCultures].[DefinitionVersionID]
    END
END
GO

PRINT N'Creating [xdb_refdata].[GetDefinitions]...';
GO

CREATE PROCEDURE [xdb_refdata].[GetDefinitions]
(
    @Criteria [xdb_refdata].[DefinitionCriteria] READONLY,
    @LatestActiveOnly BIT,
    -- Used for selecting only one of the result sets. 1 = Definitions, 2 = DefinitionCultures, anything else = both
    @ResultSetSelector SMALLINT = 0
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF @LatestActiveOnly IS NULL
    BEGIN
        RAISERROR('Parameter @LatestActiveOnly is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    DECLARE
        @MatchingDefinitions [xdb_refdata].[DefinitionBatch]

    DECLARE @MappedCriteria TABLE
    (
        [Moniker] NVARCHAR(300),
        [TypeID] UNIQUEIDENTIFIER,
        [Version] SMALLINT,
        [Culture] VARCHAR(84)
    )

    -- Resolve IDs for monikers
    INSERT INTO @MappedCriteria
    SELECT
        [Moniker],
        [TypeID],
        [Version],
        [Culture]
    FROM
        @Criteria [criteria]
    WHERE EXISTS (
            SELECT TOP 1
                [xdb_refdata].[Definitions].[ID]
            FROM
                [xdb_refdata].[Definitions]
            WHERE
                [xdb_refdata].[Definitions].[Moniker] = [criteria].[Moniker] AND
                [xdb_refdata].[Definitions].[TypeID] = [criteria].[TypeID]
        )

    -- Populate latest versions where no specific version was supplied
    IF @LatestActiveOnly = 1
    BEGIN
        UPDATE @MappedCriteria
        SET
            [Version] = MaxVersion
            FROM
            (
                SELECT
                    MAX([Version]) AS MaxVersion,
                    [TypeID],
                    [Moniker]
                FROM
                    [xdb_refdata].[Definitions]
                WHERE
                    [Definitions].[TypeID] = [TypeID] AND
                    [Definitions].[Moniker] = [Moniker] AND
                    [Definitions].[IsActive] = 1
                GROUP BY
                    [TypeID], [Moniker]
            ) MaxVersions
            INNER JOIN
                @MappedCriteria AS [MappedCriteria]
            ON
                [MappedCriteria].[TypeID] = MaxVersions.[TypeID] AND
                [MappedCriteria].[Moniker] = MaxVersions.[Moniker]
        WHERE
            [Version] IS NULL
    END
    ELSE
    BEGIN
        INSERT INTO @MappedCriteria
        (
            [TypeID],
            [Moniker],
            [Version],
            [Culture]
        )
            SELECT DISTINCT
                [MappedCriteria].[TypeID],
                [MappedCriteria].[Moniker],
                [xdb_refdata].[Definitions].[Version],
                [MappedCriteria].[Culture]
            FROM
                [xdb_refdata].[Definitions]
            INNER JOIN
                @MappedCriteria AS [MappedCriteria]
            ON
                [xdb_refdata].[Definitions].[TypeID] = [MappedCriteria].[TypeID] AND
                [xdb_refdata].[Definitions].[Moniker] = [MappedCriteria].[Moniker]
            WHERE
                [MappedCriteria].[Version] IS NULL

        DELETE @MappedCriteria
        WHERE
            [Version] IS NULL
    END

    -- Find matching definitions
    INSERT INTO
        @MatchingDefinitions
    (
        [ID],
        [TypeID],
        [Version],
        [IsActive],
        [LastModified],
        [DataTypeRevision],
        [Data],
        [Moniker]
    )
    SELECT DISTINCT
        [xdb_refdata].[Definitions].[ID],
        [xdb_refdata].[Definitions].[TypeID],
        [xdb_refdata].[Definitions].[Version],
        [xdb_refdata].[Definitions].[IsActive],
        [xdb_refdata].[Definitions].[LastModified],
        [xdb_refdata].[Definitions].[DataTypeRevision],
        [xdb_refdata].[Definitions].[Data],
        [xdb_refdata].[Definitions].[Moniker]
    FROM
        [xdb_refdata].[Definitions]
    INNER JOIN
        @MappedCriteria [Criteria]
    ON
        [Criteria].[TypeID] = [xdb_refdata].[Definitions].[TypeID] AND
        [Criteria].[Moniker] = [xdb_refdata].[Definitions].[Moniker] AND
        [Criteria].[Version] = [xdb_refdata].[Definitions].[Version]

    IF @ResultSetSelector IS NULL OR @ResultSetSelector != 2
    BEGIN
        SELECT
            [Moniker],
            [TypeID],
            [Version],
            [IsActive],
            [LastModified],
            [DataTypeRevision],
            [Data]
        FROM
            @MatchingDefinitions AS [MatchingDefinitions]
        ORDER BY
            [Moniker],
            [Version]
    END

    IF @ResultSetSelector IS NULL OR @ResultSetSelector != 1
    BEGIN
        -- Find cultures for definitions
        SELECT
            [MatchingDefinitions].[Moniker],
            [MatchingDefinitions].[TypeID],
            [MatchingDefinitions].[Version],
            [xdb_refdata].[DefinitionCultures].[Culture],
            [xdb_refdata].[DefinitionCultures].[Data]
        FROM
            [xdb_refdata].[DefinitionCultures]
        INNER JOIN
            @MatchingDefinitions AS [MatchingDefinitions]
        ON
            [MatchingDefinitions].[ID] = [xdb_refdata].[DefinitionCultures].[DefinitionVersionID]
        INNER JOIN
            @MappedCriteria [Criteria]
        ON
            [Criteria].[TypeID] = [MatchingDefinitions].[TypeID] AND
            [Criteria].[Moniker] = [MatchingDefinitions].[Moniker] AND
            [Criteria].[Version] = [MatchingDefinitions].[Version]
        WHERE
            [Criteria].[Culture] IS NULL OR
            [Criteria].[Culture] = [xdb_refdata].[DefinitionCultures].[Culture]
    END
END
GO

PRINT N'Creating [xdb_refdata].[SaveDefinitionCultures]...';
GO

CREATE PROCEDURE [xdb_refdata].[SaveDefinitionCultures]
(
    @DefinitionCultures [xdb_refdata].[DefinitionCultureBatch] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Results [xdb_refdata].[DefinitionCultureResults],
        @DefinitionInstanceID UNIQUEIDENTIFIER,
        @DefinitionVersionID UNIQUEIDENTIFIER,
        @Moniker NVARCHAR(300),
        @TypeID UNIQUEIDENTIFIER,
        @Version SMALLINT,
        @Culture VARCHAR(84),
        @Data VARBINARY(MAX)

    DECLARE InputDefinitionCulture CURSOR FAST_FORWARD FOR
        SELECT [DefinitionInstanceID], [Moniker], [TypeID], [Version], [Culture], [Data] FROM @DefinitionCultures

    OPEN InputDefinitionCulture

    FETCH NEXT FROM InputDefinitionCulture
        INTO @DefinitionInstanceID, @Moniker, @TypeID, @Version, @Culture, @Data

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
            SET @DefinitionVersionID = (
                SELECT TOP 1
                    [ID]
                FROM
                    [xdb_refdata].[Definitions]
                WHERE
                    [TypeID] = @TypeID AND
                    [Moniker] = @Moniker AND
                    [Version] = @Version
            )

            IF @DefinitionVersionID IS NULL
            BEGIN
                INSERT INTO @Results
                (
                    [DefinitionInstanceID],
                    [Moniker],
                    [TypeID],
                    [Version],
                    [Culture],
                    [Success],
                    [Message]
                )
                VALUES
                (
                    @DefinitionInstanceID,
                    @Moniker,
                    @TypeID,
                    @Version,
                    @Culture,
                    0,
                    'The definition was not found'
                )
            END
            ELSE
            BEGIN
                MERGE
                    [xdb_refdata].[DefinitionCultures] AS [target]
                USING
                (
                    SELECT @DefinitionVersionID, @Culture
                )
                AS
                    [source]([DefinitionVersionID], [Culture])
                ON
                (
                    [target].[DefinitionVersionID] = [source].[DefinitionVersionID] AND
                    [target].[Culture] = [source].[Culture]
                )
                WHEN MATCHED THEN
                    UPDATE SET [Data] = @Data
                WHEN NOT MATCHED THEN
                    INSERT
                    (
                        [ID],
                        [DefinitionVersionID],
                        [Culture],
                        [Data]
                    )
                    VALUES
                    (
                        NEWID(),
                        @DefinitionVersionID,
                        @Culture,
                        @Data
                    )
                OUTPUT
                    @DefinitionInstanceID,
                    @Moniker,
                    @TypeID,
                    @Version,
                    @Culture,
                    1,
                    $action
                INTO @Results
                (
                    [DefinitionInstanceID],
                    [Moniker],
                    [TypeID],
                    [Version],
                    [Culture],
                    [Success],
                    [Message]
                );
            END
        END TRY
        BEGIN CATCH
            INSERT INTO @Results
            (
                [DefinitionInstanceID],
                [Moniker],
                [TypeID],
                [Version],
                [Culture],
                [Success],
                [Message]
            )
            VALUES
            (
                @DefinitionInstanceID,
                @Moniker,
                @TypeID,
                @Version,
                @Culture,
                0,
                ERROR_MESSAGE()
            )
        END CATCH

        FETCH NEXT FROM InputDefinitionCulture
            INTO @DefinitionInstanceID, @Moniker, @TypeID, @Version, @Culture, @Data
    END

    CLOSE InputDefinitionCulture
    DEALLOCATE InputDefinitionCulture

    SELECT
        [DefinitionInstanceID],
        [Moniker],
        [TypeID],
        [Version],
        [Culture],
        [Success],
        CASE [Message]
            WHEN 'INSERT' THEN NULL
            ELSE [Message]
        END AS [Message]
    FROM @Results
    AS Results
END
GO

PRINT N'Creating [xdb_refdata].[SaveDefinitions]...';
GO

CREATE PROCEDURE [xdb_refdata].[SaveDefinitions]
(
    @Definitions [xdb_refdata].[MonikerDefinitions] READONLY
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Results [xdb_refdata].[DefinitionResults],
        @CurrentDate DATETIME2(0) = CONVERT(DATETIME2(0), GETUTCDATE()),
        @DefinitionInstanceID UNIQUEIDENTIFIER,
        @Moniker NVARCHAR(300),
        @TypeID UNIQUEIDENTIFIER,
        @ID UNIQUEIDENTIFIER,
        @Version SMALLINT,
        @IsActive BIT,
        @DataTypeRevision SMALLINT,
        @Data VARBINARY(MAX)

    DECLARE InputDefinition CURSOR FAST_FORWARD FOR
        SELECT [DefinitionInstanceID], [Moniker], [TypeID], [Version], [IsActive], [DataTypeRevision], [Data] FROM @Definitions

    OPEN InputDefinition

    FETCH NEXT FROM InputDefinition
        INTO @DefinitionInstanceID, @Moniker, @TypeID, @Version, @IsActive, @DataTypeRevision, @Data

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY

            MERGE
                [xdb_refdata].[Definitions] AS [target]
            USING
            (
                SELECT @TypeID, @Moniker, @Version
            )
            AS
                [source] ([TypeID], [Moniker], [Version])
            ON
            (
                [target].[TypeID] = [source].[TypeID] AND
                [target].[Moniker] = [source].[Moniker] AND
                [target].[Version] = [source].[Version]
            )
            WHEN MATCHED THEN
                UPDATE
                SET
                    [IsActive] = @IsActive,
                    [LastModified] = @CurrentDate,
                    [DataTypeRevision] = @DataTypeRevision,
                    [Data] = @Data
            WHEN NOT MATCHED THEN
                INSERT
                (
                    [ID],
                    [Version],
                    [TypeID],
                    [IsActive],
                    [LastModified],
                    [DataTypeRevision],
                    [Data],
                    [Moniker]
                )
                VALUES
                (
                    NEWID(),
                    @Version,
                    @TypeID,
                    @IsActive,
                    @CurrentDate,
                    @DataTypeRevision,
                    @Data,
                    @Moniker
                )
            OUTPUT
                @DefinitionInstanceID,
                @Moniker,
                @TypeID,
                @Version,
                1,
                $action
            INTO @Results
            (
                [DefinitionInstanceID],
                [Moniker],
                [TypeID],
                [Version],
                [Success],
                [Message]
            );

        END TRY
        BEGIN CATCH
            INSERT INTO @Results
            (
                [DefinitionInstanceID],
                [Moniker],
                [TypeID],
                [Version],
                [Success],
                [Message]
            )
            VALUES
            (
                @DefinitionInstanceID,
                @Moniker,
                @TypeID,
                @Version,
                0,
                ERROR_MESSAGE()
            )
        END CATCH

        FETCH NEXT FROM InputDefinition
        INTO @DefinitionInstanceID, @Moniker, @TypeID, @Version, @IsActive, @DataTypeRevision, @Data
    END

    CLOSE InputDefinition
    DEALLOCATE InputDefinition

    SELECT
        [DefinitionInstanceID],
        [Moniker],
        [TypeID],
        [Version],
        [Success],
        CASE [Message]
            WHEN 'INSERT' THEN NULL
            ELSE [Message]
        END AS [Message]
    FROM @Results
    AS Results
END
GO

PRINT N'Removing [xdb_refdata].[GetDefinitionID]...';
GO

DROP FUNCTION IF EXISTS [xdb_refdata].[GetDefinitionID]
GO

PRINT N'Removing [xdb_refdata].[GetDefinitionMoniker]...';
GO

DROP FUNCTION IF EXISTS [xdb_refdata].[GetDefinitionMoniker]
GO

PRINT N'Removing [xdb_refdata].[GetDefinitionMonikerHash]...';
GO

DROP FUNCTION IF EXISTS [xdb_refdata].[GetDefinitionMonikerHash]
GO

PRINT N'Creating [xdb_refdata].[DeleteSingleDefinition]...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[DeleteSingleDefinition]') AND type in (N'P', N'PC'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [xdb_refdata].[DeleteSingleDefinition] AS'
END
GO

ALTER PROCEDURE [xdb_refdata].[DeleteSingleDefinition]
(
    @Moniker NVARCHAR(300),
    @TypeID UNIQUEIDENTIFIER,
    @Version SMALLINT
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF @Moniker IS NULL
    BEGIN
        RAISERROR('Parameter @Moniker is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @TypeID IS NULL
    BEGIN
        RAISERROR('Parameter @TypeID is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @Version IS NULL
    BEGIN
        RAISERROR('Parameter @Version is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    DECLARE
        @Success BIT = 1,
        @Message NVARCHAR (MAX) = NULL

    MERGE
        [xdb_refdata].[Definitions] AS [target]
    USING
    (
        SELECT @TypeID, @Moniker, @Version
    )
    AS
        [source]([TypeID], [Moniker], [Version])
    ON
    (
        [target].[TypeID] = [source].[TypeID] AND
        [target].[Moniker] = [source].[Moniker] AND
        [target].[Version] = [source].[Version]
    )
    WHEN MATCHED AND [IsActive] = 0 THEN
        DELETE
    WHEN MATCHED AND [IsActive] = 1 THEN
        UPDATE SET @Success = 0, @Message = N'The definition is still active.';

    -- Check for not matched case
    IF @@ROWCOUNT = 0 AND @Success = 1
    BEGIN
        SET @Success = 0
        SET @Message = N'The definition version was not found.'
    END

    -- Return results
    SELECT
        NEWID() AS [DefinitionInstanceID],
        @Moniker AS [Moniker],
        @TypeID AS [TypeID],
        @Version AS [Version],
        @Success AS [Success],
        @Message AS [Message];
END
GO

PRINT N'Creating [xdb_refdata].[GetSingleDefinition]...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[GetSingleDefinition]') AND type in (N'P', N'PC'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [xdb_refdata].[GetSingleDefinition] AS'
END
GO

ALTER PROCEDURE [xdb_refdata].[GetSingleDefinition]
(
    @Moniker NVARCHAR (300),
    @TypeID UNIQUEIDENTIFIER,
    @Version SMALLINT,
    @Culture VARCHAR (84),
    @LatestActiveOnly BIT,
    -- Used for selecting only one of the result sets. 1 = Definitions, 2 = DefinitionCultures, anything else = both
    @ResultSetSelector SMALLINT = 0
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF @Moniker IS NULL
    BEGIN
        RAISERROR('Parameter @Moniker is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @TypeID IS NULL
    BEGIN
        RAISERROR('Parameter @TypeID is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @LatestActiveOnly IS NULL
    BEGIN
        RAISERROR('Parameter @LatestActiveOnly is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    DECLARE @ResolvedVersion SMALLINT = @Version;

    IF (@LatestActiveOnly = 1 AND @Version IS NULL)
    BEGIN
        SET @ResolvedVersion =
        (
            SELECT
                MAX([Version]) AS [MaxVersion]
            FROM
                [xdb_refdata].[Definitions]
            WHERE
                [Definitions].[TypeID] = @TypeID AND
                [Definitions].[Moniker] = @Moniker AND
                [Definitions].[IsActive] = 1
        );

        IF @ResolvedVersion IS NULL
            RETURN;
    END

    IF @ResultSetSelector IS NULL OR @ResultSetSelector != 2
    BEGIN
        SELECT
            [Moniker],
            [TypeID],
            [Version],
            [IsActive],
            [LastModified],
            [DataTypeRevision],
            [Data]
        FROM
            [xdb_refdata].[Definitions]
        WHERE
            [TypeID] = @TypeID AND
            [Moniker] = @Moniker AND
            [Version] = ISNULL(@ResolvedVersion, [Version])
        ORDER BY
            [Version];

        IF @@ROWCOUNT = 0
            RETURN;
    END

    IF @ResultSetSelector IS NULL OR @ResultSetSelector != 1
    BEGIN
        SELECT
            [defs].[Moniker],
            [defs].[TypeID],
            [defs].[Version],
            [cultures].[Culture],
            [cultures].[Data]
        FROM
            [xdb_refdata].[DefinitionCultures] [cultures]
        INNER JOIN
            [xdb_refdata].[Definitions] [defs]
        ON
            [defs].[ID] = [cultures].[DefinitionVersionID]
        WHERE
            [defs].[TypeID] = @TypeID AND
            [defs].[Moniker] = @Moniker AND
            [defs].[Version] = ISNULL(@ResolvedVersion, [defs].[Version]) AND
            [cultures].[Culture] = ISNULL(@Culture, [cultures].[Culture]);
    END
END
GO

PRINT N'Creating [xdb_refdata].[SaveSingleDefinition]...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[SaveSingleDefinition]') AND type in (N'P', N'PC'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [xdb_refdata].[SaveSingleDefinition] AS'
END
GO

ALTER PROCEDURE [xdb_refdata].[SaveSingleDefinition]
(
    @DefinitionInstanceID UNIQUEIDENTIFIER,
    @Moniker NVARCHAR(300),
    @TypeID UNIQUEIDENTIFIER,
    @Version SMALLINT,
    @IsActive BIT,
    @DataTypeRevision SMALLINT,
    @Data VARBINARY(MAX)
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @Results [xdb_refdata].[DefinitionResults],
        @CurrentDate DATETIME2(0) = CONVERT(DATETIME2(0), GETUTCDATE())

    IF @DefinitionInstanceID IS NULL
    BEGIN
        RAISERROR('Parameter @DefinitionInstanceID is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @Moniker IS NULL
    BEGIN
        RAISERROR('Parameter @Moniker is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @TypeID IS NULL
    BEGIN
        RAISERROR('Parameter @TypeID is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @Version IS NULL
    BEGIN
        RAISERROR('Parameter @Version is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @IsActive IS NULL
    BEGIN
        RAISERROR('Parameter @IsActive is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @DataTypeRevision IS NULL
    BEGIN
        RAISERROR('Parameter @DataTypeRevision is NULL.', 16, 1) WITH NOWAIT;
        RETURN
    END

    BEGIN TRY

        MERGE
            [xdb_refdata].[Definitions] AS [target]
        USING
        (
            SELECT @TypeID, @Moniker, @Version
        )
        AS
            [source] ([TypeID], [Moniker], [Version])
        ON
        (
            [target].[TypeID] = [source].[TypeID] AND
            [target].[Moniker] = [source].[Moniker] AND
            [target].[Version] = [source].[Version]
        )
        WHEN MATCHED THEN
            UPDATE
            SET
                [IsActive] = @IsActive,
                [LastModified] = @CurrentDate,
                [DataTypeRevision] = @DataTypeRevision,
                [Data] = @Data
        WHEN NOT MATCHED THEN
            INSERT
            (
                [ID],
                [Version],
                [TypeID],
                [IsActive],
                [LastModified],
                [DataTypeRevision],
                [Data],
                [Moniker]
            )
            VALUES
            (
                NEWID(),
                @Version,
                @TypeID,
                @IsActive,
                @CurrentDate,
                @DataTypeRevision,
                @Data,
                @Moniker
            )
        OUTPUT
            @DefinitionInstanceID,
            @Moniker,
            @TypeID,
            @Version,
            1,
            $action
        INTO @Results
        (
            [DefinitionInstanceID],
            [Moniker],
            [TypeID],
            [Version],
            [Success],
            [Message]
        );

    END TRY
    BEGIN CATCH
        INSERT INTO @Results
        (
            [DefinitionInstanceID],
            [Moniker],
            [TypeID],
            [Version],
            [Success],
            [Message]
        )
        VALUES
        (
            @DefinitionInstanceID,
            @Moniker,
            @TypeID,
            @Version,
            0,
            ERROR_MESSAGE()
        )
    END CATCH

    SELECT
        [DefinitionInstanceID],
        [Moniker],
        [TypeID],
        [Version],
        [Success],
        CASE [Message]
            WHEN 'INSERT' THEN NULL
            ELSE [Message]
        END AS [Message]
    FROM @Results
    AS Results
END
GO

PRINT N'Creating [xdb_refdata].[SaveSingleDefinitionCulture]...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[xdb_refdata].[SaveSingleDefinitionCulture]') AND type in (N'P', N'PC'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [xdb_refdata].[SaveSingleDefinitionCulture] AS'
END
GO

ALTER PROCEDURE [xdb_refdata].[SaveSingleDefinitionCulture]
(
    @DefinitionInstanceID UNIQUEIDENTIFIER,
    @Moniker NVARCHAR (300),
    @TypeID UNIQUEIDENTIFIER,
    @Version SMALLINT,
    @Culture VARCHAR (84),
    @Data VARBINARY (MAX)
)
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;

    IF @DefinitionInstanceID IS NULL
    BEGIN
        RAISERROR('Parameter @DefinitionInstanceID is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @Moniker IS NULL
    BEGIN
        RAISERROR('Parameter @Moniker is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @TypeID IS NULL
    BEGIN
        RAISERROR('Parameter @TypeID is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @Version IS NULL
    BEGIN
        RAISERROR('Parameter @Version is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    IF @Culture IS NULL
    BEGIN
        RAISERROR('Parameter @Culture is NULL', 16, 1) WITH NOWAIT;
        RETURN
    END

    DECLARE
        @DefinitionVersionID UNIQUEIDENTIFIER,
        @Succeeded BIT = 1,
        @Failed BIT = 0

    SET @DefinitionVersionID = (
        SELECT TOP 1
            [ID]
        FROM
            [xdb_refdata].[Definitions]
        WHERE
            [TypeID] = @TypeID AND
            [Moniker] = @Moniker AND
            [Version] = @Version
    )

    IF @DefinitionVersionID IS NULL
    BEGIN
        SELECT
            @DefinitionInstanceID AS [DefinitionInstanceID],
            @Moniker AS [Moniker],
            @TypeID AS [TypeID],
            @Version AS [Version],
            @Culture AS [Culture],
            @Failed AS [Success],
            N'The definition was not found' AS [Message];

        RETURN
    END

    BEGIN TRY
        MERGE
            [xdb_refdata].[DefinitionCultures] AS [target]
        USING
        (
            SELECT @DefinitionVersionID, @Culture
        )
        AS
            [source]([DefinitionVersionID], [Culture])
        ON
        (
            [target].[DefinitionVersionID] = [source].[DefinitionVersionID] AND
            [target].[Culture] = [source].[Culture]
        )
        WHEN MATCHED THEN
            UPDATE SET [Data] = @Data
        WHEN NOT MATCHED THEN
            INSERT
            (
                [ID],
                [DefinitionVersionID],
                [Culture],
                [Data]
            )
            VALUES
            (
                NEWID(),
                @DefinitionVersionID,
                @Culture,
                @Data
            )
        OUTPUT
            @DefinitionInstanceID AS [DefinitionInstanceID],
            @Moniker AS [Moniker],
            @TypeID AS [TypeID],
            @Version AS [Version],
            @Culture AS [Culture],
            @Succeeded AS [Success],
            CASE $action
                WHEN 'INSERT' THEN NULL
                ELSE $action
            END AS [Message];
    END TRY
    BEGIN CATCH
        SELECT
            @DefinitionInstanceID AS [DefinitionInstanceID],
            @Moniker AS [Moniker],
            @TypeID AS [TypeID],
            @Version AS [Version],
            @Culture AS [Culture],
            @Failed AS [Success],
            ERROR_MESSAGE() AS [Message];
    END CATCH
END
GO

PRINT N'Altering [xdb_refdata].[GrantLeastPrivilege]...';
GO

ALTER PROCEDURE [xdb_refdata].[GrantLeastPrivilege]
(
    @Name sysname
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

    EXECUTE('
        -- Types
        grant execute on TYPE::[xdb_refdata].[DefinitionBatch] TO [' + @Name + ']
        grant execute on TYPE::[xdb_refdata].[DefinitionCriteria] TO [' + @Name + ']
        grant execute on TYPE::[xdb_refdata].[DefinitionCultureBatch] TO [' + @Name + ']
        grant execute on TYPE::[xdb_refdata].[DefinitionCultureResults] TO [' + @Name + ']
        grant execute on TYPE::[xdb_refdata].[DefinitionKeys] TO [' + @Name + ']
        grant execute on TYPE::[xdb_refdata].[DefinitionResults] TO [' + @Name + ']
        grant execute on TYPE::[xdb_refdata].[MonikerDefinitions] TO [' + @Name + ']
        -- Procs
        grant execute on [xdb_refdata].[DeleteDefinitions] TO [' + @Name + ']
        grant execute on [xdb_refdata].[DeleteSingleDefinition] TO [' + @Name + ']
        grant execute on [xdb_refdata].[DeleteDefinitionType] TO [' + @Name + ']
        grant execute on [xdb_refdata].[EnsureDefinitionType] TO [' + @Name + ']
        grant execute on [xdb_refdata].[GetByDefinitionTypes] TO [' + @Name + ']
        grant execute on [xdb_refdata].[GetDefinitions] TO [' + @Name + ']
        grant execute on [xdb_refdata].[GetSingleDefinition] TO [' + @Name + ']
        grant execute on [xdb_refdata].[GetDefinitionType] TO [' + @Name + ']
        grant execute on [xdb_refdata].[SaveDefinitionCultures] TO [' + @Name + ']
        grant execute on [xdb_refdata].[SaveSingleDefinitionCulture] TO [' + @Name + ']
        grant execute on [xdb_refdata].[SaveSingleDefinition] TO [' + @Name + ']
        grant execute on [xdb_refdata].[SaveDefinitions] TO [' + @Name + ']');

END
GO

PRINT 'Upgrade (part 2) has been done successfully.'
GO
