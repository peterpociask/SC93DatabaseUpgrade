GO
PRINT N'Fact_Visits Data Migration Started';

GO
IF (OBJECT_ID('[dbo].[Fact_Visits]') IS NOT NULL AND OBJECT_ID('[dbo].[PK_Fact_Visits]', 'PK') IS NOT NULL) AND
EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ContactId' AND Object_ID = Object_ID(N'[dbo].[Fact_Visits]'))

BEGIN TRY
BEGIN TRANSACTION

DROP TABLE IF EXISTS ##TempFactVists

CREATE TABLE ##TempFactVists(
Date smalldatetime,
ItemId uniqueidentifier,
LanguageId int,
FirstVisit bit,
PagesCount bigint
)

EXEC('INSERT INTO ##TempFactVists(Date, ItemId, LanguageId, FirstVisit, PagesCount)
SELECT Date, ItemId, LanguageId, FirstVisit, SUM(PagesCount) as PagesCount from Fact_Visits GROUP BY Date, ItemId, LanguageId, FirstVisit, ContactId')

CREATE TABLE [dbo].[Fact_VisitsGroupByContactId] (
    [Date]       SMALLDATETIME    NOT NULL,
    [ItemId]     UNIQUEIDENTIFIER NOT NULL,
    [LanguageId] INT              NOT NULL,
    [FirstVisit] BIT              NOT NULL,
    [PagesCount] BIGINT           NOT NULL,
);

INSERT INTO Fact_VisitsGroupByContactId
SELECT * FROM ##TempFactVists

ALTER TABLE [dbo].[Fact_Visits] DROP CONSTRAINT [PK_Fact_Visits]
ALTER TABLE [dbo].[Fact_Visits] DROP CONSTRAINT [FK_Fact_Visits_Items]
ALTER TABLE [dbo].[Fact_Visits] DROP CONSTRAINT [FK_Fact_Visits_Languages]

DROP INDEX IF EXISTS [IX_Fact_Visits_FirstVisit] ON [dbo].[Fact_Visits]
DROP INDEX IF EXISTS [IX_Fact_Visits_Item] ON [dbo].[Fact_Visits]
DROP INDEX IF EXISTS [IX_Fact_Visits_Language] ON [dbo].[Fact_Visits]

ALTER TABLE [dbo].[Fact_VisitsGroupByContactId]
ADD CONSTRAINT [PK_Fact_Visits] PRIMARY KEY CLUSTERED 
(
	[Date] ASC,
	[FirstVisit] ASC,
	[ItemId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[Fact_VisitsGroupByContactId]  WITH NOCHECK ADD  CONSTRAINT [FK_Fact_Visits_Items] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Items] ([ItemId])


ALTER TABLE [dbo].[Fact_VisitsGroupByContactId] NOCHECK CONSTRAINT [FK_Fact_Visits_Items]


ALTER TABLE [dbo].[Fact_VisitsGroupByContactId]  WITH NOCHECK ADD  CONSTRAINT [FK_Fact_Visits_Languages] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Languages] ([LanguageId])


ALTER TABLE [dbo].[Fact_VisitsGroupByContactId] NOCHECK CONSTRAINT [FK_Fact_Visits_Languages]

CREATE NONCLUSTERED INDEX [IX_Fact_Visits_FirstVisit]
    ON [dbo].[Fact_VisitsGroupByContactId]([FirstVisit] ASC);

CREATE NONCLUSTERED INDEX [IX_Fact_Visits_Item]
    ON [dbo].[Fact_VisitsGroupByContactId]([ItemId] ASC);

CREATE NONCLUSTERED INDEX [IX_Fact_Visits_Language]
    ON [dbo].[Fact_VisitsGroupByContactId]([LanguageId] ASC);

DROP TABLE [dbo].[Fact_Visits]
DROP TABLE ##TempFactVists

EXEC sp_rename 'Fact_VisitsGroupByContactId', 'Fact_Visits';  

COMMIT TRANSACTION

PRINT N'Fact_Visits Migration Done';

END TRY
BEGIN CATCH 
	SELECT   
          ERROR_NUMBER() AS ErrorNumber  
          ,ERROR_SEVERITY() AS ErrorSeverity  
          ,ERROR_STATE() AS ErrorState  
          ,ERROR_PROCEDURE() AS ErrorProcedure  
          ,ERROR_LINE() AS ErrorLine  
          ,ERROR_MESSAGE() AS ErrorMessage;  
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN
END CATCH

ELSE
PRINT N'Fact_Visits Data Migration Done Without Any Changes';

GO
PRINT N'Fact_PageViews Data Migration Started';

GO
IF (OBJECT_ID('[dbo].[Fact_PageViews]') IS NOT NULL AND OBJECT_ID('[dbo].[PK_PageViews]', 'PK') IS NOT NULL) AND
EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'ContactId' AND Object_ID = Object_ID(N'[dbo].[Fact_PageViews]'))

