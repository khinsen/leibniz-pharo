Class {
	#name : #LzArrayENode,
	#superclass : #LzNonLeafENode,
	#type : #variable,
	#instVars : [
		'shape'
	],
	#category : #'Leibniz2-EGraphs'
}

{ #category : #comparing }
LzArrayENode >> = otherObject [
	self == otherObject ifTrue: [ ^ true ].
	self class == otherObject class ifFalse: [ ^ false ].
	self shape = otherObject shape ifFalse: [ ^ false ].
	^ self hasEqualElements: otherObject
]

{ #category : #converting }
LzArrayENode >> addAsRopedTextTo: aRopedText [
	| elementENodes |
	elementENodes := self collect: [ :each |
		(graph classForId: each) anyNode ].
	aRopedText append: '{' asRopedText.
	self
		addElementsOf: elementENodes
		shape: self shape
		asRopedTextTo: aRopedText.
	aRopedText append: '}' asRopedText
]

{ #category : #printing }
LzArrayENode >> addElementsOf: anArray shape: shapeArray asRopedTextTo: aRopedText [
	| elementShape elementSize index |
	elementShape := shapeArray allButFirst.
	elementSize := elementShape inject: 1 into: [ :product :each | product * each ].
	index := 1.
	aRopedText append: '[' asRopedText.
	1 to: shapeArray first do: [ :each |
		elementShape
			ifEmpty: [  (anArray at: index) addAsRopedTextTo: aRopedText ]
			ifNotEmpty: [
				self
					addElementsOf: (anArray copyFrom: index to: index + elementSize - 1)
					shape: elementShape
					asRopedTextTo: aRopedText ].
		index := index + elementSize.
		index > anArray size ifFalse: [ aRopedText append: ', ' asRopedText ] ].
	aRopedText append: ']' asRopedText
]

{ #category : #enumerating }
LzArrayENode >> allTerms [
	| signature |
	self assert: self hasCycle not.
	signature := graph context signature.
	^ self
		ifEmpty: [ { signature arrayTerm: #() shape: self shape } ]
		ifNotEmpty: [
			Generator on: [ :generator |
				(self allArgTerms: self) do: [ :elements |
					generator yield: (signature arrayTerm: elements shape: self shape) ] ] ]
]

{ #category : #comparing }
LzArrayENode >> hash [
	^ shape hash bitXor:  super hash
]

{ #category : #accessing }
LzArrayENode >> matchesFor: aPattern bindings: bindings [
	^ aPattern matchArrayENode: self bindings: bindings
]

{ #category : #printing }
LzArrayENode >> printAsLeibnizSyntaxOn: aStream parents: aNodeSet [
	| elementENodes |
	(aNodeSet includes: self)
		ifTrue: [ aStream nextPut: $⃞ ]
		ifFalse: [
			| parents |
			parents := aNodeSet copyWith: self.
			elementENodes := self collect: [ :each |
				(graph classForId: each) anyNode ].
			aStream nextPut: ${.
			self
				printElements: elementENodes
				shape: self shape
				on: aStream
				parents: parents.
			aStream nextPut: $} ]
]

{ #category : #printing }
LzArrayENode >> printElements: anArray shape: shapeArray on: aStream parents: parents [
	| elementShape elementSize index |
	elementShape := shapeArray allButFirst.
	elementSize := elementShape inject: 1 into: [ :product :each | product * each ].
	index := 1.
	aStream << $[.
	1 to: shapeArray first do: [ :each |
		elementShape
			ifEmpty: [ (anArray at: index) printAsLeibnizSyntaxOn: aStream parents: parents ]
			ifNotEmpty: [
				self
					printElements: (anArray copyFrom: index to: index + elementSize - 1)
					shape: elementShape
					on: aStream
					parents: parents ].
		index := index + elementSize.
		index > anArray size ifFalse: [ aStream << ', ' ] ].
	aStream << $]
]

{ #category : #accessing }
LzArrayENode >> shape [
	^ shape
]

{ #category : #accessing }
LzArrayENode >> shape: anArray [
	shape := anArray
]
