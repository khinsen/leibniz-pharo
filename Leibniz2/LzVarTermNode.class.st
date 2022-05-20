Class {
	#name : #LzVarTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'varName'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzVarTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitVarTerm: self
]

{ #category : #generated }
LzVarTermNode >> tokenVariables [
	^ #(#varName)
]

{ #category : #generated }
LzVarTermNode >> varName [
	^ varName
]

{ #category : #generated }
LzVarTermNode >> varName: aSmaCCToken [
	varName := aSmaCCToken
]
