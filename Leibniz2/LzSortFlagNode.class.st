Class {
	#name : #LzSortFlagNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'name',
		'equals',
		'yesno'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzSortFlagNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitSortFlag: self
]

{ #category : #generated }
LzSortFlagNode >> equals [
	^ equals
]

{ #category : #generated }
LzSortFlagNode >> equals: aSmaCCToken [
	equals := aSmaCCToken
]

{ #category : #generated }
LzSortFlagNode >> name [
	^ name
]

{ #category : #generated }
LzSortFlagNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
LzSortFlagNode >> tokenVariables [
	^ #(#name #equals #yesno)
]

{ #category : #generated }
LzSortFlagNode >> yesno [
	^ yesno
]

{ #category : #generated }
LzSortFlagNode >> yesno: aSmaCCToken [
	yesno := aSmaCCToken
]
