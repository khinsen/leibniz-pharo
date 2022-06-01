Class {
	#name : #LzTopLevelSortNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'op',
		'options'
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
	^ #(#vars #options)
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
	options := OrderedCollection new: 2.
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
LzTopLevelSortNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelSortNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
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
