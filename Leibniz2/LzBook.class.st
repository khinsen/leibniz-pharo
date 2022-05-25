Class {
	#name : #LzBook,
	#superclass : #Object,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #accessing }
LzBook class >> database [
	| logicalDB db |
	logicalDB := LeDatabasesRegistry defaultLogicalDatabase.
	db := logicalDB databases
		detect: [ :each | each databaseName = self databaseName ]
		ifNone: [
			| newDB |
			logicalDB properties addRegisteredDirectory: self databaseLocation.
			logicalDB reload.
			logicalDB databaseNamed: self databaseName
"			newDB := LeLocalStoreLoad current loadAndMonitorFrom: self databaseLocation.
			newDB databaseName: self databaseName.
			logicalDB addDB: newDB.
			newDB" ].
	^ db
]

{ #category : #accessing }
LzBook class >> databaseLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'documentation'
]

{ #category : #accessing }
LzBook class >> databaseName [
	^ 'Leibniz documentation'
]
