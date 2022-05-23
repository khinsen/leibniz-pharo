Class {
	#name : #LzVarTermWithSortNode,
	#superclass : #LzVarTermNode,
	#instVars : [
		'colon',
		'sort'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzVarTermWithSortNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitVarTermWithSort: self
]

{ #category : #generated }
LzVarTermWithSortNode >> colon [
	^ colon
]

{ #category : #generated }
LzVarTermWithSortNode >> colon: aSmaCCToken [
	colon := aSmaCCToken
]

{ #category : #generated }
LzVarTermWithSortNode >> nodeVariables [
	^ #(#sort)
]

{ #category : #generated }
LzVarTermWithSortNode >> sort [
	^ sort
]

{ #category : #generated }
LzVarTermWithSortNode >> sort: aLzParseTreeNode [
	self sort notNil ifTrue: [ self sort parent: nil ].
	sort := aLzParseTreeNode.
	self sort notNil ifTrue: [ self sort parent: self ]
]

{ #category : #generated }
LzVarTermWithSortNode >> tokenVariables [
	^ #(#colon #varName)
]
