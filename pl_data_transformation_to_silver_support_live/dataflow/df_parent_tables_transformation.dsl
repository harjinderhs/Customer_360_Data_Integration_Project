source(output(
		AgentID as short,
		Name as string,
		Department as string,
		Shift as string
	),
	useSchema: false,
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false,
	format: 'delimited',
	fileSystem: 'project3-container',
	folderPath: 'Bronze_Layer',
	fileName: 'Agents.csv',
	columnDelimiter: ',',
	escapeChar: '\\',
	quoteChar: '\"',
	columnNamesAsHeader: true) ~> Agents
source(output(
		CustomerID as short,
		Name as string,
		Email as string,
		Address as string
	),
	useSchema: false,
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false,
	format: 'delimited',
	fileSystem: 'project3-container',
	folderPath: 'Bronze_Layer',
	fileName: 'Customers.csv',
	columnDelimiter: ',',
	escapeChar: '\\',
	quoteChar: '\"',
	columnNamesAsHeader: true) ~> Customers
source(output(
		ProductID as short,
		Name as string,
		Category as string,
		Price as double
	),
	useSchema: false,
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false,
	format: 'delimited',
	fileSystem: 'project3-container',
	folderPath: 'Bronze_Layer',
	fileName: 'Products.csv',
	columnDelimiter: ',',
	escapeChar: '\\',
	quoteChar: '\"',
	columnNamesAsHeader: true) ~> Products
source(output(
		StoreID as short,
		Location as string,
		Manager as string,
		OpenHours as string
	),
	useSchema: false,
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false,
	format: 'delimited',
	fileSystem: 'project3-container',
	folderPath: 'Bronze_Layer',
	fileName: 'Stores.csv',
	columnDelimiter: ',',
	escapeChar: '\\',
	quoteChar: '\"',
	columnNamesAsHeader: true) ~> Stores
Agents filter(!isNull(AgentID)) ~> DropNullRows
DropNullRows aggregate(groupBy(AgentID,
		Name,
		Department,
		Shift),
	Count = count(1)) ~> RemoveDuplicateRows
RemoveDuplicateRows select(mapColumn(
		AgentID,
		Name,
		Department,
		Shift
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> DropDummyCol
DropDummyCol derive(Name = iif(isNull(trim(Name)), 'Unknown', Name),
		Department = iif(isNull(trim(Department)), 'N/A', Department),
		Shift = iif(isNull(trim(Shift)), 'Unknown', Shift)) ~> FillNullValues
FillNullValues alterRow(upsertIf(1==1)) ~> GiveUpsertPermissions
Products filter(!isNull(ProductID)) ~> DropNullRows3
Customers filter(!isNull(CustomerID)) ~> DropNullRows2
DropNullRows2 aggregate(groupBy(CustomerID,
		Name,
		Email,
		Address),
	count = count(1)) ~> RemoveDuplicateRows2
RemoveDuplicateRows2 select(mapColumn(
		CustomerID,
		Name,
		Email,
		Address
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> DropDummyCol2
DropDummyCol2 derive(Name = iif(isNull(trim(Name)), 'Unknown', Name),
		Email = iif(isNull(trim(Email)), 'Unknown', Email),
		Address = iif(isNull(trim(Address)), 'Unknown', Address)) ~> FillNullValues2
FillNullValues2 alterRow(upsertIf(1==1)) ~> GiveUpsertPermissions2
DropNullRows3 aggregate(groupBy(ProductID,
		Name,
		Category,
		Price),
	Count = count(1)) ~> RemoveDuplicateRows3
RemoveDuplicateRows3 select(mapColumn(
		ProductID,
		Name,
		Category,
		Price
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> DropDummyCol3
DropDummyCol3 derive(Name = iif(isNull(trim(Name)), 'Unknown', Name),
		Category = iif(isNull(trim(Category)), 'N/A', Category),
		Price = iif(isNull(Price), toDouble(-1), Price)) ~> FillNullValues3
FillNullValues3 alterRow(upsertIf(1==1)) ~> GiveUpsertPermissions3
Stores filter(!isNull(StoreID)) ~> DropNullRows4
DropNullRows4 aggregate(groupBy(StoreID,
		Location,
		Manager,
		OpenHours),
	Count = count(1)) ~> RemoveDuplicateRows4
RemoveDuplicateRows4 select(mapColumn(
		StoreID,
		Location,
		Manager,
		OpenHours
	),
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> DropDummyCol4
DropDummyCol4 derive(Location = iif(isNull(trim(Location)), 'Unknown', Location),
		Manager = iif(isNull(trim(Manager)), 'Unknown', Manager),
		OpenHours = iif(isNull(trim(OpenHours)), 'Unknown', OpenHours)) ~> FillNullValues4
FillNullValues4 alterRow(upsertIf(1==1)) ~> GiveUpsertPermissions4
GiveUpsertPermissions sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		AgentID as integer,
		Name as string,
		Department as string,
		Shift as string
	),
	format: 'table',
	store: 'sqlserver',
	schemaName: 'dbo',
	tableName: 'Agents',
	insertable: false,
	updateable: false,
	deletable: false,
	upsertable: true,
	keys:['AgentID'],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		AgentID,
		Name,
		Department,
		Shift
	)) ~> AzureSQLDBAgents
GiveUpsertPermissions2 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		CustomerID as integer,
		Name as string,
		Email as string,
		Address as string
	),
	format: 'table',
	store: 'sqlserver',
	schemaName: 'dbo',
	tableName: 'Customers',
	insertable: false,
	updateable: false,
	deletable: false,
	upsertable: true,
	keys:['CustomerID'],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		CustomerID,
		Name,
		Email,
		Address
	)) ~> AzureSQLDBCustomers
GiveUpsertPermissions3 sink(allowSchemaDrift: true,
	validateSchema: false,
	input(
		ProductID as integer,
		Name as string,
		Category as string,
		Price as decimal(10,2)
	),
	format: 'table',
	store: 'sqlserver',
	schemaName: 'dbo',
	tableName: 'Products',
	insertable: false,
	updateable: false,
	deletable: false,
	upsertable: true,
	keys:['ProductID'],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	errorHandlingOption: 'stopOnFirstError',
	mapColumn(
		ProductID,
		Name,
		Category,
		Price
	)) ~> AzureSQLDBProducts
GiveUpsertPermissions4 sink(allowSchemaDrift: true,
	validateSchema: false,
	format: 'table',
	store: 'sqlserver',
	schemaName: 'dbo',
	tableName: 'Stores',
	insertable: false,
	updateable: false,
	deletable: false,
	upsertable: true,
	keys:['StoreID'],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true,
	errorHandlingOption: 'stopOnFirstError') ~> AzureSQLDBStores