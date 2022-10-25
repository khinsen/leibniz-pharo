Class {
	#name : #LzTopLevelAssetNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'label',
		'options',
		'order'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelAssetNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelAsset: self
]

{ #category : #generated }
LzTopLevelAssetNode >> compositeNodeVariables [
	^ #(#options)
]

{ #category : #'generated-initialize-release' }
LzTopLevelAssetNode >> initialize [
	super initialize.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelAssetNode >> label [
	^ label
]

{ #category : #generated }
LzTopLevelAssetNode >> label: aSmaCCToken [
	label := aSmaCCToken
]

{ #category : #generated }
LzTopLevelAssetNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelAssetNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
]

{ #category : #generated }
LzTopLevelAssetNode >> order [
	^ order
]

{ #category : #generated }
LzTopLevelAssetNode >> order: aSmaCCToken [
	order := aSmaCCToken
]

{ #category : #generated }
LzTopLevelAssetNode >> tokenVariables [
	^ #(#label #order)
]
