Class {
	#name : #LzTopLevelSpecialTermsNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'specialTerms',
		'commas'
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
LzTopLevelSpecialTermsNode >> compositeTokenVariables [
	^ #(#specialTerms #commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelSpecialTermsNode >> initialize [
	super initialize.
	specialTerms := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> specialTerms [
	^ specialTerms
]

{ #category : #generated }
LzTopLevelSpecialTermsNode >> specialTerms: anOrderedCollection [
	specialTerms := anOrderedCollection
]
