Class {
	#name : #LzTopLevelOpNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'op',
		'colon',
		'sort'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelOp: self
]

{ #category : #generated }
LzTopLevelOpNode >> colon [
	^ colon
]

{ #category : #generated }
LzTopLevelOpNode >> colon: aSmaCCToken [
	colon := aSmaCCToken
]

{ #category : #generated }
LzTopLevelOpNode >> nodeVariables [
	^ #(#op #sort)
]

{ #category : #generated }
LzTopLevelOpNode >> op [
	^ op
]

{ #category : #generated }
LzTopLevelOpNode >> op: aLzOpNode [
	self op notNil ifTrue: [ self op parent: nil ].
	op := aLzOpNode.
	self op notNil ifTrue: [ self op parent: self ]
]

{ #category : #generated }
LzTopLevelOpNode >> sort [
	^ sort
]

{ #category : #generated }
LzTopLevelOpNode >> sort: aLzParseTreeNode [
	self sort notNil ifTrue: [ self sort parent: nil ].
	sort := aLzParseTreeNode.
	self sort notNil ifTrue: [ self sort parent: self ]
]

{ #category : #generated }
LzTopLevelOpNode >> tokenVariables [
	^ #(#colon)
]
