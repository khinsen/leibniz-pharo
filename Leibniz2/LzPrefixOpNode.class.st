Class {
	#name : #LzPrefixOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'leftParen',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzPrefixOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitPrefixOp: self
]

{ #category : #generated }
LzPrefixOpNode >> commas [
	^ commas
]

{ #category : #generated }
LzPrefixOpNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzPrefixOpNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzPrefixOpNode >> initialize [
	super initialize.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzPrefixOpNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzPrefixOpNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzPrefixOpNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzPrefixOpNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzPrefixOpNode >> tokenVariables [
	^ #(#leftParen #rightParen #opName)
]
