"
I represent an abstract Leibniz term. My subclasses represent concrete terms. 
"
Class {
	#name : #LbTerm,
	#superclass : #Object,
	#traits : 'EqualityThroughVariables',
	#classTraits : 'EqualityThroughVariables classTrait',
	#instVars : [
		'signature'
	],
	#category : #'Leibniz-3-Terms'
}

{ #category : #converting }
LbTerm >> asLeibnizSyntaxString [
	^ String streamContents: [ :s | self printAsLeibnizSyntaxOn: s ]
]

{ #category : #matching }
LbTerm >> assertNotAVariable [
	^ self
]

{ #category : #converting }
LbTerm >> convertToSignature: aSignature [
	^ self convertToSignature: aSignature extraVariables: Dictionary new.
]

{ #category : #converting }
LbTerm >> convertToSignature: aSignature extraVariables: aDictionary [
	self subclassResponsibility
]

{ #category : #private }
LbTerm >> hasInfixOpOtherThan: aSymbol [
	^ false
]

{ #category : #testing }
LbTerm >> isEqualityTerm [
	^ nil
]

{ #category : #testing }
LbTerm >> isInfix [
	"Answer true if the term is printed in infix notation."
	^ false.
]

{ #category : #testing }
LbTerm >> isTrue [
	"Answer true if the term the truth value 'true'."
	^ false.
]

{ #category : #matching }
LbTerm >> match: otherTerm [
	self = otherTerm
		ifTrue: [ ^ LbSubstitution new ]
		ifFalse: [ ^ nil ]
]

{ #category : #matching }
LbTerm >> matchOp: opSymbol andArgs: argList [
	^ nil
]

{ #category : #printing }
LbTerm >> printAsLeibnizSyntaxOn: aStream [
	self subclassResponsibility
]

{ #category : #printing }
LbTerm >> printAsLeibnizSyntaxOn: aStream parenthesized: aBoolean [
	aBoolean ifTrue: [ aStream nextPut: $(. ].
	self printAsLeibnizSyntaxOn: aStream.
	aBoolean ifTrue: [ aStream nextPut: $). ].

]

{ #category : #printing }
LbTerm >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printAsLeibnizSyntaxOn: aStream.
	aStream nextPut: $).

]

{ #category : #accessing }
LbTerm >> signature [
	^signature
]

{ #category : #accessing }
LbTerm >> sort [
	^self subclassResponsibility
]

{ #category : #substituting }
LbTerm >> substitute: aSubstitution [
	self subclassResponsibility
]

{ #category : #accessing }
LbTerm >> variables [
	self subclassResponsibility
]

{ #category : #transforming }
LbTerm >> withTransformedArgs: transformer [
	^ self
]
