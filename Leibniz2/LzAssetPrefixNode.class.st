Class {
	#name : #LzAssetPrefixNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'label'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzAssetPrefixNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitAssetPrefix: self
]

{ #category : #generated }
LzAssetPrefixNode >> label [
	^ label
]

{ #category : #generated }
LzAssetPrefixNode >> label: aSmaCCToken [
	label := aSmaCCToken
]

{ #category : #generated }
LzAssetPrefixNode >> tokenVariables [
	^ #(#label)
]
