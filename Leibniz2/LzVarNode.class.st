Class {
	#name : #LzVarNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'varName',
		'colon',
		'sort'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzVarNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitVar: self
]

{ #category : #generated }
LzVarNode >> colon [
	^ colon
]

{ #category : #generated }
LzVarNode >> colon: aSmaCCToken [
	colon := aSmaCCToken
]

{ #category : #generated }
LzVarNode >> nodeVariables [
	^ #(#sort)
]

{ #category : #generated }
LzVarNode >> sort [
	^ sort
]

{ #category : #generated }
LzVarNode >> sort: aLzParseTreeNode [
	self sort notNil ifTrue: [ self sort parent: nil ].
	sort := aLzParseTreeNode.
	self sort notNil ifTrue: [ self sort parent: self ]
]

{ #category : #generated }
LzVarNode >> tokenVariables [
	^ #(#varName #colon)
]

{ #category : #generated }
LzVarNode >> varName [
	^ varName
]

{ #category : #generated }
LzVarNode >> varName: aSmaCCToken [
	varName := aSmaCCToken
]
