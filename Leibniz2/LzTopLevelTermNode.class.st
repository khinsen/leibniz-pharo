Class {
	#name : #LzTopLevelTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'term'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelTerm: self
]

{ #category : #generated }
LzTopLevelTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelTermNode >> compositeNodeVariables [
	^ #(#vars)
]

{ #category : #generated }
LzTopLevelTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelTermNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelTermNode >> nodeVariables [
	^ #(#term)
]

{ #category : #generated }
LzTopLevelTermNode >> term [
	^ term
]

{ #category : #generated }
LzTopLevelTermNode >> term: aLzParseTreeNode [
	self term notNil ifTrue: [ self term parent: nil ].
	term := aLzParseTreeNode.
	self term notNil ifTrue: [ self term parent: self ]
]

{ #category : #generated }
LzTopLevelTermNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelTermNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
