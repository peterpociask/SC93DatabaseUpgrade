IF NOT EXISTS (SELECT * FROM [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] WHERE [Name] = N'ContactIdentifiersIndexShardMap')
BEGIN
	INSERT [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] ([Name], [SchemaInfo]) VALUES (N'ContactIdentifiersIndexShardMap', N'<Schema xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ReferenceTableSet i:type="ArrayOfReferenceTableInfo" /><ShardedTableSet i:type="ArrayOfShardedTableInfo"><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>ContactIdentifiersIndex</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo></ShardedTableSet></Schema>')
END
GO

IF NOT EXISTS (SELECT * FROM [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] WHERE [Name] = N'ContactIdShardMap')
BEGIN
	INSERT [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] ([Name], [SchemaInfo]) VALUES (N'ContactIdShardMap', N'<Schema xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ReferenceTableSet i:type="ArrayOfReferenceTableInfo" /><ShardedTableSet i:type="ArrayOfShardedTableInfo"><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>Contacts</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>ContactFacets</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>ContactIdentifiers</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>Interactions</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>InteractionFacets</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo></ShardedTableSet></Schema>')
END
GO

IF NOT EXISTS (SELECT * FROM [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] WHERE [Name] = N'DeviceProfileIdShardMap')
BEGIN
	INSERT [__ShardManagement].[ShardedDatabaseSchemaInfosGlobal] ([Name], [SchemaInfo]) VALUES (N'DeviceProfileIdShardMap', N'<Schema xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ReferenceTableSet i:type="ArrayOfReferenceTableInfo" /><ShardedTableSet i:type="ArrayOfShardedTableInfo"><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>DeviceProfileFacets</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo><ShardedTableInfo><SchemaName>xdb_collection</SchemaName><TableName>DeviceProfiles</TableName><KeyColumnName>ShardKey</KeyColumnName></ShardedTableInfo></ShardedTableSet></Schema>')
END
GO