BEGIN TRY
BEGIN TRANSACTION

DROP TABLE IF EXISTS ##TempFactPageViews

CREATE TABLE ##TempFactPageViews(
Date smalldatetime,
ItemId uniqueidentifier,
Views bigint,
Duration bigint,
Visits bigint,
Value bigint,
TestId uniqueidentifier,
TestCombination binary(16)
)

EXEC('INSERT INTO ##TempFactPageViews(Date, ItemId, TestId, TestCombination, Views, Duration, Visits, Value)
SELECT Date, ItemId, TestId, TestCombination, SUM(Views) as Views, SUM(Duration) as Duration, SUM(Visits) as Visits, SUM(Value) as Value 
from Fact_PageViews GROUP BY Date, ItemId, TestId, TestCombination')

CREATE TABLE [dbo].[Fact_PageViewsGroupByContactId](
	[Date] [smalldatetime] NOT NULL,
	[ItemId] [uniqueidentifier] NOT NULL,
	[Views] [bigint] NOT NULL,
	[Duration] [bigint] NOT NULL,
	[Visits] [bigint] NOT NULL,
	[Value] [bigint] NOT NULL,
	[TestId] [uniqueidentifier] NOT NULL,
	[TestCombination] [binary](16) NOT NULL);

INSERT INTO Fact_PageViewsGroupByContactId
SELECT * FROM ##TempFactPageViews

ALTER TABLE [dbo].[Fact_PageViews] DROP CONSTRAINT [PK_PageViews]
ALTER TABLE [dbo].[Fact_PageViews] DROP CONSTRAINT [FK_Fact_PageViews_Items]

DROP INDEX IF EXISTS [IX_Fact_PageViews_Item] ON [dbo].[Fact_PageViews]

ALTER TABLE [dbo].[Fact_PageViewsGroupByContactId]
ADD CONSTRAINT [PK_PageViews] PRIMARY KEY CLUSTERED 
(
[ItemId] ASC, 
[Date] ASC, 
[TestId] ASC, 
[TestCombination] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE [dbo].[Fact_PageViewsGroupByContactId]  WITH NOCHECK ADD  CONSTRAINT [FK_Fact_PageViews_Items] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Items] ([ItemId])

ALTER TABLE [dbo].[Fact_PageViewsGroupByContactId] NOCHECK CONSTRAINT [FK_Fact_PageViews_Items]

CREATE NONCLUSTERED INDEX [IX_Fact_PageViews_Item] ON [dbo].[Fact_PageViewsGroupByContactId]
(
	[ItemId] ASC
)


DROP TABLE [dbo].[Fact_PageViews]
DROP TABLE ##TempFactPageViews

EXEC sp_rename 'Fact_PageViewsGroupByContactId', 'Fact_PageViews';  

COMMIT TRANSACTION

PRINT N'Fact_PageViews Data Migration Done';

END TRY
BEGIN CATCH 
	SELECT   
          ERROR_NUMBER() AS ErrorNumber  
          ,ERROR_SEVERITY() AS ErrorSeverity  
          ,ERROR_STATE() AS ErrorState  
          ,ERROR_PROCEDURE() AS ErrorProcedure  
          ,ERROR_LINE() AS ErrorLine  
          ,ERROR_MESSAGE() AS ErrorMessage;  
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN
END CATCH

ELSE
PRINT N'Fact_PageViews Data Migration Done Without Any Changes';

