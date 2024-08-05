Class {
	#name : #LzStepTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'leftDelimiter',
		'steps',
		'commas',
		'rightDelimiter'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzStepTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitStepTerm: self
]

{ #category : #generated }
LzStepTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzStepTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzStepTermNode >> compositeNodeVariables [
	^ #(#steps)
]

{ #category : #generated }
LzStepTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzStepTermNode >> initialize [
	super initialize.
	steps := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzStepTermNode >> leftDelimiter [
	^ leftDelimiter
]

{ #category : #generated }
LzStepTermNode >> leftDelimiter: aSmaCCToken [
	leftDelimiter := aSmaCCToken
]

{ #category : #generated }
LzStepTermNode >> rightDelimiter [
	^ rightDelimiter
]

{ #category : #generated }
LzStepTermNode >> rightDelimiter: aSmaCCToken [
	rightDelimiter := aSmaCCToken
]

{ #category : #generated }
LzStepTermNode >> steps [
	^ steps
]

{ #category : #generated }
LzStepTermNode >> steps: anOrderedCollection [
	self setParents: self steps to: nil.
	steps := anOrderedCollection.
	self setParents: self steps to: self
]

{ #category : #generated }
LzStepTermNode >> tokenVariables [
	^ #(#leftDelimiter #rightDelimiter)
]
