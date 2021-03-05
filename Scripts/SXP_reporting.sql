SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

PRINT N'xA Creating Converted Column...';
PRINT N'xA Creating Table for Converted Column...';
GO 

BEGIN TRANSACTION AddConvertedColumn
  BEGIN TRY  

      DECLARE @ExperienceAnalyticsTableForConverted Table
      (
        TableName NVARCHAR(100)
      )

      INSERT INTO @ExperienceAnalyticsTableForConverted VALUES 
      ('Fact_CampaignFacetGroupMetrics'),
      ('Fact_CampaignFacetMetrics'),
      ('Fact_CampaignGroupMetrics'),
      ('Fact_CampaignMetrics'),
      ('Fact_ChannelGroupMetrics'),
      ('Fact_ChannelMetrics'),
      ('Fact_ChannelTypeMetrics'),
      ('Fact_CityMetrics'),
      ('Fact_CountryMetrics'),
      ('Fact_DeviceModelMetrics'),
      ('Fact_DeviceSizeMetrics'),
      ('Fact_DeviceTypeMetrics'),
      ('Fact_EntryPageByUrlMetrics'),
      ('Fact_EntryPageMetrics'),
      ('Fact_ExitPageByUrlMetrics'),
      ('Fact_ExitPageMetrics'),
      ('Fact_GoalFacetGroupMetrics'),
      ('Fact_GoalFacetMetrics'),
      ('Fact_GoalMetrics'),
      ('Fact_LanguageMetrics'),
      ('Fact_OutcomeGroupMetrics'),
      ('Fact_OutcomeMetrics'),
      ('Fact_PageByUrlMetrics'),
      ('Fact_PageMetrics'),
      ('Fact_PageViewsMetrics'),
      ('Fact_PatternMetrics'),
      ('Fact_ReferringSiteMetrics'),
      ('Fact_RegionMetrics'),
      ('Fact_SearchMetrics'),
      ('Fact_SegmentMetrics'),
      ('Fact_SegmentMetricsReduced')
      DECLARE @name VARCHAR(50)

      DECLARE ExperienceAnalyticsTable_cursor CURSOR FOR 
      SELECT TableName FROM @ExperienceAnalyticsTableForConverted

      OPEN ExperienceAnalyticsTable_cursor  
      FETCH NEXT FROM ExperienceAnalyticsTable_cursor INTO @name  

      WHILE @@FETCH_STATUS = 0  
      BEGIN
        IF (OBJECT_ID(@name, 'U') IS NOT NULL)
          BEGIN
            IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @name AND COLUMN_NAME = 'Converted')
              BEGIN
                EXEC('ALTER TABLE ' +  @name + ' ADD Converted INT NOT NULL CONSTRAINT defaultConstraints Default (0)' )
                EXEC('ALTER TABLE ' +  @name + ' DROP CONSTRAINT defaultConstraints')
                --Uncomment the script below if you want to retain the previous conversion rate results
                --EXEC('UPDATE ' +  @name + ' SET Converted = Conversions')
                PRINT 'Converted Column Added Successfully in ' + @name
              END
          END
        FETCH NEXT FROM ExperienceAnalyticsTable_cursor INTO @name  
      END
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
          ROLLBACK TRANSACTION;  
  END CATCH;  
  
  IF @@TRANCOUNT > 0  
  BEGIN
      COMMIT TRANSACTION;  
      PRINT N'xA Successfully Created Converted Column...'
  END;
GO  

PRINT N'xA Creating FilterId Column...';
PRINT N'xA Creating Table for FilterId Column...';
GO  

BEGIN TRANSACTION AddFilterColumn
  BEGIN TRY  

      DECLARE @ExperienceAnalyticsTableForFilterId Table
      (
        TableName NVARCHAR(100)
      )

      INSERT INTO @ExperienceAnalyticsTableForFilterId VALUES 
      ('Fact_AssetGroupMetrics'),
      ('Fact_AssetMetrics'),
      ('Fact_CampaignFacetGroupMetrics'),
      ('Fact_CampaignFacetMetrics'),
      ('Fact_CampaignGroupMetrics'),
      ('Fact_CampaignMetrics'),
      ('Fact_ChannelGroupMetrics'),
      ('Fact_ChannelMetrics'),
      ('Fact_ChannelTypeMetrics'),
      ('Fact_CityMetrics'),
      ('Fact_ConversionsMetrics'),
      ('Fact_CountryMetrics'),
      ('Fact_DeviceModelMetrics'),
      ('Fact_DeviceSizeMetrics'),
      ('Fact_DeviceTypeMetrics'),
      ('Fact_DownloadEventMetrics'),
      ('Fact_EntryPageByUrlMetrics'),
      ('Fact_EntryPageMetrics'),
      ('Fact_ExitPageByUrlMetrics'),
      ('Fact_ExitPageMetrics'),
      ('Fact_GoalFacetGroupMetrics'),
      ('Fact_GoalFacetMetrics'),
      ('Fact_GoalMetrics'),
      ('Fact_LanguageMetrics'),
      ('Fact_OutcomeGroupMetrics'),
      ('Fact_OutcomeMetrics'),
      ('Fact_PageByUrlMetrics'),
      ('Fact_PageMetrics'),
      ('Fact_PageViewsMetrics'),
      ('Fact_PatternMetrics'),
      ('Fact_ReferringSiteMetrics'),
      ('Fact_RegionMetrics'),
      ('Fact_SearchMetrics')

      DECLARE @name VARCHAR(50)

      DECLARE ExperienceAnalyticsTable_cursor CURSOR FOR 
      SELECT TableName FROM @ExperienceAnalyticsTableForFilterId

      OPEN ExperienceAnalyticsTable_cursor  
      FETCH NEXT FROM ExperienceAnalyticsTable_cursor INTO @name  

      WHILE @@FETCH_STATUS = 0  
      BEGIN
        IF (OBJECT_ID(@name, 'U') IS NOT NULL)
          BEGIN
            IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @name AND COLUMN_NAME = 'FilterId')
              BEGIN
                EXEC('ALTER TABLE ' +  @name + ' ADD FilterId UNIQUEIDENTIFIER' )
                PRINT 'FilterId Column Added Successfully in ' + @name
              END
          END
        FETCH NEXT FROM ExperienceAnalyticsTable_cursor INTO @name  
      END
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
          ROLLBACK TRANSACTION;  
  END CATCH;  
  
  IF @@TRANCOUNT > 0  
  BEGIN
      COMMIT TRANSACTION;  
      PRINT N'xA Successfully Created FilterId Column...'
  END;
GO  

BEGIN

PRINT N'Adding FirstImpressionCount to [Fact_SearchMetrics]';
IF(OBJECT_ID('[dbo].[Fact_SearchMetrics]', 'U') IS NOT NULL)
Begin
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'Fact_SearchMetrics' AND COLUMN_NAME = 'FirstImpressionCount')
	BEGIN
		ALTER TABLE [dbo].[Fact_SearchMetrics] ADD [FirstImpressionCount] INT NOT NULL CONSTRAINT Fact_SearchMetrics_FirstImpressionCount DEFAULT 0;
	END
END

PRINT N'Adding FirstImpressionCount to [Fact_PageMetrics]';
IF(OBJECT_ID('[dbo].[Fact_PageMetrics]', 'U') IS NOT NULL)
Begin 
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'Fact_PageMetrics' AND COLUMN_NAME = 'FirstImpressionCount')
	BEGIN
		ALTER TABLE [dbo].[Fact_PageMetrics] ADD [FirstImpressionCount] INT NOT NULL CONSTRAINT Fact_PageMetrics_FirstImpressionCount DEFAULT 0;
	END
END

PRINT N'Adding FirstImpressionCount to [Fact_PageByUrlMetrics]';
IF(OBJECT_ID('[dbo].[Fact_PageByUrlMetrics]', 'U') IS NOT NULL)
Begin
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'Fact_PageByUrlMetrics' AND COLUMN_NAME = 'FirstImpressionCount')
	BEGIN
		ALTER TABLE [dbo].[Fact_PageByUrlMetrics] ADD [FirstImpressionCount] INT NOT NULL CONSTRAINT Fact_PageByUrlMetrics_FirstImpressionCount DEFAULT 0;
	END
END

END
GO

--Uncomment the script below if you want to retain the previous bounce rate results
/*BEGIN TRANSACTION UpdateFirstImpressionCountColumn
  BEGIN TRY  

      DECLARE @ExperienceAnalyticsTableForFirstImpressionCount Table
      (
        TableName NVARCHAR(100)
      )

      INSERT INTO @ExperienceAnalyticsTableForFirstImpressionCount VALUES 
      ('Fact_PageByUrlMetrics'),
      ('Fact_PageMetrics'),
      ('Fact_SearchMetrics')
      DECLARE @name VARCHAR(50)

      DECLARE ExperienceAnalyticsTable_cursor CURSOR FOR 
      SELECT TableName FROM @ExperienceAnalyticsTableForFirstImpressionCount

      OPEN ExperienceAnalyticsTable_cursor  
      FETCH NEXT FROM ExperienceAnalyticsTable_cursor INTO @name  

      WHILE @@FETCH_STATUS = 0  
      BEGIN
        IF (OBJECT_ID(@name, 'U') IS NOT NULL)
          BEGIN
            IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = @name AND COLUMN_NAME = 'FirstImpressionCount')
               BEGIN
                 EXEC('UPDATE ' +  @name + ' SET FirstImpressionCount = Visits')
               END
          END
        FETCH NEXT FROM ExperienceAnalyticsTable_cursor INTO @name  
      END
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
          ROLLBACK TRANSACTION;  
  END CATCH;  
  
  IF @@TRANCOUNT > 0  
  BEGIN
      COMMIT TRANSACTION;  
      PRINT N'xA Successfully Updated First Impression Count Column...'
  END;
GO*/

PRINT N'Dropping [dbo].[Add_Failures_Tvp]...';

GO
DROP PROCEDURE [dbo].[Add_Failures_Tvp];

GO

PRINT N'Dropping [dbo].[Failures_Type]...';


GO
DROP TYPE [dbo].[Failures_Type];


GO
PRINT N'Creating [dbo].[Failures_Type]...';


GO
CREATE TYPE [dbo].[Failures_Type] AS TABLE (
    [VisitId]               UNIQUEIDENTIFIER NOT NULL,
    [AccountId]             UNIQUEIDENTIFIER NOT NULL,
    [Date]                  SMALLDATETIME    NOT NULL,
    [ContactId]             UNIQUEIDENTIFIER NOT NULL,
    [PageEventDefinitionId] UNIQUEIDENTIFIER NOT NULL,
    [KeywordsId]            UNIQUEIDENTIFIER NOT NULL,
    [ReferringSiteId]       UNIQUEIDENTIFIER NOT NULL,
    [ContactVisitIndex]     INT              NOT NULL,
    [VisitPageIndex]        INT              NOT NULL,
    [FailureDetailsId]      UNIQUEIDENTIFIER NOT NULL,
    [Value]                 BIGINT           NOT NULL,
    [Count]                 BIGINT           NOT NULL,
    PRIMARY KEY CLUSTERED ([VisitId] ASC, [AccountId] ASC, [Date] ASC, [ContactId] ASC, [PageEventDefinitionId] ASC, [KeywordsId] ASC, [ReferringSiteId] ASC, [ContactVisitIndex] ASC, [VisitPageIndex] ASC, [FailureDetailsId] ASC));


GO

PRINT N'Altering [dbo].[DimensionKeys]...';
ALTER TABLE [dbo].[DimensionKeys] ALTER COLUMN [DimensionKey] NVARCHAR (MAX) NOT NULL;

GO

IF (NOT EXISTS (SELECT * FROM sys.indexes WHERE name='IX_Trees_Visits' AND object_id = OBJECT_ID('[dbo].[Trees]')))
BEGIN

PRINT N'Creating [dbo].[Trees].[IX_Trees_Visits]...';
CREATE NONCLUSTERED INDEX [IX_Trees_Visits]
    ON [dbo].[Trees]([Visits] ASC);

END
GO

PRINT N'Altering [dbo].[Fact_TestConversions]...';
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'Date' AND Object_ID = Object_ID(N'[dbo].[Fact_TestConversions]'))
BEGIN

ALTER TABLE [Fact_TestConversions] ADD [Date] DATE NOT NULL CONSTRAINT FK_Fact_TestConversions_Date  DEFAULT '1753-01-01'

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Downloads_Campaigns]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Conversions_Campaigns]...';
ALTER TABLE [dbo].[Fact_Conversions] DROP CONSTRAINT [FK_Fact_Conversions_Campaigns];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Downloads_Campaigns]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Downloads_Campaigns]...';
ALTER TABLE [dbo].[Fact_Downloads] DROP CONSTRAINT [FK_Fact_Downloads_Campaigns];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Searches_Campaigns]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Searches_Campaigns]...';
ALTER TABLE [dbo].[Fact_Searches] DROP CONSTRAINT [FK_Fact_Searches_Campaigns];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_SiteSearches_Campaigns]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_SiteSearches_Campaigns]...';
ALTER TABLE [dbo].[Fact_SiteSearches] DROP CONSTRAINT [FK_Fact_SiteSearches_Campaigns];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Traffic_Campaigns]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Traffic_Campaigns]...';
ALTER TABLE [dbo].[Fact_Traffic] DROP CONSTRAINT [FK_Fact_Traffic_Campaigns];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Conversions_PageEventDefinitions]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Conversions_PageEventDefinitions]...';
ALTER TABLE [dbo].[Fact_Conversions] DROP CONSTRAINT [FK_Fact_Conversions_PageEventDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Conversions_TrafficTypes]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Conversions_TrafficTypes]...';
ALTER TABLE [dbo].[Fact_Conversions] DROP CONSTRAINT [FK_Fact_Conversions_TrafficTypes];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_SiteSearches_TrafficTypes]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Downloads_TrafficTypes]...';
ALTER TABLE [dbo].[Fact_Downloads] DROP CONSTRAINT [FK_Fact_Downloads_TrafficTypes];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_SiteSearches_TrafficTypes]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_SiteSearches_TrafficTypes]...';
ALTER TABLE [dbo].[Fact_SiteSearches] DROP CONSTRAINT [FK_Fact_SiteSearches_TrafficTypes];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Traffic_TrafficTypes]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Traffic_TrafficTypes]...';
ALTER TABLE [dbo].[Fact_Traffic] DROP CONSTRAINT [FK_Fact_Traffic_TrafficTypes];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_ValueBySource_TrafficTypes]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_ValueBySource_TrafficTypes]...';
ALTER TABLE [dbo].[Fact_ValueBySource] DROP CONSTRAINT [FK_Fact_ValueBySource_TrafficTypes];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_VisitsByBusinessContactLocation_TrafficTypes]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_VisitsByBusinessContactLocation_TrafficTypes]...';
ALTER TABLE [dbo].[Fact_VisitsByBusinessContactLocation] DROP CONSTRAINT [FK_Fact_VisitsByBusinessContactLocation_TrafficTypes];

END
GO

IF (OBJECT_ID('[dbo].[FK_Fact_Visits_Contacts]', 'F') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FK_Fact_Visits_Contacts]...';
ALTER TABLE [dbo].[Fact_Visits] DROP CONSTRAINT [FK_Fact_Visits_Contacts];

END
GO

IF (OBJECT_ID('[dbo].[Ensure_DimensionKeys_Tvp]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Ensure_DimensionKeys_Tvp]...';
DROP PROCEDURE [dbo].[Ensure_DimensionKeys_Tvp];

END
GO

IF (OBJECT_ID('[dbo].[Delete_CampaignActivityDefinitions]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Delete_CampaignActivityDefinitions]...';
DROP PROCEDURE [dbo].[Delete_CampaignActivityDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[Delete_FunnelDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Delete_FunnelDefinition]...';
DROP PROCEDURE [dbo].[Delete_FunnelDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Delete_GoalDefinitions]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Delete_GoalDefinitions]...';
DROP PROCEDURE [dbo].[Delete_GoalDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[Delete_MarketingAssetDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Delete_MarketingAssetDefinition]...';
DROP PROCEDURE [dbo].[Delete_MarketingAssetDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Delete_OutcomeDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Delete_OutcomeDefinition]...';
DROP PROCEDURE [dbo].[Delete_OutcomeDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_Campaign]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_Campaign]...';
DROP PROCEDURE [dbo].[Upsert_Campaign];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_CampaignActivityDefinitions]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_CampaignActivityDefinitions]...';
DROP PROCEDURE [dbo].[Upsert_CampaignActivityDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_FunnelDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_FunnelDefinition]...';
DROP PROCEDURE [dbo].[Upsert_FunnelDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_GoalDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_GoalDefinition]...';
DROP PROCEDURE [dbo].[Upsert_GoalDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_MarketingAssetDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_MarketingAssetDefinition]...';
DROP PROCEDURE [dbo].[Upsert_MarketingAssetDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_OutcomeDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_OutcomeDefinition]...';
DROP PROCEDURE [dbo].[Upsert_OutcomeDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_PageEventDefinition]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_PageEventDefinition]...';
DROP PROCEDURE [dbo].[Upsert_PageEventDefinition];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_TrafficType]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_TrafficType]...';
DROP PROCEDURE [dbo].[Upsert_TrafficType];

END
GO

IF (OBJECT_ID('[dbo].[Upsert_VisitorClassification]', 'P') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Upsert_VisitorClassification]...';
DROP PROCEDURE [dbo].[Upsert_VisitorClassification];

END
GO

