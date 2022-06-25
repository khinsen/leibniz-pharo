Class {
	#name : #LzRulePrefixNode,
	#superclass : #LzParseTreeNode,
	#instVars : [
		'label',
		'order'
	],
	#category : #'Leibniz2-SmaCCParser'
}

{ #category : #generated }
LzRulePrefixNode >> acceptVisitor: aParseTreeVisitor [
	^ aParseTreeVisitor visitRulePrefix: self
]

{ #category : #generated }
LzRulePrefixNode >> label [
	^ label
]

{ #category : #generated }
LzRulePrefixNode >> label: aSmaCCToken [
	label := aSmaCCToken
]

{ #category : #generated }
LzRulePrefixNode >> order [
	^ order
]

{ #category : #generated }
LzRulePrefixNode >> order: aSmaCCToken [
	order := aSmaCCToken
]

{ #category : #generated }
LzRulePrefixNode >> tokenVariables [
	^ #(#label #order)
]
