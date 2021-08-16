Class {
	#name : 'LbDocumentation',
	#superclass : 'Object',
	#category : 'Leibniz-0-Infrastructure'
}

{ #category : 'accessing' }
LbDocumentation >> database [
	| logicalDB db |
	logicalDB := LeDatabasesRegistry uniqueInstance currentLoadedDefaultLogicalDatabase.
	db := logicalDB databases
		detect: [ :each | each databaseName = self databaseName ]
		ifNone: [
			| newDB |
			newDB := LeLocalStoreLoad current loadAndMonitorFrom: self databaseLocation.
			newDB databaseName: self databaseName.
			logicalDB addDB: newDB.
			newDB ].
	^ db
]

{ #category : 'accessing' }
LbDocumentation >> databaseLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'documentation'
]

{ #category : 'accessing' }
LbDocumentation >> databaseName [
	^ 'Leibniz documentation'
]
