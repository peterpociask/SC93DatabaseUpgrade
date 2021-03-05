-- Moving the default error messages to a separate error queue table
GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

IF NOT (EXISTS (SELECT *
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[error]') AND type in (N'U')))
BEGIN
	CREATE TABLE [dbo].[error](
		[id] [bigint] IDENTITY(1,1) NOT NULL,
		[priority] [int] NOT NULL,
		[expiration] [datetimeoffset](7) NOT NULL,
		[visible] [datetimeoffset](7) NOT NULL,
		[headers] [varbinary](max) NOT NULL,
		[body] [varbinary](max) NOT NULL,
	CONSTRAINT [PK_dbo_error] PRIMARY KEY CLUSTERED 
	(
		[priority] ASC,
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


	CREATE NONCLUSTERED INDEX [IDX_EXPIRATION_dbo_error] ON [dbo].[error]
	(
		[expiration] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


	CREATE NONCLUSTERED INDEX [IDX_RECEIVE_dbo_error] ON [dbo].[error]
	(
		[priority] ASC,
		[visible] ASC,
		[expiration] ASC,
		[id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	DECLARE @sqlErrorTable nvarchar(max) = 'BEGIN TRANSACTION;
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

	INSERT INTO [error] (
		  [priority]
		 ,[expiration]
		 ,[visible]
		 ,[headers]
		 ,[body])
	SELECT [priority]
		 ,[expiration]
		 ,[visible]
		 ,[headers]
		 ,[body]
		 FROM
		 [Sitecore_Transport] where recipient = ''error''
	-- clean up the data
	Delete FROM [Sitecore_Transport] WHERE recipient = ''error''
	COMMIT TRANSACTION'
	EXECUTE sp_executesql @sqlErrorTable

END
GO

DECLARE @tableNames TABLE (tableName varchar(100), OldQueueName varchar(200))
INSERT into @tableNames VALUES ('Sitecore_PE_TaskStatusPublisher', 'TaskStatus')
INSERT into @tableNames VALUES ('Sitecore_PE_TaskRegistrationConsumer', '_DONTEXIST_')
INSERT into @tableNames VALUES ('Sitecore_PE_TaskProgressConsumer', '_DONTEXIST_')
INSERT into @tableNames VALUES ('Sitecore_PE_TaskRegistrationProducer', '_DONTEXIST_')
INSERT into @tableNames VALUES ('Sitecore_PE_TaskProgressProducer', '_DONTEXIST_')
INSERT into @tableNames VALUES ('Sitecore_CT_ModelTrainingTaskStatusSubscriber', 'SitecoreContentTestingModelTrainingTaskStatusProducer')
INSERT into @tableNames VALUES ('Sitecore_MA_PurgeFromCampaignMessages', 'PurgeFromCampaignMessagesQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_AutomatedMessagesQueue', 'AutomatedMessagesQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_UpdateListSubscriptionMessagesQueue', 'UpdateListSubscriptionMessagesQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_ConfirmSubscriptionMessagesQueue', 'ConfirmSubscriptionMessagesQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_EmailOpenedMessagesQueue' , 'EmailOpenedMessagesQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_ClearSuppressionListQueue', 'ClearSuppressionListQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_EmailAddressHistoryMessagesQueue', 'EmailAddressHistoryMessagesQueue')
INSERT into @tableNames VALUES ('Sitecore_EXM_SentMessagesQueue', 'SentMessagesQueue')

DECLARE @tableName varchar(100)
DECLARE @oldQueueName varchar(200)

DECLARE tableCursor CURSOR FOR
SELECT tableName, oldQueueName FROM @tableNames
OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @tableName, @oldQueueName

WHILE (@@FETCH_STATUS = 0)
BEGIN
    DECLARE @sql nvarchar(max) = '
    IF NOT (EXISTS (SELECT *
        FROM sys.objects 
        WHERE object_id = OBJECT_ID(N''[dbo].[' + @tableName + ']'') AND type in (N''U'')))
    BEGIN
        CREATE TABLE [dbo].[' + @tableName + '](
            [id] [bigint] IDENTITY(1,1) NOT NULL,
            [priority] [int] NOT NULL,
            [expiration] [datetimeoffset](7) NOT NULL,
            [visible] [datetimeoffset](7) NOT NULL,
            [headers] [varbinary](max) NOT NULL,
            [body] [varbinary](max) NOT NULL,
         CONSTRAINT [PK_dbo_' + @tableName + '] PRIMARY KEY CLUSTERED 
            ([priority] ASC, [id] ASC) 
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END
    ELSE
        PRINT N''The table ' + @tableName + ' already present'';

    IF NOT EXISTS (SELECT * 
        FROM sys.indexes 
        WHERE name = ''IDX_EXPIRATION_dbo_' +  @tableName + ''')
        BEGIN
            CREATE NONCLUSTERED INDEX [IDX_EXPIRATION_dbo_' + @tableName + '] ON [dbo].[' + @tableName + ']
            (
                [expiration] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        END
    ELSE
        PRINT N''The index IDX_EXPIRATION_dbo_' + @tableName + ' already present'';

    IF NOT EXISTS (SELECT * 
        FROM sys.indexes 
        WHERE name = ''IDX_RECEIVE_dbo_' +  @tableName + ''')
        BEGIN
            CREATE NONCLUSTERED INDEX [IDX_RECEIVE_dbo_' + @tableName + '] ON [dbo].[' + @tableName + ']
            (
                [priority] ASC,
                [visible] ASC,
                [expiration] ASC,
                [id] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        END
    ELSE
        PRINT N''The index IDX_RECEIVE_dbo_' + @tableName + ' already present'';'
    EXECUTE sp_executesql @sql

	IF COL_LENGTH('Sitecore_Transport','recipient') IS NOT NULL
	BEGIN
		DECLARE @sqlMoveDate nvarchar(max) = 'BEGIN TRANSACTION;
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		INSERT INTO [dbo].[' + @tableName + '] (
			   [priority]
			  ,[expiration]
			  ,[visible]
			  ,[headers]
			  ,[body])
		SELECT [priority]
			  ,[expiration]
			  ,[visible]
			  ,[headers]
			  ,[body]
			  FROM
			  [Sitecore_Transport] where recipient LIKE '''+@oldQueueName+'%''

		Delete FROM [Sitecore_Transport] WHERE recipient LIKE '''+@oldQueueName+'%''

		Delete FROM [Sitecore_Subscriptions] WHERE address LIKE '''+@oldQueueName+'%''
		
		COMMIT TRANSACTION'
	END

	EXECUTE sp_executesql @sqlMoveDate

    FETCH NEXT FROM tableCursor INTO @tableName, @oldQueueName
END

CLOSE tableCursor
DEALLOCATE tableCursor



-- This script updates the existing schema of the messaging tables to the latest version of Rebus schema
GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


IF EXISTS (select top 1 1 from [dbo].[Sitecore_Transport])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO

PRINT N'Dropping [dbo].[Sitecore_Transport].[IDX_RECEIVE_dbo_Sitecore_Transport]...';

GO
DROP INDEX [IDX_RECEIVE_dbo_Sitecore_Transport]
    ON [dbo].[Sitecore_Transport];


GO
PRINT N'Dropping [dbo].[Sitecore_Transport].[IDX_EXPIRATION_dbo_Sitecore_Transport]...';


GO
DROP INDEX [IDX_EXPIRATION_dbo_Sitecore_Transport]
    ON [dbo].[Sitecore_Transport];


GO
PRINT N'Starting rebuilding table [dbo].[Sitecore_DataBus]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Sitecore_DataBus] (
    [Id]           VARCHAR (200)      NULL,
    [Meta]         VARBINARY (MAX)    NULL,
    [Data]         VARBINARY (MAX)    NULL,
    [CreationTime] DATETIMEOFFSET (7) NULL,
    [LastReadTime] DATETIMEOFFSET (7) NULL
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Sitecore_DataBus])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_Sitecore_DataBus] ([Id], [Meta], [Data], [LastReadTime])
        SELECT [Id],
               [Meta],
               [Data],
               [LastReadTime]
        FROM   [dbo].[Sitecore_DataBus];
    END

DROP TABLE [dbo].[Sitecore_DataBus];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Sitecore_DataBus]', N'Sitecore_DataBus';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Sitecore_Transport]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Sitecore_Transport] (
    [id]         BIGINT             IDENTITY (1, 1) NOT NULL,
    [priority]   INT                NOT NULL,
    [expiration] DATETIMEOFFSET (7) NOT NULL,
    [visible]    DATETIMEOFFSET (7) NOT NULL,
    [headers]    VARBINARY (MAX)    NOT NULL,
    [body]       VARBINARY (MAX)    NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_dbo_Sitecore_Transport1] PRIMARY KEY CLUSTERED ([priority] ASC, [id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Sitecore_Transport])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Sitecore_Transport] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Sitecore_Transport] ([priority], [id], [expiration], [visible], [headers], [body])
        SELECT   [priority],
                 [id],
                 [expiration],
                 [visible],
                 [headers],
                 [body]
        FROM     [dbo].[Sitecore_Transport]
        ORDER BY [priority] ASC, [id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Sitecore_Transport] OFF;
    END

DROP TABLE [dbo].[Sitecore_Transport];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Sitecore_Transport]', N'Sitecore_Transport';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_dbo_Sitecore_Transport1]', N'PK_dbo_Sitecore_Transport', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[Sitecore_Transport].[IDX_RECEIVE_dbo_Sitecore_Transport]...';


GO
CREATE NONCLUSTERED INDEX [IDX_RECEIVE_dbo_Sitecore_Transport]
    ON [dbo].[Sitecore_Transport]([priority] ASC, [visible] ASC, [expiration] ASC, [id] ASC);


GO
PRINT N'Creating [dbo].[Sitecore_Transport].[IDX_EXPIRATION_dbo_Sitecore_Transport]...';


GO
CREATE NONCLUSTERED INDEX [IDX_EXPIRATION_dbo_Sitecore_Transport]
    ON [dbo].[Sitecore_Transport]([expiration] ASC);


GO
PRINT N'Update complete.';


GO