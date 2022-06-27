Class {
	#name : #LzOpENode,
	#superclass : #LzNonLeafENode,
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

{ #category : #converting }
LzOpENode >> addAsRopedTextTo: aRopedText [
	| argENodes |
	argENodes := self collect: [ :each |
		(graph classForId: each) anyNode ].
	opName
		addForArgs: argENodes
		asRopedTextTo: aRopedText
]

{ #category : #enumerating }
LzOpENode >> allTerms [
	| signature |
	self assert: self hasCycle not.
	signature := graph context signature.
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
LzOpENode >> printAsLeibnizSyntaxOn: aStream parents: aNodeSet [
	| argENodes |
	(aNodeSet includes: self)
		ifTrue: [ aStream nextPut: $⃞ ]
		ifFalse: [
			| parents |
			parents := aNodeSet copyWith: self.
			argENodes := self collect: [ :each |
				(graph classForId: each) anyNode ].
			opName
				printForArgs: argENodes
				on: aStream
				parents: parents ]
]
