Class {
	#name : #LzSuperscriptOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'leftParen',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzSuperscriptOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitSuperscriptOp: self
]

{ #category : #generated }
LzSuperscriptOpNode >> commas [
	^ commas
]

{ #category : #generated }
LzSuperscriptOpNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzSuperscriptOpNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzSuperscriptOpNode >> initialize [
	super initialize.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzSuperscriptOpNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzSuperscriptOpNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzSuperscriptOpNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzSuperscriptOpNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzSuperscriptOpNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
