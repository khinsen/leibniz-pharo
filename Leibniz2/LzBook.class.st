Class {
	#name : #LzBook,
	#superclass : #Object,
	#category : #'Leibniz2-Infrastructure'
}

{ #category : #accessing }
LzBook class >> contextNamed: aString [
	| parts |
	parts := '/' split: aString.
	self assert: parts size < 3.
	^ parts size = 1
		ifTrue: [ self dbCache contextFor: aString ]
		ifFalse: [ self dbCache subcontext: parts second for: parts first ]
]

{ #category : #accessing }
LzBook class >> database [
	| logicalDB db |
	logicalDB := LeDatabasesRegistry defaultLogicalDatabase.
	db := logicalDB databases
		detect: [ :each | each databaseName = self databaseName ]
		ifNone: [
			self halt.
			logicalDB properties addRegisteredDirectory: self databaseLocation.
			logicalDB reload.
			logicalDB databaseNamed: self databaseName ].
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

{ #category : #accessing }
LzBook class >> dbCache [
	^ self database lzDBCache
]

{ #category : #accessing }
LzBook class >> exportHtml [
	^ LzHtmlExporter new
		database: self database;
		targetDirectoryName: 'leibniz-book-export';
		mainPage: 'Leibniz book';
		export
]

{ #category : #testing }
LzBook class >> hasPageNamed: aString [
	^ self database hasPageNamed: aString
]

{ #category : #accessing }
LzBook class >> latestEditTimeOfPageNamed: aString [
	"should be:
		(self pageNamed: aString) latestEditTime
	but this is note reliably updated upon editing"
	| snippetEditTimes |
	snippetEditTimes := (self pageNamed: aString) allChildrenDepthFirst
		collect: #latestEditTime.
	^ snippetEditTimes allButFirst inject: snippetEditTimes first
		into: [ :total :each | total max: each ]
]

{ #category : #accessing }
LzBook class >> pageNamed: aString [
	^ self database pageNamed: aString
]
