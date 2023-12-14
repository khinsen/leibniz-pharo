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
LzBook class >> exportHtml [
	| aLzBook aMainPage targetDirName targetDir aBookExporter |
	aLzBook := LeDatabasesRegistry defaultLogicalDatabase
    	    databaseNamed: 'Leibniz documentation'.
	aMainPage := aLzBook pageNamed: 'Leibniz book'.
	targetDirName := 'book-export'.
	targetDir := targetDirName asFileReference.
	targetDir ensureDeleteAll.
	targetDir ensureCreateDirectory.
	aBookExporter := LeHtmlBookExporter new
	        database: aLzBook;
	        mainPage: aMainPage;
	        piece: LeHtmlGtBookPiece gtBook;
	        integerSequencer;
	        addGtBookAssets;
	        export;
	        saveToRootDirectory: targetDir.
	^ targetDir
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
