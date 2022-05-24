Class {
	#name : #LzPageReferenceNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'name',
		'equals',
		'value'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzPageReferenceNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitPageReference: self
]

{ #category : #generated }
LzPageReferenceNode >> equals [
	^ equals
]

{ #category : #generated }
LzPageReferenceNode >> equals: aSmaCCToken [
	equals := aSmaCCToken
]

{ #category : #generated }
LzPageReferenceNode >> name [
	^ name
]

{ #category : #generated }
LzPageReferenceNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
LzPageReferenceNode >> tokenVariables [
	^ #(#name #equals #value)
]

{ #category : #generated }
LzPageReferenceNode >> value [
	^ value
]

{ #category : #generated }
LzPageReferenceNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
