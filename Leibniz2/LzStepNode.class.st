Class {
	#name : #LzStepNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'term',
		'arrow',
		'var'
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
	^ #(#term #var)
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

{ #category : #generated }
LzStepNode >> var [
	^ var
]

{ #category : #generated }
LzStepNode >> var: aLzVarTermNode [
	self var notNil ifTrue: [ self var parent: nil ].
	var := aLzVarTermNode.
	self var notNil ifTrue: [ self var parent: self ]
]
