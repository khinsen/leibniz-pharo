Class {
	#name : #LzTupleOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'leftParen',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTupleOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTupleOp: self
]

{ #category : #generated }
LzTupleOpNode >> commas [
	^ commas
]

{ #category : #generated }
LzTupleOpNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTupleOpNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTupleOpNode >> initialize [
	super initialize.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzTupleOpNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzTupleOpNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzTupleOpNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzTupleOpNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzTupleOpNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
