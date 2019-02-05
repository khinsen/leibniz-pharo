"
I represent an abstract Leibniz term. My subclasses represent concrete terms. 
"
Class {
	#name : #LeibnizTerm,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #converting }
LeibnizTerm >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #matching }
LeibnizTerm >> assertNotAVariable [
	^ self
]

{ #category : #private }
LeibnizTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LeibnizTerm >> isInfix [
	"Answer true if the term is printed in infix notation."
	^ false.
]

{ #category : #matching }
LeibnizTerm >> match: otherTerm [
	self = otherTerm
		ifTrue: [ ^ LeibnizSubstitution new ]
		ifFalse: [ ^ nil ]
]

{ #category : #matching }
LeibnizTerm >> matchOp: opSymbol andArgs: argList [
	^ nil
]

{ #category : #printing }
LeibnizTerm >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LeibnizTerm >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $(. ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $). ].

]

{ #category : #printing }
LeibnizTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
LeibnizTerm >> signature [
	^signature
]

{ #category : #accessing }
LeibnizTerm >> sort [
	^self subclassResponsibility
]

{ #category : #substituting }
LeibnizTerm >> substitute: aSubstitution [
	self subclassResponsibility
]

{ #category : #accessing }
LeibnizTerm >> variables [
	self subclassResponsibility
]
