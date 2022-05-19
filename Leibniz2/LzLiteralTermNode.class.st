Class {
	#name : #LzLiteralTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'text'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzLiteralTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitLiteralTerm: self
]

{ #category : #generated }
LzLiteralTermNode >> text [
	^ text
]

{ #category : #generated }
LzLiteralTermNode >> text: aSmaCCToken [
	text := aSmaCCToken
]

{ #category : #generated }
LzLiteralTermNode >> tokenVariables [
	^ #(#text)
]
