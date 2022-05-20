Class {
	#name : #LzInfixOpTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'args',
		'opNames'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzInfixOpTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitInfixOpTerm: self
]

{ #category : #generated }
LzInfixOpTermNode >> args [
	^ args
]

{ #category : #generated }
LzInfixOpTermNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzInfixOpTermNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #generated }
LzInfixOpTermNode >> compositeTokenVariables [
	^ #(#opNames)
]

{ #category : #'generated-initialize-release' }
LzInfixOpTermNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
	opNames := OrderedCollection new: 2.
]

{ #category : #generated }
LzInfixOpTermNode >> opNames [
	^ opNames
]

{ #category : #generated }
LzInfixOpTermNode >> opNames: anOrderedCollection [
	opNames := anOrderedCollection
]