IF (OBJECT_ID('[dbo].[CampaignActivityDefinitions]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[CampaignActivityDefinitions]...';
DROP TABLE [dbo].[CampaignActivityDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[Campaigns]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[Campaigns]...';
DROP TABLE [dbo].[Campaigns];

END
GO

IF (OBJECT_ID('[dbo].[FunnelDefinitions]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[FunnelDefinitions]...';
DROP TABLE [dbo].[FunnelDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[GoalDefinitions]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[GoalDefinitions]...';
DROP TABLE [dbo].[GoalDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[MarketingAssetDefinitions]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[MarketingAssetDefinitions]...';
DROP TABLE [dbo].[MarketingAssetDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[OutcomeDefinitions]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[OutcomeDefinitions]...';
DROP TABLE [dbo].[OutcomeDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[PageEventDefinitions]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[PageEventDefinitions]...';
DROP TABLE [dbo].[PageEventDefinitions];

END
GO

IF (OBJECT_ID('[dbo].[TrafficTypes]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[TrafficTypes]...';
DROP TABLE [dbo].[TrafficTypes];

END
GO




GO

IF (OBJECT_ID('[dbo].[VisitorClassification]', 'U') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[VisitorClassification]...';
DROP TABLE [dbo].[VisitorClassification];

END
GO




GO
PRINT N'Dropping [dbo].[DimensionKeys_Type]...';


GO
DROP TYPE [dbo].[DimensionKeys_Type];


GO
PRINT N'Creating [dbo].[DimensionKeys_Type]...';


GO
CREATE TYPE [dbo].[DimensionKeys_Type] AS TABLE (
    [DimensionKeyId] BIGINT         NOT NULL,
    [DimensionKey]   NVARCHAR (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([DimensionKeyId] ASC));


GO
PRINT N'Altering [dbo].[GetTagValue]...';


GO
ALTER FUNCTION [dbo].[GetTagValue]
(
  @data XML,
  @tagName NVARCHAR(100)
)
RETURNS NVARCHAR(1000)
WITH EXECUTE AS OWNER
AS 
BEGIN
  RETURN @data.value( '(/tags/tag[@tagname = sql:variable("@tagName")]/@tagvalue)[1]', 'NVARCHAR(1000)' );
END
GO
PRINT N'Altering [dbo].[GetTaxonEntityChildIds]...';


GO
ALTER FUNCTION [GetTaxonEntityChildIds]
(
  @Id UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
WITH EXECUTE AS OWNER
AS
BEGIN
	DECLARE @idString NVARCHAR(MAX)
	
	SELECT @idString = COALESCE(@idString + ',', '') + CAST(Id AS NVARCHAR(255))
	FROM [Taxonomy_TaxonEntity]
	WHERE ParentId = @Id

	RETURN @idString
END
GO
PRINT N'Altering [dbo].[CampaignsOverview]...';


GO

ALTER VIEW [dbo].[CampaignsOverview]
AS
SELECT 
  [TrafficOverview].[Date],
  [TrafficOverview].[Month],
  [TrafficOverview].[TrafficType],
  [TrafficOverview].[ItemId],
  [TrafficOverview].[Url],
  [TrafficOverview].[KeywordsId],
  [TrafficOverview].[Keywords],
  [TrafficOverview].[ReferringSiteId],
  [TrafficOverview].[ReferringSite],
  [TrafficOverview].[Multisite],
  [TrafficOverview].[Language],
  [TrafficOverview].[DeviceName],
  [TrafficOverview].[FirstVisit],
  [TrafficOverview].[Visits],
  [TrafficOverview].[Value]
FROM
  [TrafficOverview]
WHERE
  [TrafficOverview].[CampaignId] IS NOT NULL
GO
PRINT N'Altering [dbo].[Conversions]...';


GO

ALTER VIEW [Conversions]
AS
SELECT
  [Fact_Conversions].[Date] AS [Date],
  CAST( DATEADD( DAY, (-DATEPART( DAY, [Fact_Conversions].[Date] ) + 1), [Fact_Conversions].[Date] ) AS DATE) AS [Month],
  [Fact_Conversions].[TrafficType] AS [TrafficType],
  [Fact_Conversions].[ItemId] AS [ItemId],
  ISNULL( [Fact_Conversions].[CampaignId], '00000000-0000-0000-0000-000000000000' ) AS [CampaignId],
  [Fact_Conversions].[ContactId] AS [ContactId],
  [Fact_Conversions].[AccountId] AS [AccountId],
  LOWER( [SiteNames].[SiteName] ) AS [Multisite],
  LOWER( [DeviceNames].[DeviceName] ) AS [DeviceName],
  LOWER( [Languages].[Name] ) AS [Language],
  [Fact_Conversions].[GoalId] AS [PageEventDefinitionId],
  [Fact_Conversions].[Value] AS [Value],
  [Fact_Conversions].[Visits] AS [Visits],
  [Fact_Conversions].[Count] AS [NumberOfEvents],
  [Fact_Conversions].[GoalPoints] AS [GoalPoints]
FROM
  [Fact_Conversions]
  INNER JOIN [SiteNames] ON ([Fact_Conversions].[SiteNameId] = [SiteNames].[SiteNameId])
  INNER JOIN [DeviceNames] ON ([Fact_Conversions].[DeviceNameId] = [DeviceNames].[DeviceNameId])
  INNER JOIN [Languages] ON  ([Fact_Conversions].[LanguageId] = [Languages].[LanguageId])
WHERE
  [Fact_Conversions].[GoalId] IS NOT NULL
GO
PRINT N'Altering [dbo].[Downloads]...';


GO

ALTER VIEW [Downloads]
AS
SELECT
  [Fact_Downloads].[Date] AS [Date],
  CAST( DATEADD( DAY, (-DATEPART( DAY, [Fact_Downloads].[Date] ) + 1), [Fact_Downloads].[Date] ) AS DATE) AS [Month],
  [Fact_Downloads].[TrafficType] AS [TrafficType],
  [Fact_Downloads].[ItemId] AS [ItemId],
  ISNULL( [Fact_Downloads].[CampaignId], '00000000-0000-0000-0000-000000000000' ) AS [CampaignId],
  LOWER( [SiteNames].[SiteName] ) AS [Multisite],
  LOWER( [DeviceNames].[DeviceName] ) AS [DeviceName],
  LOWER( [Languages].[Name] ) AS [Language],
  [Fact_Downloads].[AssetId] AS [AssetId],
  [Assets].[Url] AS [Asset],
  [Fact_Downloads].[Value] AS [Value],
  [Fact_Downloads].[Visits] AS [Visits],
  [Fact_Downloads].[Count] AS [NumberOfEvents]
FROM
  [Fact_Downloads]
  INNER JOIN [SiteNames] ON ([Fact_Downloads].[SiteNameId] = [SiteNames].[SiteNameId])
  INNER JOIN [DeviceNames] ON ([Fact_Downloads].[DeviceNameId] = [DeviceNames].[DeviceNameId])
  INNER JOIN [Languages] ON  ([Fact_Downloads].[LanguageId] = [Languages].[LanguageId])
  INNER JOIN [Assets] ON ([Fact_Downloads].[AssetId] = [Assets].[AssetId])
GO
PRINT N'Altering [dbo].[SiteSearches]...';


GO

ALTER VIEW [SiteSearches]
AS
SELECT
  [Fact_SiteSearches].[Date] AS [Date],
  CAST( DATEADD( DAY, (-DATEPART( DAY, [Fact_SiteSearches].[Date] ) + 1), [Fact_SiteSearches].[Date] ) AS DATE) AS [Month],
  [Fact_SiteSearches].[TrafficType] AS [TrafficType],
  ISNULL( [Fact_SiteSearches].[CampaignId], '00000000-0000-0000-0000-000000000000' ) AS [CampaignId],
  [Fact_SiteSearches].[ItemId] AS [ItemId],
  LOWER( [SiteNames].[SiteName] ) AS [Multisite],
  LOWER( [DeviceNames].[DeviceName] ) AS [DeviceName],
  LOWER( [Languages].[Name] ) AS [Language],
  [Fact_SiteSearches].[KeywordsId] AS [KeywordsId],
  [Keywords].[Keywords] AS [Keywords],
  [Fact_SiteSearches].[Value] AS [Value],
  [Fact_SiteSearches].[Visits] AS [Visits],
  [Fact_SiteSearches].[Count] AS [NumberOfEvents]
FROM
  [Fact_SiteSearches]
  INNER JOIN [SiteNames] ON ([Fact_SiteSearches].[SiteNameId] = [SiteNames].[SiteNameId])
  INNER JOIN [DeviceNames] ON ([Fact_SiteSearches].[DeviceNameId] = [DeviceNames].[DeviceNameId])
  INNER JOIN [Languages] ON  ([Fact_SiteSearches].[LanguageId] = [Languages].[LanguageId])
  INNER JOIN [Keywords] ON ([Fact_SiteSearches].[KeywordsId] = [Keywords].[KeywordsId])
GO
PRINT N'Altering [dbo].[__DeleteAllReportingData]...';


GO
ALTER PROCEDURE [dbo].[__DeleteAllReportingData]
  @exclude_tables NVARCHAR(MAX)
WITH EXECUTE AS OWNER
AS
BEGIN

CREATE TABLE #foreign_keys
(
 [foreign_key_name] NVARCHAR(MAX) NULL,
 [is_disabled] BIT,
 [primary_table_name] NVARCHAR(MAX) NULL,
 [primary_column_name] NVARCHAR(MAX) NULL,
 [foriegn_key_table_name] NVARCHAR(MAX) NULL,
 [foriegn_key_column_name] NVARCHAR(MAX) NULL
)

-- Collect all foreign keys.
INSERT INTO #foreign_keys
SELECT '[' + fk.name + ']' AS [foreign_key_name]
     , fk.is_disabled AS [is_disabled]
     , '[' + SCHEMA_NAME(pt.schema_id) + '].[' + OBJECT_NAME(pt.object_id) + ']' AS [primary_table_name]
     , '[' + ptc.name + ']' AS [primary_column_name]
     , '[' + SCHEMA_NAME(ft.schema_id) + '].[' + OBJECT_NAME(ft.object_id) + ']' AS [foriegn_key_table_name]
     , '[' + ftc.name + ']' AS [foriegn_key_column_name]
  FROM sys.foreign_keys fk
       INNER JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
       INNER JOIN sys.tables pt ON pt.object_id = fkc.parent_object_id
       INNER JOIN sys.tables ft ON ft.object_id = fkc.referenced_object_id
       INNER JOIN sys.columns ptc ON ptc.object_id = fkc.parent_object_id AND ptc.column_id = fkc.parent_column_id
       INNER JOIN sys.columns ftc ON ftc.object_id = fkc.referenced_object_id AND ftc.column_id = fkc.referenced_column_id

-- Drop the foreign keys.
DECLARE @foreign_key_name SYSNAME
      , @is_disabled SYSNAME
      , @primary_table_name SYSNAME
      , @primary_column_name SYSNAME
      , @foriegn_key_table_name SYSNAME
      , @foriegn_key_column_name SYSNAME
      , @sql NVARCHAR(MAX)

DECLARE foreign_keys CURSOR FOR
 SELECT *
   FROM #foreign_keys
  ORDER BY [primary_table_name]
BEGIN
  OPEN foreign_keys
  FETCH NEXT FROM foreign_keys INTO @foreign_key_name, @is_disabled, @primary_table_name, @primary_column_name, @foriegn_key_table_name, @foriegn_key_column_name
  WHILE @@FETCH_STATUS <> -1 BEGIN
    SET @sql = 'ALTER TABLE ' + @primary_table_name + ' DROP ' + @foreign_key_name;
    EXEC sp_executesql @sql
    FETCH NEXT FROM foreign_keys INTO @foreign_key_name, @is_disabled, @primary_table_name, @primary_column_name, @foriegn_key_table_name, @foriegn_key_column_name
  END
  CLOSE foreign_keys
  DEALLOCATE foreign_keys
END

-- Truncate all tables.
DECLARE tables CURSOR FOR
SELECT '[' + [TABLE_SCHEMA] + '].[' + [TABLE_NAME] + ']' as [primary_table_name]
  FROM [INFORMATION_SCHEMA].[TABLES]
 WHERE [TABLE_TYPE] = 'BASE TABLE' AND CHARINDEX('[' + [TABLE_SCHEMA] + '].[' + [TABLE_NAME] + ']', @exclude_tables) = 0
 ORDER BY [TABLE_SCHEMA] + '.' + [TABLE_NAME]
BEGIN
  OPEN tables
  FETCH NEXT FROM tables INTO @primary_table_name
  WHILE @@FETCH_STATUS <> -1 BEGIN
    SET @sql = 'TRUNCATE TABLE ' + @primary_table_name
    EXEC sp_executesql @sql
    FETCH NEXT FROM tables INTO @primary_table_name
  END
  CLOSE tables
  DEALLOCATE tables
END

-- Restore foreign keys.
DECLARE foreign_keys CURSOR FOR
 SELECT *
   FROM #foreign_keys
  ORDER BY [primary_table_name]
BEGIN
  OPEN foreign_keys
  FETCH NEXT FROM foreign_keys INTO @foreign_key_name, @is_disabled, @primary_table_name, @primary_column_name, @foriegn_key_table_name, @foriegn_key_column_name
  WHILE @@FETCH_STATUS <> -1 BEGIN
    SET @sql = 'ALTER TABLE ' + @primary_table_name + ' WITH NOCHECK ADD CONSTRAINT ' + @foreign_key_name + ' FOREIGN KEY(' + @primary_column_name + ')
                 REFERENCES ' + @foriegn_key_table_name + ' (' + @foriegn_key_column_name + ')
                ALTER TABLE ' + @primary_table_name + CASE WHEN @is_disabled = 1 THEN ' NOCHECK CONSTRAINT ' ELSE ' CHECK CONSTRAINT ' END + @foreign_key_name
    EXEC sp_executesql @sql
    FETCH NEXT FROM foreign_keys INTO @foreign_key_name, @is_disabled, @primary_table_name, @primary_column_name, @foriegn_key_table_name, @foriegn_key_column_name
  END
  CLOSE foreign_keys
  DEALLOCATE foreign_keys
END

DROP TABLE #foreign_keys

END
GO
PRINT N'Altering [dbo].[Add_AutomationStates]...';


GO
ALTER PROCEDURE [dbo].[Add_AutomationStates]
  @PlanId [uniqueidentifier],
  @StateId [uniqueidentifier],
  @Contacts [bigint]
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE [dbo].[Fact_AutomationStates] AS t
    USING
    (
      VALUES
      (
        @PlanId,
        @StateId,
        @Contacts
      )
    )
    as s
    (
      [PlanId],
      [StateId],
      [Contacts]
    )
    ON
    (
      t.[PlanId] = s.[PlanId] AND
      t.[StateId] = s.[StateId]
    )

    WHEN MATCHED THEN UPDATE SET
      t.[Contacts] = t.[Contacts] + s.[Contacts]

    WHEN NOT MATCHED THEN
      INSERT([PlanId], [StateId], [Contacts])
      VALUES(s.[PlanId], s.[StateId], s.[Contacts]);

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_AutomationStates]
      SET
        [Contacts] = ([Contacts] + @Contacts)
      WHERE
        ([PlanId] = @PlanId) AND
        ([StateId] = @StateId);

      IF( @@ROWCOUNT != 1 )
      BEGIN

        RAISERROR( 'Failed to insert or update rows in the [Fact_AutomationStates] table.', 18, 1 ) WITH NOWAIT;

      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;

  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_Conversions]...';


GO
ALTER PROCEDURE [dbo].[Add_Conversions]
  @Date SMALLDATETIME,
  @TrafficType INTEGER,
  @ContactId UNIQUEIDENTIFIER,
  @CampaignId UNIQUEIDENTIFIER,
  @GoalId UNIQUEIDENTIFIER,
  @SiteNameId INTEGER,
  @DeviceNameId INTEGER,
  @LanguageId INTEGER,
  @AccountId UNIQUEIDENTIFIER,
  @ItemId UNIQUEIDENTIFIER,
  @GoalPoints BIGINT,
  @Visits BIGINT,
  @Value BIGINT,
  @Count BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE
    [Fact_Conversions] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @TrafficType,
      @ContactId,
      @CampaignId,
      @GoalId,
      @SiteNameId,
      @DeviceNameId,
      @LanguageId,
      @AccountId,
      @ItemId,
      @GoalPoints,
      @Visits,
      @Value,
      @Count
    ) 
  )
  AS [source]
  (
    [Date],
    [TrafficType],
    [ContactId],
    [CampaignId],
    [GoalId],
    [SiteNameId],
    [DeviceNameId],
    [LanguageId],
    [AccountId],
    [ItemId],
    [GoalPoints],
    [Visits],
    [Value],
    [Count]
  )
  ON
  ( 
    ([target].[Date] = [source].[Date]) AND
    ([target].[TrafficType] = [source].[TrafficType]) AND
    ([target].[ContactId] = [source].[ContactId]) AND
    ([target].[CampaignId] = [source].[CampaignId]) AND
    ([target].[GoalId] = [source].[GoalId]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
    ([target].[LanguageId] = [source].[LanguageId]) AND
    ([target].[AccountId] = [source].[AccountId]) AND
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[GoalPoints] = [source].[GoalPoints])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [TrafficType],
      [ContactId],
      [CampaignId],
      [GoalId],
      [SiteNameId],
      [DeviceNameId],
      [LanguageId],
      [AccountId],
      [ItemId],
      [GoalPoints],
      [Visits],
      [Value],
      [Count]
    )
    VALUES
    (
      [source].[Date],
      [source].[TrafficType],
      [source].[ContactId],
      [source].[CampaignId],
      [source].[GoalId],
      [source].[SiteNameId],
      [source].[DeviceNameId],
      [source].[LanguageId],
      [source].[AccountId],
      [source].[ItemId],
      [source].[GoalPoints],
      [source].[Visits],
      [source].[Value],
      [source].[Count]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_Conversions]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
        [Count] = ([Count] + @Count)
      WHERE
        ([Date] = @Date) AND
        ([TrafficType] = @TrafficType) AND
        ([ContactId] = @ContactId) AND
        ([CampaignId] = @CampaignId) AND
        ([GoalId] = @GoalId) AND
        ([SiteNameId] = @SiteNameId) AND
        ([DeviceNameId] = @DeviceNameId) AND
        ([LanguageId] = @LanguageId) AND
        ([AccountId] = @AccountId) AND
        ([ItemId] = @ItemId) AND
        ([GoalPoints] = @GoalPoints);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_Conversions] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  END CATCH;

END
GO
PRINT N'Altering [dbo].[Add_Conversions_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_Conversions_Tvp]
  @table [Conversions_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_Conversions] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source]
    ON
    ( 
      ([target].[Date] = [source].[Date]) AND
      ([target].[TrafficType] = [source].[TrafficType]) AND
      ([target].[ContactId] = [source].[ContactId]) AND
      ([target].[CampaignId] = [source].[CampaignId]) AND
      ([target].[GoalId] = [source].[GoalId]) AND
      ([target].[SiteNameId] = [source].[SiteNameId]) AND
      ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
      ([target].[LanguageId] = [source].[LanguageId]) AND
      ([target].[AccountId] = [source].[AccountId]) AND
      ([target].[ItemId] = [source].[ItemId]) AND
      ([target].[GoalPoints] = [source].[GoalPoints])
    )
    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[Visits] = ([target].[Visits] + [source].[Visits]),
          [target].[Value] = ([target].[Value] + [source].[Value]),
          [target].[Count] = ([target].[Count] + [source].[Count])
    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [TrafficType],
        [ContactId],
        [CampaignId],
        [GoalId],
        [SiteNameId],
        [DeviceNameId],
        [LanguageId],
        [AccountId],
        [ItemId],
        [GoalPoints],
        [Visits],
        [Value],
        [Count]
      )
      VALUES
      (
        [source].[Date],
        [source].[TrafficType],
        [source].[ContactId],
        [source].[CampaignId],
        [source].[GoalId],
        [source].[SiteNameId],
        [source].[DeviceNameId],
        [source].[LanguageId],
        [source].[AccountId],
        [source].[ItemId],
        [source].[GoalPoints],
        [source].[Visits],
        [source].[Value],
        [source].[Count]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

  END CATCH;

END
GO
PRINT N'Altering [dbo].[Add_Downloads]...';


GO
ALTER PROCEDURE [dbo].[Add_Downloads]
  @Date SMALLDATETIME,
  @TrafficType INTEGER,
  @CampaignId UNIQUEIDENTIFIER,
  @SiteNameId INTEGER,
  @DeviceNameId INTEGER,
  @LanguageId INTEGER,
  @AccountId UNIQUEIDENTIFIER,
  @ItemId UNIQUEIDENTIFIER,
  @AssetId UNIQUEIDENTIFIER,
  @Visits BIGINT,
  @Value BIGINT,
  @Count BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE
    [Fact_Downloads] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @TrafficType,
      @CampaignId,
      @SiteNameId,
      @DeviceNameId,
      @LanguageId,
      @AccountId,
      @ItemId,
      @AssetId,
      @Visits,
      @Value,
      @Count
    )
  )
  AS [source]
  (
    [Date],
    [TrafficType], 
    [CampaignId],
    [SiteNameId],
    [DeviceNameId],
    [LanguageId],
    [AccountId],
    [ItemId],
    [AssetId],
    [Visits],
    [Value],
    [Count]
  )
  ON
  (
    ([target].[Date] = [source].[Date]) AND
    ([target].[TrafficType] = [source].[TrafficType]) AND
    ([target].[CampaignId] = [source].[CampaignId]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
    ([target].[LanguageId] = [source].[LanguageId]) AND
    ([target].[AccountId] = [source].[AccountId]) AND
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[AssetId] = [source].[AssetId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
      [target].[Visits] = ([target].[Visits] + [source].[Visits]),
      [target].[Value] = ([target].[Value] + [source].[Value]),
      [target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [TrafficType],
      [CampaignId],
      [SiteNameId],
      [DeviceNameId],
      [LanguageId],
      [AccountId],
      [ItemId],
      [AssetId],
      [Visits],
      [Value],
      [Count]
    )
    VALUES
    (
      [source].[Date],
      [source].[TrafficType],
      [source].[CampaignId],
      [source].[SiteNameId],
      [source].[DeviceNameId],
      [source].[LanguageId],
      [source].[AccountId],
      [source].[ItemId],
      [source].[AssetId],
      [source].[Visits],
      [source].[Value],
      [source].[Count]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_Downloads]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
        [Count] = ([Count] + @Count)
      WHERE
        ([Date] = @Date) AND
        ([TrafficType] = @TrafficType) AND
        ([CampaignId] = @CampaignId) AND
        ([SiteNameId] = @SiteNameId) AND
        ([DeviceNameId] = @DeviceNameId) AND
        ([LanguageId] = @LanguageId) AND
        ([AccountId] = @AccountId) AND
        ([ItemId] = @ItemId) AND
        ([AssetId] = @AssetId);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_Downloads] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;
END;
GO
PRINT N'Altering [dbo].[Add_Downloads_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_Downloads_Tvp]
  @table [Downloads_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_Downloads] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source]
    ON
    (
      ([target].[Date] = [source].[Date]) AND
      ([target].[TrafficType] = [source].[TrafficType]) AND
      ([target].[CampaignId] = [source].[CampaignId]) AND
      ([target].[SiteNameId] = [source].[SiteNameId]) AND
      ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
      ([target].[LanguageId] = [source].[LanguageId]) AND
      ([target].[AccountId] = [source].[AccountId]) AND
      ([target].[ItemId] = [source].[ItemId]) AND
      ([target].[AssetId] = [source].[AssetId])
    )
    WHEN MATCHED THEN
      UPDATE
        SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Count] = ([target].[Count] + [source].[Count])
    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [TrafficType],
        [CampaignId],
        [SiteNameId],
        [DeviceNameId],
        [LanguageId],
        [AccountId],
        [ItemId],
        [AssetId],
        [Visits],
        [Value],
        [Count]
      )
      VALUES
      (
        [source].[Date],
        [source].[TrafficType],
        [source].[CampaignId],
        [source].[SiteNameId],
        [source].[DeviceNameId],
        [source].[LanguageId],
        [source].[AccountId],
        [source].[ItemId],
        [source].[AssetId],
        [source].[Visits],
        [source].[Value],
        [source].[Count]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

  END CATCH;
END;
GO
PRINT N'Altering [dbo].[Add_Failures]...';


GO
ALTER PROCEDURE [dbo].[Add_Failures]
  @VisitId UNIQUEIDENTIFIER,
  @AccountId UNIQUEIDENTIFIER,
  @Date SMALLDATETIME,
  @ContactId UNIQUEIDENTIFIER,
  @PageEventDefinitionId UNIQUEIDENTIFIER,
  @KeywordsId UNIQUEIDENTIFIER,
  @ReferringSiteId UNIQUEIDENTIFIER,
  @ContactVisitIndex INTEGER,
  @VisitPageIndex INTEGER,
  @FailureDetailsId UNIQUEIDENTIFIER,
  @Value BIGINT,
  @Count BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE
    [Fact_Failures] AS [target]
  USING
  (
    VALUES
    (
      @VisitId,
      @AccountId,
      @Date,
      @ContactId,
      @PageEventDefinitionId,
      @KeywordsId,
      @ReferringSiteId,
      @ContactVisitIndex,
      @VisitPageIndex,
      @FailureDetailsId,
      @Value,
      @Count
    )
  )
  AS [source]
  (
    [VisitId],
    [AccountId],
    [Date],
    [ContactId],
    [PageEventDefinitionId],
    [KeywordsId],
    [ReferringSiteId],
    [ContactVisitIndex],
    [VisitPageIndex],
    [FailureDetailsId],
    [Value],
    [Count]
  )
  ON
  ( 
    ([target].[VisitId] = [source].[VisitId]) AND
    ([target].[AccountId] = [source].[AccountId]) AND
    ([target].[Date] = [source].[Date]) AND
    ([target].[ContactId] = [source].[ContactId]) AND
    ([target].[PageEventDefinitionId] = [source].[PageEventDefinitionId]) AND
    ([target].[KeywordsId] = [source].[KeywordsId]) AND
    ([target].[ReferringSiteId] = [source].[ReferringSiteId]) AND
    ([target].[ContactVisitIndex] = [source].[ContactVisitIndex]) AND
    ([target].[VisitPageIndex] = [source].[VisitPageIndex]) AND
    ([target].[FailureDetailsId] = [source].[FailureDetailsId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [VisitId],
      [AccountId],
      [Date],
      [ContactId],
      [PageEventDefinitionId],
      [KeywordsId],
      [ReferringSiteId],
      [ContactVisitIndex],
      [VisitPageIndex],
      [FailureDetailsId],
      [Value],
      [Count]
    )
    VALUES
    (
      [source].[VisitId],
      [source].[AccountId],
      [source].[Date],
      [source].[ContactId],
      [source].[PageEventDefinitionId],
      [source].[KeywordsId],
      [source].[ReferringSiteId],
      [source].[ContactVisitIndex],
      [source].[VisitPageIndex],
      [source].[FailureDetailsId],
      [source].[Value],
      [source].[Count]
    );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_Failures]
      SET
        [Value] = ([Value] + @Value),
        [Count] = ([Count] + @Count)
      WHERE
        ([VisitId] = @VisitId) AND
        ([AccountId] = @AccountId) AND
        ([Date] = @Date) AND
        ([ContactId] = @ContactId) AND
        ([PageEventDefinitionId] = @PageEventDefinitionId) AND
        ([KeywordsId] = @KeywordsId) AND
        ([ReferringSiteId] = @ReferringSiteId) AND
        ([ContactVisitIndex] = @ContactVisitIndex) AND
        ([VisitPageIndex] = @VisitPageIndex) AND
        ([FailureDetailsId] = @FailureDetailsId);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_Failures] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;

  END CATCH;

END;
GO
PRINT N'Creating [dbo].[Add_Failures_Tvp]...';


GO
CREATE PROCEDURE [dbo].[Add_Failures_Tvp]
  @table [Failures_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_Failures] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source]
    ON
    ( 
      ([target].[VisitId] = [source].[VisitId]) AND
      ([target].[AccountId] = [source].[AccountId]) AND
      ([target].[Date] = [source].[Date]) AND
      ([target].[ContactId] = [source].[ContactId]) AND
      ([target].[PageEventDefinitionId] = [source].[PageEventDefinitionId]) AND
      ([target].[KeywordsId] = [source].[KeywordsId]) AND
      ([target].[ReferringSiteId] = [source].[ReferringSiteId]) AND
      ([target].[ContactVisitIndex] = [source].[ContactVisitIndex]) AND
      ([target].[VisitPageIndex] = [source].[VisitPageIndex]) AND
      ([target].[FailureDetailsId] = [source].[FailureDetailsId])
    )
    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[Value] = ([target].[Value] + [source].[Value]),
          [target].[Count] = ([target].[Count] + [source].[Count])
    WHEN NOT MATCHED THEN
      INSERT
      (
        [VisitId],
        [AccountId],
        [Date],
        [ContactId],
        [PageEventDefinitionId],
        [KeywordsId],
        [ReferringSiteId],
        [ContactVisitIndex],
        [VisitPageIndex],
        [FailureDetailsId],
        [Value],
        [Count]
      )
      VALUES
      (
        [source].[VisitId],
        [source].[AccountId],
        [source].[Date],
        [source].[ContactId],
        [source].[PageEventDefinitionId],
        [source].[KeywordsId],
        [source].[ReferringSiteId],
        [source].[ContactVisitIndex],
        [source].[VisitPageIndex],
        [source].[FailureDetailsId],
        [source].[Value],
        [source].[Count]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_FollowHits]...';


GO
ALTER PROCEDURE [dbo].[Add_FollowHits]
  @Date SMALLDATETIME,
  @ItemId UNIQUEIDENTIFIER,
  @KeywordsId UNIQUEIDENTIFIER,
  @Visits BIGINT,
  @Value BIGINT,
  @Count BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Fact_FollowHits] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @ItemId,
      @KeywordsId,
      @Visits,
      @Value,
      @Count
    )
  )
  AS [source]
  (
    [Date], 
    [ItemId], 
    [KeywordsId], 
    [Visits], 
    [Value], 
    [Count]
  )
  ON
  ( 
    ([target].[Date] = [source].[Date]) AND 
    ([target].[ItemId] = [source].[ItemId]) AND 
    ([target].[KeywordsId] = [source].[KeywordsId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [ItemId],
      [KeywordsId],
      [Visits],
      [Value],
      [Count]
    )
    VALUES
    (
      [source].[Date],
      [source].[ItemId],
      [source].[KeywordsId],
      [source].[Visits],
      [source].[Value],
      [source].[Count]
    );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_FollowHits]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
        [Count] = ([Count] + @Count)
      WHERE
        ([Date] = @Date) AND 
        ([ItemId] = @ItemId) AND 
        ([KeywordsId] = @KeywordsId);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_FollowHits] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;	

END;
GO
PRINT N'Altering [dbo].[Add_FollowHits_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_FollowHits_Tvp]
  @table [FollowHits_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_FollowHits] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source] ON
      ( 
        ([target].[Date] = [source].[Date]) AND 
        ([target].[ItemId] = [source].[ItemId]) AND 
        ([target].[KeywordsId] = [source].[KeywordsId])
      )
    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[Visits] = ([target].[Visits] + [source].[Visits]),
          [target].[Value] = ([target].[Value] + [source].[Value]),
          [target].[Count] = ([target].[Count] + [source].[Count])
    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [ItemId],
        [KeywordsId],
        [Visits],
        [Value],
        [Count]
      )
      VALUES
      (
        [source].[Date],
        [source].[ItemId],
        [source].[KeywordsId],
        [source].[Visits],
        [source].[Value],
        [source].[Count]
      );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

  END CATCH;	

END;
GO
PRINT N'Altering [dbo].[Add_MvTesting]...';


GO
ALTER PROCEDURE [Add_MvTesting]
  @TestSetId UNIQUEIDENTIFIER,
  @TestValues BINARY(16),
  @Visits BIGINT,
  @Value BIGINT,
  @Bounces BIGINT,
  @TotalPageDuration BIGINT,
  @TotalWebsiteDuration BIGINT,
  @PageCount BIGINT,
  @Visitors BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_MvTesting] AS [target]
  USING
  (
    VALUES
    (
      @TestSetId,
      @TestValues,
      @Visits,
      @Value,
	  @Bounces,
	  @TotalPageDuration,
	  @TotalWebsiteDuration,
	  @PageCount,
	  @Visitors
    )
  )
  AS [source]
  (
    [TestSetId], 
    [TestValues], 
    [Visits], 
    [Value],
	[Bounces],
	[TotalPageDuration],
	[TotalWebsiteDuration],
	[PageCount],
	[Visitors]
  )
  ON
  (
    ([target].[TestSetId] = [source].[TestSetId]) AND 
    ([target].[TestValues] = [source].[TestValues])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
		[target].[Bounces] = ([target].[Bounces] + [source].[Bounces]),
		[target].[TotalPageDuration] = ([target].[TotalPageDuration] + [source].[TotalPageDuration]),
		[target].[TotalWebsiteDuration] = ([target].[TotalWebsiteDuration] + [source].[TotalWebsiteDuration]),
		[target].[PageCount] = ([target].[PageCount] + [source].[PageCount]),
		[target].[Visitors] = ([target].[Visitors] + [source].[Visitors])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [TestSetId],
      [TestValues],
      [Visits],
      [Value],
	  [Bounces],
	  [TotalPageDuration],
	  [TotalWebsiteDuration],
	  [PageCount],
	  [Visitors]
    )
    VALUES
    (
      [source].[TestSetId],
      [source].[TestValues],
      [source].[Visits],
      [source].[Value],
	  [source].[Bounces],
	  [source].[TotalPageDuration],
	  [source].[TotalWebsiteDuration],
	  [source].[PageCount],
	  [source].[Visitors]
    );

  END TRY
  BEGIN CATCH
  
    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN
   
      UPDATE
		[dbo].[Fact_MvTesting]
	  SET
	    [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
		[Bounces] = ([Bounces] + @Bounces),
		[TotalPageDuration] = ([TotalPageDuration] + @TotalPageDuration),
		[TotalWebsiteDuration] = ([TotalWebsiteDuration] + @TotalWebsiteDuration),
		[PageCount] = ([PageCount] + @PageCount),
		[Visitors] = ([Visitors] + @Visitors)
	  WHERE
	   ([TestSetId] = @TestSetId) AND 
       ([TestValues] = @TestValues)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_MvTesting] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
    
  END CATCH;
END;
GO
PRINT N'Altering [dbo].[Add_MvTestingDetails]...';


GO
ALTER PROCEDURE [Add_MvTestingDetails]
  @TestSetId uniqueidentifier,
  @TestValues binary(16),  
  @Value bigint,
  @Visits bigint
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_MvTestingDetails] AS [target]
  USING
  (
    VALUES
    (
      @TestSetId,
      @TestValues,
      @Value,	  
	  @Visits
    )
  )
  AS [source]
  (
    [TestSetId], 
    [TestValues], 
    [Value],
	[Visits]
  )
  ON
  (
    ([target].[TestSetId] = [source].[TestSetId]) AND 
    ([target].[TestValues] = [source].[TestValues]) AND
    ([target].[Value] = [source].[Value])	
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits])
        

  WHEN NOT MATCHED THEN
    INSERT
    (
      [TestSetId],
      [TestValues],      
      [Value],
	  [Visits]	  
    )
    VALUES
    (
      [source].[TestSetId],
      [source].[TestValues],      
      [source].[Value],	  
	  [source].[Visits]	  
    );
    
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN
     
      UPDATE
		[dbo].[Fact_MvTestingDetails]
	  SET
	    [Visits] = ([Visits] + @Visits)
	  WHERE
	    ([TestSetId] = @TestSetId) AND 
        ([TestValues] = @TestValues) AND
        ([Value] = @Value)	

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_MvTestingDetails] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_PageViews]...';


GO
ALTER PROCEDURE [Add_PageViews]
  @Date SMALLDATETIME,
  @ItemId UNIQUEIDENTIFIER,
  @TestId UNIQUEIDENTIFIER,
  @TestCombination [binary](16),
  @Views BIGINT,
  @Duration BIGINT,
  @Visits BIGINT,
  @Value BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE
    [Fact_PageViews] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @ItemId,
	    @TestId,
	    @TestCombination,
      @Views,
      @Duration,
      @Visits,
      @Value
    )
  )
  AS [source]
  (
    [Date],
    [ItemId],
    [TestId],
    [TestCombination],
	  [Views],
    [Duration],
    [Visits],
    [Value]
  )
  ON
    ([target].[Date] = [source].[Date]) AND
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[TestId] = [source].[TestId]) AND
    ([target].[TestCombination] = [source].[TestCombination])

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Views] = ([target].[Views] + [source].[Views]),
        [target].[Duration] = ([target].[Duration] + [source].[Duration]),
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [ItemId],
	    [TestId],
	    [TestCombination],
      [Views],
      [Duration],
      [Visits],
      [Value]
    )
    VALUES
    (
      [source].[Date],
      [source].[ItemId],
	    [source].[TestId],
	    [source].[TestCombination],
      [source].[Views],
      [source].[Duration],
      [source].[Visits],
      [source].[Value]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_PageViews]
      SET
        [Views] = ([Views] + @Views),
        [Duration] = ([Duration] + @Duration),
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value)
      WHERE
        ([Date] = @Date) AND
        ([ItemId] = @ItemId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_PageViews] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_PageViewsByLanguage]...';


GO
ALTER PROCEDURE [dbo].[Add_PageViewsByLanguage]
  @Date SMALLDATETIME,
  @SiteNameId INT,
  @ItemId UNIQUEIDENTIFIER,
  @LanguageId INT,
  @DeviceNameId INT,
  @Views BIGINT,
  @Visits BIGINT,
  @Duration BIGINT,
  @Value BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Fact_PageViewsByLanguage] as [target]
  USING
  (
    VALUES
    (
      @Date,
      @SiteNameId,
      @ItemId,
      @LanguageId,
      @DeviceNameId,
      @Views,
      @Visits,
      @Duration,
      @Value
    )
  )
  AS [source]
  (
    [Date],
    [SiteNameId],
    [ItemId],
    [LanguageId],
    [DeviceNameId],
    [Views],
    [Visits],
    [Duration],
    [Value]
  )
  ON
    ([target].[Date] = [source].[Date]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[LanguageId] = [source].[LanguageId]) AND
    ([target].[DeviceNameId] = [source].[DeviceNameId])

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Views] = ([target].[Views] + [source].[Views]),
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Duration] = ([target].[Duration] + [source].[Duration]),
        [target].[Value] = ([target].[Value] + [source].[Value])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [SiteNameId],
      [ItemId],
      [LanguageId],
      [DeviceNameId],
      [Views],
      [Visits],
      [Duration],
      [Value]
    )
    VALUES
    (
      [source].[Date],
      [source].[SiteNameId],
      [source].[ItemId],
      [source].[LanguageId],
      [source].[DeviceNameId],
      [source].[Views],
      [source].[Visits],
      [source].[Duration],
      [source].[Value]
    );

  END TRY

  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_PageViewsByLanguage]
      SET
        [Views] = ([Views] + @Views),
        [Visits] = ([Visits] + @Visits),
        [Duration] = ([Duration] + @Duration),
        [Value] = ([Value] + @Value)
      WHERE
        ([Date] = @Date) AND
        ([SiteNameId] = @SiteNameId) AND
        ([ItemId] = @ItemId) AND
        ([LanguageId] = @LanguageId) AND
        ([DeviceNameId] = @DeviceNameId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_PageViewsByLanguage] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  END CATCH;
END;
GO
PRINT N'Altering [dbo].[Add_Personalization]...';


GO
ALTER PROCEDURE [Add_Personalization]
  @Date DATE,
  @RuleSetId UNIQUEIDENTIFIER,
  @RuleId UNIQUEIDENTIFIER,
  @TestSetId UNIQUEIDENTIFIER,
  @TestValues BINARY (16),
  @Visits BIGINT,
  @Value BIGINT,
  @Visitors BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_Personalization] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @RuleSetId,
      @RuleId,
      @TestSetId,
      @TestValues,
      @Visits,
      @Value,
      @Visitors
    )
  )
  AS [source]
  (
    [Date],
    [RuleSetId],
    [RuleId],
    [TestSetId],
    [TestValues],
    [Visits],
    [Value],
    [Visitors]
  )
  ON
    ([target].[Date] = [source].[Date]) AND
    ([target].[RuleSetId] = [source].[RuleSetId]) AND
    ([target].[RuleId] = [source].[RuleId]) AND
    ([target].[TestSetId] = [source].[TestSetId]) AND
	([target].[TestValues] = [source].[TestValues])

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Visitors] = ([target].[Visitors] + [source].[Visitors])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [RuleSetId],
      [RuleId],
      [TestSetId],
      [TestValues],
      [Visits],
      [Value],
      [Visitors]
    )
    VALUES
    (
      [source].[Date],
      [source].[RuleSetId],
      [source].[RuleId],
      [source].[TestSetId],
      [source].[TestValues],
      [source].[Visits],
      [source].[Value],
      [source].[Visitors]
    );
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_Personalization]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
        [Visitors] = ([Visitors] + @Visitors)
      WHERE
        ([Date] = @Date) AND
		([RuleSetId] = @RuleSetId) AND
		([RuleId] = @RuleId) AND
		([TestSetId] = @TestSetId) AND
		([TestValues] = @TestValues);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_Personalization] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_RulesExposure]...';


GO
ALTER PROCEDURE [dbo].[Add_RulesExposure]
  @Date DATE,
  @ItemId UNIQUEIDENTIFIER,
  @RuleSetId UNIQUEIDENTIFIER,
  @RuleId UNIQUEIDENTIFIER,
  @Visits BIGINT,
  @Visitors BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_RulesExposure] AS [target]
  USING
  (
    VALUES
    (
      @Date,
	  @ItemId,
      @RuleSetId,
      @RuleId,
      @Visits,
      @Visitors
    )
  )
  AS [source]
  (
    [Date],
	[ItemId],
    [RuleSetId],
    [RuleId],
    [Visits],
    [Visitors]
  )
  ON
    ([target].[Date] = [source].[Date]) AND
	([target].[ItemId] = [source].[ItemId]) AND
    ([target].[RuleSetId] = [source].[RuleSetId]) AND
    ([target].[RuleId] = [source].[RuleId]) 

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Visitors] = ([target].[Visitors] + [source].[Visitors])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
	  [ItemId],
      [RuleSetId],
      [RuleId],
      [Visits],
      [Visitors]
    )
    VALUES
    (
      [source].[Date],
	  [source].[ItemId],
      [source].[RuleSetId],
      [source].[RuleId],
      [source].[Visits],
      [source].[Visitors]
    );
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_RulesExposure]
      SET
        [Visits] = ([Visits] + @Visits),
        [Visitors] = ([Visitors] + @Visitors)
      WHERE
        ([Date] = @Date) AND
		([ItemId] = @ItemId) AND
		([RuleSetId] = @RuleSetId) AND
		([RuleId] = @RuleId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_RulesExposure] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;
END
GO
PRINT N'Altering [dbo].[Add_SegmentMetrics]...';


GO
ALTER PROCEDURE [dbo].[Add_SegmentMetrics]
    @SegmentRecordId [bigint],
    @ContactTransitionType [tinyint],
    @Visits [int],
    @Value [int],
    @Bounces [int],
    @Conversions [int],
    @TimeOnSite [int],
    @Pageviews [int],
    @Count [int],
    @Converted [int]
	WITH EXECUTE AS OWNER
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
MERGE [Fact_SegmentMetrics] AS Target USING ( VALUES (@SegmentRecordId, @ContactTransitionType, @Visits, @Value, @Bounces, @Conversions, @TimeOnSite, @Pageviews, @Count, @Converted)) AS Source (SegmentRecordId, ContactTransitionType, Visits, Value, Bounces, Conversions, TimeOnSite, Pageviews, Count, Converted)
 ON 
