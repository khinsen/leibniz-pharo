Class {
	#name : #LzVarTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzVarTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitVarTerm: self
]

{ #category : #generated }
LzVarTermNode >> name [
	^ name
]

{ #category : #generated }
LzVarTermNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
LzVarTermNode >> tokenVariables [
	^ #(#name)
]
