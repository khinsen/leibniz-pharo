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
LzBook class >> htmlSinglePageTemplateLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'single-page-template.html'
]

{ #category : #accessing }
LzBook class >> htmlTemplateLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'page-template.html'
]

{ #category : #baseline }
LzBook class >> installPatchesForHtmlExport [
	"Patch GT's HTML generation code to properly deal with \n and \t in Lepiter text snippets.
	 Submitted as a PR: https://github.com/feenkcom/lepiter/pull/6"
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

	exportedNodes add: aText'.

	"Patch GT's HTML generation code to wrap exported method source code in a <pre> tag.
	 Submitted as a PR: https://github.com/feenkcom/lepiter/pull/7"
	 LeHtmlTextSnippetAnnotationVisitor compile: 'visitMethodAnnotation: aMethodAnnotation
	| methodNameArgument method methodExists |
	methodNameArgument := aMethodAnnotation nameNode.
	method := methodNameArgument imageObject.
	methodExists := method isNotNil.

	context html
		inlineTag: #code
		attributes: {#class. ''annotation annotation-label annotation-label-method annotation-label-code expandable-annotation-label {1}''
				format: {(aMethodAnnotation isExpanded and: [ methodExists ])
							ifTrue: [ ''annotation-sibling-is-expanded'' ]
							ifFalse: [ ''annotation-sibling-is-collapsed'' ]}}
		with: (aMethodAnnotation hasLabel
				ifTrue: [ aMethodAnnotation label ]
				ifFalse: [ methodNameArgument fullName ]).
				
	methodExists ifFalse: [ ^ self ].
				
	context html 
		tag: #span
		attributes: {#class. ''textual-snippet code-snippet pharo-method-snippet expandable-annotation-view {1}''
				format: {(aMethodAnnotation isExpanded)
							ifTrue: [ ''expanded-annotation-view'' ]
							ifFalse: [ ''collapsed-annotation-view'' ]}}
		do: [ 
			context html
				inlineTag: #pre
				do: [
					context html
						inlineTag: #code
						attributes: #(''class'' '''')
						with: method sourceCode ] ]'.
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
