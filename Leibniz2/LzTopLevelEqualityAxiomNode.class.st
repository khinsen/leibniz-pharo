Class {
	#name : #LzTopLevelEqualityAxiomNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'left',
		'equals',
		'right',
		'options',
		'condition',
		'prefix'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelEqualityAxiom: self
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> compositeNodeVariables [
	^ #(#vars #options)
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> compositeTokenVariables [
	^ #(#commas)
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

{ #category : #'generated-initialize-release' }
LzTopLevelEqualityAxiomNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
	options := OrderedCollection new: 2.
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
	^ #(#left #right #condition #prefix)
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> prefix [
	^ prefix
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> prefix: aLzAssetPrefixNode [
	self prefix notNil ifTrue: [ self prefix parent: nil ].
	prefix := aLzAssetPrefixNode.
	self prefix notNil ifTrue: [ self prefix parent: self ]
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

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelEqualityAxiomNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
