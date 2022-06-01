Class {
	#name : #LzTopLevelUseContextNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'pageName',
		'options'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelUseContextNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelUseContext: self
]

{ #category : #generated }
LzTopLevelUseContextNode >> compositeNodeVariables [
	^ #(#options)
]

{ #category : #'generated-initialize-release' }
LzTopLevelUseContextNode >> initialize [
	super initialize.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelUseContextNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelUseContextNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
]

{ #category : #generated }
LzTopLevelUseContextNode >> pageName [
	^ pageName
]

{ #category : #generated }
LzTopLevelUseContextNode >> pageName: aSmaCCToken [
	pageName := aSmaCCToken
]

{ #category : #generated }
LzTopLevelUseContextNode >> tokenVariables [
	^ #(#pageName)
]
