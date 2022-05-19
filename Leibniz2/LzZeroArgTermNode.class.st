Class {
	#name : #LzZeroArgTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'name'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzZeroArgTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitZeroArgTerm: self
]

{ #category : #generated }
LzZeroArgTermNode >> name [
	^ name
]

{ #category : #generated }
LzZeroArgTermNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
LzZeroArgTermNode >> tokenVariables [
	^ #(#name)
]
