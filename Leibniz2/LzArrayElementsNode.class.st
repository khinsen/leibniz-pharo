Class {
	#name : #LzArrayElementsNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'leftBracket',
		'elements',
		'commas',
		'rightBracket'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzArrayElementsNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitArrayElements: self
]

{ #category : #generated }
LzArrayElementsNode >> commas [
	^ commas
]

{ #category : #generated }
LzArrayElementsNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzArrayElementsNode >> compositeNodeVariables [
	^ #(#elements)
]

{ #category : #generated }
LzArrayElementsNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #generated }
LzArrayElementsNode >> elements [
	^ elements
]

{ #category : #generated }
LzArrayElementsNode >> elements: anOrderedCollection [
	self setParents: self elements to: nil.
	elements := anOrderedCollection.
	self setParents: self elements to: self
]

{ #category : #'generated-initialize-release' }
LzArrayElementsNode >> initialize [
	super initialize.
	elements := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzArrayElementsNode >> leftBracket [
	^ leftBracket
]

{ #category : #generated }
LzArrayElementsNode >> leftBracket: aSmaCCToken [
	leftBracket := aSmaCCToken
]

{ #category : #generated }
LzArrayElementsNode >> rightBracket [
	^ rightBracket
]

{ #category : #generated }
LzArrayElementsNode >> rightBracket: aSmaCCToken [
	rightBracket := aSmaCCToken
]

{ #category : #generated }
LzArrayElementsNode >> tokenVariables [
	^ #(#leftBracket #rightBracket)
]
