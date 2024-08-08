Class {
	#name : #LzPatternNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'term'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzPatternNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitPattern: self
]

{ #category : #generated }
LzPatternNode >> commas [
	^ commas
]

{ #category : #generated }
LzPatternNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzPatternNode >> compositeNodeVariables [
	^ #(#vars)
]

{ #category : #generated }
LzPatternNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzPatternNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzPatternNode >> nodeVariables [
	^ #(#term)
]

{ #category : #generated }
LzPatternNode >> term [
	^ term
]

{ #category : #generated }
LzPatternNode >> term: aLzParseTreeNode [
	self term notNil ifTrue: [ self term parent: nil ].
	term := aLzParseTreeNode.
	self term notNil ifTrue: [ self term parent: self ]
]

{ #category : #generated }
LzPatternNode >> vars [
	^ vars
]

{ #category : #generated }
LzPatternNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