Target.[SegmentRecordId] = Source.[SegmentRecordId] AND Target.[ContactTransitionType] = Source.[ContactTransitionType]
WHEN MATCHED THEN
  UPDATE SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),Target.[Value] = (Target.[Value] + Source.[Value]),Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]),Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]),Target.[Count] = (Target.[Count] + Source.[Count]), Target.[Converted] = (Target.[Converted] + Source.[Converted])
WHEN NOT MATCHED THEN
  INSERT ([SegmentRecordId], [ContactTransitionType], [Visits], [Value], [Bounces], [Conversions], [TimeOnSite], [Pageviews], [Count], [Converted]
)
VALUES (
Source.[SegmentRecordId], Source.[ContactTransitionType], Source.[Visits], Source.[Value], Source.[Bounces], Source.[Conversions], Source.[TimeOnSite], Source.[Pageviews], Source.[Count], Source.[Converted]);
END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN  
      UPDATE [dbo].[Fact_SegmentMetrics]
      SET
        [Visits] = ([Visits] + @Visits),[Value] = ([Value] + @Value),[Bounces] = ([Bounces] + @Bounces),[Conversions] = ([Conversions] + @Conversions), [TimeOnSite] = ([TimeOnSite] + @TimeOnSite),[Pageviews] = ([Pageviews] + @Pageviews),[Count] = ([Count] + @Count), [Converted] = ([Converted] + @Converted)
      WHERE
        [SegmentRecordId] = ([SegmentRecordId] + @SegmentRecordId) AND [ContactTransitionType] = ([ContactTransitionType] + @ContactTransitionType)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_SegmentMetrics] table.', 18, 1 ) WITH NOWAIT;
      END
    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
END CATCH;
END
GO

PRINT N'Dropping [dbo].[Add_SegmentMetrics_Tvp]...';
GO
IF (OBJECT_ID('[dbo].[Add_SegmentMetrics_Tvp]', 'P') IS NOT NULL)
Begin 
	DROP PROCEDURE [dbo].[Add_SegmentMetrics_Tvp]
End 

PRINT N'Dropping [dbo].[SegmentMetrics_Type]...';
GO
IF (TYPE_ID(N'[dbo].[SegmentMetrics_Type]') IS NOT NULL)
BEGIN
    DROP TYPE [dbo].[SegmentMetrics_Type]
END

PRINT N'Creating [dbo].[SegmentMetrics_Type]...';	

GO

      CREATE TYPE [dbo].[SegmentMetrics_Type] AS TABLE(
	    [SegmentRecordId] [bigint] NOT NULL,
	    [ContactTransitionType] [tinyint] NOT NULL,
	    [Visits] [int] NOT NULL,
	    [Value] [int] NOT NULL,
	    [Bounces] [int] NOT NULL,
	    [Conversions] [int] NOT NULL,
	    [TimeOnSite] [int] NOT NULL,
	    [Pageviews] [int] NOT NULL,
    	[Count] [int] NOT NULL,
        [Converted] [int] NOT NULL
    	PRIMARY KEY CLUSTERED 
    (
	    [SegmentRecordId] ASC,
    	[ContactTransitionType] ASC
    )WITH (IGNORE_DUP_KEY = OFF)
)


GO

PRINT N'Creating [dbo].[Add_SegmentMetrics_Tvp]...';

GO
CREATE PROCEDURE [dbo].[Add_SegmentMetrics_Tvp]
  @table [dbo].[SegmentMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY

    MERGE [Fact_SegmentMetrics] AS Target USING @table AS Source
    ON 
      Target.[SegmentRecordId] = Source.[SegmentRecordId] AND
      Target.[ContactTransitionType] = Source.[ContactTransitionType]
    WHEN MATCHED THEN
      UPDATE SET 
        Target.[Visits] = (Target.[Visits] + Source.[Visits]),
        Target.[Value] = (Target.[Value] + Source.[Value]),
        Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]),
        Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
        Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
        Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]),
        Target.[Count] = (Target.[Count] + Source.[Count]),
        Target.[Converted] = (Target.[Converted] + Source.[Converted])
    WHEN NOT MATCHED THEN
      INSERT (
        [SegmentRecordId], [ContactTransitionType], 
        [Visits], [Value], [Bounces], 
        [Conversions], [TimeOnSite], [Pageviews], [Count], [Converted]
      )
      VALUES (
        Source.[SegmentRecordId], Source.[ContactTransitionType], 
        Source.[Visits], Source.[Value], Source.[Bounces], 
        Source.[Conversions], Source.[TimeOnSite], Source.[Pageviews], Source.[Count], Source.[Converted]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  END CATCH;
END
GO
PRINT N'Altering [dbo].[Add_SiteSearches]...';


GO
ALTER PROCEDURE [dbo].[Add_SiteSearches]
  @Date SMALLDATETIME,
  @TrafficType INTEGER,
  @CampaignId UNIQUEIDENTIFIER,
  @ItemId UNIQUEIDENTIFIER,
  @SiteNameId INTEGER,
  @DeviceNameId INTEGER,
  @LanguageId INTEGER,
  @AccountId UNIQUEIDENTIFIER,
  @KeywordsId UNIQUEIDENTIFIER,
  @Visits BIGINT,
  @Value BIGINT,
  @Count BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE 
    [Fact_SiteSearches] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @TrafficType,
      @CampaignId,
      @ItemId,
      @SiteNameId,
      @DeviceNameId,
      @LanguageId,
      @AccountId,
      @KeywordsId,
      @Visits,
      @Value,
      @Count
    )
  )
  AS [source]
  (
    [Date],
    [TrafficType],
    [CampaignId],
    [ItemId],
    [SiteNameId],
    [DeviceNameId],
    [LanguageId],
    [AccountId],
    [KeywordsId],
    [Visits],
    [Value],
    [Count]
  )
  ON
  (
    ([target].[Date] = [source].[Date]) AND
    ([target].[TrafficType] = [source].[TrafficType]) AND
    ([target].[CampaignId] = [source].[CampaignId]) AND
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[DeviceNameId] = [source].[DeviceNameId]) AND 
    ([target].[LanguageId] = [source].[LanguageId]) AND
    ([target].[AccountId] = [source].[AccountId]) AND
    ([target].[KeywordsId] = [source].[KeywordsId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [TrafficType],
      [CampaignId],
      [ItemId],
      [SiteNameId],
      [DeviceNameId],
      [LanguageId],
      [AccountId],
      [KeywordsId],
      [Visits],
      [Value],
      [Count]
    )
    VALUES
    (
      [source].[Date],
      [source].[TrafficType],
      [source].[CampaignId],
      [source].[ItemId],
      [source].[SiteNameId],
      [source].[DeviceNameId],
      [source].[LanguageId],
      [source].[AccountId],
      [source].[KeywordsId],
      [source].[Visits],
      [source].[Value],
      [source].[Count]
    );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_SiteSearches]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
        [Count] = ([Count] + @Count)
      WHERE
        ([Date] = @Date) AND
        ([TrafficType] = @TrafficType) AND
        ([CampaignId] = @CampaignId) AND
        ([ItemId] = @ItemId) AND
        ([SiteNameId] = @SiteNameId) AND
        ([DeviceNameId] = @DeviceNameId) AND 
        ([LanguageId] = @LanguageId) AND
        ([AccountId] = @AccountId) AND
        ([KeywordsId] = @KeywordsId);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_SiteSearches] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_SiteSearches_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_SiteSearches_Tvp]
  @table [SiteSearches_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE 
      [Fact_SiteSearches] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source]
    ON
    (
      ([target].[Date] = [source].[Date]) AND
      ([target].[TrafficType] = [source].[TrafficType]) AND
      ([target].[CampaignId] = [source].[CampaignId]) AND
      ([target].[ItemId] = [source].[ItemId]) AND
      ([target].[SiteNameId] = [source].[SiteNameId]) AND
      ([target].[DeviceNameId] = [source].[DeviceNameId]) AND 
      ([target].[LanguageId] = [source].[LanguageId]) AND
      ([target].[AccountId] = [source].[AccountId]) AND
      ([target].[KeywordsId] = [source].[KeywordsId])
    )

    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[Visits] = ([target].[Visits] + [source].[Visits]),
          [target].[Value] = ([target].[Value] + [source].[Value]),
          [target].[Count] = ([target].[Count] + [source].[Count])

    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [TrafficType],
        [CampaignId],
        [ItemId],
        [SiteNameId],
        [DeviceNameId],
        [LanguageId],
        [AccountId],
        [KeywordsId],
        [Visits],
        [Value],
        [Count]
      )
      VALUES
      (
        [source].[Date],
        [source].[TrafficType],
        [source].[CampaignId],
        [source].[ItemId],
        [source].[SiteNameId],
        [source].[DeviceNameId],
        [source].[LanguageId],
        [source].[AccountId],
        [source].[KeywordsId],
        [source].[Visits],
        [source].[Value],
        [source].[Count]
      );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_SlowPages]...';


GO
ALTER PROCEDURE [dbo].[Add_SlowPages]
  @Date SMALLDATETIME,
  @ItemId UNIQUEIDENTIFIER,
  @Duration INTEGER,
  @VisitId UNIQUEIDENTIFIER,
  @AccountId UNIQUEIDENTIFIER,
  @ContactId UNIQUEIDENTIFIER,
  @ContactVisitIndex INTEGER,
  @Value INTEGER,
  @Views BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

	MERGE 
    [Fact_SlowPages] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @ItemId,
      @Duration,
      @VisitId,
      @AccountId,
      @ContactId,
      @ContactVisitIndex,
      @Value,
      @Views
    )
  )
  AS [source]
  (
    [Date],
    [ItemId],
    [Duration],
    [VisitId],
    [AccountId],
    [ContactId],
    [ContactVisitIndex],
    [Value],
    [Views]
  )
  ON
  (
    ([target].[Date] = [source].[Date]) AND 
    ([target].[ItemId] = [source].[ItemId]) AND 
    ([target].[Duration] = [source].[Duration]) AND 
    ([target].[VisitId] = [source].[VisitId]) AND
    ([target].[AccountId] = [source].[AccountId]) AND 
    ([target].[ContactId] = [source].[ContactId]) AND 
    ([target].[ContactVisitIndex] = [source].[ContactVisitIndex]) AND 
    ([target].[Value] = [source].[Value])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Views] = ([target].[Views] + [source].[Views])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [ItemId],
      [Duration],
      [VisitId],
      [AccountId],
      [ContactId],
      [ContactVisitIndex],
      [Value],
      [Views]
    )
    VALUES
    (
      [source].[Date],
      [source].[ItemId],
      [source].[Duration],
      [source].[VisitId],
      [source].[AccountId],
      [source].[ContactId],
      [source].[ContactVisitIndex],
      [source].[Value],
      [source].[Views]
    );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_SlowPages]
      SET
        [Views] = ([Views] + @Views)
      WHERE
        ([Date] = @Date) AND 
        ([ItemId] = @ItemId) AND 
        ([Duration] = @Duration) AND 
        ([VisitId] = @VisitId) AND
        ([AccountId] = @AccountId) AND 
        ([ContactId] = @ContactId) AND 
        ([ContactVisitIndex] = @ContactVisitIndex) AND 
        ([Value] = @Value);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_SlowPages] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_SlowPages_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_SlowPages_Tvp]
  @table [SlowPages_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE 
      [Fact_SlowPages] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source] ON
      (
        ([target].[Date] = [source].[Date]) AND 
        ([target].[ItemId] = [source].[ItemId]) AND 
        ([target].[Duration] = [source].[Duration]) AND 
        ([target].[VisitId] = [source].[VisitId]) AND
        ([target].[AccountId] = [source].[AccountId]) AND 
        ([target].[ContactId] = [source].[ContactId]) AND 
        ([target].[ContactVisitIndex] = [source].[ContactVisitIndex]) AND 
        ([target].[Value] = [source].[Value])
      )

    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[Views] = ([target].[Views] + [source].[Views])

    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [ItemId],
        [Duration],
        [VisitId],
        [AccountId],
        [ContactId],
        [ContactVisitIndex],
        [Value],
        [Views]
      )
      VALUES
      (
        [source].[Date],
        [source].[ItemId],
        [source].[Duration],
        [source].[VisitId],
        [source].[AccountId],
        [source].[ContactId],
        [source].[ContactVisitIndex],
        [source].[Value],
        [source].[Views]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_TestConversions]...';


GO
ALTER PROCEDURE [Add_TestConversions]
	@Date DATE,
	@GoalId UNIQUEIDENTIFIER,
    @TestSetId UNIQUEIDENTIFIER,
    @TestValues BINARY(16),
    @Visits BIGINT,
    @Value BIGINT,
    @Count BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_TestConversions] AS [target]
  USING
  (
    VALUES
    (
      @Date,
	  @GoalId,
      @TestSetId,
      @TestValues,
      @Visits,
      @Value,
      @Count
    )
  )
  AS [source]
  (
    [Date],
    [GoalId],
    [TestSetId], 
    [TestValues], 
    [Visits], 
    [Value],
	[Count]
  )
  ON
  (
    ([target].[Date] = [source].[Date]) AND
    ([target].[GoalId] = [source].[GoalId]) AND
    ([target].[TestSetId] = [source].[TestSetId]) AND 
    ([target].[TestValues] = [source].[TestValues])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
		[target].[Count] = ([target].[Count] + [source].[Count])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
	  [GoalId],
      [TestSetId],
      [TestValues],
      [Visits],
      [Value],
	  [Count]
    )
    VALUES
    (
      [source].[Date],
	  [source].[GoalId],
      [source].[TestSetId],
      [source].[TestValues],
      [source].[Visits],
      [source].[Value],
	  [source].[Count]
    );
    
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_TestConversions]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
		[Count] = ([Count] + @Count)
      WHERE
        ([Date] = @Date) AND
        ([GoalId] = @GoalId) AND
        ([TestSetId] = @TestSetId) AND 
        ([TestValues] = @TestValues)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_TestConversions] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_TestingCluster]...';


GO
ALTER PROCEDURE [dbo].[Add_TestingCluster]
  @Date smalldatetime,
  @TestId UNIQUEIDENTIFIER,
  @ClusterId UNIQUEIDENTIFIER,
  @FeatureName nvarchar(100),
  @FeatureValue nvarchar(100)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Testing_Clusters] AS [target]
  USING
  (
    VALUES
    (
		@Date,
		@TestId,
		@ClusterId,
		@FeatureName,
		@FeatureValue
    )
  )
  AS [source]
  (
		[Date],
		[TestId],
		[ClusterId],
		[FeatureName],
		[FeatureValue]
  )
  ON
  (
    ([target].[ClusterId] = [source].[ClusterId] AND
	 [target].[FeatureName] = [source].[FeatureName])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Date] = [source].[Date],
		[target].[TestId] = [source].[TestId],
		[target].[FeatureValue] = [source].[FeatureValue]

  WHEN NOT MATCHED THEN
    INSERT
    (
		[Date],
		[TestId],
		[ClusterId],
		[FeatureName],
		[FeatureValue] 
    )
    VALUES
    (
		[source].[Date],
		[source].[TestId],
		[source].[ClusterId],
		[source].[FeatureName],
		[source].[FeatureValue]
    );
    
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN
      
      UPDATE
        [dbo].[Testing_Clusters]
      SET
        [Date] = @Date,
		[TestId] = @TestId,
		[FeatureValue] = @FeatureValue
      WHERE
       [ClusterId] = @ClusterId AND
	   [FeatureName] = @FeatureName

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Testing_Clusters] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_TestingClusterMembers]...';


GO
ALTER PROCEDURE [Add_TestingClusterMembers]
  @Date smalldatetime,
  @TestId UNIQUEIDENTIFIER,
  @ContactId UNIQUEIDENTIFIER,
  @ClusterId UNIQUEIDENTIFIER
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Testing_ClusterMembers] AS [target]
  USING
  (
    VALUES
    (
      @Date,
	  @TestId,
	  @ContactId,
	  @ClusterId
    )
  )
  AS [source]
  (
    [Date],
	[TestId],
	[ContactId],
	[ClusterId] 
  )
  ON
  (
    ([target].[ContactId] = [source].[ContactId] AND
	 [target].[ClusterId] = [source].[ClusterId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Date] = [source].[Date],
		[target].[TestId] = [source].[TestId]

  WHEN NOT MATCHED THEN
    INSERT
    (
		[Date],
		[TestId],
		[ContactId],
		[ClusterId] 
    )
    VALUES
    (
      [source].[Date],
	  [source].[TestId],
	  [source].[ContactId],
      [source].[ClusterId]
    );
    
    END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN
   
      UPDATE
        [dbo].[Testing_ClusterMembers]
      SET
        [Date] = @Date,
		[TestId] = @TestId
      WHERE
        ([ContactId] = @ContactId AND
	     [ClusterId] = @ClusterId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Testing_ClusterMembers] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_TestOutcomes]...';


GO
ALTER PROCEDURE [Add_TestOutcomes]
  @TestSetId UNIQUEIDENTIFIER,
  @TestOwner NVARCHAR(256),
  @CompletionDate DATETIME,
  @TestScore FLOAT,
  @Effect FLOAT,
  @Guess INT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_TestOutcomes] AS [target]
  USING
  (
    VALUES
    (
      @TestSetId,
	  @TestOwner,
      @CompletionDate,
	  @TestScore,
	  @Effect,
	  @Guess
    )
  )
  AS [source]
  (
    [TestSetId], 
	[TestOwner],
    [CompletionDate],
	[TestScore],
	[Effect],
	[Guess]
  )
  ON
  (
    ([target].[TestSetId] = [source].[TestSetId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
		[target].[TestOwner] = [source].[TestOwner],
        [target].[CompletionDate] = [source].[CompletionDate],
		[target].[TestScore] = [source].[TestScore],
		[target].[Effect] = [source].[Effect],
		[target].[Guess] = [source].[Guess]

  WHEN NOT MATCHED THEN
    INSERT
    (
      [TestSetId],
	  [TestOwner],
      [CompletionDate],
	  [TestScore],
	  [Effect],
	  [Guess]
    )
    VALUES
    (
      [source].[TestSetId],
	  [source].[TestOwner],
      [source].[CompletionDate],
	  [source].[TestScore],
	  [source].[Effect],
	  [source].[Guess]
    );
    
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_TestOutcomes]
      SET
        [TestOwner] = @TestOwner,
        [CompletionDate] = @CompletionDate,
		[TestScore] = @TestScore,
		[Effect] = @Effect,
		[Guess] = @Guess
      WHERE
        ([TestSetId] = @TestSetId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_TestOutcomes] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_TestPageClicks]...';


GO
ALTER PROCEDURE [Add_TestPageClicks]
  @TestSetId UNIQUEIDENTIFIER,
  @TestValues BINARY (16),
  @ItemId UNIQUEIDENTIFIER,
  @Views BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_TestPageClicks] AS [target]
  USING
  (
    VALUES
    (
      @TestSetId, 
	  @TestValues, 
      @ItemId,
      @Views
    )
  )
  AS [source]
  (
    [TestSetId],
	[TestValues],
    [ItemId],
    [Views]
  )
  ON
    ([target].[TestSetId] = [source].[TestSetId]) AND
    ([target].[TestValues] = [source].[TestValues]) AND
    ([target].[ItemId] = [source].[ItemId])

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Views] = ([target].[Views] + [source].[Views])
  WHEN NOT MATCHED THEN
    INSERT
    (
	  [TestSetId],
	  [TestValues],
      [ItemId],
      [Views]
    )
    VALUES
    (
	  [source].[TestSetId],
	  [source].[TestValues],
      [source].[ItemId],
      [source].[Views]
    );
    
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_TestPageClicks]
      SET
        [Views] = ([Views] + @Views)
      WHERE
        ([TestSetId] = @TestSetId) AND
        ([TestValues] = @TestValues) AND
        ([ItemId] = @ItemId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_TestPageClicks] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_TestStatistics]...';


GO
ALTER PROCEDURE [Add_TestStatistics]
  @TestSetId UNIQUEIDENTIFIER,
  @Power FLOAT,
  @P FLOAT,
  @IsStatisticalRelevant BIT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_TestStatistics] AS [target]
  USING
  (
    VALUES
    (
      @TestSetId,
	  @Power,
	  @P,
	  @IsStatisticalRelevant
    )
  )
  AS [source]
  (
    [TestSetId],
	[Power],
	[P],
	[IsStatisticalRelevant] 
  )
  ON
  (
    ([target].[TestSetId] = [source].[TestSetId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Power] = [source].[Power],
		[target].[P] = [source].[P],
		[target].[IsStatisticalRelevant] = [source].[IsStatisticalRelevant]

  WHEN NOT MATCHED THEN
    INSERT
    (
      [TestSetId],
	  [Power],
	  [P],
	  [IsStatisticalRelevant] 
    )
    VALUES
    (
      [source].[TestSetId],
	  [source].[Power],
	  [source].[P],
      [source].[IsStatisticalRelevant]
    );
    
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_TestStatistics]
      SET
        [Power] = @Power,
		[P] = @P,
		[IsStatisticalRelevant] = @IsStatisticalRelevant
      WHERE
        ([TestSetId] = @TestSetId)

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_TestStatistics] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_Traffic]...';


GO
ALTER PROCEDURE [dbo].[Add_Traffic]
  @Date SMALLDATETIME,
  @Checksum INTEGER,
  @TrafficType INTEGER,
  @CampaignId UNIQUEIDENTIFIER,
  @ItemId UNIQUEIDENTIFIER,
  @KeywordsId UNIQUEIDENTIFIER,
  @ReferringSiteId UNIQUEIDENTIFIER,
  @SiteNameId INTEGER,
  @DeviceNameId INTEGER,
  @LanguageId INTEGER,
  @FirstVisit BIT,
  @Visits INTEGER,
  @Value INTEGER
WITH EXECUTE AS OWNER
AS
BEGIN

  /* 
     Fact_Traffic has no primary key, so we should use UPDATE TOP(1) to make sure only one row is updated. MERGE statement cannot be used and may lead to data corruption.
  */
  SET NOCOUNT ON;

  UPDATE TOP (1)
    [dbo].[Fact_Traffic]
  SET
    [Visits] = ([Visits] + @Visits),
    [Value] = ([Value] + @Value)
  WHERE
    ([Date] = @Date) AND
    ([Checksum] = @Checksum) AND
    ([TrafficType] = @TrafficType) AND
    ([CampaignId] = @CampaignId) AND
    ([ItemId] = @ItemId) AND
    ([KeywordsId] = @KeywordsId) AND
    ([ReferringSiteId] = @ReferringSiteId) AND
    ([SiteNameId] = @SiteNameId) AND
    ([DeviceNameId] = @DeviceNameId) AND
    ([LanguageId] = @LanguageId) AND
    ([FirstVisit] = @FirstVisit);

  IF( @@ROWCOUNT = 0 )
  BEGIN
    INSERT INTO [dbo].[Fact_Traffic]
    (
      [Date],
      [Checksum],
      [TrafficType],
      [CampaignId],
      [ItemId],
      [KeywordsId],
      [ReferringSiteId],
      [SiteNameId],
      [DeviceNameId],
      [LanguageId],
      [FirstVisit],
      [Visits],
      [Value]
    )
    VALUES
    (
      @Date,
      @Checksum,
      @TrafficType,
      @CampaignId,
      @ItemId,
      @KeywordsId,
      @ReferringSiteId,
      @SiteNameId,
      @DeviceNameId,
      @LanguageId,
      @FirstVisit,
      @Visits,
      @Value
    );
  END

END;
GO
PRINT N'Altering [dbo].[Add_Traffic_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_Traffic_Tvp]
  @table [Traffic_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  DECLARE scan_table CURSOR FOR 
  SELECT 
    [Date], [Checksum], [TrafficType], 
    [CampaignId], [ItemId], [KeywordsId], [ReferringSiteId],
    [SiteNameId], [DeviceNameId], [LanguageId], [FirstVisit],
    [Visits], [Value]
  FROM @table;

  DECLARE
    @Date SMALLDATETIME,
    @Checksum INT,
    @TrafficType INT,
    @CampaignId UNIQUEIDENTIFIER,
    @ItemId UNIQUEIDENTIFIER,
    @KeywordsId UNIQUEIDENTIFIER,
    @ReferringSiteId UNIQUEIDENTIFIER,
    @SiteNameId INT,
    @DeviceNameId INT,
    @LanguageId INT,
    @FirstVisit BIT,
    @Visits BIGINT,
    @Value BIGINT;


  OPEN scan_table;

  FETCH NEXT FROM scan_table
  INTO 
    @Date, @Checksum, @TrafficType,
    @CampaignId, @ItemId, @KeywordsId, @ReferringSiteId,
    @SiteNameId, @DeviceNameId, @LanguageId, @FirstVisit,
    @Visits, @Value;

  WHILE @@FETCH_STATUS = 0
  BEGIN
    EXEC Add_Traffic
      @Date=@Date, @Checksum=@Checksum, @TrafficType=@TrafficType,
      @CampaignId=@CampaignId, @ItemId=@ItemId, @KeywordsId=@KeywordsId, @ReferringSiteId=@ReferringSiteId,
      @SiteNameId=@SiteNameId, @DeviceNameId=@DeviceNameId, @LanguageId=@LanguageId, @FirstVisit=@FirstVisit,
      @Visits=@Visits, @Value=@Value

    FETCH NEXT FROM scan_table
    INTO 
      @Date, @Checksum, @TrafficType,
      @CampaignId, @ItemId, @KeywordsId, @ReferringSiteId,
      @SiteNameId, @DeviceNameId, @LanguageId, @FirstVisit,
      @Visits, @Value;
  END

  CLOSE scan_table;

  DEALLOCATE scan_table;
END;
GO
PRINT N'Altering [dbo].[Add_ValueBySource]...';


GO
ALTER PROCEDURE [dbo].[Add_ValueBySource]
  @Date SMALLDATETIME,
  @TrafficType INTEGER,
  @SiteNameId INTEGER,
  @DeviceNameId INTEGER,
  @LanguageId INTEGER,
  @FirstVisitValue BIGINT,
  @Contacts BIGINT,
  @Visits BIGINT,
  @Value BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Fact_ValueBySource] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @TrafficType,
      @SiteNameId,
      @DeviceNameId,
      @LanguageId,
      @FirstVisitValue,
      @Contacts,
      @Visits,
      @Value
    )
  )
  AS [source]
  (
    [Date],
    [TrafficType],
    [SiteNameId],
    [DeviceNameId],
    [LanguageId],
    [FirstVisitValue],
    [Contacts],
    [Visits],
    [Value]
  )
  ON
  (
    ([target].[Date] = [source].[Date]) AND
    ([target].[TrafficType] = [source].[TrafficType]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
    ([target].[LanguageId] = [source].[LanguageId])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[FirstVisitValue] = ([target].[FirstVisitValue] + [source].[FirstVisitValue]),
        [target].[Contacts] = ([target].[Contacts] + [source].[Contacts]),
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [TrafficType],
      [SiteNameId],
      [DeviceNameId],
      [LanguageId],
      [FirstVisitValue],
      [Contacts],
      [Visits],
      [Value]
    )
    VALUES
    (
      [source].[Date],
      [source].[TrafficType],
      [source].[SiteNameId],
      [source].[DeviceNameId],
      [source].[LanguageId],
      [source].[FirstVisitValue],
      [source].[Contacts],
      [source].[Visits],
      [source].[Value]
    );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_ValueBySource]
      SET
        [FirstVisitValue] = ([FirstVisitValue] + @FirstVisitValue),
        [Contacts] = ([Contacts] + @Contacts),
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value)
      WHERE
        ([Date] = @Date) AND
        ([TrafficType] = @TrafficType) AND
        ([SiteNameId] = @SiteNameId) AND
        ([DeviceNameId] = @DeviceNameId) AND
        ([LanguageId] = @LanguageId);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_ValueBySource] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_ValueBySource_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_ValueBySource_Tvp]
  @table [ValueBySource_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_ValueBySource] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source] ON
      (
        ([target].[Date] = [source].[Date]) AND
        ([target].[TrafficType] = [source].[TrafficType]) AND
        ([target].[SiteNameId] = [source].[SiteNameId]) AND
        ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
        ([target].[LanguageId] = [source].[LanguageId])
      )

    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[FirstVisitValue] = ([target].[FirstVisitValue] + [source].[FirstVisitValue]),
          [target].[Contacts] = ([target].[Contacts] + [source].[Contacts]),
          [target].[Visits] = ([target].[Visits] + [source].[Visits]),
          [target].[Value] = ([target].[Value] + [source].[Value])

    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [TrafficType],
        [SiteNameId],
        [DeviceNameId],
        [LanguageId],
        [FirstVisitValue],
        [Contacts],
        [Visits],
        [Value]
      )
      VALUES
      (
        [source].[Date],
        [source].[TrafficType],
        [source].[SiteNameId],
        [source].[DeviceNameId],
        [source].[LanguageId],
        [source].[FirstVisitValue],
        [source].[Contacts],
        [source].[Visits],
        [source].[Value]
      );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_Visits]...';


GO
ALTER PROCEDURE [dbo].[Add_Visits]
  @Date SMALLDATETIME,
  @ItemId UNIQUEIDENTIFIER,
  @LanguageId INTEGER,
  @FirstVisit BIT,
  @PagesCount BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Fact_Visits] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @ItemId,
      @LanguageId,
      @FirstVisit,
      @PagesCount
    )
  )
  AS [source]
  (
    [Date],
    [ItemId],
    [LanguageId],
    [FirstVisit],
    [PagesCount]
  )
  ON
  ( 
    ([target].[Date] = [source].[Date]) AND 
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[LanguageId] = [source].[LanguageId]) AND  
    ([target].[FirstVisit] = [source].[FirstVisit])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[PagesCount] = ([target].[PagesCount] + [source].[PagesCount])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [ItemId],
      [LanguageId],
      [FirstVisit],
      [PagesCount]
    )
    VALUES
    (
      [source].[Date],
      [source].[ItemId],
      [source].[LanguageId],
      [source].[FirstVisit],
      [source].[PagesCount]
    );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_Visits]
      SET
        [PagesCount] = ([PagesCount] + @PagesCount)
      WHERE
        ([Date] = @Date) AND 
        ([ItemId] = @ItemId) AND
        ([LanguageId] = @LanguageId) AND
        ([FirstVisit] = @FirstVisit);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_Visits] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO

PRINT N'Droping [dbo].[Add_Visits_Tvp]...';
GO
IF (OBJECT_ID('[dbo].[Add_Visits_Tvp]', 'P') IS NOT NULL)
BEGIN
	DROP PROCEDURE [dbo].[Add_Visits_Tvp]
End 
GO
PRINT N'Droping [dbo].[Visits_Type]...';
GO
IF (TYPE_ID(N'[dbo].[Visits_Type]') IS NOT NULL)
BEGIN
	DROP TYPE [dbo].[Visits_Type]
