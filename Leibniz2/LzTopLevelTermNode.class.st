Class {
	#name : #LzTopLevelTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'pattern',
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
LzTopLevelTermNode >> compositeNodeVariables [
	^ #(#options)
]

{ #category : #'generated-initialize-release' }
LzTopLevelTermNode >> initialize [
	super initialize.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelTermNode >> nodeVariables [
	^ #(#pattern #prefix)
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
LzTopLevelTermNode >> pattern [
	^ pattern
]

{ #category : #generated }
LzTopLevelTermNode >> pattern: aLzPatternNode [
	self pattern notNil ifTrue: [ self pattern parent: nil ].
	pattern := aLzPatternNode.
	self pattern notNil ifTrue: [ self pattern parent: self ]
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
