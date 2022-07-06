Class {
	#name : #LzTupleTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'leftParen',
		'args',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTupleTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTupleTerm: self
]

{ #category : #generated }
LzTupleTermNode >> args [
	^ args
]

{ #category : #generated }
LzTupleTermNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzTupleTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzTupleTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTupleTermNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
LzTupleTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTupleTermNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzTupleTermNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzTupleTermNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzTupleTermNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzTupleTermNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzTupleTermNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
