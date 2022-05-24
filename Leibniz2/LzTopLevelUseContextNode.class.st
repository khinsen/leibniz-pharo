Class {
	#name : #LzTopLevelUseContextNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'items',
		'bars'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelUseContextNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelUseContext: self
]

{ #category : #generated }
LzTopLevelUseContextNode >> bars [
	^ bars
]

{ #category : #generated }
LzTopLevelUseContextNode >> bars: anOrderedCollection [
	bars := anOrderedCollection
]

{ #category : #generated }
LzTopLevelUseContextNode >> compositeNodeVariables [
	^ #(#items)
]

{ #category : #generated }
LzTopLevelUseContextNode >> compositeTokenVariables [
	^ #(#bars)
]

{ #category : #'generated-initialize-release' }
LzTopLevelUseContextNode >> initialize [
	super initialize.
	items := OrderedCollection new: 2.
	bars := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelUseContextNode >> items [
	^ items
]

{ #category : #generated }
LzTopLevelUseContextNode >> items: anOrderedCollection [
	self setParents: self items to: nil.
	items := anOrderedCollection.
	self setParents: self items to: self
]
