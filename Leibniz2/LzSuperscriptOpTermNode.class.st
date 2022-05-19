Class {
	#name : #LzSuperscriptOpTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'args',
		'leftParen',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzSuperscriptOpTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitSuperscriptOpTerm: self
]

{ #category : #generated }
LzSuperscriptOpTermNode >> args [
	^ args
]

{ #category : #generated }
LzSuperscriptOpTermNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzSuperscriptOpTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzSuperscriptOpTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzSuperscriptOpTermNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
LzSuperscriptOpTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzSuperscriptOpTermNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzSuperscriptOpTermNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzSuperscriptOpTermNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzSuperscriptOpTermNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzSuperscriptOpTermNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzSuperscriptOpTermNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
