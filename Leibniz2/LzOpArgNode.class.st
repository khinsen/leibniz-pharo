Class {
	#name : #LzOpArgNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'name',
		'colon',
		'sort'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzOpArgNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitOpArg: self
]

{ #category : #generated }
LzOpArgNode >> colon [
	^ colon
]

{ #category : #generated }
LzOpArgNode >> colon: aSmaCCToken [
	colon := aSmaCCToken
]

{ #category : #generated }
LzOpArgNode >> name [
	^ name
]

{ #category : #generated }
LzOpArgNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
LzOpArgNode >> nodeVariables [
	^ #(#sort)
]

{ #category : #generated }
LzOpArgNode >> sort [
	^ sort
]

{ #category : #generated }
LzOpArgNode >> sort: aLzParseTreeNode [
	self sort notNil ifTrue: [ self sort parent: nil ].
	sort := aLzParseTreeNode.
	self sort notNil ifTrue: [ self sort parent: self ]
]

{ #category : #generated }
LzOpArgNode >> tokenVariables [
	^ #(#name #colon)
]
