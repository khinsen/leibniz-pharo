Class {
	#name : #LzHtmlExporter,
	#superclass : #Object,
	#instVars : [
		'database',
		'targetDirectory',
		'mainPage'
	],
	#category : #'Leibniz2-Lepiter'
}

{ #category : #accessing }
LzHtmlExporter >> database [
	^ database
]

{ #category : #accessing }
LzHtmlExporter >> database: anObject [
	database := anObject
]

{ #category : #accessing }
LzHtmlExporter >> export [
	| targetDir |
	targetDir := self targetDirectory.
	targetDir ensureDeleteAll.
	targetDir ensureCreateDirectory.
	LeHtmlBookExporter new
		database: self database;
		mainPage: (self database pageNamed: mainPage);
		piece: (LeHtmlGtBookPiece fromFile: self htmlTemplateLocation);
		integerSequencer;
		addAssetResourcesFrom: self htmlAssetLocation;
		export;
		saveToRootDirectory: targetDir.
	^ targetDir
]

{ #category : #accessing }
LzHtmlExporter >> htmlAssetLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'assets'
]

{ #category : #accessing }
LzHtmlExporter >> htmlSinglePageTemplateLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'single-page-template.html'
]

{ #category : #accessing }
LzHtmlExporter >> htmlTemplateLocation [
	^ FileLocator imageDirectory
		/ 'pharo-local' / 'iceberg'
		/ 'khinsen' / 'leibniz-pharo' / 'html' / 'page-template.html'
]

{ #category : #accessing }
LzHtmlExporter >> mainPage [
	^ mainPage
]

{ #category : #accessing }
LzHtmlExporter >> mainPage: anObject [
	mainPage := anObject
]

{ #category : #accessing }
LzHtmlExporter >> targetDirectory [
	^ targetDirectory
]

{ #category : #accessing }
LzHtmlExporter >> targetDirectory: anObject [
	targetDirectory := anObject
]

{ #category : #accessing }
LzHtmlExporter >> targetDirectoryName: aString [
	self targetDirectory: aString asFileReference
]
