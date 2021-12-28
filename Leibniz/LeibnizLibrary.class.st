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
	#category : 'Leibniz-8-Documents'
}

{ #category : #'instance creation' }
LeibnizLibrary class >> new [
	self error: 'Use #uniqueInstance'
]

{ #category : #'instance creation' }
LeibnizLibrary class >> reset [
	<script>
	uniqueInstance := nil.

]

{ #category : #accessing }
LeibnizLibrary class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := super new ]
]

{ #category : #accessing }
LeibnizLibrary >> XMLWithHash: aString [ 
	| file dom docElements |
	file := self fileWithHash: aString.
	dom := XMLDOMParser parse: file readStream.
	docElements := dom root descendantElementsNamed: 'leibniz-document'.
	self assert: docElements size equals: 1.
	^docElements at: 1

]

{ #category : #accessing }
LeibnizLibrary >> addDocument: aDocument [
	documents at: aDocument docHash put: aDocument

]

{ #category : #accessing }
LeibnizLibrary >> builtins [
	^self documentWithHash: (SHA256 hashMessage: 'builtins') hex
]

{ #category : #accessing }
LeibnizLibrary >> contextNamed: aContextName inDocumentWithHash: aDocHash [
	| doc |
	doc := self documentWithHash: aDocHash.
	^ doc contextNamed: aContextName.

]

{ #category : #accessing }
LeibnizLibrary >> documentWithHash: aString [ 
	| doc |
	^ documents
		at: aString
		ifAbsentPut: [
			doc := LeibnizDocument new fromXML: (self XMLWithHash: aString).
			doc docHash: aString.
			doc ]

]

{ #category : #accessing }
LeibnizLibrary >> fileWithHash: aString [ 
	| file |
	"TODO: implement a more complete lookup scheme."
	file := FileLocator home / '.leibniz' / (aString , '.html').
	"Check that the document's hash is equal to the requested one."
	self assert: (SHA256 hashStream: file binaryReadStream) hex equals: aString.
	^file

]

{ #category : #initialization }
LeibnizLibrary >> initialize [
	documents := Dictionary new.
	self addDocument: LeibnizBuiltins new.
]
