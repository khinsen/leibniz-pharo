Class {
	#name : #LzOpENode,
	#superclass : #LzENode,
	#type : #variable,
	#instVars : [
		'opName'
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
