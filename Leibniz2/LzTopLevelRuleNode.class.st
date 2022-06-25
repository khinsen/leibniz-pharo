Class {
	#name : #LzTopLevelRuleNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'vars',
		'commas',
		'pattern',
		'arrow',
		'options',
		'condition',
		'prefix'
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
LzTopLevelRuleNode >> commas [
	^ commas
]

{ #category : #generated }
LzTopLevelRuleNode >> commas: anOrderedCollection [
	commas := anOrderedCollection
]

{ #category : #generated }
LzTopLevelRuleNode >> compositeNodeVariables [
	^ #(#vars #options)
]

{ #category : #generated }
LzTopLevelRuleNode >> compositeTokenVariables [
	^ #(#commas)
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

{ #category : #'generated-initialize-release' }
LzTopLevelRuleNode >> initialize [
	super initialize.
	vars := OrderedCollection new: 2.
	commas := OrderedCollection new: 2.
	options := OrderedCollection new: 2.
]

{ #category : #generated }
LzTopLevelRuleNode >> nodeVariables [
	^ #(#pattern #condition #prefix)
]

{ #category : #generated }
LzTopLevelRuleNode >> options [
	^ options
]

{ #category : #generated }
LzTopLevelRuleNode >> options: anOrderedCollection [
	self setParents: self options to: nil.
	options := anOrderedCollection.
	self setParents: self options to: self
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
LzTopLevelRuleNode >> prefix [
	^ prefix
]

{ #category : #generated }
LzTopLevelRuleNode >> prefix: aLzRulePrefixNode [
	self prefix notNil ifTrue: [ self prefix parent: nil ].
	prefix := aLzRulePrefixNode.
	self prefix notNil ifTrue: [ self prefix parent: self ]
]

{ #category : #generated }
LzTopLevelRuleNode >> tokenVariables [
	^ #(#arrow)
]

{ #category : #generated }
LzTopLevelRuleNode >> vars [
	^ vars
]

{ #category : #generated }
LzTopLevelRuleNode >> vars: anOrderedCollection [
	self setParents: self vars to: nil.
	vars := anOrderedCollection.
	self setParents: self vars to: self
]
