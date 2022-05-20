Class {
	#name : #LzTopLevelSortNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'op'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelSortNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelSort: self
]

{ #category : #generated }
LzTopLevelSortNode >> nodeVariables [
	^ #(#op)
]

{ #category : #generated }
LzTopLevelSortNode >> op [
	^ op
]

{ #category : #generated }
LzTopLevelSortNode >> op: aLzOpNode [
	self op notNil ifTrue: [ self op parent: nil ].
	op := aLzOpNode.
	self op notNil ifTrue: [ self op parent: self ]
]
