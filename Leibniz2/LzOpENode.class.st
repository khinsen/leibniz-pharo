Class {
	#name : #LzOpENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'opName',
		'sort'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #comparing }
LzOpENode >> = otherObject [
	self == otherObject ifTrue: [ ^ true ].
	self class == otherObject class ifFalse: [ ^ false ].
	self opName = otherObject opName ifFalse: [ ^ false ].
	^ self hasEqualElements: otherObject
]

{ #category : #enumerating }
LzOpENode >> allArgTerms: classIds [
	classIds ifEmpty: [ ^ #(#()) ].
	^ Generator on: [ :generator |
		(graph classForId: classIds first)
			allTerms do: [ :firstArg |
				(self allArgTerms: classIds allButFirst) do: [ :restArgs |
					generator yield: { firstArg }, restArgs ]   ] ]
]

{ #category : #enumerating }
LzOpENode >> allTerms [
	| signature |
	signature := graph signature.
	^ self
		ifEmpty: [ { signature opTerm: self opName args: #() } ]
		ifNotEmpty: [
			Generator on: [ :generator |
				(self allArgTerms: self) do: [ :args |
					generator yield: (signature opTerm: self opName args: args) ] ] ]
]

{ #category : #printing }
LzOpENode >> hasInfixOpOtherThan: anOpName [
	^ opName isInfixOpOtherThan: anOpName
]

{ #category : #comparing }
LzOpENode >> hash [
	^ opName hash bitXor:  super hash
]

{ #category : #testing }
LzOpENode >> isInfix [
	^ opName isInfix
]

{ #category : #matching }
LzOpENode >> matchesFor: aPattern bindings: bindings [
	^ aPattern matchOpENode: self bindings: bindings
]

{ #category : #accessing }
LzOpENode >> opName [
	^ opName
]

{ #category : #accessing }
LzOpENode >> opName: anOpName [
	opName := anOpName
]

{ #category : #printing }
LzOpENode >> printAsLeibnizSyntaxOn: aStream [
	| argENodes |
	argENodes := self collect: [ :each |
		(graph classForId: each) anyNode ].
	opName printForArgs: argENodes on: aStream
]

{ #category : #accessing }
LzOpENode >> sort [
	^ sort
]

{ #category : #accessing }
LzOpENode >> sort: aSort [
	sort := aSort
]