END
GO

PRINT N'Updating [dbo].[Add_Visits_Tvp]...';

IF type_id('[dbo].[Visits_Type]') IS NULL
BEGIN

	CREATE TYPE [dbo].[Visits_Type] AS TABLE (
		[Date] SMALLDATETIME NOT NULL,
		[ItemId] UNIQUEIDENTIFIER NOT NULL,
		[LanguageId] INTEGER NOT NULL,
		[FirstVisit] BIT NOT NULL,
		[PagesCount] BIGINT NOT NULL,
	
		PRIMARY KEY CLUSTERED
		(
			[Date],
			[ItemId],
			[LanguageId],
			[FirstVisit]
		)
	);

END

GO

CREATE PROCEDURE [dbo].[Add_Visits_Tvp]
  @table [Visits_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_Visits] WITH (HOLDLOCK) AS [target]
    USING
      @table AS [source] ON
      ( 
        ([target].[Date] = [source].[Date]) AND 
        ([target].[ItemId] = [source].[ItemId]) AND
        ([target].[LanguageId] = [source].[LanguageId]) AND  
        ([target].[FirstVisit] = [source].[FirstVisit])
      )

    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[PagesCount] = ([target].[PagesCount] + [source].[PagesCount])

    WHEN NOT MATCHED THEN
      INSERT
      (
        [Date],
        [ItemId],
        [LanguageId],
        [FirstVisit],
        [PagesCount]
      )
      VALUES
      (
        [source].[Date],
        [source].[ItemId],
        [source].[LanguageId],
        [source].[FirstVisit],
        [source].[PagesCount]
      );
  
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;

GO

PRINT N'Altering [dbo].[Add_VisitsByBusinessContactLocation]...';


