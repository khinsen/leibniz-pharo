Class {
	#name : #LzTopLevelTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'term',
		'options',
		'prefix'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelTerm: self
]

{ #category : #generated }
LzTopLevelTermNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelTermNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelTermNode >> compositeNodeVariables [
	^ #(#vars #options)
]

{ #category : #generated }
LzTopLevelTermNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelTermNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelTermNode >> nodeVariables [
	^ #(#term #prefix)
]

{ #category : #generated }
LzTopLevelTermNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelTermNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
]

{ #category : #generated }
LzTopLevelTermNode >> prefix [
	^ prefix
]

{ #category : #generated }
LzTopLevelTermNode >> prefix: aLzAssetPrefixNode [
	self prefix notNil ifTrue: [ self prefix parent: nil ].
	prefix := aLzAssetPrefixNode.
	self prefix notNil ifTrue: [ self prefix parent: self ]
]

{ #category : #generated }
LzTopLevelTermNode >> term [
	^ term
]

{ #category : #generated }
LzTopLevelTermNode >> term: aLzParseTreeNode [
	self term notNil ifTrue: [ self term parent: nil ].
	term := aLzParseTreeNode.
	self term notNil ifTrue: [ self term parent: self ]
]

{ #category : #generated }
LzTopLevelTermNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelTermNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
