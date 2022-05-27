Class {
	#name : #LzTopLevelSortNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'op'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelSortNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelSort: self
]

{ #category : #generated }
LzTopLevelSortNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelSortNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelSortNode >> compositeNodeVariables [
	^ #(#vars)
]

{ #category : #generated }
LzTopLevelSortNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelSortNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
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

{ #category : #generated }
LzTopLevelSortNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelSortNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
