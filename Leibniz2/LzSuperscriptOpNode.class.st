Class {
	#name : #LzSuperscriptOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'opName',
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
LzSuperscriptOpNode >> opName [
	^ opName
]

{ #category : #generated }
LzSuperscriptOpNode >> opName: aSmaCCToken [
	opName := aSmaCCToken
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
	^ #(#opName #rightParen)
]
