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
	| book mainPage targetDirName targetDir aBookExporter |
	book := self database.
	mainPage := book pageNamed: 'Leibniz book'.
	targetDirName := 'leibniz-book-export'.
	targetDir := targetDirName asFileReference.
	targetDir ensureDeleteAll.
	targetDir ensureCreateDirectory.
	aBookExporter := LeHtmlBookExporter new
	        database: book;
	        mainPage: mainPage;
	        piece: (LeHtmlGtBookPiece fromFile: self htmlTemplateLocation);
	        integerSequencer;
	        addAssetResourcesFrom: self htmlAssetLocation;
	        export;
	        saveToRootDirectory: targetDir.
	^ targetDir
]

{ #category : #testing }
LzBook class >> hasPageNamed: aString [
	^ self database hasPageNamed: aString
]

{ #category : #accessing }
LzBook class >> htmlAssetLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'assets'
]

{ #category : #accessing }
LzBook class >> htmlTemplateLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'page-template.html'
]

{ #category : #baseline }
LzBook class >> installPatchForHtmlExport [
	"Patch GT's HTML generation code to properly deal with \n and \t in Lepiter text snippets.
	 Also submitted as a PR: https://github.com/feenkcom/lepiter/pull/6"
	LeHtmlTextSnippetVisitor compile: 'visitText: aText
	| aString |
	aString := aText content.
	aString size = 1
		ifFalse: [ context html escape: aString ]
		ifTrue: [
	aString first = Character lf
		ifTrue: [ context html nextPutAll: ''<br>'' ]
		ifFalse: [
	aString first = Character tab
		ifTrue: [ context html nextPutAll: ''&emsp;'' ]
		ifFalse: [ context html escape: aString ] ] ].

	exportedNodes add: aText'
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
