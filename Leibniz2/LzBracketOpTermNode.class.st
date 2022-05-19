Class {
	#name : #LzBracketOpTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'args',
		'leftBracket',
		'commas',
		'rightBracket'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzBracketOpTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitBracketOpTerm: self
]

{ #category : #generated }
LzBracketOpTermNode >> args [
	^ args
]

{ #category : #generated }
LzBracketOpTermNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzBracketOpTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzBracketOpTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzBracketOpTermNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
LzBracketOpTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzBracketOpTermNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzBracketOpTermNode >> leftBracket [
	^ leftBracket
]

{ #category : #generated }
LzBracketOpTermNode >> leftBracket: aSmaCCToken [
	leftBracket := aSmaCCToken
]

{ #category : #generated }
LzBracketOpTermNode >> rightBracket [
	^ rightBracket
]

{ #category : #generated }
LzBracketOpTermNode >> rightBracket: aSmaCCToken [
	rightBracket := aSmaCCToken
]

{ #category : #generated }
LzBracketOpTermNode >> tokenVariables [
	^ #(#leftBracket #rightBracket)
]
