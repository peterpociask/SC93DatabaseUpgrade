/*
Upgrade script for EXM.Master from 9.0.1 or 9.0.2 to 9.1.0
*/

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;

GO

PRINT N'Altering [dbo].[DispatchQueue]...';

GO

ALTER TABLE [dbo].[DispatchQueue]
    ADD [CustomQueryStringParameters] NVARCHAR (MAX) NULL;

GO

PRINT N'Creating [dbo].[SuppressionStatesType]...';

GO

CREATE TYPE [dbo].[SuppressionStatesType] AS TABLE (
    [SuppressionState] INT NULL);

GO

CREATE PROCEDURE [dbo].[DeleteByEmailSuppression]
	@Email NVARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT OFF;

   DELETE FROM [Suppressions] WHERE [Email] = @Email
END

GO

CREATE PROCEDURE [dbo].[DeleteSuppression]
	@SuppressionId BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT OFF;

   DELETE FROM [Suppressions] WHERE [Id] = @SuppressionID
END

GO

CREATE PROCEDURE [dbo].[GetByEmailAndStatusSuppression]
	@Email NVARCHAR(255),
	@SuppressionStates [dbo].[SuppressionStatesType] READONLY
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT ON;

   SELECT[Id], [Email], [SuppressTime], [ReasonType], [SuppressionStatus], [ModifiedTime] 
   FROM [Suppressions] WHERE [Email] = @Email AND [Suppressions].[SuppressionStatus] IN (select SuppressionState from @SuppressionStates)
END

GO

CREATE PROCEDURE [dbo].[GetByIdSuppression]
	@SuppressionId BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT ON;

   SELECT[Id], [Email], [SuppressTime], [ReasonType], [SuppressionStatus], [ModifiedTime] 
   FROM [Suppressions] WHERE [Id] = @SuppressionID
END

GO

CREATE PROCEDURE [dbo].[GetFilteredSuppressions] 
    @ModifiedStartTime DATETIME = NULL,
    @ModifiedEndTime DATETIME = NULL,
    @SuppressStartTime DATETIME = NULL,
    @SuppressEndTime DATETIME = NULL,
	@SuppressionStates [dbo].[SuppressionStatesType] READONLY
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;

    SELECT [Id], [Email], [SuppressTime], [ReasonType], [SuppressionStatus], [ModifiedTime]
	FROM [Suppressions]
	WHERE 
		[Suppressions].[ModifiedTime] >= @ModifiedStartTime
		AND [Suppressions].[ModifiedTime] <= @ModifiedEndTime
		AND [Suppressions].[SuppressTime] > @SuppressStartTime
		AND [Suppressions].[SuppressTime] < @SuppressEndTime
		AND [Suppressions].[SuppressionStatus] IN (select SuppressionState from @SuppressionStates)
    ORDER BY [Id]

	
END

GO


CREATE PROCEDURE [dbo].[GetSuppressions] 
	@QueryText NVARCHAR(255) = NULL,
    @OrderByColumn VARCHAR(25) = 'suppresstime',
    @OrderByDirection BIT,
	@SkipPages INT,
	@PageSize INT
