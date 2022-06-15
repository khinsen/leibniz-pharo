Class {
	#name : #LzTopLevelSpecialTermsNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'specialTerms',
		'commas',
		'options'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelSpecialTermsNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelSpecialTerms: self
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> compositeNodeVariables [
	^ #(#options)
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> compositeTokenVariables [
	^ #(#specialTerms #commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelSpecialTermsNode >> initialize [
	super initialize.
	specialTerms := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> specialTerms [
	^ specialTerms
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> specialTerms: anOrderedCollection [
	specialTerms := anOrderedCollection
]
