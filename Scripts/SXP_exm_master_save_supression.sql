/*
Upgrade script for EXM.Master from 9.0.1, 9.0.2 or 9.1.0 to 9.1.1
*/

GO

PRINT N'Altering [dbo].[SaveSuppression] stored procedure...';

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SaveSuppression]
	@Email NVARCHAR(255),
	@SuppressTime DATETIME,
	@ReasonType NVARCHAR(MAX) = NULL,
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

PRINT N'Update complete.';

GO