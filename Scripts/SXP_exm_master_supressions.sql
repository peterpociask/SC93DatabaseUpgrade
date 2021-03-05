/*
Upgrade script for EXM.Master from 9.0.1, 9.0.2 or 9.1.0 to 9.1.1
*/

GO

PRINT N'Altering [dbo].[Suppressions]...';

GO

ALTER TABLE [dbo].[Suppressions] ALTER COLUMN ReasonType NVARCHAR(MAX) NULL

GO

PRINT N'Update complete.';

GO