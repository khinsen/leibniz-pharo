Class {
	#name : #LzInfixOpNode,
	#superclass : #LzOpNode,
	#instVars : [
		'opName'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzInfixOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitInfixOp: self
]

{ #category : #generated }
LzInfixOpNode >> opName [
	^ opName
]

{ #category : #generated }
LzInfixOpNode >> opName: aSmaCCToken [
	opName := aSmaCCToken
]

{ #category : #generated }
LzInfixOpNode >> tokenVariables [
	^ #(#opName)
]
