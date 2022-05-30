Class {
	#name : #LzSubscriptOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'leftParen',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzSubscriptOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitSubscriptOp: self
]

{ #category : #generated }
LzSubscriptOpNode >> commas [
	^ commas
]

{ #category : #generated }
LzSubscriptOpNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzSubscriptOpNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzSubscriptOpNode >> initialize [
	super initialize.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzSubscriptOpNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzSubscriptOpNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzSubscriptOpNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzSubscriptOpNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzSubscriptOpNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
