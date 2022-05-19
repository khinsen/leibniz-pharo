Class {
	#name : #LzPrefixOpTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'name',
		'leftParen',
		'args',
		'commas',
		'rightParen'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzPrefixOpTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitPrefixOpTerm: self
]

{ #category : #generated }
LzPrefixOpTermNode >> args [
	^ args
]

{ #category : #generated }
LzPrefixOpTermNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzPrefixOpTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzPrefixOpTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzPrefixOpTermNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
LzPrefixOpTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzPrefixOpTermNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzPrefixOpTermNode >> leftParen [
	^ leftParen
]

{ #category : #generated }
LzPrefixOpTermNode >> leftParen: aSmaCCToken [
	leftParen := aSmaCCToken
]

{ #category : #generated }
LzPrefixOpTermNode >> name [
	^ name
]

{ #category : #generated }
LzPrefixOpTermNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
LzPrefixOpTermNode >> rightParen [
	^ rightParen
]

{ #category : #generated }
LzPrefixOpTermNode >> rightParen: aSmaCCToken [
	rightParen := aSmaCCToken
]

{ #category : #generated }
LzPrefixOpTermNode >> tokenVariables [
	^ #(#name #leftParen #rightParen)
]
