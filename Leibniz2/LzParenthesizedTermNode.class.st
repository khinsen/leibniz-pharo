Class {
	#name : #LzParenthesizedTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'leftParen',
		'term',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParenthesizedTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitParenthesizedTerm: self
]

{ #category : #generated }
LzParenthesizedTermNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzParenthesizedTermNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzParenthesizedTermNode >> nodeVariables [
	^ #(#term)
]

{ #category : #generated }
LzParenthesizedTermNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzParenthesizedTermNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzParenthesizedTermNode >> term [
	^ term
]

{ #category : #generated }
LzParenthesizedTermNode >> term: aLzParseTreeNode [
	self term notNil ifTrue: [ self term parent: nil ].
	term := aLzParseTreeNode.
	self term notNil ifTrue: [ self term parent: self ]
]

{ #category : #generated }
LzParenthesizedTermNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
