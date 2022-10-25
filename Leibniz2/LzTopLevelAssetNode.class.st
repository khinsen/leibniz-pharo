Class {
	#name : #LzTopLevelAssetNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'label',
		'order'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelAssetNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelAsset: self
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
