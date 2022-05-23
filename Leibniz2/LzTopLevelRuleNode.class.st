Class {
	#name : #LzTopLevelRuleNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'pattern',
		'arrow',
		'condition'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelRuleNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelRule: self
]

{ #category : #generated }
LzTopLevelRuleNode >> arrow [
	^ arrow
]

{ #category : #generated }
LzTopLevelRuleNode >> arrow: aSmaCCToken [
	arrow := aSmaCCToken
]

{ #category : #generated }
LzTopLevelRuleNode >> condition [
	^ condition
]

{ #category : #generated }
LzTopLevelRuleNode >> condition: aLzParseTreeNode [
	self condition notNil ifTrue: [ self condition parent: nil ].
	condition := aLzParseTreeNode.
	self condition notNil ifTrue: [ self condition parent: self ]
]

{ #category : #generated }
LzTopLevelRuleNode >> nodeVariables [
	^ #(#pattern #condition)
]

{ #category : #generated }
LzTopLevelRuleNode >> pattern [
	^ pattern
]

{ #category : #generated }
LzTopLevelRuleNode >> pattern: aLzParseTreeNode [
	self pattern notNil ifTrue: [ self pattern parent: nil ].
	pattern := aLzParseTreeNode.
	self pattern notNil ifTrue: [ self pattern parent: self ]
]

{ #category : #generated }
LzTopLevelRuleNode >> tokenVariables [
	^ #(#arrow)
]
