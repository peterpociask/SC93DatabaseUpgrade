BEGIN TRAN;
-- Migration Script Starts

/*Change the value of '@DropLegacyObjects' to 0 if you'd like to keep the legacy database objects*/

DECLARE @DropLegacyObjects BIT= 1;
DECLARE @DefaultConvertedValue INT;
SET @DefaultConvertedValue = 0;

/* 
	CHANNEL METRICS 
	Channel SegmentId = 29EA9B8C-E568-49F2-8227-0F3C6781CD70
	ChannelGroup Segment Id = 56649EAC-3CCF-4EAB-88B0-C74862DB862B
	ChannelType Segment Id = 0751EFD8-564F-40A3-8083-EF5C6E194247
*/

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_ChannelTypeMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_ChannelTypeMetrics]
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
         CONSTRAINT [PK_Fact_ChannelTypeMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_ChannelGroupMetrics'
))
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
         CONSTRAINT [PK_Fact_ChannelGroupMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_ChannelMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_ChannelTypeMetrics
               SELECT *
               FROM Fact_ChannelMetrics
               WHERE SegmentId = '0751EFD8-564F-40A3-8083-EF5C6E194247';
        INSERT INTO Fact_ChannelGroupMetrics
               SELECT *
               FROM Fact_ChannelMetrics
               WHERE SegmentId = '56649EAC-3CCF-4EAB-88B0-C74862DB862B';
        DELETE FROM Fact_ChannelMetrics
        WHERE SegmentId IN('0751EFD8-564F-40A3-8083-EF5C6E194247', '56649EAC-3CCF-4EAB-88B0-C74862DB862B');
END;

/* 
	DEVICE METRICS
	Device Model SegmentId = AA0EBAC8-E62B-417E-B55C-B86C2772DA92
	Device Type Segment Id = F9CBFAA6-99B6-462B-AB2D-06DF45639FA3
	Device Size Segment Id = C3158CB5-5719-4380-8CE9-2111BFACA8D1
 */

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_DeviceTypeMetrics'
))
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
         CONSTRAINT [PK_Fact_DeviceTypeMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_DeviceSizeMetrics'
))
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
         CONSTRAINT [PK_Fact_DeviceSizeMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_DeviceModelMetrics'
))
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
         CONSTRAINT [PK_Fact_DeviceModelMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_DeviceMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_DeviceTypeMetrics
               SELECT *, 
                      @DefaultConvertedValue,
                      NULL
               FROM Fact_DeviceMetrics
               WHERE SegmentId = 'F9CBFAA6-99B6-462B-AB2D-06DF45639FA3';
        INSERT INTO Fact_DeviceSizeMetrics
               SELECT *, 
                      @DefaultConvertedValue,
                      NULL
               FROM Fact_DeviceMetrics
               WHERE SegmentId = 'C3158CB5-5719-4380-8CE9-2111BFACA8D1';
        INSERT INTO Fact_DeviceModelMetrics
               SELECT *, 
                      @DefaultConvertedValue,
                      NULL
               FROM Fact_DeviceMetrics
               WHERE SegmentId = 'AA0EBAC8-E62B-417E-B55C-B86C2772DA92';
        DELETE FROM Fact_DeviceMetrics
        WHERE SegmentId IN('F9CBFAA6-99B6-462B-AB2D-06DF45639FA3', 'C3158CB5-5719-4380-8CE9-2111BFACA8D1', 'AA0EBAC8-E62B-417E-B55C-B86C2772DA92');
END;

/* 
	Geo METRICS
	Country SegmentId = 39EDE033-3729-4858-A011-C15EDDEF1442
	Region Segment Id = ECF418EB-9603-4085-8A02-1E9A6990C723
	City Segment Id = 936B1BAE-C09E-436C-80D8-E00A73BEBE1D
 */

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_CityMetrics'
))
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
         CONSTRAINT [PK_Fact_CityMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_RegionMetrics'
))
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
         CONSTRAINT [PK_Fact_RegionMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_CountryMetrics'
))
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
         CONSTRAINT [PK_Fact_CountryMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_GeoMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_CityMetrics
               SELECT *, 
                      @DefaultConvertedValue,
                      NULL
               FROM Fact_GeoMetrics
               WHERE SegmentId = '936B1BAE-C09E-436C-80D8-E00A73BEBE1D';
        INSERT INTO Fact_RegionMetrics
               SELECT *, 
                      @DefaultConvertedValue,
                      NULL
               FROM Fact_GeoMetrics
               WHERE SegmentId = 'ECF418EB-9603-4085-8A02-1E9A6990C723';
        INSERT INTO Fact_CountryMetrics
               SELECT *, 
                      @DefaultConvertedValue,
                      NULL
               FROM Fact_GeoMetrics
               WHERE SegmentId = '39EDE033-3729-4858-A011-C15EDDEF1442';
        DELETE FROM Fact_GeoMetrics
        WHERE SegmentId IN('ECF418EB-9603-4085-8A02-1E9A6990C723', '936B1BAE-C09E-436C-80D8-E00A73BEBE1D', '39EDE033-3729-4858-A011-C15EDDEF1442');
END;

/* 
	Campaign METRICS
	Campaign SegmentId = 799B0CD6-A811-4772-BDC4-6DC607106A62
	Campaign Group Segment Id = 2B6EF914-175F-4DC1-BE6F-05255B437A91
	Campaign Facet Segment Id = F47B44D8-07E4-4CD5-A423-0EB7F8A2A3DE
	Campaign Facet Group Segment Id = CA62842F-CBFE-4C7A-856E-4BB5E4FE30E1
 */

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_CampaignGroupMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_CampaignGroupMetrics]
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_CampaignGroupMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_CampaignFacetMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_CampaignFacetMetrics]
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_CampaignFacetMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_CampaignFacetGroupMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_CampaignFacetGroupMetrics]
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_CampaignFacetGroupMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_CampaignMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_CampaignGroupMetrics
               SELECT *
               FROM Fact_CampaignMetrics
               WHERE SegmentId = '2B6EF914-175F-4DC1-BE6F-05255B437A91';
        INSERT INTO Fact_CampaignFacetMetrics
               SELECT *
               FROM Fact_CampaignMetrics
               WHERE SegmentId = 'F47B44D8-07E4-4CD5-A423-0EB7F8A2A3DE';
        INSERT INTO Fact_CampaignFacetGroupMetrics
               SELECT *
               FROM Fact_CampaignMetrics
               WHERE SegmentId = 'CA62842F-CBFE-4C7A-856E-4BB5E4FE30E1';
        DELETE FROM Fact_CampaignMetrics
        WHERE SegmentId IN('2B6EF914-175F-4DC1-BE6F-05255B437A91', 'F47B44D8-07E4-4CD5-A423-0EB7F8A2A3DE', 'CA62842F-CBFE-4C7A-856E-4BB5E4FE30E1');
