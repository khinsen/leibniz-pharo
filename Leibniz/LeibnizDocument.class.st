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
	#category : #'Leibniz-Core'
}

{ #category : #'XML import' }
LeibnizDocument >> addContextFromXML: anXMLElement [
  	| name builder context |
	name := anXMLElement attributeAt: 'id'.
	builder := LeibnizContextBuilder name: name document: self.
	builder fromXML: anXMLElement.
	context := builder context.
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

{ #category : #'XML import' }
LeibnizDocument >> fromXML: anXMLElement [
	anXMLElement descendantElementsNamed: 'context' do: [ :c | self addContextFromXML: c ].

]

{ #category : #initialization }
LeibnizDocument >> initialize [
	contexts := Dictionary new.

]

{ #category : #adding }
LeibnizDocument >> newContextBuilderNamed: aString [
	| builder |
	builder := LeibnizContextBuilder name: aString document: self.
	contexts at: aString put: builder.
	^ builder.
]

{ #category : #adding }
LeibnizDocument >> replaceBuilderByContextNamed: aString [
	| builder |
	builder := contexts at: aString.
	contexts at: aString put: builder context.

]
