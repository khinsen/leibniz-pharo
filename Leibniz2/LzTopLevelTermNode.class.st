Class {
	#name : #LzTopLevelTermNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'term'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelTermNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelTerm: self
]

{ #category : #generated }
LzTopLevelTermNode >> nodeVariables [
	^ #(#term)
]

{ #category : #generated }
LzTopLevelTermNode >> term [
	^ term
]

{ #category : #generated }
LzTopLevelTermNode >> term: aLzParseTreeNode [
	self term notNil ifTrue: [ self term parent: nil ].
	term := aLzParseTreeNode.
	self term notNil ifTrue: [ self term parent: self ]
]
