Class {
	#name : #LzSubscriptOpTermNode,
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
LzSubscriptOpTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitSubscriptOpTerm: self
]

{ #category : #generated }
LzSubscriptOpTermNode >> args [
	^ args
]

{ #category : #generated }
LzSubscriptOpTermNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzSubscriptOpTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzSubscriptOpTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzSubscriptOpTermNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
LzSubscriptOpTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzSubscriptOpTermNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzSubscriptOpTermNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzSubscriptOpTermNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzSubscriptOpTermNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzSubscriptOpTermNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzSubscriptOpTermNode >> tokenVariables [
	^ #(#leftParen #rightParen)
]
