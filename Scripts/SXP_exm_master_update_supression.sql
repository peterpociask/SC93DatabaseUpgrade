/*
Upgrade script for EXM.Master from 9.0.1, 9.0.2 or 9.1.0 to 9.1.1
*/

GO

PRINT N'Altering [dbo].[UpdateSuppression] stored procedure...';

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[UpdateSuppression]
	@SuppressionId BIGINT,
	@ReasonType NVARCHAR(MAX) = NULL,
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