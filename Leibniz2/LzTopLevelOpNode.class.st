Class {
	#name : #LzTopLevelOpNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'op',
		'colon',
		'sort',
		'options'
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
LzTopLevelOpNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelOpNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelOpNode >> compositeNodeVariables [
	^ #(#vars #options)
]

{ #category : #generated }
LzTopLevelOpNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelOpNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
	options := OrderedCollection new: 2.
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
LzTopLevelOpNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelOpNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
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

{ #category : #generated }
LzTopLevelOpNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelOpNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
