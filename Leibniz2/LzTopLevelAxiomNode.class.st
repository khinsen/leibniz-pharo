Class {
	#name : #LzTopLevelAxiomNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelAxiomNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelAxiom: self
]

{ #category : #generated }
LzTopLevelAxiomNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelAxiomNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelAxiomNode >> compositeNodeVariables [
	^ #(#vars)
]

{ #category : #generated }
LzTopLevelAxiomNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelAxiomNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelAxiomNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelAxiomNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
