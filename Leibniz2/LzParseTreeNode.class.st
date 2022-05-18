Class {
	#name : #LzParseTreeNode,
	#superclass : #SmaCCParseNode,
	#instVars : [
		'text'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzParseTreeNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitParseTree: self
]

{ #category : #generated }
LzParseTreeNode >> text [
	^ text
]

{ #category : #generated }
LzParseTreeNode >> text: aSmaCCToken [
	text := aSmaCCToken
]

{ #category : #generated }
LzParseTreeNode >> tokenVariables [
	^ #(#text)
]