END;

/* 
	Goal METRICS
	Goal SegmentId = 46511EC0-EC7A-492B-A90F-96BAB33B7456
	Goal Facet Segment Id = 76F02AFB-BC38-4604-8ED8-A680AA0AF5C6
	Goal Facet Group Segment Id = 3D43ADCB-03CB-43E1-B5A7-6FCE00D19075
 */

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_GoalFacetGroupMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_GoalFacetGroupMetrics]
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_GoalFacetGroupMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_GoalFacetMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_GoalFacetMetrics]
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_GoalFacetMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_GoalMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_GoalFacetGroupMetrics
               SELECT *
               FROM Fact_GoalMetrics
               WHERE SegmentId = '3D43ADCB-03CB-43E1-B5A7-6FCE00D19075';
        INSERT INTO Fact_GoalFacetMetrics
               SELECT *
               FROM Fact_GoalMetrics
               WHERE SegmentId = '76F02AFB-BC38-4604-8ED8-A680AA0AF5C6';
        DELETE FROM Fact_GoalMetrics
        WHERE SegmentId IN('3D43ADCB-03CB-43E1-B5A7-6FCE00D19075', '76F02AFB-BC38-4604-8ED8-A680AA0AF5C6');
END;

/* 
	Page METRICS
	Page SegmentId = 7B339703-2C03-4C19-89C9-53930476A59F
	Page url Id = 46B7DA48-1AED-437B-9AF6-5D74BBED1BFD

	Entry Page SegmentId = 96B651B5-C0C6-45F3-A043-FDFB03758008
	Entry Page Url Segment Id = D9ACAA9A-F1F1-4857-91E8-58C99E4E4662
	
	Exit Page SegmentId =  D36C2D2C-5D99-486E-BF81-9BBF7DB0F004
	Exit Page url SegmentId = DDCF099D-9B6A-47A7-A920-19951B1CF85A
 */

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_ExitPageMetrics'
))
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_ExitPageMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_ExitPageByUrlMetrics'
))
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
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_EntryPageMetrics'
))
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
         CONSTRAINT [PK_Fact_EntryPageMetrics] PRIMARY KEY CLUSTERED ([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_EntryPageByUrlMetrics'
))
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
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_PageByUrlMetrics'
))
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
         [Converted]          [INT] NOT NULL, 
         [Pageviews]          [INT] NOT NULL, 
         [TimeOnSite]         [INT] NOT NULL, 
         [TimeOnPage]         [INT] NOT NULL, 
         [MonetaryValue]      [MONEY] NOT NULL, 
         [OutcomeOccurrences] [INT] NOT NULL,
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_PageByUrlMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_PageMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_ExitPageMetrics
               SELECT
				   [SegmentRecordId]
				  ,[SegmentId]
				  ,[Date]
				  ,[SiteNameId]
				  ,[DimensionKeyId]
				  ,[Visits]
				  ,[Value]
				  ,[Bounces]
				  ,[Conversions]
				  ,[Pageviews]
				  ,[TimeOnSite]
				  ,[TimeOnPage]
				  ,[MonetaryValue]
				  ,[OutcomeOccurrences]
				  ,[Converted]
				  ,[FilterId]
               FROM Fact_PageMetrics
               WHERE SegmentId = 'D36C2D2C-5D99-486E-BF81-9BBF7DB0F004';
        INSERT INTO Fact_ExitPageByUrlMetrics
               SELECT
				   [SegmentRecordId]
				  ,[SegmentId]
				  ,[Date]
				  ,[SiteNameId]
				  ,[DimensionKeyId]
				  ,[Visits]
				  ,[Value]
				  ,[Bounces]
				  ,[Conversions]
				  ,[Pageviews]
				  ,[TimeOnSite]
				  ,[TimeOnPage]
				  ,[MonetaryValue]
				  ,[OutcomeOccurrences]
				  ,[Converted]
				  ,[FilterId]
               FROM Fact_PageMetrics
               WHERE SegmentId = 'DDCF099D-9B6A-47A7-A920-19951B1CF85A';
        INSERT INTO Fact_EntryPageMetrics
               SELECT 
			   	   [SegmentRecordId]
				  ,[SegmentId]
				  ,[Date]
				  ,[SiteNameId]
				  ,[DimensionKeyId]
				  ,[Visits]
				  ,[Value]
				  ,[Bounces]
				  ,[Conversions]
				  ,[Pageviews]
				  ,[TimeOnSite]
				  ,[TimeOnPage]
				  ,[MonetaryValue]
				  ,[OutcomeOccurrences]
				  ,[Converted]
				  ,[FilterId]
               FROM Fact_PageMetrics
               WHERE SegmentId = '96B651B5-C0C6-45F3-A043-FDFB03758008';
        INSERT INTO Fact_EntryPageByUrlMetrics
               SELECT 
			   	   [SegmentRecordId]
				  ,[SegmentId]
				  ,[Date]
				  ,[SiteNameId]
				  ,[DimensionKeyId]
				  ,[Visits]
				  ,[Value]
				  ,[Bounces]
				  ,[Conversions]
				  ,[Pageviews]
				  ,[TimeOnSite]
				  ,[TimeOnPage]
				  ,[MonetaryValue]
				  ,[OutcomeOccurrences]
				  ,[Converted]
				  ,[FilterId]
               FROM Fact_PageMetrics
               WHERE SegmentId = 'D9ACAA9A-F1F1-4857-91E8-58C99E4E4662';
        INSERT INTO Fact_PageByUrlMetrics
               SELECT
			   	   [SegmentRecordId]
				  ,[SegmentId]
				  ,[Date]
				  ,[SiteNameId]
				  ,[DimensionKeyId]
				  ,[Visits]
				  ,[Value]
				  ,[Bounces]
				  ,[Conversions]
				  ,[Pageviews]
				  ,[TimeOnSite]
				  ,[TimeOnPage]
				  ,[MonetaryValue]
				  ,[OutcomeOccurrences]
				  ,[Converted]
				  ,[FilterId]
				  ,[FirstImpressionCount]
               FROM Fact_PageMetrics
               WHERE SegmentId = '46B7DA48-1AED-437B-9AF6-5D74BBED1BFD';
        DELETE FROM Fact_PageMetrics
        WHERE SegmentId IN('46B7DA48-1AED-437B-9AF6-5D74BBED1BFD', '96B651B5-C0C6-45F3-A043-FDFB03758008', 'D9ACAA9A-F1F1-4857-91E8-58C99E4E4662', 'D36C2D2C-5D99-486E-BF81-9BBF7DB0F004', 'DDCF099D-9B6A-47A7-A920-19951B1CF85A');
