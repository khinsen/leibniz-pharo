Class {
	#name : #LzTopLevelEqualityAxiomNode,
	#superclass : #LzTopLevelAxiomNode,
	#instVars : [
		'left',
		'equals',
		'right',
		'condition'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelEqualityAxiom: self
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> condition [
	^ condition
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> condition: aLzParseTreeNode [
	self condition notNil ifTrue: [ self condition parent: nil ].
	condition := aLzParseTreeNode.
	self condition notNil ifTrue: [ self condition parent: self ]
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> equals [
	^ equals
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> equals: aSmaCCToken [
	equals := aSmaCCToken
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> left [
	^ left
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> left: aLzParseTreeNode [
	self left notNil ifTrue: [ self left parent: nil ].
	left := aLzParseTreeNode.
	self left notNil ifTrue: [ self left parent: self ]
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> nodeVariables [
	^ #(#left #right #condition)
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> right [
	^ right
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> right: aLzParseTreeNode [
	self right notNil ifTrue: [ self right parent: nil ].
	right := aLzParseTreeNode.
	self right notNil ifTrue: [ self right parent: self ]
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> tokenVariables [
	^ #(#equals)
]