GO
ALTER PROCEDURE [dbo].[Add_VisitsByBusinessContactLocation]
  @AccountId UNIQUEIDENTIFIER,
  @BusinessUnitId UNIQUEIDENTIFIER,
  @Date SMALLDATETIME,
  @TrafficType INTEGER,
  @SiteNameId INTEGER,
  @DeviceNameId INTEGER,
  @ContactId UNIQUEIDENTIFIER,
  @LanguageId INTEGER,
  @Latitude FLOAT,
  @Longitude FLOAT,
  @Visits BIGINT,
  @Value BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Fact_VisitsByBusinessContactLocation] AS [target]
  USING
  (
    VALUES
    (
      @AccountId,
      @BusinessUnitId,
      @Date,
      @TrafficType,
      @SiteNameId,
      @DeviceNameId,
      @ContactId,
      @LanguageId,
      @Latitude,
      @Longitude,
      @Visits,
      @Value
    )
  )
  AS [source]
  (
    [AccountId], 
    [BusinessUnitId], 
    [Date], 
    [TrafficType], 
    [SiteNameId], 
    [DeviceNameId], 
    [ContactId], 
    [LanguageId], 
    [Latitude], 
    [Longitude], 
    [Visits], 
    [Value]
  )
  ON
  (
    ([target].[AccountId] = [source].[AccountId]) AND
    ([target].[BusinessUnitId] = [source].[BusinessUnitId]) AND
    ([target].[ContactId] = [source].[ContactId]) AND
    ([target].[Date] = [source].[Date]) AND
    ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
    ([target].[LanguageId] = [source].[LanguageId]) AND
    ([target].[Latitude] = [source].[Latitude]) AND
    ([target].[Longitude] = [source].[Longitude]) AND
    ([target].[SiteNameId] = [source].[SiteNameId]) AND
    ([target].[TrafficType] = [source].[TrafficType])
  )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [AccountId],
      [BusinessUnitId],
      [Date],
      [TrafficType],
      [SiteNameId],
      [DeviceNameId],
      [ContactId],
      [LanguageId],
      [Latitude],
      [Longitude],
      [Visits],
      [Value]
    )
    VALUES
    (
      [source].[AccountId],
      [source].[BusinessUnitId],
      [source].[Date],
      [source].[TrafficType],
      [source].[SiteNameId],
      [source].[DeviceNameId],
      [source].[ContactId],
      [source].[LanguageId],
      [source].[Latitude],
      [source].[Longitude],
      [source].[Visits],
      [source].[Value]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_VisitsByBusinessContactLocation]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value)
      WHERE
        ([AccountId] = @AccountId) AND
        ([BusinessUnitId] = @BusinessUnitId) AND
        ([ContactId] = @ContactId) AND
        ([Date] = @Date) AND
        ([DeviceNameId] = @DeviceNameId) AND
        ([LanguageId] = @LanguageId) AND
        ([Latitude] = @Latitude) AND
        ([Longitude] = @Longitude) AND
        ([SiteNameId] = @SiteNameId) AND
        ([TrafficType] = @TrafficType);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_VisitsByBusinessContactLocation] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Add_VisitsByBusinessContactLocation_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Add_VisitsByBusinessContactLocation_Tvp]
  @table [VisitsByBusinessContactLocation_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
      [Fact_VisitsByBusinessContactLocation] AS [target]
    USING
      @table AS [source] ON
      (
        ([target].[AccountId] = [source].[AccountId]) AND
        ([target].[BusinessUnitId] = [source].[BusinessUnitId]) AND
        ([target].[ContactId] = [source].[ContactId]) AND
        ([target].[Date] = [source].[Date]) AND
        ([target].[DeviceNameId] = [source].[DeviceNameId]) AND
        ([target].[LanguageId] = [source].[LanguageId]) AND
        ([target].[Latitude] = [source].[Latitude]) AND
        ([target].[Longitude] = [source].[Longitude]) AND
        ([target].[SiteNameId] = [source].[SiteNameId]) AND
        ([target].[TrafficType] = [source].[TrafficType])
      )

    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[Visits] = ([target].[Visits] + [source].[Visits]),
          [target].[Value] = ([target].[Value] + [source].[Value])

    WHEN NOT MATCHED THEN
      INSERT
      (
        [AccountId],
        [BusinessUnitId],
        [Date],
        [TrafficType],
        [SiteNameId],
        [DeviceNameId],
        [ContactId],
        [LanguageId],
        [Latitude],
        [Longitude],
        [Visits],
        [Value]
      )
      VALUES
      (
        [source].[AccountId],
        [source].[BusinessUnitId],
        [source].[Date],
        [source].[TrafficType],
        [source].[SiteNameId],
        [source].[DeviceNameId],
        [source].[ContactId],
        [source].[LanguageId],
        [source].[Latitude],
        [source].[Longitude],
        [source].[Visits],
        [source].[Value]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;
GO
PRINT N'Altering [dbo].[Ensure_Asset]...';


GO
ALTER PROCEDURE [dbo].[Ensure_Asset]
  @AssetId [uniqueidentifier],
  @Url [varchar](800)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [Assets]
    (
      [AssetId],
      [Url]
    )
    VALUES
    (
      @AssetId,
      @Url
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_Assets_Tvp]...';


GO
ALTER PROCEDURE [Ensure_Assets_Tvp]
  @table [Assets_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [Assets] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[AssetId] = [source].[AssetId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [AssetId],
      [Url]
    )
    VALUES
    (
      [source].[AssetId],
      [source].[Url]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_BusinessUnit]...';


GO
ALTER PROCEDURE [dbo].[Ensure_BusinessUnit]
  @BusinessUnitId UNIQUEIDENTIFIER,
  @AccountId UNIQUEIDENTIFIER,
  @BusinessName NVARCHAR(100),
  @Country NVARCHAR(100),
  @Region NVARCHAR(100),
  @City NVARCHAR(100)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [BusinessUnits]
    (
      [BusinessUnitId],
      [AccountId],
      [BusinessName],
      [Country],
      [Region],
      [City]
    )
    VALUES
    (
      @BusinessUnitId,
      @AccountId,
      @BusinessName,
      @Country,
      @Region,
      @City
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_BusinessUnits_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Ensure_BusinessUnits_Tvp]
  @table [BusinessUnits_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [BusinessUnits] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[BusinessUnitId] = [source].[BusinessUnitId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [BusinessUnitId],
      [AccountId],
      [BusinessName],
      [Country],
      [Region],
      [City]
    )
    VALUES
    (
      [source].[BusinessUnitId],
      [source].[AccountId],
      [source].[BusinessName],
      [source].[Country],
      [source].[Region],
      [source].[City]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_DeviceName]...';


GO
ALTER PROCEDURE [Ensure_DeviceName]
  @DeviceNameId INTEGER,
  @DeviceName NVARCHAR(450)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [DeviceNames]
    (
      [DeviceNameId],
      [DeviceName]
    )
    VALUES
    (
      @DeviceNameId,
      @DeviceName
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_DeviceNames_Tvp]...';


GO
ALTER PROCEDURE [Ensure_DeviceNames_Tvp]
  @table [DeviceNames_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [DeviceNames] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[DeviceNameId] = [source].[DeviceNameId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [DeviceNameId],
      [DeviceName]
    )
    VALUES
    (
      [source].[DeviceNameId],
      [source].[DeviceName]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_DimensionKeys]...';


GO
ALTER PROCEDURE [dbo].[Ensure_DimensionKeys]
    @DimensionKeyId [bigint],
    @DimensionKey [nvarchar](max)
	WITH EXECUTE AS OWNER
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
MERGE [DimensionKeys] AS Target USING ( VALUES (@DimensionKeyId, @DimensionKey)) AS Source (DimensionKeyId, DimensionKey)
 ON 
Target.[DimensionKeyId] = Source.[DimensionKeyId]
WHEN NOT MATCHED THEN
  INSERT ([DimensionKeyId], [DimensionKey]
)
VALUES (
Source.[DimensionKeyId], Source.[DimensionKey]);
END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();
IF( @@ERROR != 2627 )
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END
END CATCH;
END
GO
PRINT N'Creating [dbo].[Ensure_DimensionKeys_Tvp]...';


GO
CREATE PROCEDURE [dbo].[Ensure_DimensionKeys_Tvp]
  @table [DimensionKeys_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY

    MERGE [DimensionKeys] AS Target USING @table Source
    ON 
      Target.[DimensionKeyId] = Source.[DimensionKeyId]
    WHEN NOT MATCHED THEN
      INSERT ([DimensionKeyId], [DimensionKey])
      VALUES (Source.[DimensionKeyId], Source.[DimensionKey]);

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  END CATCH;
END
GO
PRINT N'Altering [dbo].[Ensure_FailureDetails]...';


GO
ALTER PROCEDURE [dbo].[Ensure_FailureDetails]
  @FailureDetailsId UNIQUEIDENTIFIER,
  @Url NVARCHAR(450),
  @ErrorText NVARCHAR(1000),
  @PreviousUrl NVARCHAR(450),
  @DataKey NVARCHAR(450),
  @Data NVARCHAR(450)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [FailureDetails]
    (
      [FailureDetailsId],
      [Url], 
      [ErrorText], 
      [PreviousUrl],
      [DataKey],
      [Data]
    )
    VALUES
    (
      @FailureDetailsId,
      @Url,
      @ErrorText,
      @PreviousUrl,
      @DataKey,
      @Data
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_FailureDetails_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Ensure_FailureDetails_Tvp]
  @table [FailureDetails_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;


  MERGE
    [FailureDetails] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[FailureDetailsId] = [source].[FailureDetailsId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [FailureDetailsId],
      [Url], 
      [ErrorText], 
      [PreviousUrl],
      [DataKey],
      [Data]
    )
    VALUES
    (
      [source].[FailureDetailsId],
      [source].[Url], 
      [source].[ErrorText], 
      [source].[PreviousUrl],
      [source].[DataKey],
      [source].[Data]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_Item]...';


GO
ALTER PROCEDURE [Ensure_Item]
  @ItemId UNIQUEIDENTIFIER,
  @Url VARCHAR(800)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [Items]
    (
      [ItemId],
      [Url]
    )
    VALUES
    (
      @ItemId,
      @Url
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_Items_Tvp]...';


GO
ALTER PROCEDURE [Ensure_Items_Tvp]
  @table [Items_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [Items] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[ItemId] = [source].[ItemId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [ItemId],
      [Url]
    )
    VALUES
    (
      [source].[ItemId],
      [source].[Url]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_Keywords]...';


GO
ALTER PROCEDURE [dbo].[Ensure_Keywords]
  @KeywordsId [uniqueidentifier],
  @Keywords [nvarchar](400)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [Keywords]
    (
      [KeywordsId],
      [Keywords]
    )
    VALUES
    (
      @KeywordsId,
      @Keywords
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_Keywords_Tvp]...';


GO
ALTER PROCEDURE [Ensure_Keywords_Tvp]
  @table [Keywords_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [Keywords] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[KeywordsId] = [source].[KeywordsId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [KeywordsId],
      [Keywords]
    )
    VALUES
    (
      [source].[KeywordsId],
      [source].[Keywords]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_Language]...';


GO
ALTER PROCEDURE [dbo].[Ensure_Language]
  @LanguageId INTEGER,
  @Name NVARCHAR(11)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [Languages]
    (
      [LanguageId],
      [Name]
    )
    VALUES
    (
      @LanguageId,
      @Name
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END
GO
PRINT N'Altering [dbo].[Ensure_Languages_Tvp]...';


GO
ALTER PROCEDURE [Ensure_Languages_Tvp]
  @table [Languages_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [Languages] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[LanguageId] = [source].[LanguageId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [LanguageId],
      [Name]
    )
    VALUES
    (
      [source].[LanguageId],
      [source].[Name]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_ReferringSite]...';


GO
ALTER PROCEDURE [Ensure_ReferringSite]
  @ReferringSiteId UNIQUEIDENTIFIER,
  @ReferringSite NVARCHAR(400)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [ReferringSites]
    (
      [ReferringSiteId],
      [ReferringSite]
    )
    VALUES
    (
      @ReferringSiteId,
      @ReferringSite
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_ReferringSites_Tvp]...';


GO
ALTER PROCEDURE [Ensure_ReferringSites_Tvp]
  @table [ReferringSites_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [ReferringSites] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[ReferringSiteId] = [source].[ReferringSiteId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [ReferringSiteId],
      [ReferringSite]
    )
    VALUES
    (
      [source].[ReferringSiteId],
      [source].[ReferringSite]
    );

END;
GO
PRINT N'Altering [dbo].[Ensure_SegmentRecords]...';


GO
ALTER PROCEDURE [dbo].[Ensure_SegmentRecords]
    @SegmentRecordId [bigint],
    @SegmentId [uniqueidentifier],
    @Date [smalldatetime],
    @SiteNameId [int],
    @DimensionKeyId [bigint]
	WITH EXECUTE AS OWNER
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
MERGE [SegmentRecords] AS Target USING ( VALUES (@SegmentRecordId, @SegmentId, @Date, @SiteNameId, @DimensionKeyId)) AS Source (SegmentRecordId, SegmentId, Date, SiteNameId, DimensionKeyId)
 ON 
Target.[SegmentRecordId] = Source.[SegmentRecordId]
WHEN NOT MATCHED THEN
  INSERT ([SegmentRecordId], [SegmentId], [Date], [SiteNameId], [DimensionKeyId]
)
VALUES (
Source.[SegmentRecordId], Source.[SegmentId], Source.[Date], Source.[SiteNameId], Source.[DimensionKeyId]);
END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();
IF( @@ERROR != 2627 )
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END
END CATCH;
END
GO
PRINT N'Altering [dbo].[Ensure_SegmentRecords_Tvp]...';


GO
ALTER PROCEDURE [dbo].[Ensure_SegmentRecords_Tvp]
  @table [dbo].[SegmentRecords_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY

    MERGE [SegmentRecords] AS Target USING @table AS Source
    ON 
      Target.[SegmentRecordId] = Source.[SegmentRecordId]
    WHEN NOT MATCHED THEN
      INSERT ([SegmentRecordId], [SegmentId], [Date], [SiteNameId], [DimensionKeyId])
      VALUES (Source.[SegmentRecordId], Source.[SegmentId], Source.[Date], Source.[SiteNameId], Source.[DimensionKeyId]);

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @@ERROR != 2627 )
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END
  END CATCH;
END
GO
PRINT N'Altering [dbo].[Ensure_SiteName]...';


GO
ALTER PROCEDURE [Ensure_SiteName]
  @SiteNameId INTEGER,
  @SiteName NVARCHAR(450)
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    INSERT INTO [SiteNames]
    (
      [SiteNameId],
      [SiteName]
    )
    VALUES
    (
      @SiteNameId,
      @SiteName
    );

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END;
GO
PRINT N'Altering [dbo].[Ensure_SiteNames_Tvp]...';


GO
ALTER PROCEDURE [Ensure_SiteNames_Tvp]
  @table [SiteNames_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  MERGE
    [SiteNames] AS [target]
  USING
    @table AS [source]
  ON
    ([target].[SiteNameId] = [source].[SiteNameId])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [SiteNameId],
      [SiteName]
    )
    VALUES
    (
      [source].[SiteNameId],
      [source].[SiteName]
    );

END;
GO
PRINT N'Altering [dbo].[Get_AllTaxonEntities]...';


GO
ALTER PROCEDURE [Get_AllTaxonEntities] 
	@TaxonomyId UNIQUEIDENTIFIER
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

    SELECT			t.Id,
					t.ParentId,
					t.TaxonomyId,
					t.Uri,
					t.Type,
					[dbo].[GetTaxonEntityChildIds](t.Id) AS ChildIds,
					t.IsDeleted
	FROM			[Taxonomy_TaxonEntity] t
	WHERE			t.Uri LIKE '/{' + CONVERT(nvarchar(50), @TaxonomyId) + '}%'

	SELECT			v.TaxonId AS TaxonId,
					d.Id AS FieldId,
					d.Name AS FieldName,
					d.IsLanguageInvariant AS LanguageInvariant,
					v.LanguageCode,
					v.FieldValue
	FROM			[Taxonomy_TaxonEntityFieldDefinition] d
	LEFT OUTER JOIN	[Taxonomy_TaxonEntityFieldValue] v
	ON				d.Id = v.FieldId
	WHERE			v.TaxonId IN (SELECT Id FROM [Taxonomy_TaxonEntity] WHERE Uri LIKE '/{' + CONVERT(NVARCHAR(50), @TaxonomyId) + '}%');

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END
GO
PRINT N'Altering [dbo].[Get_MissingDailyTrees]...';


GO
ALTER PROCEDURE [dbo].[Get_MissingDailyTrees]
     @StartDate Date,
     @EndDate Date
WITH EXECUTE AS OWNER
AS
BEGIN

SET NOCOUNT ON;

DECLARE @AllDates TABLE (StartDate Date)

DECLARE @CurrentDate Date
SET @CurrentDate = @StartDate;

WHILE @CurrentDate < @EndDate
   BEGIN
         INSERT INTO @AllDates
           VALUES  (@CurrentDate)
         SET @CurrentDate = DATEADD(DAY,1,@CurrentDate)
     END

SELECT DefinitionId, dates.StartDate
  FROM TreeDefinitions, @AllDates as dates
EXCEPT
  SELECT DefinitionId, StartDate from Trees
  WHERE DATEDIFF(day, trees.StartDate, Trees.EndDate) = 1 
ORDER BY StartDate

END
GO
PRINT N'Altering [dbo].[Get_TaxonEntity]...';


GO
ALTER PROCEDURE [Get_TaxonEntity]
	@Id UNIQUEIDENTIFIER
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	SELECT			t.Id,
					t.ParentId,
					t.TaxonomyId,
					t.Type,
					t.Uri,
					[dbo].[GetTaxonEntityChildIds](t.Id) AS ChildIds,
					t.IsDeleted
	FROM			[Taxonomy_TaxonEntity] t
	WHERE			t.Id = @Id;

	SELECT			v.TaxonId AS Id,
					d.Id AS FieldId,
					d.Name AS FieldName,
					d.IsLanguageInvariant AS LanguageInvariant,
					v.LanguageCode,
					v.FieldValue
	FROM			[Taxonomy_TaxonEntityFieldDefinition] d
	LEFT OUTER JOIN	[Taxonomy_TaxonEntityFieldValue] v
	ON				d.Id = v.FieldId
	WHERE			v.TaxonId = @Id;

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END
GO
PRINT N'Altering [dbo].[Get_TaxonEntityChildren]...';


GO
ALTER PROCEDURE [Get_TaxonEntityChildren] 
	@Id UNIQUEIDENTIFIER,
	@TaxonomyId UNIQUEIDENTIFIER
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

    SELECT			t.Id,
					t.ParentId,
					t.Uri,
					[dbo].[GetTaxonEntityChildIds](t.Id) AS ChildIds,
					t.IsDeleted
	FROM			[Taxonomy_TaxonEntity] t
	WHERE			t.ParentId = @Id
	AND				t.TaxonomyId = @TaxonomyId;

	SELECT			v.TaxonId AS TaxonId,
					d.Id AS FieldId,
					d.Name AS FieldName,
					d.IsLanguageInvariant AS LanguageInvariant,
					v.LanguageCode,
					v.FieldValue
	FROM			[Taxonomy_TaxonEntityFieldDefinition] d
	LEFT OUTER JOIN	[Taxonomy_TaxonEntityFieldValue] v
	ON				d.Id = v.FieldId
	WHERE			v.TaxonId IN (SELECT Id FROM [dbo].[Taxonomy_TaxonEntity] WHERE ParentId = @Id);

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END
GO
PRINT N'Altering [dbo].[Get_TaxonEntityList]...';


GO
ALTER PROCEDURE [Get_TaxonEntityList]
	@IdList NVARCHAR(MAX),
	@LanguageCode NVARCHAR(10)
WITH EXECUTE AS OWNER
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE	@position		INT,
			@nextPosition	INT,
			@valuelength	INT

	DECLARE @IdTable TABLE
	(
		Id UNIQUEIDENTIFIER
	)
	
	SELECT @position = 0, @nextPosition = 1
	
	WHILE @nextPosition > 0
	
	BEGIN
		SELECT @nextPosition = CHARINDEX(',', @IdList, @position + 1)
		SELECT @valuelength = CASE WHEN @nextPosition > 0
                              THEN @nextPosition
                              ELSE LEN(@IdList) + 1
                         END - @position - 1

		INSERT @IdTable (Id)
		VALUES (CONVERT(UNIQUEIDENTIFIER, SUBSTRING(@IdList, @position + 1, @valuelength)))
		SELECT @position = @nextPosition
	END

	SELECT			t.Id,
					t.ParentId,
					t.TaxonomyId,
					t.Type,
					t.Uri,
					[dbo].[GetTaxonEntityChildIds](t.Id) AS ChildIds,
					t.IsDeleted
	FROM			[Taxonomy_TaxonEntity] t
	INNER JOIN		@IdTable i
	ON				t.Id = i.Id;

	SELECT			v.TaxonId AS Id,
					d.Id AS FieldId,
					d.Name AS FieldName,
					d.IsLanguageInvariant AS LanguageInvariant,
					v.LanguageCode,
					v.FieldValue
	FROM			[Taxonomy_TaxonEntityFieldDefinition] d
	LEFT OUTER JOIN	[Taxonomy_TaxonEntityFieldValue] v
	ON				d.Id = v.FieldId  AND
					(v.LanguageCode = '' OR
					v.LanguageCode = @LanguageCode)
	INNER JOIN		@IdTable i
	ON				v.TaxonId = i.Id;

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END
GO
PRINT N'Altering [dbo].[ReduceSegmentMetrics]...';


GO
ALTER PROCEDURE [dbo].[ReduceSegmentMetrics] @SiteNameId INT,
  @SegmentId UNIQUEIDENTIFIER,
  @OtherSegmentRecordId BIGINT,
  @StartDate SMALLDATETIME,
  @OtherDimensionKeyId BIGINT,
  @OtherDimensionKey NVARCHAR(450),
  @VisitThreshold INT = 10,
  @ValueThreshold INT = -1,
  @KeepCountThreshold INT = 1000,
  @DryRun BIT = 1,
  @Debug BIT = 0,
  @UnclassifiedDeviceKey NVARCHAR(450)
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @EndDate SMALLDATETIME

        SET @EndDate = DATEADD(day, 1, @StartDate)

        -- Copy segment data for given date range
        -- Compute order value
        CREATE TABLE [dbo].[#tmp] (
		      [PredicateOrder] [bigint] NULL,
		      [SegmentId] [uniqueidentifier] NOT NULL,
		      [Date] [smalldatetime] NOT NULL,
		      [SiteNameId] [int] NOT NULL,
		      [DimensionKeyId] [bigint] NOT NULL,
		      [SegmentRecordId] [bigint] NOT NULL,
		      [ContactTransitionType] [tinyint] NOT NULL,
		      [Visits] [int] NOT NULL,
		      [Value] [int] NOT NULL,
		      [Bounces] [int] NOT NULL,
		      [Conversions] [int] NOT NULL,
		      [TimeOnSite] [int] NOT NULL,
		      [Pageviews] [int] NOT NULL,
		      [Count] [int] NOT NULL,
		      [Converted] [int] NOT NULL
		      ) ON [PRIMARY]

        INSERT #tmp
        SELECT ROW_NUMBER() OVER (
			          ORDER BY sm.Visits DESC,
				          ABS(sm.Value) DESC
			          ) AS 'PredicateOrder',
                      sr.[SegmentId], 
                      sr.[Date], 
                      sr.[SiteNameId], 
                      sr.[DimensionKeyId], 
                      sm.[SegmentRecordId], 
                      sm.[ContactTransitionType], 
                      sm.[Visits], 
                      sm.[Value], 
                      sm.[Bounces], 
                      sm.[Conversions], 
                      sm.[TimeOnSite], 
                      sm.[Pageviews], 
                      sm.[Count], 
                      sm.[Converted]
               FROM SegmentRecords sr
                    INNER JOIN Fact_SegmentMetrics sm ON sr.SegmentRecordId = sm.SegmentRecordId
                    INNER JOIN DimensionKeys dk ON dk.DimensionKeyId = sr.DimensionKeyId
               WHERE sr.SegmentId = @SegmentId
                     AND sr.[Date] >= @StartDate
                     AND sr.[Date] < @EndDate
                     AND sr.[SiteNameId] = @SiteNameId
                     AND dk.DimensionKey NOT LIKE @UnclassifiedDeviceKey + '%'

        -- Compute how many records to keep
        DECLARE @KeepCount INT

        SELECT @KeepCount = MAX(PredicateOrder)
        FROM #tmp

        IF(@KeepCount > @KeepCountThreshold)
            SET @KeepCount = @KeepCountThreshold
            ELSE
            BEGIN
                SELECT @KeepCount = MAX(PredicateOrder)
                FROM #tmp
                WHERE Visits > @VisitThreshold
                      AND ABS(Value) > @ValueThreshold

                IF(@KeepCount IS NULL)
                    SET @KeepCount = 0
        END

        -- Populate SegmentRecordsReduced from temp table
        -- Use top KeepCount records (highest predicate value)
        MERGE [SegmentRecordsReduced] AS [target]
        USING(
            SELECT DISTINCT [SegmentRecordId], 
                   [SegmentId], 
                   [Date], 
                   [SiteNameId], 
                   [DimensionKeyId]
            FROM #tmp
            WHERE PredicateOrder <= @KeepCount
        ) AS [source]([SegmentRecordId], [SegmentId], [Date], [SiteNameId], [DimensionKeyId])
        ON([target].[SegmentRecordId] = [source].[SegmentRecordId])
            WHEN MATCHED
            THEN 
              UPDATE 
              SET [target].[SegmentId] = [source].[SegmentId], 
                  [target].[Date] = [source].[Date], 
                  [target].[SiteNameId] = [source].[SiteNameId], 
                  [target].[DimensionKeyId] = [source].[DimensionKeyId]
            WHEN NOT MATCHED
            THEN
              INSERT(
                [SegmentRecordId], 
                [SegmentId], 
                [Date], 
                [SiteNameId], 
                [DimensionKeyId]
                )
              VALUES(
                [source].[SegmentRecordId], 
                [source].[SegmentId], 
                [source].[Date], 
                [source].[SiteNameId], 
                [source].[DimensionKeyId]
              );

        -- Populate Fact_SegmentMetricsReduced from temp table
        -- Use top KeepCount records (highest predicate value)
        MERGE [Fact_SegmentMetricsReduced] AS [target]
        USING (
            SELECT [SegmentRecordId], 
                   [ContactTransitionType], 
                   [Visits], 
                   [Value], 
                   [Bounces], 
                   [Conversions], 
                   [TimeOnSite], 
                   [Pageviews], 
                   [Count], 
                   [Converted]
            FROM #tmp
            WHERE PredicateOrder <= @KeepCount
            ) AS [source]([SegmentRecordId], [ContactTransitionType], [Visits], [Value], [Bounces], [Conversions], [TimeOnSite], [Pageviews], [Count], [Converted])
            ON(
                [target].[SegmentRecordId] = [source].[SegmentRecordId]
                AND [target].[ContactTransitionType] = [source].[ContactTransitionType]
                )
            WHEN MATCHED
            THEN 
              UPDATE 
              SET [target].[Visits] = [source].[Visits] + [target].[Visits], 
                  [target].[Value] = [source].[Value] + [target].[Value], 
                  [target].[Bounces] = [source].[Bounces] + [target].[Bounces], 
                  [target].[Conversions] = [source].[Conversions] + [target].[Conversions], 
                  [target].[TimeOnSite] = [source].[TimeOnSite] + [target].[TimeOnSite], 
                  [target].[Pageviews] = [source].[Pageviews] + [target].[Pageviews], 
                  [target].[Count] = [source].[Count] + [target].[Count], 
                  [target].[Converted] = [source].[Converted] + [target].[Converted]
            WHEN NOT MATCHED
            THEN
              INSERT (
                  [SegmentRecordId], 
                  [ContactTransitionType], 
                  [Visits], 
                  [Value], 
                  [Bounces], 
                  [Conversions], 
                  [TimeOnSite], 
                  [Pageviews], 
                  [Count], 
                  [Converted]
                  )
              VALUES (
                [source].[SegmentRecordId], 
                [source].[ContactTransitionType], 
                [source].[Visits], 
                [source].[Value], 
                [source].[Bounces], 
                [source].[Conversions], 
                [source].[TimeOnSite], 
                [source].[Pageviews], 
                [source].[Count], 
                [source].[Converted]
                );

        -- Populate DimensionKeys with record for "other"
        MERGE [DimensionKeys] AS [target]
        USING (
            VALUES (
              @OtherDimensionKeyId, 
              @OtherDimensionKey
            )
        ) AS [source]([DimensionKeyId], [DimensionKey])
          ON([target].[DimensionKeyId] = [source].[DimensionKeyId])
        WHEN NOT MATCHED
            THEN
              INSERT(
                [DimensionKeyId], 
                [DimensionKey]
                )
              VALUES (
                [source].[DimensionKeyId], 
                [source].[DimensionKey]
                );

        -- Populate SegmentRecordsReduced with one record for "other" if some records were reduced
        IF(
          EXISTS (
            SELECT *
            FROM #tmp
            WHERE PredicateOrder > @KeepCount
            )
          )
         MERGE [SegmentRecordsReduced] AS [target]
        USING(
          VALUES (
            @OtherSegmentRecordId, 
            @SegmentId, 
            @StartDate, 
            @SiteNameId, 
            @OtherDimensionKeyId
            )
          ) AS [source]([SegmentRecordId], [SegmentId], [Date], [SiteNameId], [DimensionKeyId])
            ON([target].[SegmentRecordId] = [source].[SegmentRecordId])
                WHEN MATCHED
                THEN 
                  UPDATE
                  SET [target].[SegmentId] = [source].[SegmentId], 
                      [target].[Date] = [source].[Date], 
                      [target].[SiteNameId] = [source].[SiteNameId], 
                      [target].[DimensionKeyId] = [source].[DimensionKeyId]
                WHEN NOT MATCHED
                  THEN
                    INSERT(
                        [SegmentRecordId], 
                        [SegmentId], 
                        [Date], 
                        [SiteNameId], 
                        [DimensionKeyId]
                        )
                    VALUES(
                      [source].[SegmentRecordId], 
                      [source].[SegmentId], 
                      [source].[Date], 
                      [source].[SiteNameId], 
                      [source].[DimensionKeyId]
                      );

        -- Populate Fact_SegmentMetricsReduced from temp table with "other" records.
        -- Other is a summary of bottom records (lowest predicate value; above KeepCount)
        MERGE [Fact_SegmentMetricsReduced] AS [target]
        USING (
            SELECT @OtherSegmentRecordId AS [SegmentRecordId], 
                   [ContactTransitionType], 
                   SUM([Visits]) AS [Visits], 
                   SUM([Value]) AS [Value], 
                   SUM([Bounces]) AS [Bounces], 
                   SUM([Conversions]) AS [Conversions], 
                   SUM([TimeOnSite]) AS [TimeOnSite], 
                   SUM([Pageviews]) AS [Pageviews], 
                   SUM([Count]) AS [Count], 
                   SUM([Converted]) AS [Converted]
            FROM #tmp
            WHERE PredicateOrder > @KeepCount
            GROUP BY ContactTransitionType
        ) AS [source]([SegmentRecordId], [ContactTransitionType], [Visits], [Value], [Bounces], [Conversions], [Converted], [TimeOnSite], [Pageviews], [Count])
        ON(
            [target].[SegmentRecordId] = [source].[SegmentRecordId]
            AND [target].[ContactTransitionType] = [source].[ContactTransitionType]
            )
        WHEN MATCHED
            THEN 
                UPDATE
                SET [target].[Visits] = [source].[Visits] + [target].[Visits], 
                    [target].[Value] = [source].[Value] + [target].[Value], 
                    [target].[Bounces] = [source].[Bounces] + [target].[Bounces], 
                    [target].[Conversions] = [source].[Conversions] + [target].[Conversions], 
                    [target].[TimeOnSite] = [source].[TimeOnSite] + [target].[TimeOnSite], 
                    [target].[Pageviews] = [source].[Pageviews] + [target].[Pageviews], 
                    [target].[Count] = [source].[Count] + [target].[Count], 
                    [target].[Converted] = [source].[Converted] + [target].[Converted]
            WHEN NOT MATCHED
            THEN
              INSERT (
                [SegmentRecordId], 
                [ContactTransitionType], 
                [Visits], 
                [Value], 
                [Bounces], 
                [Conversions], 
                [TimeOnSite], 
                [Pageviews], 
                [Count],
                [Converted]
                )
              VALUES (
                [source].[SegmentRecordId], 
                [source].[ContactTransitionType], 
                [source].[Visits], 
                [source].[Value], 
                [source].[Bounces], 
                [source].[Conversions], 
                [source].[TimeOnSite], 
                [source].[Pageviews], 
                [source].[Count], 
                [source].[Converted]
                );

        --pruning trace
        IF @Debug = 1
            BEGIN
                SELECT *
                FROM Fact_SegmentMetrics
                INNER JOIN SegmentRecords ON Fact_SegmentMetrics.SegmentRecordId = SegmentRecords.SegmentRecordId
                WHERE Fact_SegmentMetrics.SegmentRecordId IN (
                    SELECT SegmentRecordId
                    FROM #tmp
                    )
        END

        -- Delete processed data from Fact_SegmentMetrics and SegmentRecords
        IF @DryRun = 0
        BEGIN
            PRINT N'Deleting source records.';

            DELETE Fact_SegmentMetrics
            WHERE SegmentRecordId IN (
                SELECT SegmentRecordId
                FROM #tmp
                )

            DELETE SegmentRecords
            WHERE SegmentRecordId IN (
                SELECT SegmentRecordId
                FROM #tmp
                )
        END
        ELSE
        BEGIN
            PRINT N'Executed in dry run mode.';
        END

        DROP TABLE #tmp
END
GO
PRINT N'Altering [dbo].[Register_AutomationStates]...';


GO
ALTER PROCEDURE [Register_AutomationStates]
  @AutomationStateId UNIQUEIDENTIFIER,
  @SeqNumber         INT,
  @Processed         SMALLDATETIME = NULL
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  IF( @Processed IS NULL )
  BEGIN
    SET @Processed = GETUTCDATE();
  END

  INSERT INTO [Trail_AutomationStates]
  (
    [AutomationStateId],
    [SeqNumber],
    [Processed]
  )
  VALUES
  (
    @AutomationStateId,
    @SeqNumber,
    @Processed
  );

END;
GO
PRINT N'Altering [dbo].[Register_Interaction]...';


GO
ALTER PROCEDURE [Register_Interaction]
  @Id VARBINARY(128),
  @Processed SMALLDATETIME = NULL
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  IF( @Processed IS NULL )
  BEGIN
    SET @Processed = GETUTCDATE();
  END

  INSERT INTO [Trail_Interactions]
  (
    [Id],
    [Processed]
  )
  VALUES
  (
    @Id,
    @Processed
  );

END;
GO
PRINT N'Altering [dbo].[Upsert_Account]...';


GO
ALTER PROCEDURE [Upsert_Account]
  @AccountId UNIQUEIDENTIFIER,
  @BusinessName NVARCHAR(100),
  @Country NVARCHAR(100),
  @Classification INTEGER,
  @IntegrationId UNIQUEIDENTIFIER,
  @IntegrationLabel NVARCHAR(100),
  @ExternalUser NVARCHAR(256)
WITH EXECUTE AS OWNER
AS
BEGIN

SET NOCOUNT ON;

  IF EXISTS
  (
    SELECT
      1
    FROM
      [Accounts]
    WHERE
      ([AccountId] = @AccountId)
  )
  BEGIN
    IF NOT EXISTS
    (
      SELECT
        1
      FROM
        [Accounts]
      WHERE
        ([AccountId] = @AccountId) AND
        ([BusinessName] = @BusinessName) AND
        ([Country] = @Country) AND
        ([Classification] = @Classification) AND
        ([IntegrationId] = @IntegrationId OR ([IntegrationId] IS NULL AND @IntegrationId IS NULL)) AND
        ([IntegrationLabel] = @IntegrationLabel OR ([IntegrationLabel] IS NULL AND @IntegrationLabel IS NULL)) AND
        ([ExternalUser] = @ExternalUser OR ([ExternalUser] IS NULL AND @ExternalUser IS NULL))
    )
    BEGIN
      UPDATE
        [Accounts]
      SET
        [BusinessName] = @BusinessName,
        [Country] = @Country,
        [Classification] = @Classification,
        [IntegrationId] = @IntegrationId,
        [IntegrationLabel] = @IntegrationLabel,
        [ExternalUser] = @ExternalUser
      WHERE
        ([AccountId] = @AccountId)
    END
  END
  ELSE 
  BEGIN
    BEGIN TRY
      INSERT INTO [Accounts]
      (
        [AccountId],
        [BusinessName],
        [Country],
        [Classification],
        [IntegrationId],
        [IntegrationLabel],
        [ExternalUser]
      )
      VALUES
      (
        @AccountId,
        @BusinessName,
        @Country,
        @Classification,
        @IntegrationId,
        @IntegrationLabel,
        @ExternalUser
      );
    END TRY
    BEGIN CATCH
      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();
      IF( @error_number = 2627 )
      BEGIN
        IF NOT EXISTS
        (
          SELECT
            1
          FROM
            [Accounts]
          WHERE
            ([AccountId] = @AccountId) AND
            ([BusinessName] = @BusinessName) AND
            ([Country] = @Country) AND
            ([Classification] = @Classification) AND
            ([IntegrationId] = @IntegrationId OR ([IntegrationId] IS NULL AND @IntegrationId IS NULL)) AND
            ([IntegrationLabel] = @IntegrationLabel OR ([IntegrationLabel] IS NULL AND @IntegrationLabel IS NULL)) AND
            ([ExternalUser] = @ExternalUser OR ([ExternalUser] IS NULL AND @ExternalUser IS NULL))
        )
        BEGIN
          UPDATE
            [Accounts]
          SET
            [BusinessName] = @BusinessName,
            [Country] = @Country,
            [Classification] = @Classification,
            [IntegrationId] = @IntegrationId,
            [IntegrationLabel] = @IntegrationLabel,
            [ExternalUser] = @ExternalUser
          WHERE
            ([AccountId] = @AccountId)
          
          IF( @@ROWCOUNT != 1 )
          BEGIN
            RAISERROR( 'Failed to update row in the [Accounts] table.', 18, 1 ) WITH NOWAIT;
          END
        END
      END
      ELSE
      BEGIN
         RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
      END
    END CATCH
  END

END
GO
PRINT N'Altering [dbo].[Upsert_Contact]...';


GO
ALTER PROCEDURE [Upsert_Contact]
  @ContactId UNIQUEIDENTIFIER,
  @AuthenticationLevel INTEGER,
  @Classification INTEGER,
  @ContactTags XML,
  @IntegrationLevel INTEGER,
  @ExternalUser NVARCHAR(100),
  @OverrideClassification INTEGER
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  BEGIN TRY

    MERGE
      [Contacts] AS [target]
    USING
    (
      VALUES
      (
        @ContactId,
        @AuthenticationLevel,
        @Classification,
        @ContactTags,
        @IntegrationLevel,
        @ExternalUser,
        @OverrideClassification
      )
    )
    AS [source]
    (
      [ContactId],
      [AuthenticationLevel],
      [Classification],
      [ContactTags],
      [IntegrationLevel],
      [ExternalUser],
      [OverrideClassification]
    )
    ON
      ([target].[ContactId] = [source].[ContactId])

    WHEN MATCHED THEN
      UPDATE
        SET
          [target].[AuthenticationLevel] = [source].[AuthenticationLevel],
          [target].[Classification] = [source].[Classification],
          [target].[ContactTags] = [source].[ContactTags],
          [target].[IntegrationLevel] = [source].[IntegrationLevel],
          [target].[ExternalUser] = [source].[ExternalUser],
          [target].[OverrideClassification] = [source].[OverrideClassification]

    WHEN NOT MATCHED THEN
      INSERT
      (
        [ContactId],
        [AuthenticationLevel],
        [Classification],
        [ContactTags],
        [IntegrationLevel],
        [ExternalUser],
        [OverrideClassification]
      )
      VALUES
      (
        [source].[ContactId],
        [source].[AuthenticationLevel],
        [source].[Classification],
        [source].[ContactTags],
        [source].[IntegrationLevel],
        [source].[ExternalUser],
        [source].[OverrideClassification]
      );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN
      
      UPDATE
        [Contacts]
      SET
        [AuthenticationLevel] = @AuthenticationLevel,
        [Classification] = @Classification,
        [ContactTags] = @ContactTags,
        [IntegrationLevel] = @IntegrationLevel,
        [ExternalUser] = @ExternalUser,
        [OverrideClassification] = @OverrideClassification
      WHERE
      ( 
        ([ContactId] = @ContactId)
      )

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to update row in the [Contacts] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END
GO
PRINT N'Altering [dbo].[Upsert_TaxonEntities]...';


GO
ALTER PROCEDURE [Upsert_TaxonEntities]
	@EntitiesXml XML
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @entities TABLE(
		Id UNIQUEIDENTIFIER NOT NULL,
		ParentId UNIQUEIDENTIFIER, 
		TaxonomyId UNIQUEIDENTIFIER NOT NULL, 
		[Type] NVARCHAR(255) NOT NULL, 
		Uri NVARCHAR(MAX) NOT NULL
		PRIMARY KEY (Id));

	-- parse out the xml into a table
	INSERT INTO @entities (Id, ParentId, TaxonomyId, [Type], Uri)
	SELECT  CONVERT(UNIQUEIDENTIFIER, e.value('@id', 'NVARCHAR(50)')),
			CASE WHEN e.exist('@parentId') = 1 THEN CONVERT(UNIQUEIDENTIFIER, e.value('@parentId', 'NVARCHAR(50)')) ELSE NULL END,
			CONVERT(UNIQUEIDENTIFIER, e.value('@taxonomyId', 'NVARCHAR(50)')),
			e.value('@type', 'NVARCHAR(255)'),
			e.value('@uri', 'NVARCHAR(MAX)')
	FROM @EntitiesXml.nodes('/entities/entity') AS T(e)

	-- add the new taxons
	INSERT INTO [Taxonomy_TaxonEntity] (Id, ParentId, TaxonomyId, [Type], Uri, IsDeleted)
	SELECT e.Id, e.ParentId, e.TaxonomyId, e.[Type], e.Uri, 0
	FROM @entities e
	LEFT OUTER JOIN [Taxonomy_TaxonEntity] te
		ON te.Id = e.Id
	WHERE te.Id IS NULL	

	-- update the existing taxons
	UPDATE [Taxonomy_TaxonEntity]
	SET ParentId = e.ParentId,
		TaxonomyId = e.TaxonomyId,
		[Type] = e.[Type],
		Uri = e.Uri,
		IsDeleted = 0
	FROM [Taxonomy_TaxonEntity] te
	INNER JOIN @entities e
		ON te.Id = e.Id

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END;
GO
PRINT N'Altering [dbo].[Upsert_TaxonEntity]...';


GO
ALTER PROCEDURE [Upsert_TaxonEntity]
	@Id UNIQUEIDENTIFIER,
	@ParentId UNIQUEIDENTIFIER,
	@TaxonomyId UNIQUEIDENTIFIER,
	@Type NVARCHAR(255),
	@Uri NVARCHAR(MAX),
	@IsDeleted BIT
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

    IF EXISTS
	(
		SELECT	1
		FROM	[Taxonomy_TaxonEntity]
		WHERE	[Id] = @Id
	)
	BEGIN
		UPDATE	[Taxonomy_TaxonEntity]
		SET		[ParentId] = @ParentId,
				[TaxonomyId] = @TaxonomyId,
				[Type] = @Type,
				[Uri] = @Uri,
				[IsDeleted] = @IsDeleted
		WHERE	[Id] = @Id;
	END
	ELSE
	BEGIN
		INSERT INTO	[Taxonomy_TaxonEntity] ([Id], [ParentId], [TaxonomyId], [Type], [Uri], [IsDeleted])
		VALUES		(@Id, @ParentId, @TaxonomyId, @Type, @Uri, @IsDeleted);
	END

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END
GO
PRINT N'Altering [dbo].[Upsert_TaxonEntityField]...';


GO
ALTER PROCEDURE [Upsert_TaxonEntityField]
	@TaxonId UNIQUEIDENTIFIER,
	@Id UNIQUEIDENTIFIER,
	@FieldName NVARCHAR(255),
	@LanguageCode NVARCHAR(10),
	@IsLanguageInvariant BIT,
	@Value NVARCHAR(MAX)
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	-- create/update the field definition
	IF EXISTS
	(
		SELECT 1
		FROM   [Taxonomy_TaxonEntityFieldDefinition]
		WHERE  Id = @Id
	)
	BEGIN
		UPDATE [Taxonomy_TaxonEntityFieldDefinition]
		SET	   Name = @FieldName,
			   IsLanguageInvariant = @IsLanguageInvariant
		WHERE  Id = @Id
	END
	ELSE
	BEGIN
		INSERT INTO [Taxonomy_TaxonEntityFieldDefinition] (Id, Name, IsLanguageInvariant)
		VALUES (@Id, @FieldName, @IsLanguageInvariant);
	END
	
	-- create/update the field value
    IF EXISTS
	(
		SELECT	1
		FROM	[Taxonomy_TaxonEntityFieldValue]
		WHERE	[TaxonId] = @TaxonId
		AND		[FieldId] = @Id
		AND		[LanguageCode] = @LanguageCode
	)
	BEGIN
		UPDATE	[Taxonomy_TaxonEntityFieldValue]
		SET		[FieldValue] = @Value
		WHERE	[TaxonId] = @TaxonId
		AND		[FieldId] = @Id
		AND		[LanguageCode] = @LanguageCode;
	END
	ELSE
	BEGIN
		INSERT INTO	[Taxonomy_TaxonEntityFieldValue] ([TaxonId], [FieldId], [LanguageCode], [FieldValue])
		VALUES		(@TaxonId, @Id, @LanguageCode, @Value);
	END

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END
GO
PRINT N'Altering [dbo].[Upsert_TaxonEntityFields]...';


GO
ALTER PROCEDURE [Upsert_TaxonEntityFields]
	@EntityFieldsXml XML
WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @entityFieldDefs TABLE(
		Id UNIQUEIDENTIFIER NOT NULL,
		Name NVARCHAR(255) NOT NULL,
		IsLanguageInvariant BIT NOT NULL,
		PRIMARY KEY (Id));

	DECLARE @entityFieldValues TABLE(
		TaxonId UNIQUEIDENTIFIER NOT NULL,
		FieldId UNIQUEIDENTIFIER,
		LanguageCode NVARCHAR(10) NOT NULL,
		FieldValue NVARCHAR(max) NOT NULL,
		PRIMARY KEY (TaxonId, FieldId, LanguageCode));

	-- split the xml out into the two tables
	INSERT INTO @entityFieldDefs (Id, Name, IsLanguageInvariant)
	SELECT fieldDefs.Id, fieldDefs.Name, fieldDefs.IsLanguageInvariant
	FROM (
		-- deduplicate the fields to get the unique field defs
		SELECT allFieldInstances.*,
			   ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id ASC) AS Position
		FROM (
			-- get all fields from xml, which could have duplicate fields for different languages
			SELECT  CONVERT(UNIQUEIDENTIFIER, f.value('@id', 'NVARCHAR(50)')) AS Id,
					f.value('@name', 'NVARCHAR(255)') AS Name,
					f.value('@isLanguageInvariant', 'bit') AS IsLanguageInvariant
			FROM @EntityFieldsXml.nodes('/entityFields/entityField') AS T(f)
		) AS [allFieldInstances]
	) [fieldDefs]
	WHERE Position = 1

	INSERT INTO @entityFieldValues (TaxonId, FieldId, LanguageCode, FieldValue)
	SELECT fieldValues.TaxonId, fieldValues.FieldId, fieldValues.LanguageCode, fieldValues.FieldValue
	FROM (
		-- deduplicate the field values to get rid of any duplicate invariant fields
		SELECT allFieldValues.*,
			   ROW_NUMBER() OVER (PARTITION BY TaxonId, FieldId, LanguageCode ORDER BY TaxonId) AS Position
		FROM (
			-- get all the fields from the xml, which could have duplicate invariant fields for the same taxon that came from
			-- different language variants of the same taxon
			SELECT  CONVERT(UNIQUEIDENTIFIER, f.value('@taxonId', 'NVARCHAR(50)')) AS TaxonId,
					CONVERT(UNIQUEIDENTIFIER, f.value('@id', 'NVARCHAR(50)')) AS FieldId,
					f.value('@languageCode', 'NVARCHAR(255)') AS LanguageCode,
					f.value('@value', 'NVARCHAR(255)') AS FieldValue
			FROM @EntityFieldsXml.nodes('/entityFields/entityField') AS T(f)
		) AS [allFieldValues]
	) [fieldValues]
	WHERE Position = 1

	-- add the new field defs
	INSERT INTO [Taxonomy_TaxonEntityFieldDefinition] (Id, Name, IsLanguageInvariant)
	SELECT efd.Id, efd.Name, efd.IsLanguageInvariant			   
	FROM @entityFieldDefs efd
	LEFT OUTER JOIN [Taxonomy_TaxonEntityFieldDefinition] fd
		ON fd.Id = efd.Id
	WHERE fd.Id IS NULL	

	-- update the existing field defs
	UPDATE [Taxonomy_TaxonEntityFieldDefinition]
	SET Id = efd.Id,
		Name = efd.Name,
		IsLanguageInvariant = efd.IsLanguageInvariant
	FROM [Taxonomy_TaxonEntityFieldDefinition] fd
	INNER JOIN @entityFieldDefs efd
		ON fd.Id = efd.Id

	-- add the new field values
	INSERT INTO [Taxonomy_TaxonEntityFieldValue] (TaxonId, FieldId, LanguageCode, FieldValue)
	SELECT efv.TaxonId, efv.FieldId, efv.LanguageCode, efv.FieldValue
	FROM @entityFieldValues efv
	LEFT OUTER JOIN [Taxonomy_TaxonEntityFieldValue] fv
		ON fv.TaxonId = efv.TaxonId AND
		   fv.FieldId = efv.FieldId AND
		   fv.LanguageCode = efv.LanguageCode
	WHERE fv.TaxonId IS NULL	

	-- update the existing field values
	UPDATE [Taxonomy_TaxonEntityFieldValue]
	SET FieldValue = efv.FieldValue
	FROM @entityFieldValues efv
	INNER JOIN [Taxonomy_TaxonEntityFieldValue] fv
		ON fv.TaxonId = efv.TaxonId AND
		   fv.FieldId = efv.FieldId AND
		   fv.LanguageCode = efv.LanguageCode

	END TRY
	BEGIN CATCH

		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();
    
		RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
	END CATCH;
END;
GO

PRINT N'Refreshing [dbo].[ReportDataView]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ReportDataView]';


GO
PRINT N'Refreshing [dbo].[Ensure_DimensionKeys]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ensure_DimensionKeys]';


GO
PRINT N'Refreshing [dbo].[Ensure_DimensionKeys_Tvp]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Ensure_DimensionKeys_Tvp]';


GO
PRINT N'Refreshing [dbo].[ReduceSegmentMetrics]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[ReduceSegmentMetrics]';



PRINT N'Update complete.';


GO

PRINT N' XA Update Started';
GO
PRINT N'Creating [dbo].[DownloadEventMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[DownloadEventMetrics_Type]') IS NULL)
    BEGIN
        CREATE TYPE [dbo].[DownloadEventMetrics_Type] AS TABLE
        ([SegmentRecordId] BIGINT NOT NULL, 
         [SegmentId]       UNIQUEIDENTIFIER NOT NULL, 
         [Date]            SMALLDATETIME NOT NULL, 
         [SiteNameId]      INT NOT NULL, 
         [DimensionKeyId]  BIGINT NOT NULL, 
         [Visits]          INT NOT NULL, 
         [Value]           INT NOT NULL, 
         [Count]           INT NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
        );
END;
GO
PRINT N'Creating [dbo].[Fact_CampaignMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_CampaignMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_CampaignMetrics]
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [MonetaryValue]   [MONEY] NOT NULL, 
         [Bounces]         [INT] NOT NULL, 
         [Conversions]     [INT] NOT NULL, 
         [Pageviews]       [INT] NOT NULL, 
         [TimeOnSite]      [INT] NOT NULL, 
         [Converted]       [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_CampaignMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_ChannelMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_ChannelMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_ChannelMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL,  
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_ChannelMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
PRINT N'Creating [dbo].[Fact_ChannelGroupMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_ChannelGroupMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_ChannelGroupMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_ChannelGroupMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_ConversionsMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_ConversionsMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_ConversionsMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_ConversionsMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_DownloadEventMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_DownloadEventMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_DownloadEventMetrics]
        ([SegmentRecordId] BIGINT NOT NULL, 
         [SegmentId]       UNIQUEIDENTIFIER NOT NULL, 
         [Date]            SMALLDATETIME NOT NULL, 
         [SiteNameId]      INT NOT NULL, 
         [DimensionKeyId]  BIGINT NOT NULL, 
         [Visits]          INT NOT NULL, 
         [Value]           INT NOT NULL, 
         [Count]           INT NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER], 
         CONSTRAINT [PK_Fact_DownloadEventMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        );
END;
GO
PRINT N'Creating [dbo].[Fact_GoalMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_GoalMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_GoalMetrics]
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL, 
         [Conversions]     [INT] NOT NULL, 
         [Converted]       [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_GoalMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_LanguageMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_LanguageMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_LanguageMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_LanguageMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_OutcomeMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_OutcomeMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_OutcomeMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_OutcomeMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_PageMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_PageMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_PageMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],         
         [FirstImpressionCount]    [INT] NOT NULL,
         CONSTRAINT [PK_Fact_PageMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_PageViewsMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_PageViewsMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_PageViewsMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_PageViewsMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_PatternMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_PatternMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_PatternMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_PatternMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_ReferringSiteMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_ReferringSiteMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_ReferringSiteMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_ReferringSiteMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO
PRINT N'Creating [dbo].[Fact_SearchMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_SearchMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_SearchMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL,  
         [TimeOnSite]         [INT] NOT NULL, 
         [Count]              [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],         
         [FirstImpressionCount]    [INT] NOT NULL,
         CONSTRAINT [PK_Fact_SearchMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Refreshing [dbo].[ReportDataView]...';
GO
EXECUTE sp_refreshsqlmodule 
        N'[dbo].[ReportDataView]';
GO


PRINT N'Altering [dbo].[Ensure_DimensionKeys]...';
GO
ALTER PROCEDURE [dbo].[Ensure_DimensionKeys] @DimensionKeyId [BIGINT], 
                                             @DimensionKey   [NVARCHAR](MAX)
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [DimensionKeys] AS Target
            USING(VALUES
            (@DimensionKeyId, 
             @DimensionKey
            )) AS Source(DimensionKeyId, DimensionKey)
            ON Target.[DimensionKeyId] = Source.[DimensionKeyId]
                WHEN NOT MATCHED
                THEN
                  INSERT([DimensionKeyId], 
                         [DimensionKey])
                  VALUES
            (Source.[DimensionKeyId], 
             Source.[DimensionKey]
            );
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            IF(@@ERROR != 2627)
                BEGIN
                    RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
            END;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_CampaignMetrics_Tvp]...'; 
GO
IF(OBJECT_ID('[dbo].[Add_CampaignMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_CampaignMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[CampaignMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[CampaignMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[CampaignMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[CampaignMetrics_Type]...';
GO
CREATE TYPE [dbo].[CampaignMetrics_Type] AS TABLE
([SegmentRecordId] [BIGINT] NOT NULL, 
 [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]            [SMALLDATETIME] NOT NULL, 
 [SiteNameId]      [INT] NOT NULL, 
 [DimensionKeyId]  [BIGINT] NOT NULL, 
 [Visits]          [INT] NOT NULL, 
 [Value]           [INT] NOT NULL, 
 [MonetaryValue]   [MONEY] NOT NULL, 
 [Bounces]         [INT] NOT NULL, 
 [Conversions]     [INT] NOT NULL, 
 [Pageviews]       [INT] NOT NULL, 
 [TimeOnSite]      [INT] NOT NULL,
 [Converted]       [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_CampaignMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_CampaignMetrics_Tvp] @table [dbo].[CampaignMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_CampaignMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [MonetaryValue], 
                         [Bounces], 
                         [Conversions], 
                         [Pageviews], 
                         [TimeOnSite],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[MonetaryValue], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[Pageviews], 
             Source.[TimeOnSite],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_ChannelMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_ChannelMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ChannelMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[ChannelMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[ChannelMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ChannelMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[ChannelMetrics_Type]...';
GO
CREATE TYPE [dbo].[ChannelMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_ChannelMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_ChannelMetrics_Tvp] @table [dbo].[ChannelMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_ChannelMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions],  
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_ChannelGroupMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_ChannelGroupMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ChannelGroupMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[ChannelGroupMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[ChannelGroupMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ChannelGroupMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[ChannelGroupMetrics_Type]...';
GO
CREATE TYPE [dbo].[ChannelGroupMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[[Add_ChannelGroupMetrics_Tvp]]...';
GO
CREATE PROCEDURE [dbo].[Add_ChannelGroupMetrics_Tvp] @table [dbo].[ChannelGroupMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_ChannelGroupMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_ConversionsMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_ConversionsMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ConversionsMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[ConversionsMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[ConversionsMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ConversionsMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[ConversionsMetrics_Type]...';
GO
CREATE TYPE [dbo].[ConversionsMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_ConversionsMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_ConversionsMetrics_Tvp] @table [dbo].[ConversionsMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_ConversionsMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO

PRINT N'Dropping [dbo].[Add_GoalMetrics_Tvp]...';
IF(OBJECT_ID('[dbo].[Add_GoalMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_GoalMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[GoalMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[GoalMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[GoalMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[GoalMetrics_Type]...';
GO
CREATE TYPE [dbo].[GoalMetrics_Type] AS TABLE
([SegmentRecordId] [BIGINT] NOT NULL, 
 [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]            [SMALLDATETIME] NOT NULL, 
 [SiteNameId]      [INT] NOT NULL, 
 [DimensionKeyId]  [BIGINT] NOT NULL, 
 [Visits]          [INT] NOT NULL, 
 [Value]           [INT] NOT NULL, 
 [Count]           [INT] NOT NULL, 
 [Conversions]     [INT] NOT NULL, 
 [Converted]       [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_GoalMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_GoalMetrics_Tvp] @table [dbo].[GoalMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_GoalMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[Count] = (Target.[Count] + Source.[Count]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[Value],
					[Count],
					[Conversions],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[Value],
					Source.[Count],
					Source.[Conversions],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N'Dropping [dbo].[Add_LanguageMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_LanguageMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_LanguageMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[LanguageMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[LanguageMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[LanguageMetrics_Type];
END;
PRINT N'Creating [dbo].[LanguageMetrics_Type]';
GO
CREATE TYPE [dbo].[LanguageMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_LanguageMetrics_Tvp]';
GO
CREATE PROCEDURE [dbo].[Add_LanguageMetrics_Tvp] @table [dbo].[LanguageMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_LanguageMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_OutcomeMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_OutcomeMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_OutcomeMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[OutcomeMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[OutcomeMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[OutcomeMetrics_Type];
END;
PRINT N'Creating [dbo].[OutcomeMetrics_Type]...';
GO
CREATE TYPE [dbo].[OutcomeMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_OutcomeMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_OutcomeMetrics_Tvp] @table [dbo].[OutcomeMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_OutcomeMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [MonetaryValue], 
                         [OutcomeOccurrences], 
                         [Value], 
                         [Conversions], 
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences], 
             Source.[Value], 
             Source.[Conversions], 
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO
PRINT N'Dropping [dbo].[Add_PageMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_PageMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_PageMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[PageMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[PageMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[PageMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[PageMetrics_Type]...';
GO
CREATE TYPE [dbo].[PageMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [TimeOnPage]         [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 [FirstImpressionCount]    [INT] NOT NULL,
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_PageMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_PageMetrics_Tvp] @table [dbo].[PageMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_PageMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[TimeOnPage] = (Target.[TimeOnPage] + Source.[TimeOnPage]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted]),
                                Target.[FirstImpressionCount] = (Target.[FirstImpressionCount] + Source.[FirstImpressionCount])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions],  
                         [Pageviews], 
                         [TimeOnPage], 
                         [TimeOnSite], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
						 [FilterId],
                         [FirstImpressionCount])                                                  
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions],  
             Source.[Pageviews], 
             Source.[TimeOnPage], 
             Source.[TimeOnSite], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId],
             Source.[FirstImpressionCount]
            );
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_PageViewsMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_PageViewsMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_PageViewsMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[PageViewsMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[PageViewsMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[PageViewsMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[PageViewsMetrics_Type]...';
GO
CREATE TYPE [dbo].[PageViewsMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_PageViewsMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_PageViewsMetrics_Tvp] @table [dbo].[PageViewsMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_PageViewsMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_PatternMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_PatternMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_PatternMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[PatternMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[PatternMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[PatternMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[PatternMetrics_Type]...';
GO
CREATE TYPE [dbo].[PatternMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_PatternMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_PatternMetrics_Tvp] @table [dbo].[PatternMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_PatternMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_ReferringSiteMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_ReferringSiteMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ReferringSiteMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[ReferringSiteMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[ReferringSiteMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ReferringSiteMetrics_Type];
END;
PRINT N'Creating [dbo].[ReferringSiteMetrics_Type]...';
GO
CREATE TYPE [dbo].[ReferringSiteMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_ReferringSiteMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_ReferringSiteMetrics_Tvp] @table [dbo].[ReferringSiteMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_ReferringSiteMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),  
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[Add_SearchMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_SearchMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_SearchMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[SearchMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[SearchMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[SearchMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[SearchMetrics_Type]...';
GO
CREATE TYPE [dbo].[SearchMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Count]              [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 [FirstImpressionCount]    [INT] NOT NULL ,
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_SearchMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_SearchMetrics_Tvp] @table [dbo].[SearchMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_SearchMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Count] = (Target.[Count] + Source.[Count]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted]),
                                Target.[FirstImpressionCount] = (Target.[FirstImpressionCount] + Source.[FirstImpressionCount])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Count], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
						 [FilterId],
                         [FirstImpressionCount])
                         
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Count], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
			 Source.[FilterId],
             Source.[FirstImpressionCount]
            );                       
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Dropping [dbo].[ReduceMetricsTable]...';
GO
IF(OBJECT_ID('[dbo].[ReduceMetricsTable]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[ReduceMetricsTable];
END;
GO


PRINT N'Creating [dbo].[ReduceMetricsTable]...';
GO
CREATE PROCEDURE [dbo].[ReduceMetricsTable] 
    @SiteNameId INT,
	@Date SMALLDATETIME,
	@RolledUpKeyId BIGINT,
	@RolledUpKey NVARCHAR(MAX),
	@RowsToKeep INT,
	@ExceptDimensionKey NVARCHAR(MAX),
	@TableName SYSNAME,
	@OrderBy NVARCHAR(MAX),
	@debug BIT = 0
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT TABLE_NAME
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = @TableName
			)
	BEGIN
		DECLARE @errorMsg VARCHAR(MAX);

		SET @errorMsg = 'Invalid table name ''' + @TableName + '''';

		RAISERROR (
				@errorMsg,
				16,
				1
				);

		RETURN;
	END;

	DECLARE @EndDate SMALLDATETIME;
	DECLARE @sql NVARCHAR(MAX);

	SET @EndDate = DATEADD(day, 1, @Date);

	-- Populate DimensionKeys with record for "other"
	IF NOT EXISTS (
			SELECT DimensionKeyId
			FROM DimensionKeys
			WHERE DimensionKey = @RolledUpKey
			)
	BEGIN
		INSERT INTO DimensionKeys
		VALUES (
			@RolledUpKeyId,
			@RolledUpKey
			);
	END;

	CREATE TABLE #segmentIdsTable (
		RowId INT IDENTITY,
		SegmentId UNIQUEIDENTIFIER,
        FilterId UNIQUEIDENTIFIER
		);

	SET @sql = 'Insert into #segmentIdsTable Select distinct SegmentId, FilterId from ' + QUOTENAME(@TableName);

	IF @debug = 1
		PRINT @sql;

	EXEC (@sql);

	DECLARE @tempTblCount INT = (
			SELECT COUNT(*)
			FROM #segmentIdsTable
			);
	DECLARE @index INT = 1;
	DECLARE @SegmentId UNIQUEIDENTIFIER;
    DECLARE @FilterId UNIQUEIDENTIFIER;
	DECLARE @RolledUpRecordId BIGINT;
	-- Prepare columns lists which will be used later in dynamic queries
	DECLARE @ColumnList AS VARCHAR(MAX);
	DECLARE @SumColumnList AS VARCHAR(MAX);
	DECLARE @mergeUpdateColumnList AS VARCHAR(MAX);
	DECLARE @sourceColumnList AS VARCHAR(MAX);

	SET @sql = 'SELECT @ColumnList = COALESCE(@ColumnList+'','' ,'''') + COLUMN_NAME,
		  @SumColumnList = COALESCE(@SumColumnList+'','' ,'''') + ''SUM(''+COLUMN_NAME+'') AS ''+COLUMN_NAME,
		  @mergeUpdateColumnList = COALESCE(@mergeUpdateColumnList+'','' ,'''') + ''[target].''+COLUMN_NAME+'' = [source].''+COLUMN_NAME+'' + [target].''+COLUMN_NAME,
		  @sourceColumnList = COALESCE(@sourceColumnList+'','' ,'''') + ''[source].''+COLUMN_NAME
		  FROM INFORMATION_SCHEMA.COLUMNS
		  where TABLE_NAME = ''' + @TableName + ''' 
		  and COLUMN_NAME not in (''SegmentRecordId'', ''SegmentId'', ''Date'', ''SiteNameId'', ''DimensionKeyId'', ''FilterId'');';

	IF @debug = 1
		PRINT @sql;

	EXECUTE sp_executesql @sql,
		N'@ColumnList AS Varchar(MAX) OUT,@SumColumnList AS Varchar(MAX) OUT,@mergeUpdateColumnList AS Varchar(MAX) OUT,@sourceColumnList AS Varchar(MAX) OUT',
		@ColumnList = @ColumnList OUTPUT,
		@SumColumnList = @SumColumnList OUTPUT,
		@mergeUpdateColumnList = @mergeUpdateColumnList OUTPUT,
		@sourceColumnList = @sourceColumnList OUTPUT;

	-- while loop for each distinct segment id in table
	WHILE (@tempTblCount >= @index)
	BEGIN
		SET @SegmentId = (
				SELECT SegmentId
				FROM #segmentIdsTable
				WHERE RowId = @index
				);
        SET @FilterId = (
				SELECT FilterId
				FROM #segmentIdsTable
				WHERE RowId = @index
				);
                
		SELECT @RolledUpRecordId = CHECKSUM(@SegmentId, @Date, @SiteNameId, @FilterId);

		-- Get the 'count' of records for specified segment, site and date		 
		DECLARE @count INT;

		SET @sql = 'SELECT @count = COUNT(*)
		  FROM ' + QUOTENAME(@TableName) + ' WHERE SegmentId = @SegmentId
		  AND [Date] >= @Date
		  AND [Date] < @EndDate
		  AND [SiteNameId] = @SiteNameId
		  AND [FilterId] = @FilterId
		  AND [SegmentRecordId] <> @RolledUpRecordId
		  AND DimensionKeyId NOT IN
		  (
			 SELECT DimensionKeyId
			 FROM DimensionKeys
			 WHERE DimensionKey LIKE @ExceptDimensionKey+''%''
		  );';

		IF @debug = 1
			PRINT @sql;

		EXECUTE sp_executesql @sql,
			N'@SegmentId UNIQUEIDENTIFIER,@Date SMALLDATETIME,@SiteNameId INT,@FilterId UNIQUEIDENTIFIER,@ExceptDimensionKey NVARCHAR(MAX),@EndDate SMALLDATETIME,@RolledUpRecordId BIGINT,@count INT OUT',
			@SegmentId = @SegmentId,
			@Date = @Date,
			@EndDate = @EndDate,
			@SiteNameId = @SiteNameId,
			@FilterId = @FilterId,
			@ExceptDimensionKey = @ExceptDimensionKey,
			@RolledUpRecordId = @RolledUpRecordId,
			@count = @count OUTPUT;

		-- if no records to process, exit	  	   
		IF @count <= @RowsToKeep
		BEGIN
			SET @index = @index + 1;

			CONTINUE;
		END;

		-- collect the rows eligible to reduce into #EligibleToReduce
		SET @sql = 'SELECT TOP (@count - @RowsToKeep) *
		  INTO #EligibleToReduce
		  FROM ' + QUOTENAME(@TableName) + ' WHERE SegmentId = @SegmentId
			   AND [Date] >= @Date
			   AND [Date] < @EndDate
			   AND [SiteNameId] = @SiteNameId
			   AND [FilterId] = @FilterId
			   AND [SegmentRecordId] <> @RolledUpRecordId
			   AND DimensionKeyId NOT IN
					(
					   SELECT DimensionKeyId
					   FROM DimensionKeys
					   WHERE DimensionKey LIKE @ExceptDimensionKey+''%''
					)
		  ORDER BY ' + @OrderBy +
			-- reduce into #Reduced
			' SELECT @RolledUpRecordId AS SegmentRecordId,
			SegmentId,
			Date,
			SiteNameId,
			@RolledUpKeyId AS DimensionKeyId,' + @SumColumnList + ', FilterId INTO #Reduced
		  FROM #EligibleToReduce
		  GROUP BY SegmentId, Date, SiteNameId, FilterId;' +
			-- merge thre reduced rows from #Reduced to the original table 
			'MERGE ' + QUOTENAME(@TableName) + ' AS [target]
		  USING #Reduced AS [source]
		  ON([target].[SegmentRecordId] = [source].[SegmentRecordId] -- Assumpution: @RolledUpRecordId is a hash of (SegmentId, date, siteName, FilterId)
		  )
			 WHEN MATCHED
			 THEN UPDATE SET ' + @mergeUpdateColumnList + ' WHEN NOT MATCHED
			 THEN INSERT([SegmentRecordId],
					   [SegmentId],
					   [Date],
					   [SiteNameId],
					   [DimensionKeyId],' + @ColumnList + ', FilterId) VALUES
		  ([source].[SegmentRecordId],
		   [source].[SegmentId],
		   [source].[Date],
		   [source].[SiteNameId],
		   [source].[DimensionKeyId],' + @sourceColumnList + ',
		   [source].[FilterId]);' +
			-- delete the original rows which have already been reduced 
			'DELETE ' + QUOTENAME(@TableName) + ' WHERE SegmentRecordId IN
		  (
			 SELECT SegmentRecordId
			 FROM #EligibleToReduce
		  );

		  DROP TABLE #Reduced;
		  DROP TABLE #EligibleToReduce;';

		IF @debug = 1
			PRINT @sql;

		EXECUTE sp_executesql @sql,
			N'@SegmentId UNIQUEIDENTIFIER,@Date SMALLDATETIME,@SiteNameId INT, @FilterId UNIQUEIDENTIFIER,@RolledUpRecordId BIGINT,@RolledUpKeyId BIGINT,@RowsToKeep INT,@ExceptDimensionKey NVARCHAR(MAX),@EndDate SMALLDATETIME,@count INT,@ColumnList AS VARCHAR(MAX),@SumColumnList AS VARCHAR(MAX),@mergeUpdateColumnList AS VARCHAR(MAX),@sourceColumnList AS VARCHAR(MAX)',
			@SegmentId = @SegmentId,
			@Date = @Date,
			@EndDate = @EndDate,
			@SiteNameId = @SiteNameId,
			@FilterId = @FilterId,
			@ExceptDimensionKey = @ExceptDimensionKey,
			@count = @count,
			@RolledUpRecordId = @RolledUpRecordId,
			@RolledUpKeyId = @RolledUpKeyId,
			@RowsToKeep = @RowsToKeep,
			@ColumnList = @ColumnList,
			@SumColumnList = @SumColumnList,
			@mergeUpdateColumnList = @mergeUpdateColumnList,
			@sourceColumnList = @sourceColumnList;

		SET @index = @index + 1;
	END;

	DROP TABLE #segmentIdsTable;
END;
GO


PRINT N'Dropping [dbo].[Add_CampaignFacetGroupMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_CampaignFacetGroupMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_CampaignFacetGroupMetrics_Tvp];
END; 
GO
PRINT N'Dropping [dbo].[CampaignFacetGroupMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[CampaignFacetGroupMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[CampaignFacetGroupMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[CampaignFacetGroupMetrics_Type]...';
GO
CREATE TYPE [dbo].[CampaignFacetGroupMetrics_Type] AS TABLE
([SegmentRecordId] [BIGINT] NOT NULL, 
 [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]            [SMALLDATETIME] NOT NULL, 
 [SiteNameId]      [INT] NOT NULL, 
 [DimensionKeyId]  [BIGINT] NOT NULL, 
 [Visits]          [INT] NOT NULL, 
 [Value]           [INT] NOT NULL, 
 [MonetaryValue]   [MONEY] NOT NULL, 
 [Bounces]         [INT] NOT NULL, 
 [Conversions]     [INT] NOT NULL, 
 [Pageviews]       [INT] NOT NULL, 
 [TimeOnSite]      [INT] NOT NULL,
 [Converted]       [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_CampaignFacetGroupMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_CampaignFacetGroupMetrics_Tvp] @table [dbo].[CampaignFacetGroupMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_CampaignFacetGroupMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [MonetaryValue], 
                         [Bounces], 
                         [Conversions], 
                         [Pageviews], 
                         [TimeOnSite],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[MonetaryValue], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[Pageviews], 
             Source.[TimeOnSite],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO
PRINT N'Creating [dbo].[Fact_EntryPageMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_EntryPageMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_EntryPageMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_EntryPageMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_EntryPageMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_EntryPageMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_EntryPageMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[EntryPageMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[EntryPageMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[EntryPageMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[EntryPageMetrics_Type]...';
GO
CREATE TYPE [dbo].[EntryPageMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [TimeOnPage]         [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_EntryPageMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_EntryPageMetrics_Tvp] @table [dbo].[EntryPageMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_EntryPageMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),  
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[TimeOnPage] = (Target.[TimeOnPage] + Source.[TimeOnPage]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [Pageviews], 
                         [TimeOnPage], 
                         [TimeOnSite], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[Pageviews], 
             Source.[TimeOnPage], 
             Source.[TimeOnSite], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_ExitPageMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_ExitPageMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_ExitPageMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_ExitPageMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_ExitPageMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_ExitPageMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ExitPageMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[ExitPageMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[ExitPageMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ExitPageMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[ExitPageMetrics_Type]...';
GO
CREATE TYPE [dbo].[ExitPageMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [TimeOnPage]         [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_ExitPageMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_ExitPageMetrics_Tvp] @table [dbo].[ExitPageMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_ExitPageMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[TimeOnPage] = (Target.[TimeOnPage] + Source.[TimeOnPage]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [Pageviews], 
                         [TimeOnPage], 
                         [TimeOnSite], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[Pageviews], 
             Source.[TimeOnPage], 
             Source.[TimeOnSite], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_CityMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_CityMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_CityMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_CityMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_CityMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_CityMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_CityMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[CityMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[CityMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[CityMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[CityMetrics_Type]...';
GO
CREATE TYPE [dbo].[CityMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_CityMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_CityMetrics_Tvp] @table [dbo].[CityMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_CityMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_RegionMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_RegionMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_RegionMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_RegionMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_RegionMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_RegionMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_RegionMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[RegionMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[RegionMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[RegionMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[RegionMetrics_Type]...';
GO
CREATE TYPE [dbo].[RegionMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_RegionMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_RegionMetrics_Tvp] @table [dbo].[RegionMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_RegionMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_CountryMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_CountryMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_CountryMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_CountryMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_CountryMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_CountryMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_CountryMetrics_Tvp];
END; 
GO
PRINT N'Dropping [dbo].[CountryMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[CountryMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[CountryMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[CountryMetrics_Type]...';
GO
CREATE TYPE [dbo].[CountryMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_CountryMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_CountryMetrics_Tvp] @table [dbo].[CountryMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_CountryMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),  
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_DeviceSizeMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_DeviceSizeMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_DeviceSizeMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_DeviceSizeMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_DeviceSizeMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_DeviceSizeMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_DeviceSizeMetrics_Tvp];
END; 
GO
PRINT N'Dropping [dbo].[DeviceSizeMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[DeviceSizeMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[DeviceSizeMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[DeviceSizeMetrics_Type]...';
GO
CREATE TYPE [dbo].[DeviceSizeMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_DeviceSizeMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_DeviceSizeMetrics_Tvp] @table [dbo].[DeviceSizeMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_DeviceSizeMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_DeviceModelMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_DeviceModelMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_DeviceModelMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_DeviceModelMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_DeviceModelMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_DeviceModelMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_DeviceModelMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[DeviceModelMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[DeviceModelMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[DeviceModelMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[DeviceModelMetrics_Type]...';
GO
CREATE TYPE [dbo].[DeviceModelMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL,  
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER]
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_DeviceModelMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_DeviceModelMetrics_Tvp] @table [dbo].[DeviceModelMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_DeviceModelMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_DeviceTypeMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_DeviceTypeMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_DeviceTypeMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_DeviceTypeMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_DeviceTypeMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_DeviceTypeMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_DeviceTypeMetrics_Tvp];
END; 
GO
PRINT N'Dropping [dbo].[DeviceTypeMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[DeviceTypeMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[DeviceTypeMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[DeviceTypeMetrics_Type]...';
GO
CREATE TYPE [dbo].[DeviceTypeMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL,  
 [TimeOnSite]         [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER],
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_DeviceTypeMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_DeviceTypeMetrics_Tvp] @table [dbo].[DeviceTypeMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_DeviceTypeMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),  
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [TimeOnSite], 
                         [Pageviews], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[TimeOnSite], 
             Source.[Pageviews], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_AssetGroupMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_AssetGroupMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_AssetGroupMetrics]
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER],
         CONSTRAINT [PK_Fact_AssetGroupMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO

PRINT N'Dropping [dbo].[Add_AssetGroupMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_AssetGroupMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_AssetGroupMetrics_Tvp];
END; 
GO

PRINT N'Dropping [dbo].[AssetGroupMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[AssetGroupMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[AssetGroupMetrics_Type];
END;
GO

PRINT N'Creating [dbo].[AssetGroupMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[AssetGroupMetrics_Type]') IS NULL)
    BEGIN
        CREATE TYPE [dbo].[AssetGroupMetrics_Type] AS TABLE
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(IGNORE_DUP_KEY = OFF)
        );
END;
GO

PRINT N'Creating [dbo].[Add_AssetGroupMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_AssetGroupMetrics_Tvp] @table [dbo].[AssetGroupMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_AssetGroupMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Count] = (Target.[Count] + Source.[Count])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Count],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Count],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_AssetMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_AssetMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_AssetMetrics]
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_AssetMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO

PRINT N'Dropping [dbo].[Add_AssetMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_AssetMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_AssetMetrics_Tvp];
END; 
GO

PRINT N'Dropping [dbo].[AssetMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[AssetMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[AssetMetrics_Type];
END;
GO

PRINT N'Creating [dbo].[AssetMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[AssetMetrics_Type]') IS NULL)
    BEGIN
        CREATE TYPE [dbo].[AssetMetrics_Type] AS TABLE
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(IGNORE_DUP_KEY = OFF)
        );
END;
GO

PRINT N'Creating [dbo].[Add_AssetMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_AssetMetrics_Tvp] @table [dbo].[AssetMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_AssetMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Count] = (Target.[Count] + Source.[Count])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Count],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Count],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_DownloadEventMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_DownloadEventMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_DownloadEventMetrics]
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_DownloadEventMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO

PRINT N'Dropping [dbo].[Add_DownloadEventMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_DownloadEventMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_DownloadEventMetrics_Tvp];
END; 
GO

IF (TYPE_ID(N'[dbo].[DownloadEventMetrics_Type]') IS NOT NULL)
BEGIN
    DROP TYPE [dbo].[DownloadEventMetrics_Type]
END
GO

PRINT N'Creating [dbo].[DownloadEventMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[DownloadEventMetrics_Type]') IS NULL)
    BEGIN
        CREATE TYPE [dbo].[DownloadEventMetrics_Type] AS TABLE
        ([SegmentRecordId] [BIGINT] NOT NULL, 
         [SegmentId]       [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]            [SMALLDATETIME] NOT NULL, 
         [SiteNameId]      [INT] NOT NULL, 
         [DimensionKeyId]  [BIGINT] NOT NULL, 
         [Visits]          [INT] NOT NULL, 
         [Value]           [INT] NOT NULL, 
         [Count]           [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(IGNORE_DUP_KEY = OFF)
        );
END;
GO

PRINT N'Creating [dbo].[Add_DownloadEventMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_DownloadEventMetrics_Tvp] @table [dbo].[DownloadEventMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_DownloadEventMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Count] = (Target.[Count] + Source.[Count])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Count],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Count],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_ExitPageByUrlMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_ExitPageByUrlMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_ExitPageByUrlMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_ExitPageByUrlMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_ExitPageByUrlMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_ExitPageByUrlMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ExitPageByUrlMetrics_Tvp];
END;
GO
PRINT N'Dropping [dbo].[ExitPageByUrlMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[ExitPageByUrlMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ExitPageByUrlMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[ExitPageByUrlMetrics_Type]...';
GO
CREATE TYPE [dbo].[ExitPageByUrlMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [TimeOnPage]         [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER]
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_ExitPageByUrlMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_ExitPageByUrlMetrics_Tvp] @table [dbo].[ExitPageByUrlMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_ExitPageByUrlMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[TimeOnPage] = (Target.[TimeOnPage] + Source.[TimeOnPage]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [Pageviews], 
                         [TimeOnPage], 
                         [TimeOnSite], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[Pageviews], 
             Source.[TimeOnPage], 
             Source.[TimeOnSite], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_EntryPageByUrlMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_EntryPageByUrlMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_EntryPageByUrlMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_EntryPageByUrlMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_EntryPageByUrlMetrics_Tvp]...';
GO
IF(OBJECT_ID('[dbo].[Add_EntryPageByUrlMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_EntryPageByUrlMetrics_Tvp];
END; 
GO
PRINT N'Dropping [dbo].[EntryPageByUrlMetrics_Type]...';
GO
IF(TYPE_ID(N'[dbo].[EntryPageByUrlMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[EntryPageByUrlMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[EntryPageByUrlMetrics_Type]...';
GO
CREATE TYPE [dbo].[EntryPageByUrlMetrics_Type] AS TABLE
([SegmentRecordId]    [BIGINT] NOT NULL, 
 [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
 [Date]               [SMALLDATETIME] NOT NULL, 
 [SiteNameId]         [INT] NOT NULL, 
 [DimensionKeyId]     [BIGINT] NOT NULL, 
 [Visits]             [INT] NOT NULL, 
 [Value]              [INT] NOT NULL, 
 [Bounces]            [INT] NOT NULL, 
 [Conversions]        [INT] NOT NULL, 
 [Pageviews]          [INT] NOT NULL, 
 [TimeOnSite]         [INT] NOT NULL, 
 [TimeOnPage]         [INT] NOT NULL, 
 [MonetaryValue]      [MONEY] NOT NULL, 
 [OutcomeOccurrences] [INT] NOT NULL,
 [Converted]          [INT] NOT NULL,
 [FilterId] [UNIQUEIDENTIFIER]
 PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
 WITH(IGNORE_DUP_KEY = OFF)
);
GO
PRINT N'Creating [dbo].[Add_EntryPageByUrlMetrics_Tvp]...';
GO
CREATE PROCEDURE [dbo].[Add_EntryPageByUrlMetrics_Tvp] @table [dbo].[EntryPageByUrlMetrics_Type] READONLY
WITH EXECUTE AS OWNER
AS
    BEGIN
        SET NOCOUNT ON;
        BEGIN TRY
            MERGE [Fact_EntryPageByUrlMetrics] AS Target
            USING @table AS Source
            ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
                WHEN MATCHED
                THEN UPDATE SET 
                                Target.[Visits] = (Target.[Visits] + Source.[Visits]), 
                                Target.[Value] = (Target.[Value] + Source.[Value]), 
                                Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]), 
                                Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]), 
                                Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]), 
                                Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]), 
                                Target.[TimeOnPage] = (Target.[TimeOnPage] + Source.[TimeOnPage]), 
                                Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]), 
                                Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
                                Target.[Converted] = (Target.[Converted] + Source.[Converted])
                WHEN NOT MATCHED
                THEN
                  INSERT([SegmentRecordId], 
                         [SegmentId], 
                         [Date], 
                         [SiteNameId], 
                         [DimensionKeyId], 
                         [Visits], 
                         [Value], 
                         [Bounces], 
                         [Conversions], 
                         [Pageviews], 
                         [TimeOnPage], 
                         [TimeOnSite], 
                         [MonetaryValue], 
                         [OutcomeOccurrences],
                         [Converted],
                         [FilterId])
                  VALUES
            (Source.[SegmentRecordId], 
             Source.[SegmentId], 
             Source.[Date], 
             Source.[SiteNameId], 
             Source.[DimensionKeyId], 
             Source.[Visits], 
             Source.[Value], 
             Source.[Bounces], 
             Source.[Conversions], 
             Source.[Pageviews], 
             Source.[TimeOnPage], 
             Source.[TimeOnSite], 
             Source.[MonetaryValue], 
             Source.[OutcomeOccurrences],
             Source.[Converted],
             Source.[FilterId]);
        END TRY
        BEGIN CATCH
            DECLARE @error_number INTEGER= ERROR_NUMBER();
            DECLARE @error_severity INTEGER= ERROR_SEVERITY();
            DECLARE @error_state INTEGER= ERROR_STATE();
            DECLARE @error_message NVARCHAR(4000)= ERROR_MESSAGE();
            DECLARE @error_procedure SYSNAME= ERROR_PROCEDURE();
            DECLARE @error_line INTEGER= ERROR_LINE();
            RAISERROR(N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message) WITH NOWAIT;
        END CATCH;
    END;
GO


PRINT N'Creating [dbo].[Fact_PageByUrlMetrics]...';
GO
IF(OBJECT_ID('[dbo].[Fact_PageByUrlMetrics]', 'U') IS NULL)
    BEGIN
        CREATE TABLE [dbo].[Fact_PageByUrlMetrics]
        ([SegmentRecordId]    [BIGINT] NOT NULL, 
         [SegmentId]          [UNIQUEIDENTIFIER] NOT NULL, 
         [Date]               [SMALLDATETIME] NOT NULL, 
         [SiteNameId]         [INT] NOT NULL, 
         [DimensionKeyId]     [BIGINT] NOT NULL, 
         [Visits]             [INT] NOT NULL, 
         [Value]              [INT] NOT NULL, 
         [Bounces]            [INT] NOT NULL, 
         [Conversions]        [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL, 
         [Converted]          [INT] NOT NULL,
		 [FilterId] [UNIQUEIDENTIFIER],
         [FirstImpressionCount]    [INT] NOT NULL, 
         CONSTRAINT [PK_Fact_PageByUrlMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
GO


PRINT N'Dropping [dbo].[Add_PageByUrlMetrics_Tvp]...';
GO
IF (OBJECT_ID('[dbo].[Add_PageByUrlMetrics_Tvp]', 'P') IS NOT NULL)
Begin 
	DROP PROCEDURE [dbo].[Add_PageByUrlMetrics_Tvp]
End 
GO
PRINT N'Dropping [dbo].[PageByUrlMetrics_Type]...';
GO
IF (TYPE_ID(N'[dbo].[PageByUrlMetrics_Type]') IS NOT NULL)
BEGIN
		  DROP TYPE [dbo].[PageByUrlMetrics_Type]
END
GO
PRINT N'Creating [dbo].[PageByUrlMetrics_Type]...';
GO
      CREATE TYPE [dbo].[PageByUrlMetrics_Type] AS TABLE(
			[SegmentRecordId] [bigint] NOT NULL,
			[SegmentId] [uniqueidentifier] NOT NULL,
			[Date] [smalldatetime] NOT NULL,
			[SiteNameId] [int] NOT NULL,
			[DimensionKeyId] [bigint] NOT NULL,
			[Visits] [int] NOT NULL,
			[Value] [int] NOT NULL,
			[Bounces] [int] NOT NULL,
			[Conversions] [int] NOT NULL,
			[Pageviews] [int] NOT NULL,
			[TimeOnSite] [int] NOT NULL,
			[TimeOnPage] [int] NOT NULL,
			[MonetaryValue] [money] NOT NULL,
			[OutcomeOccurrences] [int] NOT NULL,
			[Converted] [int] NOT NULL,
			[FilterId] [UNIQUEIDENTIFIER],
			[FirstImpressionCount] [int] NOT NULL,
			
      
		 PRIMARY KEY CLUSTERED
		( [SegmentRecordId] ASC ) WITH (IGNORE_DUP_KEY = OFF)
		)
GO
PRINT N'Creating [dbo].[Add_PageByUrlMetrics_Tvp]...';
GO
	CREATE PROCEDURE [dbo].[Add_PageByUrlMetrics_Tvp]
	@table [dbo].[PageByUrlMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			MERGE [Fact_PageByUrlMetrics] AS Target USING @table AS Source
			ON
			Target.[SegmentRecordId] = Source.[SegmentRecordId]
			WHEN MATCHED THEN
			UPDATE SET
				Target.[Visits] = (Target.[Visits] + Source.[Visits]),
				Target.[Value] = (Target.[Value] + Source.[Value]),
				Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]),
				Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
				Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]),
				Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
				Target.[TimeOnPage] = (Target.[TimeOnPage] + Source.[TimeOnPage]),
				Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]),
				Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
				Target.[Converted] = (Target.[Converted] + Source.[Converted]),
        Target.[FirstImpressionCount] = (Target.[FirstImpressionCount] + Source.[FirstImpressionCount])
			WHEN NOT MATCHED THEN
			INSERT ([SegmentRecordId],
	     [SegmentId],
	     [Date],
	     [SiteNameId],
	     [DimensionKeyId],
	     [Visits],
	     [Value],
	     [Bounces],
	     [Conversions],
	     [Pageviews],
       [TimeOnPage],
       [TimeOnSite],
		   [MonetaryValue],
		   [OutcomeOccurrences],
     	   [Converted],
		   [FilterId],
		   [FirstImpressionCount])       
	     Values (Source.[SegmentRecordId],
	     Source.[SegmentId],
	     Source.[Date],
	     Source.[SiteNameId],
	     Source.[DimensionKeyId],
	     Source.[Visits],
	     Source.[Value],
	     Source.[Bounces],
	     Source.[Conversions],
	     Source.[Pageviews],
       Source.[TimeOnPage],
       Source.[TimeOnSite],
		   Source.[MonetaryValue],
		   Source.[OutcomeOccurrences],
		 Source.[Converted],
		 Source.[FilterId],
		 Source.[FirstImpressionCount]);       
		END TRY
		BEGIN CATCH
			DECLARE @error_number INTEGER = ERROR_NUMBER();
			DECLARE @error_severity INTEGER = ERROR_SEVERITY();
			DECLARE @error_state INTEGER = ERROR_STATE();
			DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
			DECLARE @error_line INTEGER = ERROR_LINE();
			RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
		END CATCH;
	END
GO


PRINT N'Dropping [dbo].[Add_CampaignFacetMetrics_Tvp]......';
GO
IF(OBJECT_ID('[dbo].[Add_CampaignFacetMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_CampaignFacetMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[CampaignFacetMetrics_Type]......';
GO
IF(TYPE_ID(N'[dbo].[CampaignFacetMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[CampaignFacetMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[CampaignFacetMetrics_Type]......';
GO
CREATE TYPE [dbo].[CampaignFacetMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[Visits] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[MonetaryValue] [money] NOT NULL,
	[Bounces] [int] NOT NULL,
	[Conversions] [int] NOT NULL,
	[Pageviews] [int] NOT NULL,
	[TimeOnSite] [int] NOT NULL,
	[Converted] [int] NOT NULL,
  [FilterId] [UNIQUEIDENTIFIER],
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	);
GO
PRINT N'Creating [dbo].[Add_CampaignFacetMetrics_Tvp]......';
GO
CREATE PROCEDURE [dbo].[Add_CampaignFacetMetrics_Tvp] @table [dbo].[CampaignFacetMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_CampaignFacetMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]),
					Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
					Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]),
					Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
					Target.[Converted] = (Target.[Converted] + Source.[Converted])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[Value],
					[MonetaryValue],
					[Bounces],
					[Conversions],
					[Pageviews],
					[TimeOnSite],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[Value],
					Source.[MonetaryValue],
					Source.[Bounces],
					Source.[Conversions],
					Source.[Pageviews],
					Source.[TimeOnSite],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N'Dropping [dbo].[Add_CampaignGroupMetrics_Tvp]......';
GO
IF(OBJECT_ID('[dbo].[Add_CampaignGroupMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_CampaignGroupMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[CampaignGroupMetrics_Type]......';
GO
IF(TYPE_ID(N'[dbo].[CampaignGroupMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[CampaignGroupMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[CampaignGroupMetrics_Type]......';
GO
CREATE TYPE [dbo].[CampaignGroupMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[Visits] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[MonetaryValue] [money] NOT NULL,
	[Bounces] [int] NOT NULL,
	[Conversions] [int] NOT NULL,
	[Pageviews] [int] NOT NULL,
	[TimeOnSite] [int] NOT NULL,
	[Converted] [int] NOT NULL,
  [FilterId] [UNIQUEIDENTIFIER],
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	)
GO
PRINT N'Creating [dbo].[Add_CampaignGroupMetrics_Tvp]......';
GO
CREATE PROCEDURE [dbo].[Add_CampaignGroupMetrics_Tvp] @table [dbo].[CampaignGroupMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_CampaignGroupMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]),
					Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
					Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]),
					Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
					Target.[Converted] = (Target.[Converted] + Source.[Converted])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[Value],
					[MonetaryValue],
					[Bounces],
					[Conversions],
					[Pageviews],
					[TimeOnSite],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[Value],
					Source.[MonetaryValue],
					Source.[Bounces],
					Source.[Conversions],
					Source.[Pageviews],
					Source.[TimeOnSite],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N'Dropping [dbo].[Add_ChannelTypeMetrics_Tvp]......';
GO
IF(OBJECT_ID('[dbo].[Add_ChannelTypeMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_ChannelTypeMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[ChannelTypeMetrics_Type]......';
GO
IF(TYPE_ID(N'[dbo].[ChannelTypeMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[ChannelTypeMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[ChannelTypeMetrics_Type]......';
GO
CREATE TYPE [dbo].[ChannelTypeMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[Visits] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[Bounces] [int] NOT NULL,
	[Conversions] [int] NOT NULL,
	[TimeOnSite] [int] NOT NULL,
	[Pageviews] [int] NOT NULL,
	[MonetaryValue] [money] NOT NULL,
	[OutcomeOccurrences] [int] NOT NULL,
	[Converted] [int] NOT NULL,
  [FilterId] [UNIQUEIDENTIFIER]
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	)
GO
PRINT N'Creating [dbo].[Add_ChannelTypeMetrics_Tvp]......';
GO
CREATE PROCEDURE [dbo].[Add_ChannelTypeMetrics_Tvp] @table [dbo].[ChannelTypeMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_ChannelTypeMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[Bounces] = (Target.[Bounces] + Source.[Bounces]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
					Target.[TimeOnSite] = (Target.[TimeOnSite] + Source.[TimeOnSite]),
					Target.[Pageviews] = (Target.[Pageviews] + Source.[Pageviews]),
					Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]),
					Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
					Target.[Converted] = (Target.[Converted] + Source.[Converted])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[Value],
					[Bounces],
					[Conversions],
					[TimeOnSite],
					[Pageviews],
					[MonetaryValue],
					[OutcomeOccurrences],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[Value],
					Source.[Bounces],
					Source.[Conversions],
					Source.[TimeOnSite],
					Source.[Pageviews],
					Source.[MonetaryValue],
					Source.[OutcomeOccurrences],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N'Dropping [dbo].[Add_GoalFacetGroupMetrics_Tvp]......';
GO
IF(OBJECT_ID('[dbo].[Add_GoalFacetGroupMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_GoalFacetGroupMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[GoalFacetGroupMetrics_Type]......';
GO
IF(TYPE_ID(N'[dbo].[GoalFacetGroupMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[GoalFacetGroupMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[GoalFacetGroupMetrics_Type]......';
GO
CREATE TYPE [dbo].[GoalFacetGroupMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[Visits] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Conversions] [int] NOT NULL,
	[Converted] [int] NOT NULL,
  [FilterId] [UNIQUEIDENTIFIER]
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	)
GO
PRINT N'Creating [dbo].[Add_GoalFacetGroupMetrics_Tvp]......';
GO
CREATE PROCEDURE [dbo].[Add_GoalFacetGroupMetrics_Tvp] @table [dbo].[GoalFacetGroupMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_GoalFacetGroupMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[Count] = (Target.[Count] + Source.[Count]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
					Target.[Converted] = (Target.[Converted] + Source.[Converted])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[Value],
					[Count],
					[Conversions],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[Value],
					Source.[Count],
					Source.[Conversions],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N'Dropping [dbo].[Add_GoalFacetMetrics_Tvp]......';
GO
IF(OBJECT_ID('[dbo].[Add_GoalFacetMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_GoalFacetMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[GoalFacetMetrics_Type]......';
GO
IF(TYPE_ID(N'[dbo].[GoalFacetMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[GoalFacetMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[GoalFacetMetrics_Type]......';
GO
CREATE TYPE [dbo].[GoalFacetMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[Visits] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Conversions] [int] NOT NULL,
	[Converted] [int] NOT NULL,
  [FilterId] [UNIQUEIDENTIFIER]
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	)
GO
PRINT N'Creating [dbo].[Add_GoalFacetMetrics_Tvp]......';
GO
CREATE PROCEDURE [dbo].[Add_GoalFacetMetrics_Tvp] @table [dbo].[GoalFacetMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_GoalFacetMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[Count] = (Target.[Count] + Source.[Count]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
					Target.[Converted] = (Target.[Converted] + Source.[Converted])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[Value],
					[Count],
					[Conversions],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[Value],
					Source.[Count],
					Source.[Conversions],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N'Dropping [dbo].[Add_OutcomeGroupMetrics_Tvp]......';
GO
IF(OBJECT_ID('[dbo].[Add_OutcomeGroupMetrics_Tvp]', 'P') IS NOT NULL)
    BEGIN
        DROP PROCEDURE [dbo].[Add_OutcomeGroupMetrics_Tvp];
END;
PRINT N'Dropping [dbo].[OutcomeGroupMetrics_Type]......';
GO
IF(TYPE_ID(N'[dbo].[OutcomeGroupMetrics_Type]') IS NOT NULL)
    BEGIN
        DROP TYPE [dbo].[OutcomeGroupMetrics_Type];
END;
GO
PRINT N'Creating [dbo].[OutcomeGroupMetrics_Type]......';
GO
CREATE TYPE [dbo].[OutcomeGroupMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[Visits] [int] NOT NULL,
	[MonetaryValue] [money] NOT NULL,
	[OutcomeOccurrences] [int] NOT NULL,
	[Value] [int] NOT NULL,
	[Conversions] [int] NOT NULL,
	[Converted] [int] NOT NULL,
  [FilterId] [UNIQUEIDENTIFIER]
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	)
GO
PRINT N'Creating [dbo].[Add_OutcomeGroupMetrics_Tvp]......';
GO
CREATE PROCEDURE [dbo].[Add_OutcomeGroupMetrics_Tvp] @table [dbo].[OutcomeGroupMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_OutcomeGroupMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Visits] = (Target.[Visits] + Source.[Visits]),
					Target.[MonetaryValue] = (Target.[MonetaryValue] + Source.[MonetaryValue]),
					Target.[OutcomeOccurrences] = (Target.[OutcomeOccurrences] + Source.[OutcomeOccurrences]),
					Target.[Value] = (Target.[Value] + Source.[Value]),
					Target.[Conversions] = (Target.[Conversions] + Source.[Conversions]),
					Target.[Converted] = (Target.[Converted] + Source.[Converted])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[Visits],
					[MonetaryValue],
					[OutcomeOccurrences],
					[Value],
					[Conversions],
					[Converted],
          [FilterId]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[Visits],
					Source.[MonetaryValue],
					Source.[OutcomeOccurrences],
					Source.[Value],
					Source.[Conversions],
					Source.[Converted],
          Source.[FilterId]);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO


PRINT N' Dropping [ReportDataView]......';
GO
DROP VIEW [dbo].[ReportDataView]
GO
PRINT N' Creating [ReportDataView]......';
GO
CREATE VIEW [dbo].[ReportDataView] AS
SELECT        dbo.Fact_SegmentMetrics.SegmentRecordId, dbo.Fact_SegmentMetrics.ContactTransitionType, dbo.Fact_SegmentMetrics.Visits, dbo.Fact_SegmentMetrics.Value, dbo.Fact_SegmentMetrics.Bounces, 
                         dbo.Fact_SegmentMetrics.Conversions, CAST(dbo.Fact_SegmentMetrics.TimeOnSite AS [BigInt]) AS TimeOnSite, dbo.Fact_SegmentMetrics.Pageviews, dbo.Fact_SegmentMetrics.Count, 
                         dbo.SegmentRecords.SegmentId, dbo.SegmentRecords.Date, dbo.SegmentRecords.SiteNameId, dbo.SegmentRecords.DimensionKeyId, dbo.DimensionKeys.DimensionKey, dbo.Fact_SegmentMetrics.Converted
FROM            dbo.Fact_SegmentMetrics INNER JOIN
                         dbo.SegmentRecords ON dbo.Fact_SegmentMetrics.SegmentRecordId = dbo.SegmentRecords.SegmentRecordId INNER JOIN
                         dbo.DimensionKeys ON dbo.SegmentRecords.DimensionKeyId = dbo.DimensionKeys.DimensionKeyId
UNION 
SELECT        dbo.Fact_SegmentMetricsReduced.SegmentRecordId, dbo.Fact_SegmentMetricsReduced.ContactTransitionType, dbo.Fact_SegmentMetricsReduced.Visits, dbo.Fact_SegmentMetricsReduced.Value, dbo.Fact_SegmentMetricsReduced.Bounces, 
                         dbo.Fact_SegmentMetricsReduced.Conversions, CAST(dbo.Fact_SegmentMetricsReduced.TimeOnSite AS [BigInt]) AS TimeOnSite, dbo.Fact_SegmentMetricsReduced.Pageviews, dbo.Fact_SegmentMetricsReduced.Count, 
                         dbo.SegmentRecordsReduced.SegmentId, dbo.SegmentRecordsReduced.Date, dbo.SegmentRecordsReduced.SiteNameId, dbo.SegmentRecordsReduced.DimensionKeyId, dbo.DimensionKeys.DimensionKey, dbo.Fact_SegmentMetricsReduced.Converted
FROM            dbo.Fact_SegmentMetricsReduced INNER JOIN
                         dbo.SegmentRecordsReduced ON dbo.Fact_SegmentMetricsReduced.SegmentRecordId = dbo.SegmentRecordsReduced.SegmentRecordId INNER JOIN
                         dbo.DimensionKeys ON dbo.SegmentRecordsReduced.DimensionKeyId = dbo.DimensionKeys.DimensionKeyId
GO


PRINT N' Updating [IX_Fact_SegmentMetrics_All_Columns]......';
GO
    CREATE NONCLUSTERED INDEX [IX_Fact_SegmentMetrics_All_Columns] ON [dbo].Fact_SegmentMetrics (
		[SegmentRecordId] ASC,
		[ContactTransitionType] ASC,
		[Visits] ASC,
		[Value] ASC,
		[Bounces] ASC,
		[Conversions] ASC,
		[TimeOnSite] ASC,
		[Pageviews] ASC,
		[Count] ASC,
		[Converted] ASC
		)
		WITH (
				SORT_IN_TEMPDB = OFF,
				DROP_EXISTING = ON,
				ONLINE = OFF
				) ON [PRIMARY]
GO


PRINT N' Updating [IX_Fact_SegmentMetricsReduced_All_Columns]......';
GO
	CREATE NONCLUSTERED INDEX [IX_Fact_SegmentMetricsReduced_All_Columns] ON [dbo].Fact_SegmentMetricsReduced (
		[SegmentRecordId] ASC,
		[ContactTransitionType] ASC,
		[Visits] ASC,
		[Value] ASC,
		[Bounces] ASC,
		[Conversions] ASC,
		[TimeOnSite] ASC,
		[Pageviews] ASC,
		[Count] ASC,
		[Converted] ASC
		)
		WITH (
				SORT_IN_TEMPDB = OFF,
				DROP_EXISTING = ON,
				ONLINE = OFF
				) ON [PRIMARY]

GO

IF (
		EXISTS (
			SELECT *
			FROM INFORMATION_SCHEMA.ROUTINES
			WHERE ROUTINE_SCHEMA = 'dbo'
				AND ROUTINE_NAME = 'Add_SystemMetrics_Tvp'
			)
		)
	DROP PROCEDURE [dbo].[Add_SystemMetrics_Tvp]

GO

IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[Ensure_FilterIdExists_In_Segment]')
			AND type IN (N'P', N'PC')
		)
	DROP PROCEDURE [dbo].Ensure_FilterIdExists_In_Segment  

GO

IF (
		EXISTS (
			SELECT *
			FROM sys.types
			WHERE name = 'SegmentFilterId_Type'
			)
		)
	DROP TYPE [dbo].SegmentFilterId_Type;

GO	

IF (
		EXISTS (
			SELECT *
			FROM sys.types
			WHERE name = 'SystemMetrics_Type'
			)
		)
	DROP TYPE [dbo].SystemMetrics_Type;	
  
GO

IF (
		NOT EXISTS (
			SELECT *
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_SCHEMA = 'dbo'
				AND TABLE_NAME = 'Fact_SystemMetrics'
			)
		)
BEGIN
	CREATE TABLE [dbo].[Fact_SystemMetrics] (		
		[SegmentRecordId] [bigint] NOT NULL,
		[SegmentId] [uniqueidentifier] NOT NULL,
		[Date] [smalldatetime] NOT NULL,
		[SiteNameId] [int] NOT NULL,
		[DimensionKeyId] [bigint] NOT NULL,
		[FilterId] [uniqueidentifier],
		[TotalVisits] [int] NOT NULL,
		[TotalEngagementValue] [int] NOT NULL,
		[TotalTimeOnSite] [int] NOT NULL,
		[TotalPageviews] [int] NOT NULL,
		CONSTRAINT [PK_Fact_SystemMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (
			PAD_INDEX = OFF,
			STATISTICS_NORECOMPUTE = OFF,
			IGNORE_DUP_KEY = OFF,
			ALLOW_ROW_LOCKS = ON,
			ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
		) ON [PRIMARY]
END

GO

IF (
		NOT EXISTS (
			SELECT *
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_SCHEMA = 'dbo'
				AND TABLE_NAME = 'Fact_SystemMetrics'
			)
		)
BEGIN
	CREATE TABLE [dbo].[Fact_SystemMetrics] (		
		[SegmentRecordId] [bigint] NOT NULL,
		[SegmentId] [uniqueidentifier] NOT NULL,
		[Date] [smalldatetime] NOT NULL,
		[SiteNameId] [int] NOT NULL,
		[DimensionKeyId] [bigint] NOT NULL,
		[FilterId] [uniqueidentifier],
		[TotalVisits] [int] NOT NULL,
		[TotalEngagementValue] [int] NOT NULL,
		[TotalTimeOnSite] [int] NOT NULL,
		[TotalPageviews] [int] NOT NULL,
		CONSTRAINT [PK_Fact_SystemMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (
			PAD_INDEX = OFF,
			STATISTICS_NORECOMPUTE = OFF,
			IGNORE_DUP_KEY = OFF,
			ALLOW_ROW_LOCKS = ON,
			ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
		) ON [PRIMARY]
END

CREATE TYPE [dbo].[SystemMetrics_Type] AS TABLE (
	[SegmentRecordId] [bigint] NOT NULL,
	[SegmentId] [uniqueidentifier] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SiteNameId] [int] NOT NULL,
	[DimensionKeyId] [bigint] NOT NULL,
	[FilterId] [uniqueidentifier],
	[TotalVisits] [int] NOT NULL,
	[TotalEngagementValue] [int] NOT NULL,
	[TotalTimeOnSite] [int] NOT NULL,
	[TotalPageviews] [int] NOT NULL,
	PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC) WITH (IGNORE_DUP_KEY = OFF)
	)
GO

CREATE PROCEDURE [dbo].[Add_SystemMetrics_Tvp] @table [dbo].[SystemMetrics_Type] READONLY
	WITH EXECUTE AS OWNER
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		MERGE [Fact_SystemMetrics] AS Target
		USING @table AS Source
			ON Target.[SegmentRecordId] = Source.[SegmentRecordId]
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[TotalVisits] = (Target.[TotalVisits] + Source.[TotalVisits]),
					Target.[TotalEngagementValue] = (Target.[TotalEngagementValue] + Source.[TotalEngagementValue]),
					Target.[TotalTimeOnSite] = (Target.[TotalTimeOnSite] + Source.[TotalTimeOnSite]),
					Target.[TotalPageviews] = (Target.[TotalPageviews] + Source.[TotalPageviews])
		WHEN NOT MATCHED
			THEN
				INSERT (
					[SegmentRecordId],
					[SegmentId],
					[Date],
					[SiteNameId],
					[DimensionKeyId],
					[FilterId],
					[TotalVisits],
					[TotalEngagementValue],
					[TotalTimeOnSite],
					[TotalPageviews]
					)
				VALUES (
					Source.[SegmentRecordId],
					Source.[SegmentId],
					Source.[Date],
					Source.[SiteNameId],
					Source.[DimensionKeyId],
					Source.[FilterId],					
					Source.[TotalVisits],
					Source.[TotalEngagementValue],
					Source.[TotalTimeOnSite],
					Source.[TotalPageviews]
					);
	END TRY

	BEGIN CATCH
		DECLARE @error_number INTEGER = ERROR_NUMBER();
		DECLARE @error_severity INTEGER = ERROR_SEVERITY();
		DECLARE @error_state INTEGER = ERROR_STATE();
		DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
		DECLARE @error_line INTEGER = ERROR_LINE();

		RAISERROR (
				N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s',
				@error_severity,
				1,
				@error_number,
				@error_severity,
				@error_state,
				@error_procedure,
				@error_line,
				@error_message
				)
		WITH NOWAIT;
	END CATCH;
END
GO

CREATE TYPE [dbo].[SegmentFilterId_Type] AS TABLE(
	[SegmentId] [uniqueidentifier] NOT NULL,
	[FilterId] [uniqueidentifier] NOT NULL
	PRIMARY KEY CLUSTERED 
(
	[SegmentId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

CREATE PROCEDURE [dbo].[Ensure_FilterIdExists_In_Segment]
  @TableName SYSNAME,
  @SegmentFilterIdTable [SegmentFilterId_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;

  IF NOT EXISTS (
			SELECT TABLE_NAME
			FROM INFORMATION_SCHEMA.TABLES
			WHERE TABLE_NAME = @TableName
			)
	BEGIN
		DECLARE @errorMsg VARCHAR(MAX);

		SET @errorMsg = 'Invalid table name ''' + @TableName + '''';

		RAISERROR (
				@errorMsg,
				16,
				1
				);

		RETURN;
	END;
  DECLARE @sql NVARCHAR(MAX);

  BEGIN TRY
	DECLARE @count INT;
	SET @sql = 'SELECT @count = COUNT (*) FROM' + QUOTENAME(@TableName) + ' WHERE SegmentId 
				IN 
				(SELECT SegmentId FROM @SegmentFilterIdTable)
				AND [FilterId] IS NULL';

	EXECUTE sp_executesql @sql,
			N'@SegmentFilterIdTable [SegmentFilterId_Type] READONLY, @count int OUT',
			@SegmentFilterIdTable = @SegmentFilterIdTable,
			@count = @count OUTPUT;

	IF @count > 0
		BEGIN
			SET @sql = 'UPDATE fact
						SET fact.FilterId = sf.FilterId
						FROM '+ QUOTENAME(@TableName) +' fact
						INNER JOIN @SegmentFilterIdTable sf ON fact.SegmentId = sf.SegmentId';
			EXECUTE sp_executesql @sql,
			N'@SegmentFilterIdTable [dbo].[SegmentFilterId_Type] READONLY',
			@SegmentFilterIdTable = @SegmentFilterIdTable;
		END;

  END TRY
  BEGIN CATCH

    IF( @@ERROR != 2627 )
    BEGIN

      DECLARE @error_number INTEGER = ERROR_NUMBER();
      DECLARE @error_severity INTEGER = ERROR_SEVERITY();
      DECLARE @error_state INTEGER = ERROR_STATE();
      DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
      DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
      DECLARE @error_line INTEGER = ERROR_LINE();

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END

  END CATCH

END
GO


PRINT N' XA Update complete.';
GO

PRINT N' Path Analyzer Update Started.';
GO

DELETE FROM [dbo].[TreeDefinitions] WHERE DefinitionId IN ('E049AD86-D98B-4639-A450-77D1B294A270','D57B53BE-CD98-4EC4-9767-C99F8A72EC0A','F2C21FD3-22C5-4F32-92AC-443984D06FC7','4118EA73-7CEE-4FBC-AECE-5693171744C7')
GO

PRINT N' Path Analyzer Update complete.';
GO

PRINT N'Forms Update started';

GO
PRINT N'Creating [dbo].[Fact_FormFieldMetrics]...';

GO

IF (OBJECT_ID('[dbo].[Fact_FormFieldMetrics]', 'U') IS NULL)
BEGIN
CREATE TABLE [dbo].[Fact_FormFieldMetrics] (
    [FormId]               UNIQUEIDENTIFIER NOT NULL,
    [FieldId]              UNIQUEIDENTIFIER NOT NULL,
    [InteractionId]        UNIQUEIDENTIFIER NOT NULL,
    [InteractionStartDate] SMALLDATETIME    NOT NULL,
    [Completed]            INT              NOT NULL,
    [Errors]               INT              NOT NULL,
    [AverageTime]          FLOAT            NOT NULL,
    [Dropouts]             INT              NOT NULL,
    [ErrorRate]            FLOAT            NOT NULL,
    [Visits]               INT              NOT NULL,
    CONSTRAINT [PK_Fact_FormFieldMetrics] PRIMARY KEY CLUSTERED ([FormId] ASC, [FieldId] ASC, [InteractionId] ASC, [InteractionStartDate] ASC)
);
END
GO
PRINT N'Creating [dbo].[Fact_FormMetrics]...';

GO
IF (OBJECT_ID('[dbo].[Fact_FormMetrics]', 'U') IS NULL)
BEGIN
CREATE TABLE [dbo].[Fact_FormMetrics] (
    [ContactId]            UNIQUEIDENTIFIER NOT NULL,
    [InteractionId]        UNIQUEIDENTIFIER NOT NULL,
    [InteractionStartDate] SMALLDATETIME    NOT NULL,
    [FormId]               UNIQUEIDENTIFIER NOT NULL,
    [Success]              INT              NOT NULL,
    [Submits]              INT              NOT NULL,
    [Errors]               INT              NOT NULL,
    [Dropouts]             INT              NOT NULL,
    [Visits]               INT              NOT NULL,
    CONSTRAINT [PK_FormMetrics] PRIMARY KEY CLUSTERED ([ContactId] ASC, [InteractionId] ASC, [InteractionStartDate] ASC, [FormId] ASC)
);
END
GO
PRINT N'Creating [dbo].[FormFieldNames]...';

GO
IF (OBJECT_ID('[dbo].[FormFieldNames]', 'U') IS NULL)
BEGIN
CREATE TABLE [dbo].[FormFieldNames](
    [FieldId]            UNIQUEIDENTIFIER NOT NULL,
    [FieldName]          [nvarchar](100)  NOT NULL,
    CONSTRAINT [PK_FormFieldNames] PRIMARY KEY CLUSTERED ([FieldId] ASC)
);
END
GO
PRINT N'Forms Update complete.';

GO
PRINT N'Fact_PageViews Update started';

GO
IF (OBJECT_ID('[dbo].[PK_PageViews]', 'PK') IS NOT NULL)
BEGIN

PRINT N'Altering [dbo].[Fact_PageViews]...';
ALTER TABLE [dbo].[Fact_PageViews] ALTER COLUMN [TestId] UNIQUEIDENTIFIER NOT NULL
ALTER TABLE [dbo].[Fact_PageViews] ALTER COLUMN [TestCombination] BINARY(16) NOT NULL

PRINT N'Dropping [dbo].[PK_PageViews]...';
ALTER TABLE [dbo].[Fact_PageViews] DROP CONSTRAINT [PK_PageViews];

END

GO
IF (OBJECT_ID('[dbo].[PK_PageViews]', 'PK') IS NULL)
BEGIN

PRINT N'Adding [dbo].[PK_PageViews]...';
ALTER TABLE [dbo].[Fact_PageViews] ADD CONSTRAINT [PK_PageViews] PRIMARY KEY CLUSTERED ([ItemId] ASC, [Date] ASC, [TestId] ASC, [TestCombination] ASC)
END

GO
PRINT N'Fact_PageViews Update complete';

GO

GO
PRINT N'Fact_TestConversions Update started';

GO
IF (OBJECT_ID('[dbo].[PK_Fact_TestConversions]', 'PK') IS NOT NULL)
BEGIN

PRINT N'Dropping [dbo].[PK_Fact_TestConversions]...';
ALTER TABLE [dbo].[Fact_TestConversions] DROP CONSTRAINT [PK_Fact_TestConversions];

END

GO

IF (OBJECT_ID('[dbo].[PK_Fact_TestConversions]', 'PK') IS NULL)
BEGIN

PRINT N'Adding [dbo].[PK_Fact_TestConversions]...';
ALTER TABLE [dbo].[Fact_TestConversions] ADD CONSTRAINT [PK_Fact_TestConversions] PRIMARY KEY CLUSTERED ([TestSetId] ASC, [TestValues] ASC, [GoalId] ASC, [Date] ASC)

END

GO

IF OBJECTPROPERTY(OBJECT_ID('[dbo].[FK_Fact_TestConversions_Date]'), 'IsConstraint') = 1

BEGIN

PRINT N'Dropping [dbo].[FK_Fact_TestConversions_Date]...';
ALTER TABLE [dbo].[Fact_TestConversions] DROP CONSTRAINT [FK_Fact_TestConversions_Date];

END

GO
PRINT N'Fact_TestConversions Update complete';

GO


PRINT N'Creating [dbo].[Accounts_Type]...';


GO
IF (TYPE_ID(N'[dbo].[Accounts_Type]') IS NULL)
BEGIN
CREATE TYPE [dbo].[Accounts_Type] AS TABLE (
    [AccountId]        UNIQUEIDENTIFIER NOT NULL,
    [BusinessName]     NVARCHAR (MAX)   NOT NULL,
    [Country]          NVARCHAR (MAX)   NOT NULL,
    [Classification]   INT              NOT NULL,
    [IntegrationId]    UNIQUEIDENTIFIER NULL,
    [IntegrationLabel] NVARCHAR (MAX)   NULL,
    [ExternalUser]     NVARCHAR (MAX)   NULL,
    PRIMARY KEY CLUSTERED ([AccountId] ASC));
END

GO
PRINT N'Creating [dbo].[Contacts_Type]...';


GO

IF (TYPE_ID(N'[dbo].[Contacts_Type]') IS NULL)
BEGIN
CREATE TYPE [dbo].[Contacts_Type] AS TABLE (
    [ContactId]              UNIQUEIDENTIFIER NOT NULL,
    [AuthenticationLevel]    INT              NOT NULL,
    [Classification]         INT              NOT NULL,
    [ContactTags]            XML              NULL,
    [IntegrationLevel]       INT              NOT NULL,
    [ExternalUser]           NVARCHAR (MAX)   NULL,
    [OverrideClassification] INT              NOT NULL,
    PRIMARY KEY CLUSTERED ([ContactId] ASC));
END

GO
PRINT N'Droping [dbo].[Add_PageViews_Tvp]...';


GO
IF (OBJECT_ID('[dbo].[Add_PageViews_Tvp]', 'P') IS NOT NULL)
BEGIN
	DROP PROCEDURE [dbo].[Add_PageViews_Tvp]
End 

GO
PRINT N'Droping [dbo].[PageViews_Type]...';


GO
IF (TYPE_ID(N'[dbo].[PageViews_Type]') IS NOT NULL)
BEGIN
	DROP TYPE [dbo].[PageViews_Type]
END

GO
PRINT N'Creating [dbo].[PageViews_Type]...';


GO
IF (TYPE_ID(N'[dbo].[PageViews_Type]') IS NULL)
BEGIN
CREATE TYPE [dbo].[PageViews_Type] AS TABLE (
    [Date]            SMALLDATETIME    NOT NULL,
    [ItemId]          UNIQUEIDENTIFIER NOT NULL,
    [Views]           BIGINT           NOT NULL,
    [Duration]        BIGINT           NOT NULL,
    [Visits]          BIGINT           NOT NULL,
    [Value]           BIGINT           NOT NULL,
    [TestId]          UNIQUEIDENTIFIER NULL,
    [TestCombination] BINARY (16)      NULL,
    PRIMARY KEY CLUSTERED ([ItemId] ASC, [Date] ASC));
END

GO


PRINT N'Creating [dbo].[Add_PageViews_Tvp]...';


GO
-- This SP is not used by default for Fact_PageViews table, because it is possible to get PrimaryKey violation. The PK (consists of [ItemId], [Date], [ContactId]) is not unique enough to distinguish rows in the same batch. Date column represents smalldatetime column. It is possible to have PageView from the same contact to the same Item within the same minute.
CREATE PROCEDURE [dbo].[Add_PageViews_Tvp]
    @table [PageViews_Type] READONLY
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
        [Fact_PageViews] WITH (HOLDLOCK) AS [target]
  USING
    @table AS [source] ON
        (
            ([target].[ItemId] = [source].[ItemId]) AND
            ([target].[Date] = [source].[Date])
        )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Views] = ([target].[Views] + [source].[Views]),
        [target].[Duration] = ([target].[Duration] + [source].[Duration]),
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [ItemId],
        [TestId],
        [TestCombination],
      [Views],
      [Duration],
      [Visits],
      [Value]
    )
    VALUES
    (
      [source].[Date],
      [source].[ItemId],
        [source].[TestId],
        [source].[TestCombination],
      [source].[Views],
      [source].[Duration],
      [source].[Visits],
      [source].[Value]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;
GO
PRINT N'Creating [dbo].[Ensure_Accounts_Tvp]...';


GO

IF (OBJECT_ID('[Ensure_Accounts_Tvp]', 'P') IS NOT NULL)
Begin 
	DROP PROCEDURE [Ensure_Accounts_Tvp]
End 

GO
CREATE PROCEDURE [Ensure_Accounts_Tvp]
  @table [Accounts_Type] READONLY
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Accounts] WITH (HOLDLOCK) AS [target]
  USING
    @table AS [source] ON
    (
      ([target].[AccountId] = [source].[AccountId])
    )

  WHEN MATCHED THEN
    UPDATE
      SET
        -- If we use non TVP SP, it silently truncates data in the parameters. We truncate data in TVP to ensure that data continues to be truncated (due to backwards compatibility) and no errors generated. 
        [target].[BusinessName] = CAST([source].[BusinessName] AS NVARCHAR(100)), 
        [target].[Country] = CAST([source].[Country] AS NVARCHAR(100)),
        [target].[Classification] = [source].[Classification],
        [target].[IntegrationId] = [source].[IntegrationId],
        [target].[IntegrationLabel] = CAST([source].[IntegrationLabel] AS NVARCHAR(100)),
        [target].[ExternalUser] = CAST([source].[ExternalUser] AS NVARCHAR(256))

  WHEN NOT MATCHED THEN
    INSERT
    (
      [AccountId],
      [BusinessName],
      [Country],
      [Classification],
      [IntegrationId],
      [IntegrationLabel],
      [ExternalUser]
    )
    VALUES
    (
      [source].[AccountId],
      CAST([source].[BusinessName] AS NVARCHAR(100)),
      CAST([source].[Country] AS NVARCHAR(100)),
      [source].[Classification],
      [source].[IntegrationId],
      CAST([source].[IntegrationLabel] AS NVARCHAR(100)),
      CAST([source].[ExternalUser] AS NVARCHAR(256))
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;
GO
PRINT N'Creating [dbo].[Ensure_Contacts_Tvp]...';


GO

IF (OBJECT_ID('[Ensure_Contacts_Tvp]', 'P') IS NOT NULL)
Begin 
	DROP PROCEDURE [Ensure_Contacts_Tvp]
End 

GO

CREATE PROCEDURE [Ensure_Contacts_Tvp]
  @table [Contacts_Type] READONLY
AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

  MERGE
    [Contacts] WITH (HOLDLOCK) AS [target]
  USING
    @table AS [source] ON
    (
      ([target].[ContactId] = [source].[ContactId])
    )

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[AuthenticationLevel] = [source].[AuthenticationLevel],
        [target].[Classification] = [source].[Classification],
        [target].[ContactTags] = [source].[ContactTags],
        [target].[IntegrationLevel] = [source].[IntegrationLevel],
        -- If we use non TVP SP, it silently truncates data in the parameters. We truncate data in TVP to ensure that data continues to be truncated (due to backwards compatibility) and no errors generated. 
        [target].[ExternalUser] = CAST([source].[ExternalUser] AS NVARCHAR(100)), 
        [target].[OverrideClassification] = [source].[OverrideClassification]

  WHEN NOT MATCHED THEN
    INSERT
    (
      [ContactId],
      [AuthenticationLevel],
      [Classification],
      [ContactTags],
      [IntegrationLevel],
      [ExternalUser],
      [OverrideClassification]
    )
    VALUES
    (
      [source].[ContactId],
      [source].[AuthenticationLevel],
      [source].[Classification],
      [source].[ContactTags],
      [source].[IntegrationLevel],
      CAST([source].[ExternalUser] AS NVARCHAR(100)),
      [source].[OverrideClassification]
    );

  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  
  END CATCH;

END;
GO

-- xOptimization
PRINT N'xOptimization component upgrade started.'
BEGIN
	IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Fact_PersonalizationRule'))
	BEGIN
		CREATE TABLE [dbo].[Fact_PersonalizationRule](
			[Id] BIGINT IDENTITY(1,1) NOT NULL,
			[DateTime] DATETIME NOT NULL,
			[LastUpdatedOn] DATETIME NULL,
			[RuleId] UNIQUEIDENTIFIER NOT NULL,
			[PredictionInfo] NVARCHAR(MAX) NOT NULL,
			[IsActive] BIT NOT NULL,
			[RuleFeatureId] BIGINT NOT NULL,
			[TestMetadataId] BIGINT NOT NULL
			CONSTRAINT [PK_Fact_PersonalizationRule] PRIMARY KEY CLUSTERED ([Id] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
			ON [PRIMARY]) ON [PRIMARY]

			PRINT N'The table Fact_PersonalizationRule is added.'
		END
	ELSE
		PRINT N'The table Fact_PersonalizationRule already present.'
END

BEGIN
	IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Dimension_TestMetadata'))
	BEGIN
		CREATE TABLE [dbo].[Dimension_TestMetadata](
			[Id] BIGINT NOT NULL,
			[DimensionKey] NVARCHAR(MAX) NOT NULL,
			[TestCombination] BINARY(16) NOT NULL
			CONSTRAINT [PK_Dimension_TestMetadata] PRIMARY KEY CLUSTERED ([Id] ASC) 
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
			ON [PRIMARY]) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

			PRINT N'The table Dimension_TestMetadata is added.'
		END
	ELSE
		PRINT N'The table Dimension_TestMetadata already present.'
END

BEGIN
	IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Dimension_RuleFeature'))
	BEGIN
		CREATE TABLE [dbo].[Dimension_RuleFeature](
			[Id] BIGINT NOT NULL,
			[DimensionKey] NVARCHAR(100) NOT NULL,
			[FeatureName] NVARCHAR(100) NOT NULL,
			[FeatureValues] NVARCHAR(MAX) NOT NULL,
			[Operator] NVARCHAR(50) NOT NULL,
			CONSTRAINT [PK_Dimension_RuleFeature] PRIMARY KEY CLUSTERED ([Id] ASC)
			WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
			ON [PRIMARY]) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

			PRINT N'The table Dimension_RuleFeature is added.'
		END
	ELSE
		PRINT N'The table Dimension_RuleFeature already present.'
END
GO
-- STORED PROCEDURES
-- Update the store procedure: Add_RulesExposure_Tvp
IF type_id('[dbo].[RulesExposure_Type]') IS NULL
BEGIN

	CREATE TYPE [dbo].[RulesExposure_Type] AS TABLE (
		[Date] [datetime] NULL,
		[ItemId] [uniqueidentifier] NOT NULL,
		[RuleSetId] [uniqueidentifier] NOT NULL,
		[RuleId] [uniqueidentifier] NOT NULL,
		[Visits] [bigint] NOT NULL,
		[Visitors] [bigint] NOT NULL
	)
END

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Add_RulesExposure_Tvp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	BEGIN
		DROP PROCEDURE [dbo].[Add_RulesExposure_Tvp]
	END

	GO
	CREATE PROCEDURE [dbo].[Add_RulesExposure_Tvp]
		@table [dbo].[RulesExposure_Type] READONLY
		WITH EXECUTE AS OWNER
		AS
		BEGIN
			SET NOCOUNT ON;
			BEGIN TRY
				MERGE [Fact_RulesExposure] AS TARGET 
				USING(
					SELECT 
					[Date]
					,[ItemId]
					,[RuleSetId]
					,[RuleId],SUM([Visits]) as [Visits]
					,SUM([Visitors]) as [Visitors]
				FROM @table
					GROUP BY [Date],[ItemId],[RuleSetId],[RuleId])
				AS SOURCE
				ON
					(TARGET.[Date] = SOURCE.[Date]) AND
					(TARGET.[ItemId] = SOURCE.[ItemId]) AND
					(TARGET.[RuleSetId] = SOURCE.[RuleSetId]) AND
					(TARGET.[RuleId] = SOURCE.[RuleId]) 

				WHEN MATCHED THEN
					UPDATE	
					SET
					TARGET.[Visits] = (TARGET.[Visits] + SOURCE.[Visits]),
					TARGET.[Visitors] = (TARGET.[Visitors] + SOURCE.[Visitors])
				WHEN NOT MATCHED THEN
					INSERT ([Date],
							[ItemId],
							[RuleSetId],
							[RuleId],
							[Visits],
							[Visitors])
					VALUES (SOURCE.[Date],
							SOURCE.[ItemId],
							SOURCE.[RuleSetId],
							SOURCE.[RuleId],
							SOURCE.[Visits],
							SOURCE.[Visitors]);
			END TRY
			BEGIN CATCH
				DECLARE @error_number INTEGER = ERROR_NUMBER();
				DECLARE @error_severity INTEGER = ERROR_SEVERITY();
				DECLARE @error_state INTEGER = ERROR_STATE();
				DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
				DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
				DECLARE @error_line INTEGER = ERROR_LINE();
				RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
			END CATCH;
	END

GO

PRINT N'The stored procedure [Add_RulesExposure_Tvp] is updated.';

-- Update the store procedure: Add_PersonalizationRule
IF type_id('[dbo].[PersonalizationRule_Type]') IS NULL
BEGIN

	CREATE TYPE [dbo].[PersonalizationRule_Type] AS TABLE (
		[Id] BIGINT NOT NULL,
		[DateTime] DATETIME NOT NULL,
		[LastUpdatedOn] DATETIME NULL,
		[RuleId] UNIQUEIDENTIFIER NOT NULL,
		[PredictionInfo] NVARCHAR(MAX) NOT NULL,
		[IsActive] BIT NOT NULL,
		[RuleFeatureId] BIGINT NOT NULL,
		[TestMetadataId] BIGINT NOT NULL
	)
END

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Add_PersonalizationRule]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
	BEGIN
		DROP PROCEDURE [dbo].[Add_PersonalizationRule]
	END

	GO
	CREATE PROCEDURE [dbo].[Add_PersonalizationRule]
		@table [dbo].[PersonalizationRule_Type] READONLY
		WITH EXECUTE AS OWNER
		AS
		BEGIN
			SET NOCOUNT ON;
			BEGIN TRY
				MERGE [Fact_PersonalizationRule] AS TARGET 
				USING @table AS SOURCE
					ON (TARGET.[Id] = SOURCE.[Id]
					AND TARGET.[RuleId] = SOURCE.[RuleId]
					AND TARGET.[RuleFeatureId] = SOURCE.[RuleFeatureId]
					AND TARGET.[TestMetadataId] = SOURCE.[TestMetadataId])
				WHEN MATCHED THEN
					UPDATE SET 
					TARGET.[IsActive] = SOURCE.[IsActive],
					TARGET.[LastUpdatedOn] = SOURCE.[LastUpdatedOn]
				WHEN NOT MATCHED THEN
					INSERT ([DateTime],
							[LastUpdatedOn],
							[RuleId],
							[PredictionInfo],
							[IsActive],
							[RuleFeatureId],
							[TestMetadataId])
					Values (SOURCE.[DateTime],
							SOURCE.[LastUpdatedOn],
							SOURCE.[RuleId],
							SOURCE.[PredictionInfo],
							SOURCE.[IsActive],
							SOURCE.[RuleFeatureId],
							SOURCE.[TestMetadataId]);
			END TRY
			BEGIN CATCH
				DECLARE @error_number INTEGER = ERROR_NUMBER();
				DECLARE @error_severity INTEGER = ERROR_SEVERITY();
				DECLARE @error_state INTEGER = ERROR_STATE();
				DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
				DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
				DECLARE @error_line INTEGER = ERROR_LINE();
				RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
			END CATCH;
	END

GO
PRINT N'The stored procedure [Add_PersonalizationRule] is updated.';

-- Update the store procedure: Add_TestMetadata
IF type_id('[dbo].[TestMetadata_Type]') IS NULL
BEGIN
	CREATE TYPE [dbo].[TestMetadata_Type] AS TABLE (
		[Id] BIGINT NOT NULL,
		[DimensionKey] NVARCHAR(MAX) NOT NULL,
		[TestCombination] BINARY(16) NOT NULL
	)
END

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Add_TestMetadata]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
	DROP PROCEDURE [dbo].[Add_TestMetadata]
END

GO

CREATE PROCEDURE [dbo].[Add_TestMetadata]
	@table [dbo].[TestMetadata_Type] READONLY
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			MERGE [Dimension_TestMetadata] AS TARGET 
			USING @table AS SOURCE
				ON (TARGET.[Id] = SOURCE.[Id]
				AND TARGET.[TestCombination] = SOURCE.[TestCombination])
			WHEN NOT MATCHED THEN
				INSERT ([Id],
						[DimensionKey],
						[TestCombination])
				Values (SOURCE.[Id],
						SOURCE.[DimensionKey],
						SOURCE.[TestCombination]);
		END TRY
		BEGIN CATCH
			DECLARE @error_number INTEGER = ERROR_NUMBER();
			DECLARE @error_severity INTEGER = ERROR_SEVERITY();
			DECLARE @error_state INTEGER = ERROR_STATE();
			DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
			DECLARE @error_line INTEGER = ERROR_LINE();
			RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
		END CATCH;
END
  
GO
PRINT N'The stored procedure [Add_TestMetadata] is updated.';

-- Update the store procedure: [Add_RuleFeature]
IF type_id('[dbo].[RuleFeature_Type]') IS NULL
BEGIN
	CREATE TYPE [dbo].[RuleFeature_Type] AS TABLE (
		[Id] BIGINT NOT NULL,
		[DimensionKey] NVARCHAR(MAX) NOT NULL,
		[FeatureName] NVARCHAR(MAX) NOT NULL,
		[FeatureValues] NVARCHAR(MAX) NOT NULL,
		[Operator] NVARCHAR(50) NOT NULL
	)
END

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Add_RuleFeature]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
	DROP PROCEDURE [dbo].[Add_RuleFeature]
END

GO

CREATE PROCEDURE [dbo].[Add_RuleFeature]
	@table [dbo].[RuleFeature_Type] READONLY
	WITH EXECUTE AS OWNER
	AS
	BEGIN
		SET NOCOUNT ON;
		BEGIN TRY
			MERGE [Dimension_RuleFeature] AS TARGET 
			USING @table AS SOURCE
				ON (TARGET.[Id] = SOURCE.[Id])
			WHEN NOT MATCHED THEN
				INSERT ([Id],
						[DimensionKey],
						[FeatureName],
						[FeatureValues],
						[Operator])
				Values (SOURCE.[Id],
						SOURCE.[DimensionKey],
						SOURCE.[FeatureName],
						SOURCE.[FeatureValues],
						SOURCE.[Operator]);
		END TRY
		BEGIN CATCH
			DECLARE @error_number INTEGER = ERROR_NUMBER();
			DECLARE @error_severity INTEGER = ERROR_SEVERITY();
			DECLARE @error_state INTEGER = ERROR_STATE();
			DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
			DECLARE @error_line INTEGER = ERROR_LINE();
			RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
		END CATCH;
END;
  
GO
PRINT N'The stored procedure [Add_RuleFeature] is updated.';


--Update the [Fact_Personalization] table
IF NOT EXISTS 
(
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE table_name = 'Fact_Personalization'
    AND column_name = 'ItemId'
)
BEGIN	
	ALTER TABLE [dbo].[Fact_Personalization]
	ADD [ItemId] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Fact_Pers_ItemId] DEFAULT ('00000000-0000-0000-0000-000000000000');
    PRINT 'Added [ItemId] column to the [Fact_Personalization] table.'
END

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'PK_Fact_Personalization')
BEGIN
  ALTER TABLE [dbo].[Fact_Personalization]
  DROP CONSTRAINT [PK_Fact_Personalization]
END;

IF EXISTS (SELECT * FROM sysobjects WHERE name = 'DF_Fact_Pers_ItemId')
BEGIN
  ALTER TABLE [dbo].[Fact_Personalization]
  DROP CONSTRAINT [DF_Fact_Pers_ItemId]
END;

ALTER TABLE [dbo].[Fact_Personalization]
ADD CONSTRAINT [PK_Fact_Personalization] PRIMARY KEY CLUSTERED
(
	[TestSetId] ASC, 
	[TestValues] ASC, 
	[ItemId] ASC, 
	[Date] ASC, 
	[RuleSetId] ASC, 
	[RuleId] ASC, 
	[IsDefault] ASC
)

GO
PRINT N'The table [Fact_Personalization] is updated.';

--Add_Personalization stored procedure
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[Add_Personalization]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].[Add_Personalization]
END

GO

CREATE PROCEDURE [Add_Personalization]
  @Date DATE,
  @RuleSetId UNIQUEIDENTIFIER,
  @RuleId UNIQUEIDENTIFIER,
  @ItemId UNIQUEIDENTIFIER,
  @TestSetId UNIQUEIDENTIFIER,
  @TestValues BINARY (16),
  @IsDefault BIT,
  @Visits BIGINT,
  @Value BIGINT,
  @Visitors BIGINT
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
    [Fact_Personalization] AS [target]
  USING
  (
    VALUES
    (
      @Date,
      @RuleSetId,
      @RuleId,
	  @ItemId,
      @TestSetId,
      @TestValues,
      @IsDefault,
      @Visits,
      @Value,
      @Visitors
    )
  )
  AS [source]
  (
    [Date],
    [RuleSetId],
    [RuleId],
    [ItemId],
    [TestSetId],
    [TestValues],
    [IsDefault],
    [Visits],
    [Value],
    [Visitors]
  )
  ON
    ([target].[Date] = [source].[Date]) AND
    ([target].[RuleSetId] = [source].[RuleSetId]) AND
    ([target].[RuleId] = [source].[RuleId]) AND
    ([target].[ItemId] = [source].[ItemId]) AND
    ([target].[TestSetId] = [source].[TestSetId]) AND
    ([target].[TestValues] = [source].[TestValues]) AND
    ([target].[IsDefault] = [source].[IsDefault])

  WHEN MATCHED THEN
    UPDATE
      SET
        [target].[Visits] = ([target].[Visits] + [source].[Visits]),
        [target].[Value] = ([target].[Value] + [source].[Value]),
        [target].[Visitors] = ([target].[Visitors] + [source].[Visitors])

  WHEN NOT MATCHED THEN
    INSERT
    (
      [Date],
      [RuleSetId],
      [RuleId],
      [ItemId],
      [TestSetId],
      [TestValues],
      [IsDefault],
      [Visits],
      [Value],
      [Visitors]
    )
    VALUES
    (
      [source].[Date],
      [source].[RuleSetId],
      [source].[RuleId],
      [source].[ItemId],
      [source].[TestSetId],
      [source].[TestValues],
      [source].[IsDefault],
      [source].[Visits],
      [source].[Value],
      [source].[Visitors]
    );
  END TRY
  BEGIN CATCH

    DECLARE @error_number INTEGER = ERROR_NUMBER();
    DECLARE @error_severity INTEGER = ERROR_SEVERITY();
    DECLARE @error_state INTEGER = ERROR_STATE();
    DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
    DECLARE @error_line INTEGER = ERROR_LINE();

    IF( @error_number = 2627 )
    BEGIN

      UPDATE
        [dbo].[Fact_Personalization]
      SET
        [Visits] = ([Visits] + @Visits),
        [Value] = ([Value] + @Value),
        [Visitors] = ([Visitors] + @Visitors)
      WHERE
        ([Date] = @Date) AND
		([RuleSetId] = @RuleSetId) AND
		([RuleId] = @RuleId) AND
		([ItemId] = @ItemId) AND
		([TestSetId] = @TestSetId) AND
		([TestValues] = @TestValues) AND
		([IsDefault] = @IsDefault);

      IF( @@ROWCOUNT != 1 )
      BEGIN
        RAISERROR( 'Failed to insert or update rows in the [Fact_Personalization] table.', 18, 1 ) WITH NOWAIT;
      END

    END
    ELSE
    BEGIN

      RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;

    END;
  
  END CATCH;

END;
GO

-- Update the store procedure: Add_Personalization_Tvp

GO
PRINT N'Droping [dbo].[Add_Personalization_Tvp]...';


GO
IF (OBJECT_ID('[dbo].[Add_Personalization_Tvp]', 'P') IS NOT NULL)
BEGIN
	DROP PROCEDURE [dbo].[Add_Personalization_Tvp]
End 

GO
PRINT N'Droping [dbo].[Personalization_Type]...';


GO
IF (TYPE_ID(N'[dbo].[Personalization_Type]') IS NOT NULL)
BEGIN
	DROP TYPE [dbo].[Personalization_Type]
END

IF type_id('[dbo].[Personalization_Type]') IS NULL
BEGIN

	CREATE TYPE [dbo].[Personalization_Type] AS TABLE (
		[Date] [date] NOT NULL,
		[RuleSetId] [uniqueidentifier] NOT NULL,
		[RuleId] [uniqueidentifier] NOT NULL,
		[ItemId] [uniqueidentifier] NOT NULL,
		[TestSetId] [uniqueidentifier] NOT NULL,
		[TestValues] [binary](16) NOT NULL,
		[IsDefault] [bit] NOT NULL,
		[Visits] [bigint] NOT NULL,
		[Value] [bigint] NOT NULL,
		[Visitors] [bigint] NOT NULL
	)
END

GO

CREATE PROCEDURE [dbo].[Add_Personalization_Tvp]
  @table [dbo].[Personalization_Type] READONLY
WITH EXECUTE AS OWNER
AS
BEGIN

  SET NOCOUNT ON;
  
  BEGIN TRY

  MERGE
	[Fact_Personalization] AS TARGET
	USING (
	  Select 
	   [Date]
	  ,[RuleSetId]
	  ,[RuleId]
	  ,[ItemId]
	  ,[TestSetId]
	  ,[TestValues]
	  ,[IsDefault]
	  ,SUM([Visits]) as [Visits]
	  ,SUM([Value]) as [Value]
	  ,SUM([Visitors]) as [Visitors]
	FROM @table
	GROUP BY 
	   [Date]
	  ,[RuleSetId]
	  ,[RuleId]
	  ,[ItemId]
	  ,[TestSetId]
	  ,[TestValues]
	  ,[IsDefault]
	)
  AS SOURCE
  ON
	(TARGET.[Date] = SOURCE.[Date]) AND
	(TARGET.[RuleSetId] = SOURCE.[RuleSetId]) AND
	(TARGET.[RuleId] = SOURCE.[RuleId]) AND
	(TARGET.[ItemId] = SOURCE.[ItemId]) AND
	(TARGET.[TestSetId] = SOURCE.[TestSetId]) AND
	(TARGET.[TestValues] = SOURCE.[TestValues]) AND
	(TARGET.[IsDefault] = SOURCE.[IsDefault])

  WHEN MATCHED THEN
	UPDATE
	  SET
		TARGET.[Visits] = (TARGET.[Visits] + SOURCE.[Visits]),
		TARGET.[Value] = (TARGET.[Value] + SOURCE.[Value]),
		TARGET.[Visitors] = (TARGET.[Visitors] + SOURCE.[Visitors])

  WHEN NOT MATCHED THEN
	INSERT
	(
	  [Date],
	  [RuleSetId],
	  [RuleId],
	  [ItemId],
	  [TestSetId],
	  [TestValues],
	  [IsDefault],
	  [Visits],
	  [Value],
	  [Visitors]
	)
	VALUES
	(
	  SOURCE.[Date],
	  SOURCE.[RuleSetId],
	  SOURCE.[RuleId],
	  SOURCE.[ItemId],
	  SOURCE.[TestSetId],
	  SOURCE.[TestValues],
	  SOURCE.[IsDefault],
	  SOURCE.[Visits],
	  SOURCE.[Value],
	  SOURCE.[Visitors]
	);
  END TRY
   BEGIN CATCH
	DECLARE @error_number INTEGER = ERROR_NUMBER();
	DECLARE @error_severity INTEGER = ERROR_SEVERITY();
	DECLARE @error_state INTEGER = ERROR_STATE();
	DECLARE @error_message NVARCHAR(4000) = ERROR_MESSAGE();
	DECLARE @error_procedure SYSNAME = ERROR_PROCEDURE();
	DECLARE @error_line INTEGER = ERROR_LINE();
	RAISERROR( N'T-SQL ERROR %d, SEVERITY %d, STATE %d, PROCEDURE %s, LINE %d, MESSAGE: %s', @error_severity, 1, @error_number, @error_severity, @error_state, @error_procedure, @error_line, @error_message ) WITH NOWAIT;
  END CATCH;
  
END;
GO


PRINT N'The stored procedure [Add_Personalization_Tvp] is updated.';
PRINT N'xOptimization component upgrade completed.'
GO
IF (OBJECT_ID('PK_Fact_DownloadEventRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].[Fact_DownloadEventMetrics] Drop CONSTRAINT PK_Fact_DownloadEventRecords_1
  ALTER TABLE [dbo].[Fact_DownloadEventMetrics] ADD CONSTRAINT [PK_Fact_DownloadEventMetrics] PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	
END

IF (OBJECT_ID('PK_Fact_CampaignRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_CampaignMetrics Drop CONSTRAINT PK_Fact_CampaignRecords_1
  ALTER TABLE [dbo].Fact_CampaignMetrics ADD CONSTRAINT PK_Fact_CampaignMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_ChannelRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_ChannelMetrics Drop CONSTRAINT PK_Fact_ChannelRecords_1
  ALTER TABLE [dbo].Fact_ChannelMetrics ADD CONSTRAINT PK_Fact_ChannelMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_ConversionsRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_ConversionsMetrics Drop CONSTRAINT PK_Fact_ConversionsRecords_1
  ALTER TABLE [dbo].Fact_ConversionsMetrics ADD CONSTRAINT PK_Fact_ConversionsMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_GoalRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_GoalMetrics Drop CONSTRAINT PK_Fact_GoalRecords_1
  ALTER TABLE [dbo].Fact_GoalMetrics ADD CONSTRAINT PK_Fact_GoalMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_OutcomeRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_OutcomeMetrics Drop CONSTRAINT PK_Fact_OutcomeRecords_1
  ALTER TABLE [dbo].Fact_OutcomeMetrics ADD CONSTRAINT PK_Fact_OutcomeMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_PageRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_PageMetrics Drop CONSTRAINT PK_Fact_PageRecords_1
  ALTER TABLE [dbo].Fact_PageMetrics ADD CONSTRAINT PK_Fact_PageMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]  
END

IF (OBJECT_ID('Fact_SearchMetrics_FirstImpressionCount') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].[Fact_SearchMetrics] DROP CONSTRAINT [Fact_SearchMetrics_FirstImpressionCount]
END

IF (OBJECT_ID('Fact_PageMetrics_FirstImpressionCount') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].[Fact_PageMetrics] DROP CONSTRAINT [Fact_PageMetrics_FirstImpressionCount]
END

IF (OBJECT_ID('Fact_PageByUrlMetrics_FirstImpressionCount') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].[Fact_PageByUrlMetrics] DROP CONSTRAINT [Fact_PageByUrlMetrics_FirstImpressionCount]
END

IF (OBJECT_ID('PK_Fact_ReferringSiteRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_ReferringSiteMetrics Drop CONSTRAINT PK_Fact_ReferringSiteRecords_1
  ALTER TABLE [dbo].Fact_ReferringSiteMetrics ADD CONSTRAINT PK_Fact_ReferringSiteMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF(OBJECT_ID('PK_Fact_PatternRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_PatternMetrics Drop CONSTRAINT PK_Fact_PatternRecords_1
  ALTER TABLE [dbo].Fact_PatternMetrics ADD CONSTRAINT PK_Fact_PatternMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_LanguageRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_LanguageMetrics Drop CONSTRAINT PK_Fact_LanguageRecords_1
  ALTER TABLE [dbo].Fact_LanguageMetrics ADD CONSTRAINT PK_Fact_LanguageMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_SearchRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_SearchMetrics Drop CONSTRAINT PK_Fact_SearchRecords_1
  ALTER TABLE [dbo].Fact_SearchMetrics ADD CONSTRAINT PK_Fact_SearchMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF (OBJECT_ID('PK_Fact_PageViewsRecords_1') IS NOT NULL)
BEGIN
  ALTER TABLE [dbo].Fact_PageViewsMetrics Drop CONSTRAINT PK_Fact_PageViewsRecords_1
  ALTER TABLE [dbo].Fact_PageViewsMetrics ADD CONSTRAINT PK_Fact_PageViewsMetrics PRIMARY KEY CLUSTERED
		(
		[SegmentRecordId] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

GO

PRINT N'Altering [dbo].[Properties], Changing the value column from NTEXT to NVARCHAR(MAX)...';
GO
IF (OBJECT_ID(N'[dbo].[Properties]', 'U') IS NOT NULL)
BEGIN
	Alter Table [dbo].[Properties]
	Alter Column [Value] nvarchar(max) NOT NULL
END;
Go
PRINT N'Done Updating [dbo].[Properties]';

PRINT N'Update complete.';
