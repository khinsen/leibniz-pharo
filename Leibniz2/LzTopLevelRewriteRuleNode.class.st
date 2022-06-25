Class {
	#name : #LzTopLevelRewriteRuleNode,
	#superclass : #LzTopLevelRuleNode,
	#instVars : [
		'replacement'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzTopLevelRewriteRuleNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitTopLevelRewriteRule: self
]

{ #category : #generated }
LzTopLevelRewriteRuleNode >> nodeVariables [
	^ #(#replacement #pattern #condition #prefix)
]

{ #category : #generated }
LzTopLevelRewriteRuleNode >> replacement [
	^ replacement
]

{ #category : #generated }
LzTopLevelRewriteRuleNode >> replacement: aLzParseTreeNode [
	self replacement notNil ifTrue: [ self replacement parent: nil ].
	replacement := aLzParseTreeNode.
	self replacement notNil ifTrue: [ self replacement parent: self ]
]
