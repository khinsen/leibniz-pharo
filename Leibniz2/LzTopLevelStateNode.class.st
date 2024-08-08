Class {
	#name : #LzTopLevelStateNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'var',
		'options'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelStateNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelState: self
]

{ #category : #generated }
LzTopLevelStateNode >> compositeNodeVariables [
	^ #(#options)
]

{ #category : #'generated-initialize-release' }
LzTopLevelStateNode >> initialize [
	super initialize.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelStateNode >> nodeVariables [
	^ #(#var)
]

{ #category : #generated }
LzTopLevelStateNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelStateNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
]

{ #category : #generated }
LzTopLevelStateNode >> var [
	^ var
]

{ #category : #generated }
LzTopLevelStateNode >> var: aLzVarNode [
	self var notNil ifTrue: [ self var parent: nil ].
	var := aLzVarNode.
	self var notNil ifTrue: [ self var parent: self ]
]
