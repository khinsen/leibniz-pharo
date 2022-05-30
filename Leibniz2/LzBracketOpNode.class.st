Class {
	#name : #LzBracketOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'leftBracket',
		'commas',
		'rightBracket'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzBracketOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitBracketOp: self
]

{ #category : #generated }
LzBracketOpNode >> commas [
	^ commas
]

{ #category : #generated }
LzBracketOpNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzBracketOpNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzBracketOpNode >> initialize [
	super initialize.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzBracketOpNode >> leftBracket [
	^ leftBracket
]

{ #category : #generated }
LzBracketOpNode >> leftBracket: aSmaCCToken [
	leftBracket := aSmaCCToken
]

{ #category : #generated }
LzBracketOpNode >> rightBracket [
	^ rightBracket
]

{ #category : #generated }
LzBracketOpNode >> rightBracket: aSmaCCToken [
	rightBracket := aSmaCCToken
]

{ #category : #generated }
LzBracketOpNode >> tokenVariables [
	^ #(#leftBracket #rightBracket)
]