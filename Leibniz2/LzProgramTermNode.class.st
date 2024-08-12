Class {
	#name : #LzProgramTermNode,
	#superclass : #LzTermNode,
	#instVars : [
		'leftDelimiter',
		'steps',
		'semicolons',
		'rightDelimiter'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzProgramTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitProgramTerm: self
]

{ #category : #generated }
LzProgramTermNode >> compositeNodeVariables [
	^ #(#steps)
]

{ #category : #generated }
LzProgramTermNode >> compositeTokenVariables [
	^ #(#semicolons)
]

{ #category : #'generated-initialize-release' }
LzProgramTermNode >> initialize [
	super initialize.
	steps := OrderedCollection new: 2.
	semicolons := OrderedCollection new: 2.
]

{ #category : #generated }
LzProgramTermNode >> leftDelimiter [
	^ leftDelimiter
]

{ #category : #generated }
LzProgramTermNode >> leftDelimiter: aSmaCCToken [
	leftDelimiter := aSmaCCToken
]

{ #category : #generated }
LzProgramTermNode >> rightDelimiter [
	^ rightDelimiter
]

{ #category : #generated }
LzProgramTermNode >> rightDelimiter: aSmaCCToken [
	rightDelimiter := aSmaCCToken
]

{ #category : #generated }
LzProgramTermNode >> semicolons [
	^ semicolons
]

{ #category : #generated }
LzProgramTermNode >> semicolons: anOrderedCollection [
	semicolons := anOrderedCollection
]

{ #category : #generated }
LzProgramTermNode >> steps [
	^ steps
]

{ #category : #generated }
LzProgramTermNode >> steps: anOrderedCollection [
	self setParents: self steps to: nil.
	steps := anOrderedCollection.
	self setParents: self steps to: self
]

{ #category : #generated }
LzProgramTermNode >> tokenVariables [
	^ #(#leftDelimiter #rightDelimiter)
]
