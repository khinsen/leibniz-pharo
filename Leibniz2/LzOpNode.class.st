Class {
	#name : #LzOpNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'args'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzOpNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitOp: self
]

{ #category : #generated }
LzOpNode >> args [
	^ args
]

{ #category : #generated }
LzOpNode >> args: anOrderedCollection [
	self setParents: self args to: nil.
	args := anOrderedCollection.
	self setParents: self args to: self
]

{ #category : #generated }
LzOpNode >> compositeNodeVariables [
	^ #(#args)
]

{ #category : #'generated-initialize-release' }
LzOpNode >> initialize [
	super initialize.
	args := OrderedCollection new: 2.
]
