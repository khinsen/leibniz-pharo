Class {
	#name : #LzArrayTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'leftBrace',
		'arrayElements',
		'rightBrace'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzArrayTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitArrayTerm: self
]

{ #category : #generated }
LzArrayTermNode >> arrayElements [
	^ arrayElements
]

{ #category : #generated }
LzArrayTermNode >> arrayElements: aLzArrayElementsNode [
	self arrayElements notNil ifTrue: [ self arrayElements parent: nil ].
	arrayElements := aLzArrayElementsNode.
	self arrayElements notNil ifTrue: [ self arrayElements parent: self ]
]

{ #category : #generated }
LzArrayTermNode >> leftBrace [
	^ leftBrace
]

{ #category : #generated }
LzArrayTermNode >> leftBrace: aSmaCCToken [
	leftBrace := aSmaCCToken
]

{ #category : #generated }
LzArrayTermNode >> nodeVariables [
	^ #(#arrayElements)
]

{ #category : #generated }
LzArrayTermNode >> rightBrace [
	^ rightBrace
]

{ #category : #generated }
LzArrayTermNode >> rightBrace: aSmaCCToken [
	rightBrace := aSmaCCToken
]

{ #category : #generated }
LzArrayTermNode >> tokenVariables [
	^ #(#leftBrace #rightBrace)
]
