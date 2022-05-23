Class {
	#name : #LzBook,
	#superclass : #Object,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #accessing }
LzBook >> database [
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

{ #category : #accessing }
LzBook >> databaseLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'documentation'
]

{ #category : #accessing }
LzBook >> databaseName [
	^ 'Leibniz documentation'
]