-- Assign execution context to OWNER of the module (stored procedure)
WITH EXECUTE AS OWNER 
AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets 
    -- (return a number of affected rows by the statements)
    -- in order to improve performance.
    SET NOCOUNT ON;

    SELECT [Id], [Email], [SuppressTime], [ReasonType], [SuppressionStatus], [ModifiedTime], COUNT(*) OVER()
	FROM [Suppressions]
	WHERE [SuppressionStatus] != '2'
	AND (@QueryText IS NULL OR [Email] = @QueryText )
    ORDER BY

		CASE WHEN @OrderByColumn = 'id' AND @OrderByDirection = 'true' THEN [Suppressions].[Id] END DESC,    
		CASE WHEN @OrderByColumn = 'id' AND @OrderByDirection = 'false' THEN [Suppressions].[Id] END ASC,    
		CASE WHEN @OrderByColumn = 'email' AND @OrderByDirection = 'true' THEN [Suppressions].[Email] END DESC,
		CASE WHEN @OrderByColumn = 'email' AND @OrderByDirection = 'false' THEN [Suppressions].[Email] END ASC,
		CASE WHEN @OrderByColumn = 'reasontype' AND @OrderByDirection = 'true' THEN [Suppressions].[ReasonType] END DESC,
		CASE WHEN @OrderByColumn = 'reasontype' AND @OrderByDirection = 'false' THEN [Suppressions].[ReasonType] END ASC,
		CASE WHEN @OrderByColumn = 'suppressionstatus' AND @OrderByDirection = 'true' THEN [Suppressions].[SuppressionStatus] END DESC,
		CASE WHEN @OrderByColumn = 'suppressionstatus' AND @OrderByDirection = 'false' THEN [Suppressions].[SuppressionStatus] END ASC,
		CASE WHEN @OrderByColumn = 'suppresstime' AND @OrderByDirection = 'true' THEN [Suppressions].[SuppressTime] END DESC,
		CASE WHEN @OrderByColumn = 'suppresstime' AND @OrderByDirection = 'false' THEN [Suppressions].[SuppressTime] END ASC,
		CASE WHEN @OrderByColumn = 'modifiedtime' AND @OrderByDirection = 'true' THEN [Suppressions].[ModifiedTime] END DESC,
		CASE WHEN @OrderByColumn = 'modifiedtime' AND @OrderByDirection = 'false' THEN [Suppressions].[ModifiedTime] END ASC

    OFFSET @SkipPages ROWS FETCH NEXT @PageSize ROWS ONLY 

	
END

GO

CREATE PROCEDURE [dbo].[SaveSuppression]
	@Email NVARCHAR(255),
	@SuppressTime DATETIME,
	@ReasonType NVARCHAR(MAX),
	@SuppressionStatus INT,
	@ModifiedTime DATETIME,
	@SuppressionID BIGINT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
   SET NOCOUNT ON;

   SET @SuppressionID = (SELECT [Id] FROM [Suppressions] WHERE [Email] = @Email)
		
	IF @SuppressionID IS NULL OR @SuppressionID = 0
	   BEGIN
		   INSERT INTO [Suppressions] ([Email], [SuppressTime], [ReasonType], [SuppressionStatus], [ModifiedTime]) 
		   VALUES (@Email, @SuppressTime, @ReasonType, @SuppressionStatus, @ModifiedTime)
		   SET @SuppressionID = @@IDENTITY
	   END
	ELSE
	   BEGIN
		   UPDATE [Suppressions] 
		   SET [ReasonType] = @ReasonType, [SuppressionStatus] = @SuppressionStatus, [ModifiedTime] = @ModifiedTime 
		   WHERE [Id] = @SuppressionID
	   END

	RETURN
END

GO

CREATE PROCEDURE [dbo].[SyncPendingSuppressions]
	@SuppressionId BIGINT,
	@SuppressionStatus INT,
	@ModifiedTime DATETIME
AS
BEGIN
   SET NOCOUNT OFF;
   
   IF EXISTS(SELECT 1 FROM [Suppressions] WHERE [Id] = @SuppressionId)
	   BEGIN
		   UPDATE [Suppressions] 
		   SET [SuppressionStatus] = @SuppressionStatus, [ModifiedTime] = @ModifiedTime 
		   WHERE [Id] = @SuppressionID
	   END
	
	RETURN
END

GO

CREATE PROCEDURE [dbo].[UpdateSuppression]
	@SuppressionId BIGINT,
	@ReasonType NVARCHAR(MAX),
	@SuppressionStatus INT,
	@ModifiedTime DATETIME
AS
BEGIN
   SET NOCOUNT OFF;

   DECLARE @OldSuppressionStatus AS INT

   SET @OldSuppressionStatus = (SELECT [SuppressionStatus] FROM [Suppressions] WHERE [Id] = @SuppressionId)
		
	IF @OldSuppressionStatus IS NULL
	   RETURN
	ELSE IF @OldSuppressionStatus = '1' AND @SuppressionStatus = '2'
	   BEGIN
		   DELETE FROM [Suppressions] 
		   WHERE [Id] = @SuppressionID
	   END
	ELSE
	   BEGIN
		   UPDATE [Suppressions] 
		   SET [ReasonType] = @ReasonType, [SuppressionStatus] = @SuppressionStatus, [ModifiedTime] = @ModifiedTime 
		   WHERE [Id] = @SuppressionID
	   END
	
	RETURN
END

GO

PRINT N'Update complete.';

GO
