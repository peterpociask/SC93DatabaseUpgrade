/*
Deployment script for Sitecore.Processing.Engine.Storage
*/
GO

SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

PRINT N'Altering [sitecore_processing_storage].[GrantLeastPrivilege]...';
GO

ALTER PROCEDURE [sitecore_processing_storage].[GrantLeastPrivilege]
(
    @Name SYSNAME
)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    IF (LEN(ISNULL(@Name, N'')) = 0)
    BEGIN
        RAISERROR( 'Parameter @Name cannot be null or empty', 16, 1 ) WITH NOWAIT;
        RETURN
    END;

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

    EXECUTE ('
        grant execute on [sitecore_processing_storage].[GetBlob] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[GetKeys] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[KeyExists] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[PurgeExpired] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[PutBlob] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[RemoveAllBlobs] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[RemoveBlob] TO [' + @Name + ']
        grant execute on [sitecore_processing_storage].[UpdateTimeToLive] TO [' + @Name + ']');
END
GO

PRINT N'Update complete.';
GO
