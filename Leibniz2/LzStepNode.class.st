Class {
	#name : #LzStepNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'term',
		'arrow',
		'pattern'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzStepNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitStep: self
]

{ #category : #generated }
LzStepNode >> arrow [
	^ arrow
]

{ #category : #generated }
LzStepNode >> arrow: aSmaCCToken [
	arrow := aSmaCCToken
]

{ #category : #generated }
LzStepNode >> nodeVariables [
	^ #(#term #pattern)
]

{ #category : #generated }
LzStepNode >> pattern [
	^ pattern
]

{ #category : #generated }
LzStepNode >> pattern: aLzPatternNode [
	self pattern notNil ifTrue: [ self pattern parent: nil ].
	pattern := aLzPatternNode.
	self pattern notNil ifTrue: [ self pattern parent: self ]
]

{ #category : #generated }
LzStepNode >> term [
	^ term
]

{ #category : #generated }
LzStepNode >> term: aLzParseTreeNode [
	self term notNil ifTrue: [ self term parent: nil ].
	term := aLzParseTreeNode.
	self term notNil ifTrue: [ self term parent: self ]
]

{ #category : #generated }
LzStepNode >> tokenVariables [
	^ #(#arrow)
]
