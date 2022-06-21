Class {
	#name : #LzSimpleOpArgNode,
	#superclass : #LzOpArgNode,
	#instVars : [
		'leftParen',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzSimpleOpArgNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitSimpleOpArg: self
]

{ #category : #generated }
LzSimpleOpArgNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzSimpleOpArgNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzSimpleOpArgNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzSimpleOpArgNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzSimpleOpArgNode >> tokenVariables [
	^ #(#leftParen #rightParen #name #colon)
]