END;

/* 
	Outcome METRICS
	Outcome SegmentId = 4D39901D-54D3-4F72-A9BF-83DC0823F355
	Outcome Group Segment Id = 62E41AA0-774F-4278-9923-66DE5854B3EC
 */

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_OutcomeGroupMetrics'
))
    BEGIN
        CREATE TABLE [dbo].[Fact_OutcomeGroupMetrics]
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_OutcomeGroupMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_OutcomeMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_OutcomeGroupMetrics
               SELECT *
               FROM Fact_OutcomeMetrics
               WHERE SegmentId = '62E41AA0-774F-4278-9923-66DE5854B3EC';
        DELETE FROM Fact_OutcomeMetrics
        WHERE SegmentId IN('62E41AA0-774F-4278-9923-66DE5854B3EC');
END;

/* 
	Download Event METRICS
	Download Event SegmentId = 2D028781-459C-4707-A500-9DC6080CE142
	Asset Segment Id = 124D5A53-6FF4-4883-871F-40051353B5C9
	Asset Group Segment Id = 11640AA1-0AB2-4F08-A803-CC444EEAB2FA
 */
/* Create [AssetMetrics]*/

IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_AssetMetrics'
))
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
IF(NOT EXISTS
(
    SELECT *
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_SCHEMA = 'dbo'
          AND TABLE_NAME = 'Fact_AssetGroupMetrics'
))
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
         [FilterId] [UNIQUEIDENTIFIER]
         CONSTRAINT [PK_Fact_AssetGroupMetrics] PRIMARY KEY CLUSTERED([SegmentRecordId] ASC)
         WITH(PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        )
        ON [PRIMARY];
