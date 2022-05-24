Class {
	#name : #LzTopLevelUseContextNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'pageName',
		'sortFlag'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelUseContextNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelUseContext: self
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
LzTopLevelUseContextNode >> sortFlag [
	^ sortFlag
]

{ #category : #generated }
LzTopLevelUseContextNode >> sortFlag: aSmaCCToken [
	sortFlag := aSmaCCToken
]

{ #category : #generated }
LzTopLevelUseContextNode >> tokenVariables [
	^ #(#pageName #sortFlag)
]
