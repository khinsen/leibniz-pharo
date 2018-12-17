"
I represent a Leibniz document containing named contexts and references to other Leibniz documents.

"
Class {
	#name : #LeibnizDocument,
	#superclass : #Object,
	#instVars : [
		'docHash',
		'contexts',
		'library'
	],
	#category : #'Leibniz-Core'
}

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
	^ self new fromXML: anXMLElement
]

{ #category : #'XML-import' }
LeibnizDocument >> addContextFromXML: anXMLElement [
  	| context |
	context := LeibnizContext new fromXML: anXMLElement inDocument: self.
	contexts at: context name put: context.

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

{ #category : #initialization }
LeibnizDocument >> initialize [
	library := LeibnizLibrary uniqueInstance.
	contexts := Dictionary new.

]

{ #category : #adding }
LeibnizDocument >> newContextNamed: aString [
	| context |
	context := LeibnizContext withName: aString inDocument: self.
	contexts at: aString put: context.
	^ context.
]

{ #category : #accessing }
LeibnizDocument >> resolveContextReference: aDictionary [
	| doc |
	doc := (aDictionary includesKey: #document)
				ifTrue: [ library documentWithHash: (aDictionary at: #document) ]
				ifFalse: [ self ].
	^ doc contextNamed: (aDictionary at: #context)

]
