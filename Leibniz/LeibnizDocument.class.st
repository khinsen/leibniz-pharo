"
I represent a Leibniz document containing named contexts and references to other Leibniz documents.

"
Class {
	#name : #LeibnizDocument,
	#superclass : #Object,
	#instVars : [
		'docHash',
		'contexts'
	],
	#category : #Leibniz
}

{ #category : #'instance creation' }
LeibnizDocument class >> fromDocHash: aString [ 
	| file doc |
	"TODO: implement a more complete lookup scheme."
	file := FileLocator home / '.leibniz' / (aString , '.html').
	"Check that the document's hash is equal to the requested one."
	self assert: (SHA256 hashStream: file binaryReadStream) hex equals: aString.
	doc := self fromStream: file readStream.
	doc docHash: aString.
	^ doc
]

{ #category : #'instance creation' }
LeibnizDocument class >> fromStream: aStream [
	| dom docElements docElement |
	dom := XMLDOMParser parse: aStream.
	docElements := dom root descendantElementsNamed: 'leibniz-document'.
	self assert: docElements size equals: 1.
	docElement := docElements at: 1.
	^ self fromXML: docElement
]

{ #category : #'instance creation' }
LeibnizDocument class >> fromXML: anXMLElement [ 
	^ self new fromXML: anXMLElement.
]

{ #category : #adding }
LeibnizDocument >> addContext: aContext [
	contexts at: aContext name put: aContext.

]

{ #category : #adding }
LeibnizDocument >> addContext: aContext named: aString [
	contexts at: aString put: aContext.

]

{ #category : #'XML-import' }
LeibnizDocument >> addContextFromXML: anXMLElement [
  	| context |
	context := LeibnizContext new fromXML: anXMLElement.
	self addContext: context.

]

{ #category : #accessing }
LeibnizDocument >> contextNamed: aString [
	^ contexts at: aString.

]

{ #category : #accessing }
LeibnizDocument >> contexts [
	^ contexts.
]

{ #category : #accessing }
LeibnizDocument >> docHash [
	^ docHash
]

{ #category : #accessing }
LeibnizDocument >> docHash: anObject [
	docHash := anObject
]

{ #category : #'XML-import' }
LeibnizDocument >> fromXML: anXMLElement [
	anXMLElement descendantElementsNamed: 'context' do: [ :c | self addContextFromXML: c ].

]

{ #category : #initializing }
LeibnizDocument >> initialize [
	contexts := Dictionary new.

]
