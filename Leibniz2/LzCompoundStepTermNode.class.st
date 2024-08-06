Class {
	#name : #LzCompoundStepTermNode,
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
LzCompoundStepTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitCompoundStepTerm: self
]

{ #category : #generated }
LzCompoundStepTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzCompoundStepTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzCompoundStepTermNode >> compositeNodeVariables [
	^ #(#steps)
]

{ #category : #generated }
LzCompoundStepTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzCompoundStepTermNode >> initialize [
	super initialize.
	steps := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzCompoundStepTermNode >> leftDelimiter [
	^ leftDelimiter
]

{ #category : #generated }
LzCompoundStepTermNode >> leftDelimiter: aSmaCCToken [
	leftDelimiter := aSmaCCToken
]

{ #category : #generated }
LzCompoundStepTermNode >> rightDelimiter [
	^ rightDelimiter
]

{ #category : #generated }
LzCompoundStepTermNode >> rightDelimiter: aSmaCCToken [
	rightDelimiter := aSmaCCToken
]

{ #category : #generated }
LzCompoundStepTermNode >> steps [
	^ steps
]

{ #category : #generated }
LzCompoundStepTermNode >> steps: anOrderedCollection [
	self setParents: self steps to: nil.
	steps := anOrderedCollection.
	self setParents: self steps to: self
]

{ #category : #generated }
LzCompoundStepTermNode >> tokenVariables [
	^ #(#leftDelimiter #rightDelimiter)
]
