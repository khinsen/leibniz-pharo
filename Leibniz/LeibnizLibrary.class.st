"
My unique instance represents the library of available Leibniz documents.

"
Class {
	#name : #LeibnizLibrary,
	#superclass : #Object,
	#instVars : [
		'documents'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Leibniz
}

{ #category : #'instance creation' }
LeibnizLibrary class >> new [
	self error: 'Use #uniqueInstance'
]

{ #category : #accessing }
LeibnizLibrary class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #accessing }
LeibnizLibrary >> add: aDocument [
	documents at: aDocument docHash put: aDocument

]

{ #category : #accessing }
LeibnizLibrary >> documentWithHash: aString [ 
	| file doc |
	^ documents
		at: aString
		ifAbsentPut: [
			"TODO: implement a more complete lookup scheme."
			file := FileLocator home / '.leibniz' / (aString , '.html').
			"Check that the document's hash is equal to the requested one."
			self assert: (SHA256 hashStream: file binaryReadStream) hex equals: aString.
			doc := LeibnizDocument fromStream: file readStream.
			doc docHash: aString.
			doc ]

]

{ #category : #initialization }
LeibnizLibrary >> initialize [
	documents := Dictionary new.

]
