SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'aspnet_Membership'))
BEGIN
	IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'UserLogins'))
	BEGIN
		PRINT N'Creating table UserLogins...'
		CREATE TABLE [UserLogins] (
				[LoginProvider] NVARCHAR (128) NOT NULL,
				[ProviderKey]   NVARCHAR (128) NOT NULL,
				[UserId]        uniqueidentifier NOT NULL,
					CONSTRAINT [PK_dbo.UserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
				CONSTRAINT [FK_dbo.UserLogins_dbo.aspnet_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [aspnet_Users] ([UserId]) ON DELETE CASCADE
			);
			CREATE NONCLUSTERED INDEX [IX_UserId]
				ON [UserLogins]([UserId] ASC);
	END
	ELSE
		PRINT N'The table UserLogins already present';

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PersistedGrants')
	BEGIN
		CREATE TABLE [PersistedGrants] (
			[Key] nvarchar(200) NOT NULL,
			[Type] nvarchar(50) NOT NULL,
			[SubjectId] nvarchar(200) NULL,
			[ClientId] nvarchar(200) NOT NULL,
			[CreationTime] datetime2 NOT NULL,
			[Expiration] datetime2 NULL,
			[Data] nvarchar(max) NOT NULL,
			CONSTRAINT [PK_PersistedGrants] PRIMARY KEY ([Key])
		);
		
		CREATE INDEX [IX_PersistedGrants_SubjectId_ClientId_Type] ON [PersistedGrants] ([SubjectId], [ClientId], [Type]);
	END

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ExternalUserData')
	BEGIN
		CREATE TABLE [ExternalUserData] (
			[Key] int IDENTITY(1,1),
			[ProviderName] nvarchar(200) NOT NULL,
			[UserId] nvarchar(200) NOT NULL,
			[IsActive] bit NOT NULL,
			[Data] nvarchar(max) NOT NULL,
			CONSTRAINT [PK_ExternalUserData] PRIMARY KEY ([Key])
		);

		CREATE UNIQUE INDEX [IX_ExternalUserData_ProviderName_UserId] ON [ExternalUserData] ([ProviderName], [UserId]);
	END
END

PRINT N'Update complete.';