END;
IF(OBJECT_ID('dbo.[Fact_DownloadEventMetrics]', 'U') IS NOT NULL)
    BEGIN
        INSERT INTO Fact_AssetMetrics
               SELECT *
               FROM Fact_DownloadEventMetrics
               WHERE SegmentId = '124D5A53-6FF4-4883-871F-40051353B5C9';
        INSERT INTO Fact_AssetGroupMetrics
               SELECT *
               FROM Fact_DownloadEventMetrics
               WHERE SegmentId = '11640AA1-0AB2-4F08-A803-CC444EEAB2FA';
        DELETE FROM Fact_DownloadEventMetrics
        WHERE SegmentId IN('124D5A53-6FF4-4883-871F-40051353B5C9', '11640AA1-0AB2-4F08-A803-CC444EEAB2FA');
END;
IF(@DropLegacyObjects = 1)
    BEGIN

        /* Deleting Legacy XA SQL Objects */

        IF(EXISTS
        (
            SELECT *
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'Add_DeviceMetrics_Tvp'
        ))
            DROP PROCEDURE [dbo].[Add_DeviceMetrics_Tvp];
        IF(EXISTS
        (
            SELECT *
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = 'dbo'
                  AND TABLE_NAME = 'Fact_DeviceMetrics'
        ))
            DROP TABLE [dbo].[Fact_DeviceMetrics];
        IF(EXISTS
        (
            SELECT *
            FROM sys.types
            WHERE name = 'DeviceMetrics_Type'
        ))
            DROP TYPE [dbo].DeviceMetrics_Type;
        IF(EXISTS
        (
            SELECT *
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'Add_GeoMetrics_Tvp'
        ))
            DROP PROCEDURE [dbo].[Add_GeoMetrics_Tvp];
        IF(EXISTS
        (
            SELECT *
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = 'dbo'
                  AND TABLE_NAME = 'Fact_GeoMetrics'
        ))
            DROP TABLE [dbo].[Fact_GeoMetrics];
        IF(EXISTS
        (
            SELECT *
            FROM sys.types
            WHERE name = 'GeoMetrics_Type'
        ))
            DROP TYPE [dbo].GeoMetrics_Type;
END;
COMMIT;