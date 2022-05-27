Class {
	#name : #LzTopLevelSubsortNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'subsort',
		'subsetOf',
		'supersort'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelSubsortNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelSubsort: self
]

{ #category : #generated }
LzTopLevelSubsortNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelSubsortNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelSubsortNode >> compositeNodeVariables [
	^ #(#vars)
]

{ #category : #generated }
LzTopLevelSubsortNode >> compositeTokenVariables [
	^ #(#commas)
]

{ #category : #'generated-initialize-release' }
LzTopLevelSubsortNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelSubsortNode >> nodeVariables [
	^ #(#subsort #supersort)
]

{ #category : #generated }
LzTopLevelSubsortNode >> subsetOf [
	^ subsetOf
]

{ #category : #generated }
LzTopLevelSubsortNode >> subsetOf: aSmaCCToken [
	subsetOf := aSmaCCToken
]

{ #category : #generated }
LzTopLevelSubsortNode >> subsort [
	^ subsort
]

{ #category : #generated }
LzTopLevelSubsortNode >> subsort: aLzParseTreeNode [
	self subsort notNil ifTrue: [ self subsort parent: nil ].
	subsort := aLzParseTreeNode.
	self subsort notNil ifTrue: [ self subsort parent: self ]
]

{ #category : #generated }
LzTopLevelSubsortNode >> supersort [
	^ supersort
]

{ #category : #generated }
LzTopLevelSubsortNode >> supersort: aLzParseTreeNode [
	self supersort notNil ifTrue: [ self supersort parent: nil ].
	supersort := aLzParseTreeNode.
	self supersort notNil ifTrue: [ self supersort parent: self ]
]

{ #category : #generated }
LzTopLevelSubsortNode >> tokenVariables [
	^ #(#subsetOf)
]

{ #category : #generated }
LzTopLevelSubsortNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelSubsortNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
